import 'package:xchaindart/src/xchain_client/xchain_client.dart';

class EthereumClient implements XChainClient {
  @override
  late String address;

  @override
  Network network;

  @override
  String seed;

  EthereumClient(this.seed, [this.network = Network.mainnet]) {
    int walletIndex = 0;
    address = getAddress(walletIndex);
  }

  @override
  getAddress(walletIndex) {
    if (walletIndex < 0) {
      throw ('index must be greater than zero');
    }
    // address = this.hdNode.derivePath(this.getFullDerivationPath(index));
    address = "0xEFff51aa65B8AE49a2F2Fe3b941c79bB23Fd0AF4";
    if (walletIndex == 1) {
      address = "0x9b39aF85c2973bd52fF3DCc424E2f02E9D7606Bc";
    }
    return address;
  }

  @override
  getBalance(address, assets) {
    List balances = [
      {'asset': 'ETH:ETH', 'amount': 100000000}
    ];
    return balances;
  }

  @override
  getExplorerAddressUrl(address) {
    return "https://blockchair.com/bitcoin/address/19iqYbeATe4RxghQZJnYVFU4mjUUu76EA6";
  }

  @override
  getExplorerTransactionUrl(txId) {
    return "https://blockchair.com/bitcoin/transaction/d11ff3352c50b1f5c8e2030711702a2071ca0e65457b40e6e0bcbea99e5dc82e";
  }

  @override
  getExplorerUrl() {
    return "https://blockchair.com/bitcoin/";
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
