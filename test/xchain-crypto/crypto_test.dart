import 'package:test/test.dart';
import 'package:xchaindart/src/xchain-crypto/crypto.dart';

void main() {
  group('mnemonic phrase (BIP39)', () {
    test('generate default phrase', () {
      var phrase = generateMnemonic();
      var words = phrase.split(' ');

      expect(words.length, 12);
    });

    test('generate 12-word phrase', () {
      var phrase = generateMnemonic(size: 12);
      var words = phrase.split(' ');

      expect(words.length, 12);
    });

    test('generate 24-word phrase', () {
      var phrase = generateMnemonic(size: 24);
      var words = phrase.split(' ');

      expect(words.length, 24);
    });

    test('generate neither a 12 or 24-word phrase', () {
      var phrase = generateMnemonic(size: 8);
      var words = phrase.split(' ');

      expect(words.length, 12);
    });
  });
}
