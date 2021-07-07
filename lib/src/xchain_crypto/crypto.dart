import 'dart:typed_data';

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

Uint8List getSeed(String mnemonic, {String passphrase = ""}) {
  // if (!validateMnemonic(mnemonic)) {
  //   throw new ArgumentError(_INVALID_MNEMONIC);
  // }
  final seed = bip39.mnemonicToSeed(mnemonic, passphrase: passphrase);

  return seed;
}

String getSeedHex(String mnemonic, {String passphrase = ""}) {
  if (!validateMnemonic(mnemonic)) {
    throw new ArgumentError('Invalid BIP39 phrase');
  }
  final seedHex = bip39.mnemonicToSeedHex(mnemonic, passphrase: passphrase);

  return seedHex;
}

// encryptToKeyStore (mnemonic, password) {
// if (!validateMnemonic(mnemonic)) {
//   throw new ArgumentError ('Invalid BIP39 phrase');
// }
// const _uuid = Uuid();
// final _buffer = Uint8List(16);
// final uuid = _uuid.v4buffer(_buffer);
// const salt = crypto.randomBytes(32)
// const iv = crypto.randomBytes(16)
// const kdfParams = {
// prf: prf,
// dklen: dklen,
// salt: salt.toString('hex'),
// c: c,
// }
// const cipherParams = {
// iv: iv.toString('hex'),
// }
//
// const derivedKey = await pbkdf2Async(Buffer.from(password), salt, kdfParams.c, kdfParams.dklen, hashFunction)
// const cipherIV = crypto.createCipheriv(cipher, derivedKey.slice(0, 16), iv)
// const cipherText = Buffer.concat([cipherIV.update(Buffer.from(phrase, 'utf8')), cipherIV.final()])
// const mac = blake256(Buffer.concat([derivedKey.slice(16, 32), Buffer.from(cipherText)]))
//
// const cryptoStruct = {
// cipher: cipher,
// ciphertext: cipherText.toString('hex'),
// cipherparams: cipherParams,
// kdf: kdf,
// kdfparams: kdfParams,
// mac: mac,
// }
//
// const keystore = {
// crypto: cryptoStruct,
// id: uuid,
// version: 1,
// meta: meta,
// }
//
// return keystore
// }
