import 'package:test/test.dart';
import 'package:xchaindart/xchaindart.dart';

void main() {
  const phrase =
      'canyon throw labor waste awful century ugly they found post source draft';
  // https://iancoleman.io/bip39/
  // m/44'/60'/0'/0/0
  const addrPath0 = 'bnb154hd7fvmv96jl6ch7rcnpftatpyckv2d9yppwf';
  // m/44'/60'/0'/0/1
  const addrPath1 = 'bnb154hd7fvmv96jl6ch7rcnpftatpyckv2d9yppwf';
  // random address
  const addrPathX = 'bnb1xfy0jlr4f0cllcjzrjc83s0aptw7hq049cuq9l';

  group('config and setup', () {
    XChainClient client = new BinanceClient(
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
      expect(address, addrPath1);
    });
  });
  group('binance-client', () {
    XChainClient client = new BinanceClient(phrase);
    test('check valid address on creation', () {
      expect(client.address, addrPath0);
    });
    test('check valid address on creation', () {
      expect(client.getAddress(1), addrPath1);
    });
  });

  group('empty binance-lite-client', () {
    XChainClient client = new BinanceClient.readonly(addrPath0);
    test('check if the readOnlyClient flag is set', () {
      expect(client.readOnlyClient, true);
    });
    test('check if address is set on creation', () {
      expect(client.address, addrPath0);
    });
    test('check balance', () async {
      List balances = await client.getBalance(addrPath0, 'BNB:BNB');
      expect(balances.length, 1);
      expect(balances.first['amount'], 0.0);
    });
  });

  group('non-empty binance-lite-client', () {
    XChainClient client = new BinanceClient.readonly(addrPathX);
    test('check if the readOnlyClient flag is set', () {
      expect(client.readOnlyClient, true);
    });
    test('check if address is set on creation', () {
      expect(client.address, addrPathX);
    });
    test('check balance', () async {
      List balances = await client.getBalance(addrPathX, 'BNB:BNB');
      expect(balances.length, greaterThan(1));
      expect(balances.first['amount'], greaterThan(1.0));
    });
  });
}
