abstract class XChainClient {
  late String address;
  late String network;
  late bool readOnlyClient;
  late String seed;

  XChainClient([this.network = 'mainnet']);

  getAddress(walletIndex) {}

  getBalance(address, assets) {}

  getExplorerAddressUrl(address) {}

  getExplorerTransactionUrl(txId) {}

  getExplorerUrl() {}

  getFees(params) {}

  getNetwork() {}

  getTransactionData(txId) {}

  getTransactions(address, [limit]) {}

  purgeClient() {}

  setNetwork(newNetwork) {}

  setPhrase(mnemonic, walletIndex) {}

  transfer(params) {}

  validateAddress(address) {}
}
