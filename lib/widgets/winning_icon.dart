import 'package:flutter/material.dart';

class WinningIcon extends Icon {
  WinningIcon(bool gameLost, {super.key})
      : super(
          _getIcon(gameLost),
          color: _getColor(gameLost),
        );

  static IconData _getIcon(bool gameLost) {
    return gameLost ? Icons.sentiment_dissatisfied : Icons.sentiment_satisfied;
  }

  static MaterialColor _getColor(bool gameLost) {
    return gameLost ? Colors.orange : Colors.grey;
  }
}
