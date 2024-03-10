import 'dart:math';

import 'location_content.dart';
import 'english_board.dart';
import 'location.dart';
import 'move.dart';

class EnglishBoardCalculator {
  List<Move> assembleMoves() {
    int rows = EnglishBoard.rows;
    int columns = EnglishBoard.columns;
    List<Move> moves = [];
    for (int row = 0; row < rows; row++) {
      for (int column = 0; column < columns; column++) {
        // detect possible horizontal moves
        if ((row + 2 < rows) && _isUsable(row, column) && _isUsable(row + 1, column) && _isUsable(row + 2, column)) {
          moves.add(Move(Location(row, column), Location(row + 1, column), Location(row + 2, column)));
          moves.add(Move(Location(row + 2, column), Location(row + 1, column), Location(row, column)));
        }
        // detect possible vertical moves
        if ((column + 2 < columns) &&
            _isUsable(row, column) &&
            _isUsable(row, column + 1) &&
            _isUsable(row, column + 2)) {
          moves.add(Move(Location(row, column), Location(row, column + 1), Location(row, column + 2)));
          moves.add(Move(Location(row, column + 2), Location(row, column + 1), Location(row, column)));
        }
      }
    }
    return moves;
  }

  String? findConsecutivePosition(String currentPosition, Location start, Location end, List<Move> moves) {
    // a move is uniquely defined by start and end location
    List<Move> possibleMoves = moves.where((Move move) => (move.start == start) && move.end == end).toList();
    if (possibleMoves.isEmpty) {
      return null;
    }
    var possibleMove = possibleMoves[0];
    if (!LocationContent.forName(currentPosition[getIndex(start)]).isPeg() // start must be peg
            ||
            !LocationContent.forName(currentPosition[getIndex(possibleMove.between)]).isPeg() // between must be peg
            ||
            !LocationContent.forName(currentPosition[getIndex(possibleMove.end)]).isHole() // end must be hole
        ) {
      return null;
    }
    // apply move to position
    return applyMove(currentPosition, start, possibleMove, end); // end is a peg now
  }

  String applyMove(String currentPosition, Location start, Move possibleMove, Location end) {
    String newPosition =
        _replaceCharAt(currentPosition, getIndex(start), LocationContent.hole.name); // start is a hole now
    newPosition =
        _replaceCharAt(newPosition, getIndex(possibleMove.between), LocationContent.hole.name); // between is a hole now
    return _replaceCharAt(newPosition, getIndex(end), LocationContent.peg.name); // end is a peg now
  }

  LocationContent getContentAtLocation(String position, int row, int column) {
    assert((row >= 0 && row < EnglishBoard.rows) || (column >= 0 || column < EnglishBoard.columns));
    String content = position[row * EnglishBoard.columns + column];
    return LocationContent.forName(content);
  }

  Set<String> getSymmetricPositions(String position) {
    Set<String> symmetricPositions = <String>{};
    symmetricPositions.add(_convertToLong(position));
    symmetricPositions.add(_convertToLong(_rotateBy180(position)));
    symmetricPositions.add(_convertToLong(_mirrorOnVerticalAxis(position)));
    // equals mirror on horizontal axis
    symmetricPositions.add(_convertToLong(_mirrorOnVerticalAxis(_rotateBy180(position))));

    String rotatedBy90 = _transpose(position);
    symmetricPositions.add(_convertToLong(rotatedBy90));
    symmetricPositions.add(_convertToLong(_rotateBy180(rotatedBy90)));

    String mirroredDiagonally = _mirrorOnVerticalAxis(rotatedBy90);
    symmetricPositions.add(_convertToLong(mirroredDiagonally));
    symmetricPositions.add(_convertToLong(_rotateBy180(mirroredDiagonally)));

    return symmetricPositions;
  }

  int getIndex(Location location) {
    return location.row * EnglishBoard.columns + location.column;
  }

  bool _isUsable(int row, int column) {
    return !getContentAtLocation(EnglishBoard.layout, row, column).isUnused();
  }

  String _transpose(String position) {
    String result = position;
    for (int i = 0; i < 7; i++) {
      for (int j = i; j < 7; j++) {
        String temp = result[j * 7 + i];
        result = _replaceCharAt(result, j * 7 + i, result[i * 7 + j]);
        result = _replaceCharAt(result, i * 7 + j, temp);
      }
    }
    return result;
  }

  String _rotateBy180(String position) {
    return _mirrorOnHorizontalAxis(_mirrorOnVerticalAxis(position));
  }

  String _mirrorOnHorizontalAxis(String position) {
    return List<int>.generate(7, (i) => i)
        .map((j) {
          return position.substring(j * 7, j * 7 + 7).split('').reversed.join('');
        })
        .join()
        .split('')
        .reversed
        .join('');
  }

  String _mirrorOnVerticalAxis(String position) {
    // revert each line
    return List<int>.generate(7, (i) => i).map((j) {
      return position.substring(j * 7, j * 7 + 7).split('').reversed.join('');
    }).join();
  }

  /// where the lowest bit represents the right bottom location
  String _convertToLong(String position) {
    int converted = 0;
    String revertedPositionString = position.split('').reversed.join();
    for (var j in List<int>.generate(49, (i) => i)) {
      if (LocationContent.forName(revertedPositionString[j]).isPeg()) {
        converted = converted + (pow(2, j).toInt());
      }
    }
    return converted.toString();
  }

  String _replaceCharAt(String oldString, int index, String newChar) {
    return oldString.substring(0, index) + newChar + oldString.substring(index + 1);
  }
}
