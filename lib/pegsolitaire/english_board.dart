import 'package:pegsolitaire/pegsolitaire/board_calculator.dart';

import 'location_content.dart';
import 'location.dart';
import 'move.dart';

/// This class describes an english peg solitaire board e.g. dimensions, possibles moves, ...
/// and can be used for calculations and board presentation.
/// The internal data structure is a string but matrix access is provided: getLocationContent(position, row, column)
class EnglishBoard {
  static const int rows = 7;
  static const int columns = 7;
  static const String layout = '  111    111  111111111111111111111  111    111  ';
  static const String startPosition = '  111    111  111111111101111111111  111    111  ';
  final int numberOfIndices = 7 * 7;
  final int numberOfHoles = 33;
  final EnglishBoardCalculator boardCalculator = EnglishBoardCalculator();

  List<Move> moves = [];

  EnglishBoard() {
    moves = boardCalculator.assembleMoves();
  }

  int getRows() {
    return rows;
  }

  int getColumns() {
    return columns;
  }

  LocationContent getContentAtLocation(String position, int row, int column) {
    return boardCalculator.getContentAtLocation(position, row, column);
  }

  int getNumberOfPegs(String position) {
    return LocationContent.peg.name.allMatches(position).length;
  }

  bool isSolved(String position) {
    return getNumberOfPegs(position) == 1;
  }

  String? findConsecutivePosition(String currentPosition, Location start, Location end) {
    return boardCalculator.findConsecutivePosition(currentPosition, start, end, moves);
  }

  Set<String> getSymmetricPositions(String newPosition) {
    return boardCalculator.getSymmetricPositions(newPosition);
  }

  List<Move> getMoves(String currentPosition) {
    return moves.where((Move move) {
      // check if this move is possible for the current position
      return LocationContent.forName(currentPosition[boardCalculator.getIndex(move.start)]).isPeg() // start must be peg
          &&
          LocationContent.forName(currentPosition[boardCalculator.getIndex(move.between)]).isPeg() // between must be peg
          &&
          LocationContent.forName(currentPosition[boardCalculator.getIndex(move.end)]).isHole();
    }).toList();
  }
}
