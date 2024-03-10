import 'package:flutter/material.dart';
import 'package:pegsolitaire/config/pegsolitaire_localization.dart';
import 'package:pegsolitaire/config/pegsolitaire_preferences.dart';
import 'package:pegsolitaire/pegsolitaire/game_model.dart';

class GameFinishedDialogProvider {
  void show(BuildContext context, GameModel model, Function reset) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: _getGameFinishedTitle(model, context),
          content: _getGameFinishedContent(model, context),
          actions: <Widget>[
            TextButton(
              child: Text(
                EasyPegSolitaireLocalizations.translate(context, 'newGame'),
                style: TextStyle(color: Colors.grey[700]),
              ),
              onPressed: () {
                reset();
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Text _getGameFinishedTitle(GameModel model, BuildContext context) {
    if (model.lost) {
      return Text(
        EasyPegSolitaireLocalizations.translate(
            context, 'gameFinishedTitleLost'),
        style: TextStyle(color: Colors.grey[700]),
      );
    } else {
      return Text(
        EasyPegSolitaireLocalizations.translate(
            context, 'gameFinishedTitleWon'),
        style: TextStyle(color: Colors.grey[700]),
      );
    }
  }

  Widget _getGameFinishedContent(GameModel model, BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                EasyPegSolitaireLocalizations.translate(context, 'score'),
                //style: Theme.of(context).textTheme.subhead,
                style: TextStyle(
                    color: Colors.grey[700],
                    fontSize: 16,
                    fontWeight: FontWeight.bold),
              ),
              _getStarsForScore(EasyPegSolitaireSharedPreferences()
                  .getScore(model.getPegsRemaining().toString())),
            ],
          ),
          Container(height: 20.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                EasyPegSolitaireLocalizations.translate(
                    context, 'pegsRemaining'),
                //style: Theme.of(context).textTheme.subhead,
                style: TextStyle(
                    color: Colors.grey[700],
                    fontSize: 16,
                    fontWeight: FontWeight.bold),
              ),
              Text(model.getPegsRemaining().toString()),
            ],
          ),
          Container(height: 40.0),
          _getGameFinishedText(model, context),
        ],
      ),
    );
  }

  Text _getGameFinishedText(GameModel model, BuildContext context) {
    if (model.lost) {
      return Text(
        EasyPegSolitaireLocalizations.translate(
            context, 'gameFinishedTextLost'),
        style: TextStyle(color: Colors.grey[700]),
      );
    } else {
      return Text(
        EasyPegSolitaireLocalizations.translate(context, 'gameFinishedTextWon'),
        style: TextStyle(color: Colors.grey[700]),
      );
    }
  }

  Widget _getStarsForScore(int bestScore) {
    if (bestScore == 3) {
      return const Row(
        children: <Widget>[
          Icon(Icons.star, color: Colors.amberAccent),
          Icon(Icons.star, color: Colors.amberAccent),
          Icon(Icons.star, color: Colors.amberAccent),
        ],
      );
    }
    if (bestScore == 2) {
      return const Row(
        children: <Widget>[
          Icon(Icons.star, color: Colors.amberAccent),
          Icon(Icons.star, color: Colors.amberAccent),
          Icon(Icons.star_border, color: Colors.amberAccent),
        ],
      );
    }
    if (bestScore == 1) {
      return const Row(
        children: <Widget>[
          Icon(Icons.star, color: Colors.amberAccent),
          Icon(Icons.star_border, color: Colors.amberAccent),
          Icon(Icons.star_border, color: Colors.amberAccent),
        ],
      );
    }
    return const Row(
      children: <Widget>[
        Icon(Icons.star_border, color: Colors.amberAccent),
        Icon(Icons.star_border, color: Colors.amberAccent),
        Icon(Icons.star_border, color: Colors.amberAccent),
      ],
    );
  }
}
