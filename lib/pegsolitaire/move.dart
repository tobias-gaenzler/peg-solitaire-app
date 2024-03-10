import 'package:quiver/core.dart';

import 'location.dart';

class Move {
  final Location start;
  final Location between;
  final Location end;

  const Move(this.start, this.between, this.end);

  @override
  bool operator ==(other) =>
      other is Move &&
          other.start == start &&
          other.between == between &&
          other.end == end;

  @override
  int get hashCode => hash3(start.hashCode, between.hashCode, end.hashCode);
}