import 'package:flutter/material.dart';
import 'package:pegsolitaire/pegsolitaire/game_model.dart';

import 'board_location.dart';
import 'pegsolitaire_board.dart';

class BoardRow extends StatefulWidget {
  // Children are the squares in the row.
  final int row;
  final double width;
  final double height;
  final GameModel model;
  final LocationClickedCallback onLocationClick;
  final Function refreshBoard;

  const BoardRow(
      {super.key,
      required this.row,
      required this.width,
      required this.model,
      required this.onLocationClick,
      required this.refreshBoard,
      required this.height});

  @override
  State<StatefulWidget> createState() => _BoardRowState();
}

class _BoardRowState extends State<BoardRow> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.width,
      height: widget.height,
      child: Row(
        children: List<int>.generate(widget.model.board.getColumns(), (i) => i)
            .map((column) => BoardLocation(
                row: widget.row,
                column: column,
                model: widget.model,
                size: widget.height,
                onLocationClick: widget.onLocationClick,
                refreshBoard: widget.refreshBoard))
            .toList(),
      ),
    );
  }
}
