enum Chain {
  BNB,
  BTC,
  ETH,
  THOR,
  GAIA,
  POLKA,
  BCH,
  LTC,
}

identifyChain(String source) {
  // If source is empty or null
  if (source.isEmpty) {
    return 'Input is empty';
  }

  // matches on spaces
  RegExp regExpSpaces = new RegExp(r' ');
  bool hasIllegalChars = regExpSpaces.hasMatch(source);

  if (hasIllegalChars) {
    return "Illegal character";
  }

  // starts with chain prefix
  RegExp regExpPrefix = new RegExp(r':');
  bool hasPrefix = regExpPrefix.hasMatch(source);

  if (hasPrefix) {
    var regex2 = RegExp(r'^(.+):(.+)');
    var matches2 = regex2.firstMatch(source);
    var prefix = matches2!.group(1);
    // var address = matches2!.group(2);
    var chain = checkPrefix(prefix);
    if (chain != null) {
      return '$chain';
    } else {
      return 'unknown chain prefix';
    }
  }
  if (!hasPrefix) {
    var regex3 = RegExp(r'^(.+)');
    var matches2 = regex3.firstMatch(source);
    var address = matches2!.group(1);
    var chain = checkAddress(address);
    if (chain != null) {
      return '$chain';
    } else {
      return 'unknown chain prefix';
    }
  }
}

checkAddress(String? address) {
  // Bitcoin Legacy address starts with 1 and has 34 or less characters
  if (address!.startsWith(new RegExp(r'(^1[A-z,0-9]{33})'))) {
    return Chain.BTC;
  }
  // Bitcoin Segwit address starts with 3 and has 34 characters
  if (address.startsWith(new RegExp(r'(^3[A-z,0-9]{33})'))) {
    return Chain.BTC;
  }
  // Bitcoin Native-Segwit address starts with bc1 and has 42 characters
  if (address.startsWith(new RegExp(r'(^bc1[A-z,0-9]{39})'))) {
    return Chain.BTC;
  }
  // Ethereum address starts with 0x and has 42 characters
  if (address.startsWith(new RegExp(r'(^0x[A-z,0-9]{40})'))) {
    return Chain.ETH;
  } else {
    return null;
  }
}

Chain? checkPrefix(String? prefix) {
  if (prefix == 'bitcoin') {
    return Chain.BTC;
  } else if (prefix == 'ethereum') {
    return Chain.ETH;
  } else {
    return null;
  }
}
