library pegsolitaire_board;

import 'dart:math';

import 'package:quiver/core.dart';

/// This class describes an english peg solitaire board e.g. dimensions, possibles moves, ...
/// and can be used for calculations and board presentation.
/// The internal data structure is a string but matrix access is provided: getContent(position, row, column)
class EnglishBoard {
  final int rows = 7;
  final int columns = 7;
  final int numberOfIndices = 7 * 7;
  final int numberOfHoles = 33;
  static const String LAYOUT = //@formatter:off
      '  111  ' +
      '  111  ' +
      '1111111' +
      '1111111' +
      '1111111' +
      '  111  ' +
      '  111  ';
  static const String START_POSITION =
      '  111  ' +
      '  111  ' +
      '1111111' +
      '1110111' +
      '1111111' +
      '  111  ' +
      '  111  ';//@formatter:on

  List<Move> moves = new List<Move>();

  EnglishBoard() {
    _assembleMoves();
  }

  void _assembleMoves() {
    for (int row = 0; row < rows; row++) {
      for (int column = 0; column < columns; column++) {
        // detect possible horizontal moves
        if ((row + 2 < rows) && isUsable(row, column) && isUsable(row + 1, column) && isUsable(row + 2, column)) {
          moves.add(new Move(Location(row, column), new Location(row + 1, column), new Location(row + 2, column)));
          moves.add(new Move(Location(row + 2, column), new Location(row + 1, column), new Location(row, column)));
        }
        // detect possible vertical moves
        if ((column + 2 < columns) && isUsable(row, column) && isUsable(row, column + 1) && isUsable(row, column + 2)) {
          moves.add(new Move(Location(row, column), new Location(row, column + 1), new Location(row, column + 2)));
          moves.add(new Move(Location(row, column + 2), new Location(row, column + 1), new Location(row, column)));
        }
      }
    }
  }

  BoardContent getContent(String position, int row, int column) {
    assert((row >= 0 && row < rows) || (column >= 0 || column < columns));
    String content = position[row * columns + column];
    return BoardContent.forName(content);
  }

  int getIndex(Location location) {
    return location.row * columns + location.column;
  }

  int getNumberOfPegs(String position) {
    return BoardContent.PEG.name
        .allMatches(position)
        .length;
  }

  bool isSolved(String position) {
    return getNumberOfPegs(position) == 1;
  }

  bool isUsable(int row, int column) {
    return !getContent(LAYOUT, row, column).isUnused();
  }

  String getConsecutivePosition(String currentPosition, Location start, Location end) {
    // a move is uniquely defined by start and end location
    List<Move> possibleMoves = moves.where((Move move) => (move.start == start) && move.end == end).toList();
    if (possibleMoves.length == 0) {
      return null;
    }
    var possibleMove = possibleMoves[0];
    if (!BoardContent.forName(currentPosition[getIndex(start)]).isPeg() // start must be peg
        || !BoardContent.forName(currentPosition[getIndex(possibleMove.between)]).isPeg() // between must be peg
        || !BoardContent.forName(currentPosition[getIndex(possibleMove.end)]).isHole() // end must be hole
    ) {
      return null;
    }
    // apply move to position
    return applyMove(currentPosition, start, possibleMove, end); // end is a peg now
  }

  String applyMove(String currentPosition, Location start, Move possibleMove, Location end) {
    String newPosition = replaceCharAt(currentPosition, getIndex(start), BoardContent.HOLE.name); // start is a hole now
    newPosition =
        replaceCharAt(newPosition, getIndex(possibleMove.between), BoardContent.HOLE.name); // between is a hole now
    return replaceCharAt(newPosition, getIndex(end), BoardContent.PEG.name); // end is a peg now
  }

  List<Move> getMoves(String currentPosition) {
    return moves.where((Move move) {
      // check if this move is possible for the current position
      return BoardContent.forName(currentPosition[getIndex(move.start)]).isPeg() // start must be peg
          && BoardContent.forName(currentPosition[getIndex(move.between)]).isPeg() // between must be peg
          && BoardContent.forName(currentPosition[getIndex(move.end)]).isHole();
    }).toList();
  }

