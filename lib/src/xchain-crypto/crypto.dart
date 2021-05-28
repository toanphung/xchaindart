import 'package:bip39/bip39.dart' as bip39;

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
