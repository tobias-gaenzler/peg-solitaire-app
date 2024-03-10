import 'package:quiver/core.dart';

class Location {
  final int row;
  final int column;

  const Location(this.row, this.column);

  @override
  String toString() {
    return '($row,$column)';
  }

  @override
  bool operator ==(other) =>
      other is Location && other.row == row && other.column == column;

  @override
  int get hashCode => hash2(row.hashCode, column.hashCode);
}
