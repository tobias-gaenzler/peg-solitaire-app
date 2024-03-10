import 'package:flutter/material.dart';
import 'package:pegsolitaire/pegsolitaire/location_content.dart';
import 'package:pegsolitaire/pegsolitaire/game_model.dart';
import 'package:pegsolitaire/pegsolitaire/location.dart';
import 'package:pegsolitaire/widgets/pegsolitaire_board.dart';

class BoardLocation extends StatefulWidget {
  final int row;
  final int column;
  final GameModel model;
  final double size;
  final LocationClickedCallback onLocationClick;
  final Function refreshBoard;

  const BoardLocation({
    super.key,
    required this.row,
    required this.column,
    required this.model,
    required this.size,
    required this.onLocationClick,
    required this.refreshBoard,
  });

  @override
  State<StatefulWidget> createState() => _BoardLocationState();
}

class _BoardLocationState extends State<BoardLocation> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.size,
      height: widget.size,
      child: _getImageToDisplay(size: widget.size),
    );
  }

  Widget _getImageToDisplay({required double size}) {
    LocationContent content = widget.model.getContentAtLocation(widget.row, widget.column);
    if (content.isUnused()) {
      // empty location (no hole or peg)
      return SizedBox(
        height: widget.size,
        width: widget.size,
      );
    }
    if (widget.model.selectedPegLocation != null &&
        widget.model.selectedPegLocation ==
            Location(widget.row, widget.column)) {
      return getIconButton('${_getImageName(content.name)}_highlighted');
    }
    return getIconButton(_getImageName(content.name));
  }

  IconButton getIconButton(String imageName) {
    return IconButton(
        padding: EdgeInsets.zero,
        icon: Image.asset(
          'assets/$imageName.png',
          height: widget.size,
          width: widget.size,
        ),
        onPressed: () {
          widget.onLocationClick(Location(
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
        return 'peg_${widget.model.pegColor}';
      default:
        return 'unused';
    }
  }
}