  Set<String> getSymmetricPositions(String position) {
    Set<String> symmetricPositions = new Set<String>();
    symmetricPositions.add(convertToLong(position));
    symmetricPositions.add(convertToLong(rotateBy180(position)));
    symmetricPositions.add(convertToLong(mirrorOnVerticalAxis(position)));
    // equals mirror on horizontal axis
    symmetricPositions.add(convertToLong(mirrorOnVerticalAxis(rotateBy180(position))));

    String rotatedBy90 = transpose(position);
    symmetricPositions.add(convertToLong(rotatedBy90));
    symmetricPositions.add(convertToLong(rotateBy180(rotatedBy90)));

    String mirroredDiagonally = mirrorOnVerticalAxis(rotatedBy90);
    symmetricPositions.add(convertToLong(mirroredDiagonally));
    symmetricPositions.add(convertToLong(rotateBy180(mirroredDiagonally)));

    return symmetricPositions;
  }

  String transpose(String position) {
    String result = position;
    for (int i = 0; i < 7; i++)
      for (int j = i; j < 7; j++) {
        String temp = result[j * 7 + i];
        result = replaceCharAt(result, j * 7 + i, result[i * 7 + j]);
        result = replaceCharAt(result, i * 7 + j, temp);
      }
    return result;
  }

  //@formatter:off
  String rotateBy180(String position) {
    return mirrorOnHorizontalAxis(mirrorOnVerticalAxis(position));
  }

  String mirrorOnHorizontalAxis(String position) {
    return List<int>.generate(7, (i) => i).map((j) {
      return position.substring(j*7, j*7 + 7).split('').reversed.join('');
    }).join().split('').reversed.join('');
  }

  String mirrorOnVerticalAxis(String position) {
    // revert each line
    return List<int>.generate(7, (i) => i).map((j) {
      return position.substring(j*7, j*7 + 7).split('').reversed.join('');
    }).join();
  }    //@formatter:on

  /// The winning positions are encoded as long values (use less space)
  /// where the lowest bit represents the right bottom location
  String convertToLong(String position) {
    int converted = 0;
    //@formatter:off
    String revertedPositionString = position.split('').reversed.join();
    List<int>.generate(49, (i) => i).forEach((j) {
      if (BoardContent.forName(revertedPositionString[j]).isPeg()) {
        converted = converted + pow(2, j);
      }
    });
    return converted.toString();
    //@formatter:on
    }
}

class BoardContent {
  final String name;

  const BoardContent._internal(this.name);

  static const BoardContent UNUSED = const BoardContent._internal(' ');
  static const BoardContent PEG = const BoardContent._internal('1');
  static const BoardContent HOLE = const BoardContent._internal('0');

  String toString() => name;

  bool isHole() {
    return HOLE == this;
  }

  bool isPeg() {
    return PEG == this;
  }

  bool isUnused() {
    return UNUSED == this;
  }

  static BoardContent forName(String name) {
    if (UNUSED.name == name) {
      return UNUSED;
    }
    if (PEG.name == name) {
      return PEG;
    }
    return HOLE;
  }
}

class Move {
  final Location start;
  final Location between;
  final Location end;

  const Move(this.start, this.between, this.end);

  bool operator ==(o) => o is Move && o.start == start && o.between == between && o.end == end;

  int get hashCode => hash3(start.hashCode, between.hashCode, end.hashCode);
}

class Location {
  final int row;
  final int column;

  const Location(this.row, this.column);

  String toString() {
    return '($row,$column)';
  }

  bool operator ==(o) => o is Location && o.row == row && o.column == column;

  int get hashCode => hash2(row.hashCode, column.hashCode);
}

String replaceCharAt(String oldString, int index, String newChar) {
//  return oldString.replaceRange(index, index + 1, newChar);
  return oldString.substring(0, index) + newChar + oldString.substring(index + 1);
}
