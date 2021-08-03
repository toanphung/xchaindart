import 'package:http/http.dart' as http;

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
    String prefix = matches2!.group(1)!;
    if (prefix == 'bitcoin' ||
        prefix == 'bitcoincash' ||
        prefix == 'ethereum') {
      address = matches2.group(2)!;
      // identify chain and assets
      addresses = _identifyChain(address, prefix);
    } else {
      throw ArgumentError('Unsupported chain prefix');
    }
  } else {
    address = source;
    // identify chain and assets
    addresses = _identifyChain(address);
  }

  return addresses;
}

_identifyChain(String address, [String? prefix]) {
  List<Address> _addresses = [];

  if (prefix == 'bitcoin') {
    _addresses.add(Address(address, 'BTC:BTC', 'mainnet'));
  } else if (prefix == 'bitcoincash') {
    _addresses.add(Address(address, 'BCH:BCH', 'mainnet'));
  } else if (prefix == 'ethereum') {
    _addresses.add(Address(address, 'ETH:ETH', 'mainnet'));
  }

  // Binance address starts with bnb and has 42 characters
  else if (address.startsWith(new RegExp(r'(^bnb[A-z,0-9]{39})'))) {
    _addresses.add(Address(address, 'BNB:BNB', 'mainnet'));
  }
  // Binance testnet address starts with tbnb and has 42 characters
  else if (address.startsWith(new RegExp(r'(^tbnb[A-z,0-9]{39})'))) {
    _addresses.add(Address(address, 'BNB:BNB', 'testnet'));
  }
  // Bitcoin Legacy address starts with 1 and has 34 or less characters
  else if (address.startsWith(new RegExp(r'(^1[A-z,0-9]{33})'))) {
    _addresses.add(Address(address, 'BCH:BCH', 'mainnet'));
    _addresses.add(Address(address, 'BTC:BTC', 'mainnet'));
  }
  // Bitcoin & Litecoin Segwit address starts with 3 and has 34 characters
  else if (address.startsWith(new RegExp(r'(^3[A-z,0-9]{33})'))) {
    _addresses.add(Address(address, 'BTC:BTC', 'mainnet'));
    _addresses.add(Address(address, 'LTC:LTC', 'mainnet'));
  }
  // Bitcoin Native-Segwit address starts with bc1 and has 42 characters
  else if (address.startsWith(new RegExp(r'(^bc1[A-z,0-9]{39})'))) {
    _addresses.add(Address(address, 'BTC:BTC', 'mainnet'));
  }
  // Bitcoin Cash address starts with q and has 42 characters
  else if (address.startsWith(new RegExp(r'(^q[A-z,0-9]{41})'))) {
    _addresses.add(Address(address, 'BCH:BCH', 'mainnet'));
  }
  // Litecoin address starts with L and has 34 or less characters
  else if (address.startsWith(new RegExp(r'(^L[A-z,0-9]{33})'))) {
    _addresses.add(Address(address, 'LTC:LTC', 'mainnet'));
  }
  // Litecoin address starts with ltc and has 43 or less characters
  else if (address.startsWith(new RegExp(r'(^ltc[A-z,0-9]{40})'))) {
    _addresses.add(Address(address, 'LTC:LTC', 'mainnet'));
  }
  // Dogecoin address starts with D and has 34 or less characters
  else if (address.startsWith(new RegExp(r'(^D[A-z,0-9]{33})'))) {
    _addresses.add(Address(address, 'DOGE:DOGE', 'mainnet'));
  }
  // Ethereum address starts with 0x and has 42 characters
  else if (address.startsWith(new RegExp(r'(^0x[A-z,0-9]{40})'))) {
    _addresses.add(Address(address, 'ETH:ETH', 'mainnet'));
  }
  // Thorchain address starts with thor and has 43 characters
  else if (address.startsWith(new RegExp(r'(^thor[A-z,0-9]{39})'))) {
    _addresses.add(Address(address, 'RUNE:RUNE', 'mainnet'));
  }
  // Thorchain testnet address starts with tthor and has 44 characters
  else if (address.startsWith(new RegExp(r'(^tthor[A-z,0-9]{39})'))) {
    _addresses.add(Address(address, 'RUNE:RUNE', 'testnet'));
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

class NetworkHelper {
  Future getData(String uri, [Map<String, String>? header]) async {
    // print('uri: $uri');
    // print('header: $header');
    var url = Uri.parse(uri);
    http.Response response = await http.get(url, headers: header);
    if (response.statusCode == 200) {
      String data = response.body;
      // print('body: $data');
      return data;
    } else {
      print(response.statusCode);
      throw 'Problem with the get request';
    }
  }
}
