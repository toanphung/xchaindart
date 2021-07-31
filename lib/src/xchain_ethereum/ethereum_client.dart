import 'dart:convert';
import 'dart:math';

import 'package:xchaindart/src/xchain_client/xchain_client.dart';

import '../../xchaindart.dart';

class EthereumClient implements XChainClient {
  @override
  late String address;

  @override
  late String network;

  @override
  late bool readOnlyClient;

  @override
  late String seed;

  /// It's not recommended to use freekey in a product mode.
  static const apiKey = 'freekey';

  EthereumClient(this.seed, [this.network = 'mainnet']) {
    readOnlyClient = false;
    int walletIndex = 0;
    address = getAddress(walletIndex);
  }

  EthereumClient.readonly(this.address, [this.network = 'mainnet']) {
    readOnlyClient = true;
    address = this.address;
  }

  @override
  getAddress(walletIndex) {
    if (walletIndex < 0) {
      throw ('index must be greater than zero');
    }
    // address = this.hdNode.derivePath(this.getFullDerivationPath(index));
    address = "0xb8c0c226d6FE17E5d9132741836C3ae82A5B6C4E";
    if (walletIndex == 1) {
      address = "0x1804137641b5CB781226b361976F15B4067ee0F9";
    }
    return address;
  }

  @override
  getBalance(address, assets) async {
    List balances = [];

    String uri = '${getExplorerAddressUrl(address)}?apiKey=$apiKey';
    NetworkHelper networkHelper = NetworkHelper();

    String responseBody = await networkHelper.getData(uri);
    num amount = jsonDecode(responseBody)['ETH']['balance'];
    if (amount != null) {
      balances.add({
        'asset': 'ETH:ETH',
        'amount': amount,
        'image': 'https://s2.coinmarketcap.com/static/img/coins/64x64/1027.png'
      });
    }

    var tokens = jsonDecode(responseBody)['tokens'];
    if (tokens != null) {
      for (var token in tokens) {
        String symbol = token['tokenInfo']['symbol'];
        String? image = token['tokenInfo']['image'];
        String imageUrl =
            'https://s2.coinmarketcap.com/static/img/coins/64x64/1027.png';
        if (image != null) {
          imageUrl = 'https://ethplorer.io$image';
        }

        num balance = token['balance'];
        num decimals = int.parse(token['tokenInfo']['decimals']);
        num amount = balance / pow(10, decimals);

        if (amount != null) {
          balances.add(
              {'asset': 'ETH:$symbol', 'amount': amount, 'image': imageUrl});
        }
      }
    }
    return balances;
  }

  @override
  getExplorerAddressUrl(address) {
    return '${this.getExplorerUrl()}/getAddressInfo/${address}';
  }

  @override
  getExplorerTransactionUrl(txId) {
    return '${this.getExplorerUrl()}/getTxInfo/${txId}';
  }

  @override
  getExplorerUrl() {
    if (network == 'mainnet') {
      return 'https://api.ethplorer.io';
    } else if (network == 'testnet') {
      return 'https://kovan-api.ethplorer.io';
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
  getTransactions(params) {
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
    address = "0xEFff51aa65B8AE49a2F2Fe3b941c79bB23Fd0AF4";
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
