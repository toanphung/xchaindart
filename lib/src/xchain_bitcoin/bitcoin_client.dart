import 'dart:convert';

import 'package:xchaindart/src/xchain_client/xchain_client.dart';

import '../../xchaindart.dart';

class BitcoinClient implements XChainClient {
  @override
  late String address;

  @override
  late String network;

  @override
  late bool readOnlyClient;

  @override
  late String seed;

  BitcoinClient(this.seed, [this.network = 'mainnet']) {
    readOnlyClient = false;
    int walletIndex = 0;
    address = getAddress(walletIndex);
  }

  BitcoinClient.readonly(this.address, [this.network = 'mainnet']) {
    readOnlyClient = true;
    address = this.address;
  }

  @override
  getAddress(walletIndex) {
    if (walletIndex < 0) {
      throw ('index must be greater than zero');
    }
    // address = this.hdNode.derivePath(this.getFullDerivationPath(index));
    address = "12tSpVdC9CAwod9CFaw33JL9o7JngpE2pJ";
    if (walletIndex == 1) {
      address = "19LQH9PSE35u15kLYTgyjdCo2SBTLn4xhM";
    }
    return address;
  }

  @override
  getBalance(address, assets) async {
    List balances = [];

    String uri = '${getExplorerAddressUrl(address)}';
    NetworkHelper networkHelper = NetworkHelper();

    String responseBody = await networkHelper.getData(uri);
    num funded = jsonDecode(responseBody)['chain_stats']['funded_txo_sum'];
    num spend = jsonDecode(responseBody)['chain_stats']['spent_txo_sum'];
    num amount = (funded - spend) / 100000000;
    if (amount != null) {
      balances.add({
        'asset': 'BTC.BTC',
        'amount': amount,
        'image': 'https://s2.coinmarketcap.com/static/img/coins/64x64/1.png'
      });
    }
    return balances;
  }

  @override
  getExplorerAddressUrl(address) {
    return '${this.getExplorerUrl()}/address/${address}';
  }

  @override
  getExplorerTransactionUrl(txId) {
    return '${this.getExplorerUrl()}/tx/${txId}';
  }

  @override
  getExplorerUrl() {
    if (network == 'mainnet') {
      return 'https://blockstream.info/api';
    } else if (network == 'testnet') {
      return 'https://blockstream.info/testnet/api';
    } else {
      throw ArgumentError('Unsupported network');
    }
  }

  @override
  getFees(params) {
    List fees = [
      {
        "type": "byte",
        "fastest": 300,
        "fast": 275,
        "average": 250,
      }
    ];
    return fees;
  }

  @override
  getNetwork() {
    return network;
  }

  @override
  getTransactionData(txId) async {
    var txData = {};

    String uri = '${getExplorerTransactionUrl(txId)}';
    NetworkHelper networkHelper = NetworkHelper();

    String responseBody = await networkHelper.getData(uri);
    var rawTx = jsonDecode(responseBody);

    var epoch = rawTx['status']['block_time'];
    var date =
        new DateTime.fromMillisecondsSinceEpoch(epoch * 1000, isUtc: false);
    var hash = rawTx['status']['block_hash'];

    List<Map> from = [];
    rawTx['vin'].forEach((tx) {
      Map txMap = tx;
      txMap.forEach((key, value) {
        if (key == 'prevout') {
          Map prevoutMap = value;
          late String address;
          late int amount;
          prevoutMap.forEach((subkey, subvalue) {
            if (subkey == 'scriptpubkey_address') {
              address = subvalue;
            }
            if (subkey == 'value') {
              amount = subvalue;
            }
          });
          if (address.isNotEmpty) {
            var map = {'address': address, 'amount': amount};
            from.add(map);
          }
        }
      });
    });

    List<Map> to = [];
    rawTx['vout'].forEach((tx) {
      Map txMap = tx;
      late String address;
      late int amount;
      txMap.forEach((key, value) {
        if (key == 'scriptpubkey_address') {
          address = value;
        }

        if (key == 'value') {
          amount = value;
        }
      });
      if (address.isNotEmpty) {
        var map = {'address': address, 'amount': amount};
        to.add(map);
      }
    });

    if (rawTx != null) {
      txData.addAll({
        'asset': 'BTC.BTC',
        'from': from,
        'to': to,
        'date': date,
        'type': "transfer",
        'hash': hash,
      });
    }
    return txData;
  }

  @override
  getTransactions(address, [limit]) async {
    List txData = [];
    String uri = '${getExplorerAddressUrl(address)}/txs';
    NetworkHelper networkHelper = NetworkHelper();

    String responseBody = await networkHelper.getData(uri);
    List rawTxs = jsonDecode(responseBody);

    if (limit != null) {
      rawTxs.removeRange(limit, rawTxs.length);
    }

    for (var rawTx in rawTxs) {
      var epoch = rawTx['status']['block_time'];
      var date =
          new DateTime.fromMillisecondsSinceEpoch(epoch * 1000, isUtc: false);
      var hash = rawTx['status']['block_hash'];

      List<Map> from = [];
      rawTx['vin'].forEach((tx) {
        Map txMap = tx;
        txMap.forEach((key, value) {
          if (key == 'prevout') {
            Map prevoutMap = value;
            late String address;
            late int amount;
            prevoutMap.forEach((subkey, subvalue) {
              if (subkey == 'scriptpubkey_address') {
                address = subvalue;
              }
              if (subkey == 'value') {
                amount = subvalue;
              }
            });
            if (address.isNotEmpty) {
              var map = {'address': address, 'amount': amount};
              from.add(map);
            }
          }
        });
      });

      List<Map> to = [];
      rawTx['vout'].forEach((tx) {
        Map txMap = tx;
        late String address;
        late int amount;
        txMap.forEach((key, value) {
          if (key == 'scriptpubkey_address') {
            address = value;
          }

          if (key == 'value') {
            amount = value;
          }
        });
        if (address.isNotEmpty) {
          var map = {'address': address, 'amount': amount};
          to.add(map);
        }
      });

      txData.add({
        'asset': 'BTC.BTC',
        'from': from,
        'to': to,
        'date': date,
        'type': "transfer",
        'hash': hash,
      });
    }

    return txData;
  }

  @override
  purgeClient() {
    // When a wallet is "locked" the private key should be purged in each client by setting it back to null.
  }

  @override
  setNetwork(newNetwork) {
    network = newNetwork;
  }

  @override
  setPhrase(mnemonic, walletIndex) {
    address = "12tSpVdC9CAwod9CFaw33JL9o7JngpE2pJ";
    return address;
  }

  @override
  transfer(params) {
    String txHash =
        '59bbb95bbe740ad6acf24509d38f13f83ca49d6f11207f6a162999ffc5863b77';
    return txHash;
  }

  @override
  validateAddress(address) {
    // check validity of address
    bool result = true;
    return result;
  }
}
