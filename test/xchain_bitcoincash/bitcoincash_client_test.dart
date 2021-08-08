import 'package:test/test.dart';
import 'package:xchaindart/xchaindart.dart';

void main() {
  const phrase =
      'canyon throw labor waste awful century ugly they found post source draft';
  // https://iancoleman.io/bip39/
  // m/44'/145'/0'/0/0
  const addrPath0 = 'bitcoincash:qpl4lfjq7emfg8p4akr6p27dap5duj35zcc82aqul5';
  // m/44'/145'/0'/0/1
  const addrPath1 = 'bitcoincash:qra08x26q4dvkj0rvpkt83dzewfhdsjrsvkct0kmrm';
  // satoshis legacy address
  const addrPathX = '1HLoD9E4SDFFPDiYfNYnkBLQ85Y51J3Zb1';

  group('config and setup', () {
    XChainClient client = new BitcoinCashClient(
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
  group('bitcoincash-client', () {
    XChainClient client = new BitcoinCashClient(phrase);
    test('check valid address on creation', () {
      expect(client.address, addrPath0);
    });
    test('check valid address on creation', () {
      expect(client.getAddress(1), addrPath1);
    });
  });

  group('empty bitcoincash-lite-client', () {
    XChainClient client = new BitcoinCashClient.readonly(addrPath0);
    test('check if the readOnlyClient flag is set', () {
      expect(client.readOnlyClient, true);
    });
    test('check if address is set on creation', () {
      expect(client.address, addrPath0);
    });
    test('check balance', () async {
      List balances = await client.getBalance(addrPath0, 'BCH.BCH');
      expect(balances.length, 1);
      expect(balances.first['amount'], 0.0);
    });
  });

  group('non-empty bitcoincash-lite-client', () {
    XChainClient client = new BitcoinCashClient.readonly(addrPathX);
    test('check if the readOnlyClient flag is set', () {
      expect(client.readOnlyClient, true);
    });
    test('check if address is set on creation', () {
      expect(client.address, addrPathX);
    });
    test('check balance', () async {
      List balances = await client.getBalance(addrPathX, 'BCH.BCH');
      expect(balances.length, equals(1));
      expect(balances.first['amount'], greaterThan(50.0));
    });
  });
}
