enum Network {
  testnet,
  mainnet,
}

abstract class XChainClient {
  Network network;
  String seed;
  late String address;

  XChainClient(this.seed, [this.network = Network.mainnet]);

  getAddress(walletIndex) {}

  getBalance(address, assets) {}

  getExplorerAddressUrl(address) {}

  getExplorerTransactionUrl(txId) {}

  getExplorerUrl() {}

  getFees(params) {}

  getNetwork() {}

  getTransactionData(txId) {}

  getTransactions(params) {}

  purgeClient() {}

  setNetwork(newNetwork) {}

  setPhrase(mnemonic, walletIndex) {}

  transfer(params) {}

  validateAddress(address) {}
}
