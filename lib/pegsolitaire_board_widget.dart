library pegsolitaire_board_widget;

import 'package:flutter/material.dart';
import 'package:pegsolitaire/pegsolitaire_board.dart';
import 'package:pegsolitaire/pegsolitaire_model.dart';

typedef Null LocationClickedCallback(Location location);

/// Presentation of a peg solitaire board used for presenting a board state to the user.
/// The presentation uses a model to retrieve layout and position and
/// interaction on board should be handled by a presenter
class PegSolitaireBoardWidget extends StatefulWidget {
  // Defines the length and width of the board widget.
  final double widgetSize;
  final PegSolitaireModel model;
  final LocationClickedCallback onLocationClick;

  PegSolitaireBoardWidget({
    this.widgetSize = 200.0,
    @required this.model,
    @required this.onLocationClick,
  });

  @override
  _PegSolitaireBoardWidgetState createState() => new _PegSolitaireBoardWidgetState();
}

class _PegSolitaireBoardWidgetState extends State<PegSolitaireBoardWidget> {
  @override
  Widget build(BuildContext context) {
    return new Container(
        height: widget.widgetSize,
        width: widget.widgetSize,
        child: new Column(
            children: List < int>.generate(widget.model.board.rows, (i) => i).map((row) {
          return new BoardRowWidget(
            row: row,
            width: widget.widgetSize,
            height: widget.widgetSize / widget.model.board.rows,
            model: widget.model,
            onLocationClick: widget.onLocationClick,
            refreshBoard: refreshBoard,
          );
        }).toList()),);
  }

  void refreshBoard() {
    setState(() {});
  }
}

class BoardRowWidget extends StatefulWidget {
  // Children are the squares in the row.
  final int row;
  final double width;
  final double height;
  final PegSolitaireModel model;
  final LocationClickedCallback onLocationClick;
  final Function refreshBoard;

  BoardRowWidget({this.row, this.width, this.model, this.onLocationClick, this.refreshBoard, this.height});

  @override
  _BoardRowWidgetState createState() => _BoardRowWidgetState();
}

class _BoardRowWidgetState extends State<BoardRowWidget> {
  @override
  Widget build(BuildContext context) {
    return new SizedBox(
      width: widget.width,
      height: widget.height,
      child: new Row(
          children: List < int>.generate(widget.model.board.columns, (i) => i)
          .map((column) =>
      new BoardLocationWidget(
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

class BoardLocationWidget extends StatefulWidget {
  final int row;
  final int column;
  final PegSolitaireModel model;
  final double size;
  final LocationClickedCallback onLocationClick;
  final Function refreshBoard;

  BoardLocationWidget({
    this.row,
    this.column,
    this.model,
    this.size,
    this.onLocationClick,
    this.refreshBoard,
  });

  @override
  _BoardLocationWidgetState createState() => new _BoardLocationWidgetState();
}

class _BoardLocationWidgetState extends State<BoardLocationWidget> {
  @override
  Widget build(BuildContext context) {
    return new SizedBox(
      width: widget.size,
      height: widget.size,
      child: _getImageToDisplay(size: widget.size),
    );
  }

  Widget _getImageToDisplay({double size}) {
    BoardContent content = widget.model.getContent(widget.row, widget.column);
    if (content.isUnused()) {
      // empty location (no hole or peg)
      return new Container(
        height: widget.size,
        width: widget.size,
      );
    }
    Location selectedPegLocation = widget.model.selectedPegLocation;
    if (selectedPegLocation != null && selectedPegLocation == new Location(widget.row, widget.column)) {
      return getIconButton(_getImageName(content.name) + '_highlighted');
    }
    return getIconButton(_getImageName(content.name));
  }

  IconButton getIconButton(String imageName) {
    return new IconButton(
        padding: EdgeInsets.zero,
        icon: new Image.asset(
          'assets/$imageName.png',
          height: widget.size,
          width: widget.size,
        ),
        onPressed: () {
          widget.onLocationClick(new Location(
            widget.row,
            widget.column,
          ));
          // Update view after model has changed
          widget.refreshBoard();
        });
  }

  String _getImageName(String boardContentName) {
    switch (boardContentName) {
      case '0':
        return 'hole';
      case '1':
        if (widget.model.pegColor == null) { // might not yet have loaded preferences
          return 'unused';
        }
        return 'peg_' + widget.model.pegColor;
      default:
        return 'unused';
    }
  }
}
