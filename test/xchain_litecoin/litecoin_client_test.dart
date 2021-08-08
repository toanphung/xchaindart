import 'package:test/test.dart';
import 'package:xchaindart/src/xchain_client/xchain_client.dart';
import 'package:xchaindart/src/xchain_litecoin/litecoin_client.dart';

void main() {
  const phrase =
      'canyon throw labor waste awful century ugly they found post source draft';
  // https://iancoleman.io/bip39/
  // m/44'/0'/0'/0/0
  const addrPath0 = 'LRXrGoPaJGuiJ8N4hgu2uYLihoHKkomkqs';
  // m/44'/0'/0'/0/1
  const addrPath1 = 'LfH5fgQdMEqjq3R3xkXqWZRjktNBJHVf4w';
  // random address
  const addrPathX = 'Lf1kns7hHXrpVcjUdw1MvHXd6DXHRRYmRo';

  group('config and setup', () {
    XChainClient client = new LitecoinClient(
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
  group('litecoin-client', () {
    XChainClient client = new LitecoinClient(phrase);
    test('check valid address on creation', () {
      expect(client.address, addrPath0);
    });
    test('check valid address on creation', () {
      expect(client.getAddress(1), addrPath1);
    });
  });

  group('empty litecoin-lite-client', () {
    XChainClient client = new LitecoinClient.readonly(addrPath0);
    test('check if the readOnlyClient flag is set', () {
      expect(client.readOnlyClient, true);
    });
    test('check if address is set on creation', () {
      expect(client.address, addrPath0);
    });
    test('check balance', () async {
      List balances = await client.getBalance(addrPath0, 'LTC.LTC');
      expect(balances.length, 1);
      expect(balances.first['amount'], 0.0);
    });
  });

  group('non-empty litecoin-lite-client', () {
    XChainClient client = new LitecoinClient.readonly(addrPathX);
    test('check if the readOnlyClient flag is set', () {
      expect(client.readOnlyClient, true);
    });
    test('check if address is set on creation', () {
      expect(client.address, addrPathX);
    });
    test('check balance', () async {
      List balances = await client.getBalance(addrPathX, 'LTC.LTC');
      expect(balances.length, equals(1));
      expect(balances.first['amount'], 0.12);
    });
  });

  // group('non-empty testnet litecoin-lite-client', () {
  //   XChainClient client = new EthereumClient.readonly(addrPath0, 'testnet');
  //   test('check if the readOnlyClient flag is set', () {
  //     expect(client.readOnlyClient, true);
  //   });
  //   test('check if address is set on creation', () {
  //     expect(client.address, addrPath0);
  //   });
  //   test('check balance', () async {
  //     List balances = await client.getBalance(addrPath0, 'ETH:ETH');
  //     expect(balances.length, greaterThan(1));
  //     expect(balances.first['amount'], 0.000378);
  //   });
  // });
}
