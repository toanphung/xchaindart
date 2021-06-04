import 'dart:typed_data';

import 'package:bip39/bip39.dart' as bip39;

// // Constants
// const cipher = 'aes-128-ctr';
// const kdf = 'pbkdf2';
// const prf = 'hmac-sha256';
// const dklen = 32;
// const c = 262144;
// const hashFunction = 'sha256';
// const meta = 'xchain-keystore';

// const _INVALID_MNEMONIC = 'Invalid mnemonic';

String generateMnemonic({int size = 12}) {
  // Generate a random mnemonic (uses crypto.randomBytes under the hood), defaults to 128-bits of entropy.

  int entropy = size == 24 ? 256 : 128;
  var mnemonic = bip39.generateMnemonic(strength: entropy);
  return mnemonic;
}

bool validateMnemonic(String mnemonic) {
  bool result = bip39.validateMnemonic(mnemonic);

  return result;
}

Uint8List getSeed(String mnemonic, {String passphrase = ""}) {
  // if (!validateMnemonic(mnemonic)) {
  //   throw new ArgumentError(_INVALID_MNEMONIC);
  // }
  final seed = bip39.mnemonicToSeed(mnemonic, passphrase: passphrase);

  return seed;
}

String getSeedHex(String mnemonic, {String passphrase = ""}) {
  // if (!validateMnemonic(mnemonic)) {
  //   throw new ArgumentError(_INVALID_MNEMONIC);
  // }
  final seedHex = bip39.mnemonicToSeedHex(mnemonic, passphrase: passphrase);

  return seedHex;
}
