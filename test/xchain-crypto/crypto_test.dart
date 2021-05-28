import 'package:test/test.dart';
import 'package:xchaindart/src/xchain-crypto/crypto.dart';

void main() {
  group('generate mnemonic phrase (BIP39)', () {
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

  group('validate phrase', () {
    test('validate 12-word phrase', () {
      var phrase = generateMnemonic(size: 12);
      bool correctPhrase = validateMnemonic(phrase);

      expect(correctPhrase, true);
    });

    test('validate 24-word phrase', () {
      var phrase = generateMnemonic(size: 24);
      bool correctPhrase = validateMnemonic(phrase);

      expect(correctPhrase, true);
    });

    test('validate invalid phrase', () {
      const phrase =
          'flush viable fury sword mention dignity ethics secret nasty gallery teach wrong';
      bool incorrectPhrase = validateMnemonic(phrase);

      expect(incorrectPhrase, false);
    });

    test('validate incomplete phrase', () {
      const phrase = 'neck grocery crumble super myself license ghost';
      bool incorrectPhrase = validateMnemonic(phrase);

      expect(incorrectPhrase, false);
    });
  });

  group('export keystore', () {
    test('validate 12-word phrase', () {
      var phrase = generateMnemonic(size: 12);
      bool correctPhrase = validateMnemonic(phrase);

      expect(correctPhrase, true);
    });
  });
}
