library pegsolitaire_model;

import 'package:flutter/services.dart';
import 'package:pegsolitaire/pegsolitaire_board.dart';

/// Model for a peg solitaire game which holds data like the board, move history, current position.
/// Used by the game presenter and view.
class PegSolitaireModel {
  final EnglishBoard board = new EnglishBoard();
  List<String> positionHistory = new List<String>();
  int move = -1;
  String currentPosition;
  Location selectedPegLocation;
  List<Set<String>> winningPositions = new List<Set<String>>();
  bool lost = false;
  int numUndos = 0; // how many times a move has been undone
  int maxNumUndos = 3; // max number of times a user can undo a move
  String pegColor;
  String bestGamePegsRemaining;

  PegSolitaireModel() {
    addMove(EnglishBoard.START_POSITION);
  }

  void reset() {
    positionHistory.clear();
    move = -1;
    currentPosition = null;
    selectedPegLocation = null;
    lost = false;
    numUndos = 0;
    addMove(EnglishBoard.START_POSITION);
  }

  void addMove(String position) {
    move = move + 1;
    currentPosition = position;
    positionHistory.add(position);
  }

  void deleteMove() {
    if (move <= 0 || numUndos >= maxNumUndos) {
      return;
    }
    numUndos = numUndos + 1;
    move = move - 1;
    currentPosition = positionHistory[move];
    positionHistory.removeLast();
    selectedPegLocation = null;
    lost = !isInWinningPositions(currentPosition);
  }

  BoardContent getContent(int row, int column) {
    return board.getContent(currentPosition, row, column);
  }

  String findBoardPositionAfterMove(Location start, Location end) {
    return board.getConsecutivePosition(currentPosition, start, end);
  }

  bool isInWinningPositions(String newPosition) {
    Set<String> symmetricPositions = board.getSymmetricPositions(newPosition);
    Set<String> currentWinningPositions = winningPositions[move];
    return currentWinningPositions
        .intersection(symmetricPositions)
        .isNotEmpty;
  }

  bool isUndoAllowed() {
    return move > 0 && numUndos < maxNumUndos;
  }

  bool isGameFinished() {
    return board
        .getMoves(currentPosition)
        .isEmpty;
  }

  void readWinningPositions(AssetBundle rootBundle) {
    // read winning positions. We do not use a zipped file because decoding would slow down start up.
    // the packing of the apk is good enough to shrink the size.
    // there is only one string in the file (line endings are ignored)
    Stopwatch stopwatch = new Stopwatch()
      ..start();
    rootBundle.loadString('assets/english_board_winning_positions.txt').asStream().forEach((fileContent) {
      winningPositions = fileContent
          .split('\r\n') // split lines
          .where((line) => line.isNotEmpty) // skip empty lines
          .toList() //
          .map((line) {
        return line
            .split(',') // split numbers in one line
            .where((num) => num.isNotEmpty) // remove empty numbers
            .toSet();
      }).toList();
      print('${winningPositions.length} winning positions loaded in ${stopwatch.elapsed}');
    });
  }

  int getNumUndosLeft() {
    if (maxNumUndos - numUndos >= 0) {
      return maxNumUndos - numUndos;
    }
    return 0;
  }

  int getPegsRemaining() {
    return (32 - move);
  }
}
