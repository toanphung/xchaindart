import 'package:test/test.dart';
import 'package:xchaindart/xchaindart.dart';

void main() {
  const phrase =
      'canyon throw labor waste awful century ugly they found post source draft';
  // https://iancoleman.io/bip39/
  // m/44'/3'/0'/0/0
  const addrPath0 = 'D7pdrzASjtTQdWPy99NCLv7vjm4QSmnZ8f';
  // m/44'/3'/0'/0/1
  const addrPath1 = 'DSamHNDKnLztSW9YuJRKcRyqyKfNsQUiHy';
  // random address
  const addrPathX = 'DDUoTGov76gcqAEBXXpUHzSuSQkPYKze9N';

  group('config and setup', () {
    XChainClient client = new DogecoinClient(
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
      expect(address, addrPath0);
    });
  });
  group('dogecoin client', () {
    XChainClient client = new DogecoinClient(phrase);
    test('check valid address on creation', () {
      expect(client.address, addrPath0);
    });
    test('check valid address on creation', () {
      expect(client.getAddress(1), addrPath1);
    });
  });

  group('empty dogecoin lite-client', () {
    XChainClient client = new DogecoinClient.readonly(addrPath0);
    test('check if the readOnlyClient flag is set', () {
      expect(client.readOnlyClient, true);
    });
    test('check if address is set on creation', () {
      expect(client.address, addrPath0);
    });
    test('check balance', () async {
      List balances = await client.getBalance(addrPath0, 'DOGE.DOGE');
      expect(balances.length, 1);
      expect(balances.first['amount'], 0.0);
    });
  });

  group('non-empty dogecoin lite-client', () {
    XChainClient client = new DogecoinClient.readonly(addrPathX);
    test('check if the readOnlyClient flag is set', () {
      expect(client.readOnlyClient, true);
    });
    test('check if address is set on creation', () {
      expect(client.address, addrPathX);
    });
    test('check balance', () async {
      List balances = await client.getBalance(addrPathX, 'DOGE.DOGE');
      expect(balances.length, equals(1));
      expect(balances.first['amount'], greaterThan(100.0));
    });
  });
}
