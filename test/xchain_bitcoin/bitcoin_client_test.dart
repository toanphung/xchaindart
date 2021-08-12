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
  // satoshis address
  const addrPathX = '1HLoD9E4SDFFPDiYfNYnkBLQ85Y51J3Zb1';

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
      List balances = await client.getBalance(addrPath0, 'BTC.BTC');
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
      List balances = await client.getBalance(addrPathX, 'BTC.BTC');
      expect(balances.length, equals(1));
      expect(balances.first['amount'], greaterThan(0.01597));
    });
  });

  group('transaction history', () {
    XChainClient client = new BitcoinClient.readonly(addrPathX);
    test('get specific tx history', () async {
      Map txData = await client.getTransactionData(
          'b12dd481c49c01c3570672e2a5f72efb2deb74a10a5d27a9cbe4483160fe9565');
      expect(
          txData.containsValue(
              '000000000000000000008d1e5a3c919bcd0db96ce149b88da6f6246b0dab3f12'),
          true);
    });
    test('get all tx history', () async {
      List transactions = await client.getTransactions(addrPathX, 3);
      Map tx = transactions.first;
      bool asset = tx.containsValue('BTC.BTC');
      expect(asset, true);
      expect(transactions.length, 3);
    });
  });
}
