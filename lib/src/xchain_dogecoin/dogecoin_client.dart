import 'dart:convert';

import 'package:xchaindart/src/xchain_client/xchain_client.dart';

import '../../xchaindart.dart';

class DogecoinClient implements XChainClient {
  @override
  late String address;

  @override
  late String network;

  @override
  late bool readOnlyClient;

  @override
  late String seed;

  DogecoinClient(this.seed, [this.network = 'mainnet']) {
    readOnlyClient = false;
    int walletIndex = 0;
    address = getAddress(walletIndex);
  }

  DogecoinClient.readonly(this.address, [this.network = 'mainnet']) {
    readOnlyClient = true;
    address = this.address;
  }

  @override
  getAddress(walletIndex) {
    if (walletIndex < 0) {
      throw ('index must be greater than zero');
    }
    // address = this.hdNode.derivePath(this.getFullDerivationPath(index));
    address = "D7pdrzASjtTQdWPy99NCLv7vjm4QSmnZ8f";
    if (walletIndex == 1) {
      address = "DSamHNDKnLztSW9YuJRKcRyqyKfNsQUiHy";
    }
    return address;
  }

  @override
  getBalance(address, assets) async {
    List balances = [];

    String uri = '${getExplorerAddressUrl(address)}';
    NetworkHelper networkHelper = NetworkHelper();

    String responseBody = await networkHelper.getData(uri);
    String amountString = jsonDecode(responseBody)['data']['confirmed_balance'];

    if (amountString != null || amountString != '') {
      num amount = double.parse(amountString);
      balances.add({
        'asset': 'DOGE.DOGE',
        'amount': amount,
        'image': 'https://s2.coinmarketcap.com/static/img/coins/64x64/74.png'
      });
    }
    return balances;
  }

  @override
  getExplorerAddressUrl(address) {
    return '${this.getExplorerUrl()}/get_address_balance/DOGE/${address}';
  }

  @override
  getExplorerTransactionUrl(txId) {
    return '${this.getExplorerUrl()}/get_tx/LTC/${txId}';
  }

  @override
  getExplorerUrl() {
    if (network == 'mainnet') {
      return 'https://chain.so/api/v2';
    } else if (network == 'testnet') {
      throw ArgumentError('Unsupported network');
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
  getTransactionData(txId) {
    List txData = [
      {
        "asset": "ETH.ETH",
        "from": [
          {
            "from": "0xEfse31aa65B8A2R9a2F2Fe3b941c79bB23Fd1BC3",
            "amount": 100000000,
          }
        ],
        "to": [
          {
            "to": "0xEFff51aa65B8AE49a2F2Fe3b941c79bB23Fd0AF4",
            "amount": 100000000,
          }
        ],
        "date": "2020-10-04T06:24:36.548Z",
        "type": "transfer",
        "hash":
            "980D9519CCB39DC02F8B0208A4D181125EE8A2678B280AF70666288B62957DAE",
      }
    ];
    return txData;
  }

  @override
  getTransactions(address, [limit]) {
    List transactions = [
      {
        "total": 1,
        "txs": [
          {
            "asset": "ETH.ETH",
            "from": [
              {
                "from": "0xEfse31aa65B8A2R9a2F2Fe3b941c79bB23Fd1BC3",
                "amount": 100000000
              }
            ],
            "to": [
              {
                "to": "0xEFff51aa65B8AE49a2F2Fe3b941c79bB23Fd0AF4",
                "amount": 100000000
              }
            ],
            "date": "2020-10-04T06:24:36.548Z",
            "type": "transfer",
            "hash":
                "980D9519CCB39DC02F8B0208A4D181125EE8A2678B280AF70666288B62957DAE",
          }
        ],
      }
    ];
    return transactions;
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
    address = "D7pdrzASjtTQdWPy99NCLv7vjm4QSmnZ8f";
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
