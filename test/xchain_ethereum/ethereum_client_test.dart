import 'package:test/test.dart';
import 'package:xchaindart/src/xchain_ethereum/ethereum_client.dart';
import 'package:xchaindart/src/xchain_client/xchain_client.dart';

void main() {
  const phrase =
      'canyon throw labor waste awful century ugly they found post source draft';
  // https://iancoleman.io/bip39/
  // m/44'/60'/0'/0/0
  const addrPath0 = '0xb8c0c226d6FE17E5d9132741836C3ae82A5B6C4E';
  // m/44'/60'/0'/0/1
  const addrPath1 = '0x1804137641b5CB781226b361976F15B4067ee0F9';
  const ethplorerUrl = 'https://api.ethplorer.io';

  group('config and setup', () {
    XChainClient client = new EthereumClient(
      phrase,
    );

    test('get default network', () {
      var networkType = client.getNetwork();
      expect(networkType, Network.mainnet);
    });
    test('set testnet network', () {
      client.setNetwork(Network.testnet);
      var networkType = client.getNetwork();
      expect(networkType, Network.testnet);
    });
    test('set phrase', () {
      String address = client.setPhrase(phrase, 0);
      expect(address, "0xEFff51aa65B8AE49a2F2Fe3b941c79bB23Fd0AF4");
    });
  });
  group('ethereum-client', () {
    XChainClient client = new EthereumClient(phrase);
    test('check valid address on creation', () {
      expect(client.address, addrPath0);
    });
    test('check valid address on creation', () {
      expect(client.getAddress(1), addrPath1);
    });
  });

  group('querying', () {});
}
