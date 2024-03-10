library game_model;

import 'package:flutter/material.dart';
import 'package:pegsolitaire/pegsolitaire/english_board.dart';

import 'location.dart';
import 'location_content.dart';

/// Model for a peg solitaire game which holds data like the board, move history, current position.
/// Used by the game presenter and view.
class GameModel extends ChangeNotifier {
  final EnglishBoard board = EnglishBoard();
  List<String> positionHistory = [];
  int move = -1;
  String? currentPosition;
  Location? selectedPegLocation;
  List<Set<String>> winningPositions = [];
  bool lost = false;
  int numUndos = 0; // how many times a move has been undone
  int maxNumUndos = 3; // max number of times a user can undo a move
  String pegColor = 'blue';
  String? bestGamePegsRemaining;

  GameModel() {
    addMove(EnglishBoard.startPosition);
  }

  void reset() {
    positionHistory.clear();
    move = -1;
    currentPosition = null;
    selectedPegLocation = null;
    lost = false;
    numUndos = 0;
    addMove(EnglishBoard.startPosition);
    notifyListeners();
  }

  void addMove(String position) {
    move = move + 1;
    currentPosition = position;
    positionHistory.add(position);
    notifyListeners();
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
    if (currentPosition == null) {
      lost = false;
    } else {
      lost = !isInWinningPositions(currentPosition!);
    }
    notifyListeners();
  }

  LocationContent getContentAtLocation(int row, int column) {
    assert(currentPosition != null);
    return board.getContentAtLocation(currentPosition!, row, column);
  }

  String? findBoardPositionAfterMove(Location start, Location end) {
    assert(currentPosition != null);
    return board.findConsecutivePosition(currentPosition!, start, end);
  }

  bool isInWinningPositions(String newPosition) {
    Set<String> symmetricPositions = board.getSymmetricPositions(newPosition);
    Set<String> currentWinningPositions = winningPositions[move];
    return currentWinningPositions.intersection(symmetricPositions).isNotEmpty;
  }

  bool isUndoAllowed() {
    return move > 0 && numUndos < maxNumUndos;
  }

  bool isGameFinished() {
    assert(currentPosition != null);
    return board.getMoves(currentPosition!).isEmpty;
  }

  void readWinningPositions(AssetBundle rootBundle) {
    // read winning positions. We do not use a zipped file because decoding would slow down start up.
    // the packing of the apk is good enough to shrink the size.
    // there is only one string in the file (line endings are ignored)
    Stopwatch stopwatch = Stopwatch()..start();
    rootBundle.loadString('assets/english_board_winning_positions.txt').asStream().forEach((fileContent) {
      winningPositions = fileContent
          .split('\n') // split lines
          .where((line) => line.isNotEmpty) // skip empty lines
          .toList() //
          .map((line) {
        return line
            .split(',') // split numbers in one line
            .where((String num) => num.isNotEmpty) // remove empty numbers
            .toSet();
      }).toList();
      debugPrint('${winningPositions.length} winning positions loaded in ${stopwatch.elapsed}');
    });
    notifyListeners();
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

  void notify() {
    notifyListeners();
  }
}
