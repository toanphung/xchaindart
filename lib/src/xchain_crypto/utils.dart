// Create address from the public key.
substractAddress(String source) {
  String address;

  // start with empty list
  List<Address> addresses = [];

  // If source is empty or null
  if (source.isEmpty) {
    throw ArgumentError('Input is empty');
  }

  // matches on spaces
  RegExp regExpSpaces = new RegExp(r' ');
  bool hasIllegalChars = regExpSpaces.hasMatch(source);
  if (hasIllegalChars) {
    throw ArgumentError('Illegal character');
  }

  // starts with chain prefix
  RegExp regExpPrefix = new RegExp(r':');
  bool hasPrefix = regExpPrefix.hasMatch(source);

  if (hasPrefix) {
    RegExp regex2 = RegExp(r'^(.+):(.+)');
    var matches2 = regex2.firstMatch(source);
    String? prefix = matches2!.group(1);
    if (prefix == 'bitcoin' || prefix == 'ethereum') {
      address = matches2.group(2)!;
    } else {
      throw ArgumentError('Unsupported chain prefix');
    }
  } else {
    address = source;
  }

  // identify chain and assets
  addresses = _identifyChain(address);

  return addresses;
}

_identifyChain(String? address) {
  List<Address> _addresses = [];

  // Bitcoin Legacy address starts with 1 and has 34 or less characters
  if (address!.startsWith(new RegExp(r'(^1[A-z,0-9]{33})'))) {
    _addresses.add(Address(address, 'BTC:BTC', 'mainnet'));
  }
  // Bitcoin Segwit address starts with 3 and has 34 characters
  else if (address.startsWith(new RegExp(r'(^3[A-z,0-9]{33})'))) {
    _addresses.add(Address(address, 'BTC:BTC', 'mainnet'));
  }
  // Bitcoin Native-Segwit address starts with bc1 and has 42 characters
  else if (address.startsWith(new RegExp(r'(^bc1[A-z,0-9]{39})'))) {
    _addresses.add(Address(address, 'BTC:BTC', 'mainnet'));
  }
  // Ethereum address starts with 0x and has 42 characters
  else if (address.startsWith(new RegExp(r'(^0x[A-z,0-9]{40})'))) {
    _addresses.add(Address(address, 'ETH:ETH', 'mainnet'));
  } else {
    throw ArgumentError('Unsupported chain');
  }
  return _addresses;
}

class Address {
  String address;
  String asset;
  String networkType;

  Address(this.address, this.asset, this.networkType);
}
