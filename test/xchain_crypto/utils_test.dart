import 'package:test/test.dart';
import 'package:xchaindart/src/xchain_crypto/utils.dart';

void main() {
  test('is empty', () {
    String source = '';
    List<Address> addresses = [];
    try {
      addresses = substractAddress(source);
    } catch (err) {
      expect((err as ArgumentError).message, 'Input is empty');
    } finally {
      expect(addresses, isEmpty);
    }
  });

  test('contains spaces', () {
    String source =
        '3QaesQ25kJc4tyCQM5wJ54ky39DNsUMx7Z 0xC52A857FDa38994CB6CC8e0DE2AEDD67a7353e0d';
    try {
      substractAddress(source);
    } catch (err) {
      expect((err as ArgumentError).message, 'Illegal character');
    }
  });

  test('starts with bitcoin chain prefix', () {
    String source = 'bitcoin:3QaesQ25kJc4tyCQM5wJ54ky39DNsUMx7Z';
    List<Address> addresses = substractAddress(source);
    expect(addresses.length, 1);
    expect(addresses.first.address, '3QaesQ25kJc4tyCQM5wJ54ky39DNsUMx7Z');
    expect(addresses.first.asset, 'BTC:BTC');
    expect(addresses.first.networkType, 'mainnet');
  });

  test('starts with ethereum chain prefix', () {
    String source = 'ethereum:0xC52A857FDa38994CB6CC8e0DE2AEDD67a7353e0d';
    List<Address> addresses = substractAddress(source);
    expect(
        addresses.first.address, '0xC52A857FDa38994CB6CC8e0DE2AEDD67a7353e0d');
    expect(addresses.first.asset, 'ETH:ETH');
    expect(addresses.first.networkType, 'mainnet');
  });

  test('starts with dragonsdex chain prefix', () {
    String source = 'dragonsdex:0xC52A857FDa38994CB6CC8e0DE2AEDD67a7353e0d';
    List<Address> addresses = [];
    try {
      addresses = substractAddress(source);
    } catch (err) {
      expect((err as ArgumentError).message, 'Unsupported chain prefix');
    } finally {
      expect(addresses.length, 0);
    }
  });

  test('bitcoin legacy address without chain prefix', () {
    String source = '16we9adsewmBDKv5CSgeRMZPo3RadcgVZV';
    List<Address> addresses = substractAddress(source);
    expect(addresses.length, 1);
    expect(addresses.first.address, '16we9adsewmBDKv5CSgeRMZPo3RadcgVZV');
    expect(addresses.first.asset, 'BTC:BTC');
    expect(addresses.first.networkType, 'mainnet');
  });

  test('bitcoin segwit address without chain prefix', () {
    String source = '3QaesQ25kJc4tyCQM5wJ54ky39DNsUMx7Z';
    List<Address> addresses = substractAddress(source);
    expect(addresses.length, 1);
    expect(addresses.first.address, '3QaesQ25kJc4tyCQM5wJ54ky39DNsUMx7Z');
    expect(addresses.first.asset, 'BTC:BTC');
    expect(addresses.first.networkType, 'mainnet');
  });

  test('bitcoin native segwit address without chain prefix', () {
    String source = 'bc1qfw00pnu77vvw3r8fpterjukx0u3nj26n724pq3';
    List<Address> addresses = substractAddress(source);
    expect(addresses.length, 1);
    expect(
        addresses.first.address, 'bc1qfw00pnu77vvw3r8fpterjukx0u3nj26n724pq3');
    expect(addresses.first.asset, 'BTC:BTC');
    expect(addresses.first.networkType, 'mainnet');
  });

  test('ethereum address without chain prefix', () {
    String source = '0xC52A857FDa38994CB6CC8e0DE2AEDD67a7353e0d';
    List<Address> addresses = substractAddress(source);
    expect(
        addresses.first.address, '0xC52A857FDa38994CB6CC8e0DE2AEDD67a7353e0d');
    expect(addresses.first.asset, 'ETH:ETH');
    expect(addresses.first.networkType, 'mainnet');
  });

  test('unsupported chain DogeCoin', () {
    String source = 'DJXPYa2aYizxXfhcEcmom1xuEyZLF6DX5b';
    List<Address> addresses = [];
    try {
      addresses = substractAddress(source);
    } catch (err) {
      expect((err as ArgumentError).message, 'Unsupported chain');
    } finally {
      expect(addresses, isEmpty);
    }
  });
}
