import 'package:flutter/material.dart';
import 'package:pegsolitaire/pegsolitaire/game_model.dart';

import '../pegsolitaire/location.dart';
import 'board_row.dart';

typedef LocationClickedCallback = void Function(Location location);

/// Presentation of a peg solitaire board used for presenting a board state to the user.
/// The presentation uses a model to retrieve layout and position and
/// interaction on board should be handled by a presenter
class PegSolitaireBoard extends StatefulWidget {
  // Defines the length and width of the board widget.
  final double widgetSize;
  final GameModel model;
  final LocationClickedCallback onLocationClick;

  const PegSolitaireBoard({
    super.key,
    this.widgetSize = 200.0,
    required this.model,
    required this.onLocationClick,
  });

  @override
  State<StatefulWidget> createState() => _PegSolitaireBoardState();
}

class _PegSolitaireBoardState extends State<PegSolitaireBoard> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: widget.widgetSize,
      width: widget.widgetSize,
      child: Column(
          children: List<int>.generate(widget.model.board.getRows(), (i) => i).map((row) {
        return BoardRow(
          row: row,
          width: widget.widgetSize,
          height: widget.widgetSize / widget.model.board.getRows(),
          model: widget.model,
          onLocationClick: widget.onLocationClick,
          refreshBoard: refreshBoard,
        );
      }).toList()),
    );
  }

  void refreshBoard() {
    setState(() {});
  }
}
