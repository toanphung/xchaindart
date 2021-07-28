import 'package:test/test.dart';
import 'package:xchaindart/src/xchain_bitcoin/bitcoin_client.dart';
import 'package:xchaindart/src/xchain_client/xchain_client.dart';

void main() {
  const phrase =
      'canyon throw labor waste awful century ugly they found post source draft';
  // https://iancoleman.io/bip39/
  // m/44'/0'/0'/0/0
  const addrPath0 = '12tSpVdC9CAwod9CFaw33JL9o7JngpE2pJ';
  // m/44'/0'/0'/0/1
  const addrPath1 = '19LQH9PSE35u15kLYTgyjdCo2SBTLn4xhM';
  // random address
  const addrPathX = '1DML6c39gTnv2JxAfvzpgTFBATuusPYTi4';

  group('config and setup', () {
    XChainClient client = new BitcoinClient(
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
      expect(address, "12tSpVdC9CAwod9CFaw33JL9o7JngpE2pJ");
    });
  });
  group('bitcoin-client', () {
    XChainClient client = new BitcoinClient(phrase);
    test('check valid address on creation', () {
      expect(client.address, addrPath0);
    });
    test('check valid address on creation', () {
      expect(client.getAddress(1), addrPath1);
    });
  });

  group('empty bitcoin-lite-client', () {
    XChainClient client = new BitcoinClient.readonly(addrPath0);
    test('check if the readOnlyClient flag is set', () {
      expect(client.readOnlyClient, true);
    });
    test('check if address is set on creation', () {
      expect(client.address, addrPath0);
    });
    test('check balance', () async {
      List balances = await client.getBalance(addrPath0, 'BTC:BTC');
      expect(balances.length, 1);
      expect(balances.first['amount'], 0.0);
    });
  });

  group('non-empty bitcoin-lite-client', () {
    XChainClient client = new BitcoinClient.readonly(addrPathX);
    test('check if the readOnlyClient flag is set', () {
      expect(client.readOnlyClient, true);
    });
    test('check if address is set on creation', () {
      expect(client.address, addrPathX);
    });
    test('check balance', () async {
      List balances = await client.getBalance(addrPathX, 'BTC:BTC');
      expect(balances.length, equals(1));
      expect(balances.first['amount'], 1.94476528);
    });
  });

  // group('non-empty testnet ethereum-lite-client', () {
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
