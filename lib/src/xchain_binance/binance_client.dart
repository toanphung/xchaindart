import 'dart:convert';

import 'package:xchaindart/xchaindart.dart';

class BinanceClient implements XChainClient {
  @override
  late String address;

  @override
  late String network;

  @override
  late bool readOnlyClient;

  @override
  late String seed;

  BinanceClient(this.seed, [this.network = 'mainnet']) {
    readOnlyClient = false;
    int walletIndex = 0;
    address = getAddress(walletIndex);
  }

  BinanceClient.readonly(this.address, [this.network = 'mainnet']) {
    readOnlyClient = true;
    address = this.address;
  }

  @override
  getAddress(walletIndex) {
    if (walletIndex < 0) {
      throw ('index must be greater than zero');
    }
    // address = this.hdNode.derivePath(this.getFullDerivationPath(index));
    address = "bnb154hd7fvmv96jl6ch7rcnpftatpyckv2d9yppwf";
    if (walletIndex == 1) {
      address = "bnb154hd7fvmv96jl6ch7rcnpftatpyckv2d9yppwf";
    }
    return address;
  }

  @override
  getBalance(address, assets) async {
    List balances = [];

    String uri = '${getExplorerAddressUrl(address)}';
    NetworkHelper networkHelper = NetworkHelper();

    String responseBody = await networkHelper.getData(uri);
    var tokens = jsonDecode(responseBody)['balances'];
    if (tokens != null) {
      for (var token in tokens) {
        String imageUrl =
            'https://s2.coinmarketcap.com/static/img/coins/64x64/1839.png';
        String symbol = token['symbol'];
        String freeAmount = token['free'];
        num amount = double.parse(freeAmount);

        if (amount != null) {
          balances.add(
              {'asset': 'BNB.$symbol', 'amount': amount, 'image': imageUrl});
        }
      }
    }
    return balances;
  }

  @override
  getExplorerAddressUrl(address) {
    return '${this.getExplorerUrl()}/api/v1/account/${address}';
  }

  @override
  getExplorerTransactionUrl(txId) {
    return '${this.getExplorerUrl()}/api/v1/tx/${txId}?format=json';
  }

  @override
  getExplorerUrl() {
    if (network == 'mainnet') {
      return 'https://dex.binance.org';
    } else if (network == 'testnet') {
      return 'https://testnet-dex.binance.org';
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
    address = "bnb154hd7fvmv96jl6ch7rcnpftatpyckv2d9yppwf";
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
