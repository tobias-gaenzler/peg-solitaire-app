class LocationContent {
  final String name;

  const LocationContent._internal(this.name);

  static const LocationContent unused = LocationContent._internal(' ');
  static const LocationContent peg = LocationContent._internal('1');
  static const LocationContent hole = LocationContent._internal('0');

  @override
  String toString() => name;

  bool isHole() {
    return hole == this;
  }

  bool isPeg() {
    return peg == this;
  }

  bool isUnused() {
    return unused == this;
  }

  static LocationContent forName(String name) {
    if (unused.name == name) {
      return unused;
    }
    if (peg.name == name) {
      return peg;
    }
    return hole;
  }
}
