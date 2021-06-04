import 'dart:typed_data';

import 'package:test/test.dart';
import 'package:xchaindart/src/xchain-crypto/crypto.dart';

void main() {
  group('generate mnemonic (BIP39)', () {
    test('generate default mnemonic', () {
      var mnemonic = generateMnemonic();
      var words = mnemonic.split(' ');

      expect(words.length, 12);
    });

    test('generate 12-word mnemonic', () {
      var mnemonic = generateMnemonic(size: 12);
      var words = mnemonic.split(' ');

      expect(words.length, 12);
    });

    test('generate 24-word mnemonic', () {
      var mnemonic = generateMnemonic(size: 24);
      var words = mnemonic.split(' ');

      expect(words.length, 24);
    });

    test('generate neither a 12 or 24-word mnemonic', () {
      var mnemonic = generateMnemonic(size: 8);
      var words = mnemonic.split(' ');

      expect(words.length, 12);
    });
  });

  group('validate mnemonic', () {
    test('validate 12-word mnemonic', () {
      var mnemonic = generateMnemonic(size: 12);
      bool correctMnemonic = validateMnemonic(mnemonic);

      expect(correctMnemonic, true);
    });

    test('validate 24-word mnemonic', () {
      var mnemonic = generateMnemonic(size: 24);
      bool correctMnemonic = validateMnemonic(mnemonic);

      expect(correctMnemonic, true);
    });

    test('validate invalid mnemonic', () {
      const mnemonic =
          'flush viable fury sword mention dignity ethics secret nasty gallery teach wrong';
      bool incorrectMnemonic = validateMnemonic(mnemonic);

      expect(incorrectMnemonic, false);
    });

    test('validate incomplete mnemonic', () {
      const mnemonic = 'neck grocery crumble super myself license ghost';
      bool incorrectMnemonic = validateMnemonic(mnemonic);

      expect(incorrectMnemonic, false);
    });
  });

  group('generate seed', () {
    test('generate seed hex from mnemonic', () {
      String seed = getSeedHex(
          "update elbow source spin squeeze horror world become oak assist bomb nuclear");

      expect(seed,
          '77e6a9b1236d6b53eaa64e2727b5808a55ce09eb899e1938ed55ef5d4f8153170a2c8f4674eb94ce58be7b75922e48e6e56582d806253bd3d72f4b3d896738a4');
    });

    test('generate seed hex from mnemonic and passphrase', () {
      String seed = getSeedHex(
          "update elbow source spin squeeze horror world become oak assist bomb nuclear",
          passphrase: "xchain rocks");

      expect(seed,
          '34f9182bda6d4cb579f66a932dc0941bf990ade04d41ac1e55801e70857ed253af6cf5a9fe76af56f18ba01a07aa2ac3ad0115264cbd365f391684acfc29cae5');
    });

    // test('generate seed hex from invalid mnemonic', () {
    //   String seed = getSeedHex(
    //       "update elbow source spin squeeze horror world become oak assist bomb wrong");
    //
    //   expect(seed, isArgumentError);
    // });

    test('generate seed from mnemonic', () {
      Uint8List seed = getSeed('basket actual');
      // Uint8List seed = getSeed(
      //     'update elbow source spin squeeze horror world become oak assist bomb nuclear');
      expect(seed, [
        92,
        242,
        212,
        168,
        176,
        53,
        94,
        144,
        41,
        91,
        223,
        197,
        101,
        160,
        34,
        164,
        9,
        175,
        6,
        61,
        83,
        101,
        187,
        87,
        191,
        116,
        217,
        82,
        143,
        73,
        75,
        250,
        68,
        0,
        245,
        61,
        131,
        73,
        184,
        15,
        218,
        228,
        64,
        130,
        215,
        249,
        84,
        30,
        29,
        186,
        43,
        0,
        59,
        207,
        236,
        157,
        13,
        83,
        120,
        28,
        166,
        118,
        101,
        31
      ]);
    });
  });
}
