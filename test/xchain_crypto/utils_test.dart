import 'package:test/test.dart';
import 'package:xchaindart/src/xchain_crypto/utils.dart';

void main() {
  test('is empty', () {
    String source = '';
    expect(identifyChain(source), 'Input is empty');
  });

  test('contains spaces', () {
    String source =
        '3QaesQ25kJc4tyCQM5wJ54ky39DNsUMx7Z 0xC52A857FDa38994CB6CC8e0DE2AEDD67a7353e0d';
    expect(identifyChain(source), 'Illegal character');
  });

  test('starts with bitcoin chain prefix', () {
    String source = 'bitcoin:3QaesQ25kJc4tyCQM5wJ54ky39DNsUMx7Z';
    expect(identifyChain(source), 'Chain.BTC');
  });

  test('starts with ethereum chain prefix', () {
    String source = 'ethereum:0xC52A857FDa38994CB6CC8e0DE2AEDD67a7353e0d';
    expect(identifyChain(source), 'Chain.ETH');
  });

  test('starts with dragonsdex chain prefix', () {
    String source = 'dragonsdex:0xC52A857FDa38994CB6CC8e0DE2AEDD67a7353e0d';
    expect(identifyChain(source), 'unknown chain prefix');
  });

  test('bitcoin legacy address without chain prefix', () {
    String source = '16we9adsewmBDKv5CSgeRMZPo3RadcgVZV';
    expect(identifyChain(source), 'Chain.BTC');
  });

  test('bitcoin segwit address without chain prefix', () {
    String source = '3QaesQ25kJc4tyCQM5wJ54ky39DNsUMx7Z';
    expect(identifyChain(source), 'Chain.BTC');
  });

  test('bitcoin native segwit address without chain prefix', () {
    String source = 'bc1qfw00pnu77vvw3r8fpterjukx0u3nj26n724pq3';
    expect(identifyChain(source), 'Chain.BTC');
  });

  test('ethereum address without chain prefix', () {
    String source = '0xC52A857FDa38994CB6CC8e0DE2AEDD67a7353e0d';
    expect(identifyChain(source), 'Chain.ETH');
  });
}
