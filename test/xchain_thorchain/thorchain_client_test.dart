import 'package:test/test.dart';
import 'package:xchaindart/xchaindart.dart';

void main() {
  const phrase =
      'canyon throw labor waste awful century ugly they found post source draft';
  // https://iancoleman.io/bip39/
  // m/44'/931'/0'/0/0
  const addrPath0 = 'thor1aqvhacnhnw8cvm8a39sgjycs8hj4v39zmvll2w';
  // m/44'/931'/0'/0/1
  const addrPath1 = 'thor18gua30ja2e5ry29tf89evtwxqd305lmw9ahhd2';
  // non-empty address
  const addrPathX = 'thor1yyn0z4z5en2nyzhkh3mrv094k7zatdlc7v8qt4';
  // non-empty testnet address
  const addrPathY = 'tthor1zg8d9p8z79g8c0c2ypjd8x3dhuqtxv0u3ksstv';

  group('config and setup', () {
    XChainClient client = new ThorChainClient(
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
  group('thorchain-client', () {
    XChainClient client = new ThorChainClient(phrase);
    test('check valid address on creation', () {
      expect(client.address, addrPath0);
    });
    test('check valid address on creation', () {
      expect(client.getAddress(1), addrPath1);
    });
  });

  group('empty thorchain lite-client', () {
    XChainClient client = new ThorChainClient.readonly(addrPath0);
    test('check if the readOnlyClient flag is set', () {
      expect(client.readOnlyClient, true);
    });
    test('check if address is set on creation', () {
      expect(client.address, addrPath0);
    });
    test('check balance', () async {
      List balances = await client.getBalance(addrPath0, 'RUNE.RUNE');
      expect(balances.length, 1);
      expect(balances.first['amount'], 0.0);
    });
  });

  group('non-empty thorchain lite-client', () {
    XChainClient client = new ThorChainClient.readonly(addrPathX);
    test('check if the readOnlyClient flag is set', () {
      expect(client.readOnlyClient, true);
    });
    test('check if address is set on creation', () {
      expect(client.address, addrPathX);
    });
    test('check balance', () async {
      List balances = await client.getBalance(addrPathX, 'RUNE.RUNE');
      expect(balances.length, equals(1));
      expect(balances.first['amount'], greaterThan(0.0));
    });
  });

  group('non-empty thorchain lite-client on testnet', () {
    XChainClient client = new ThorChainClient.readonly(addrPathY);
    test('testnet client balance', () async {
      client.setNetwork('testnet');
      List balances = await client.getBalance(addrPathY, 'RUNE.RUNE');
      expect(balances.length, equals(1));
      expect(balances.first['amount'], greaterThan(0.0));
    });
  });
}
