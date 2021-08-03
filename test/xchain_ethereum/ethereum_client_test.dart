import 'package:test/test.dart';
import 'package:xchaindart/src/xchain_client/xchain_client.dart';
import 'package:xchaindart/src/xchain_ethereum/ethereum_client.dart';

void main() {
  const phrase =
      'canyon throw labor waste awful century ugly they found post source draft';
  // https://iancoleman.io/bip39/
  // m/44'/60'/0'/0/0
  const addrPath0 = '0xb8c0c226d6FE17E5d9132741836C3ae82A5B6C4E';
  // m/44'/60'/0'/0/1
  const addrPath1 = '0x1804137641b5CB781226b361976F15B4067ee0F9';
  // random address
  const addrPathX = '0xb862Ed31e4D838bBC5AE1fDE647a6c9288dc3856';

  group('config and setup', () {
    XChainClient client = new EthereumClient(
      phrase,
    );

    test('check if the readOnlyClient flag is set', () {
      expect(client.readOnlyClient, false);
    });
    test('get default network', () {
      var networkType = client.getNetwork();
      expect(networkType, 'mainnet');
    });
    test('set testnet network', () {
      client.setNetwork('testnet');
      var networkType = client.getNetwork();
      expect(networkType, 'testnet');
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

  group('empty ethereum-lite-client', () {
    XChainClient client = new EthereumClient.readonly(addrPath0);
    test('check if the readOnlyClient flag is set', () {
      expect(client.readOnlyClient, true);
    });
    test('check if address is set on creation', () {
      expect(client.address, addrPath0);
    });
    test('check balance', () async {
      List balances = await client.getBalance(addrPath0, 'ETH:ETH');
      expect(balances.length, 1);
      expect(balances.first['amount'], 0.0);
    });
  });

  group('non-empty ethereum-lite-client', () {
    XChainClient client = new EthereumClient.readonly(addrPathX);
    test('check if the readOnlyClient flag is set', () {
      expect(client.readOnlyClient, true);
    });
    test('check if address is set on creation', () {
      expect(client.address, addrPathX);
    });
    test('check balance', () async {
      List balances = await client.getBalance(addrPathX, 'ETH:ETH');
      expect(balances.length, greaterThan(1));
      expect(balances.first['amount'], greaterThan(0.0));
    });
  });

  group('non-empty testnet ethereum-lite-client', () {
    XChainClient client = new EthereumClient.readonly(addrPath0, 'testnet');
    test('check if the readOnlyClient flag is set', () {
      expect(client.readOnlyClient, true);
    });
    test('check if address is set on creation', () {
      expect(client.address, addrPath0);
    });
    test('check balance', () async {
      List balances = await client.getBalance(addrPath0, 'ETH:ETH');
      expect(balances.length, greaterThan(1));
      expect(balances.first['amount'], 0.000378);
    });
  });
}
