library pegsolitaire_game_widgets;

import 'package:flutter/material.dart';
import 'package:pegsolitaire/pegsolitaire_localization.dart';
import 'package:pegsolitaire/pegsolitaire_model.dart';
import 'package:pegsolitaire/pegsolitaire_preferences.dart';
import 'package:pegsolitaire/pegsolitaire_size_calculator.dart';

class UndoDialogProvider {
  void show(BuildContext context, int usedUndos, int maxUndos) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return new AlertDialog(
          title: new Text(
            EasyPegSolitaireLocalizations.translate(context, 'undoPopupTitle'),
            style: TextStyle(color: Colors.grey[700]),
          ),
          content: new Text(
            EasyPegSolitaireLocalizations.translate(context, 'undoPopupText'),
            style: TextStyle(color: Colors.grey[700]),
          ),
          actions: <Widget>[
            new FlatButton(
              child: new Text(
                EasyPegSolitaireLocalizations.translate(context, 'continue'),
                style: TextStyle(color: Colors.grey[700]),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}

class GameFinishedDialogProvider {
  void show(BuildContext context, PegSolitaireModel model, Function reset) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: _getGameFinishedTitle(model, context),
          content: _getGameFinishedContent(model, context),
          actions: <Widget>[
            new FlatButton(
              child: new Text(
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

  Text _getGameFinishedTitle(PegSolitaireModel model, BuildContext context) {
    if (model.lost) {
      return new Text(
        EasyPegSolitaireLocalizations.translate(
            context, 'gameFinishedTitleLost'),
        style: TextStyle(color: Colors.grey[700]),
      );
    } else {
      return new Text(
        EasyPegSolitaireLocalizations.translate(
            context, 'gameFinishedTitleWon'),
        style: TextStyle(color: Colors.grey[700]),
      );
    }
  }

  Widget _getGameFinishedContent(
      PegSolitaireModel model, BuildContext context) {
    return new Container(
      padding: EdgeInsets.all(20.0),
      child: new Column(
        children: <Widget>[
          new Row(
            children: <Widget>[
              new Text(
                EasyPegSolitaireLocalizations.translate(context, 'score'),
                //style: Theme.of(context).textTheme.subhead,
                style: TextStyle(
                    color: Colors.grey[700],
                    fontSize: 16,
                    fontWeight: FontWeight.bold),
              ),
              _getStarsForScore(new EasyPegSolitaireSharedPreferences()
                  .getScore(model.getPegsRemaining().toString())),
            ],
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
          ),
          new Container(height: 20.0),
          new Row(
            children: <Widget>[
              new Text(
                EasyPegSolitaireLocalizations.translate(
                    context, 'pegsRemaining'),
                //style: Theme.of(context).textTheme.subhead,
                style: TextStyle(
                    color: Colors.grey[700],
                    fontSize: 16,
                    fontWeight: FontWeight.bold),
              ),
              new Text(model.getPegsRemaining().toString()),
            ],
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
          ),
          new Container(height: 40.0),
          _getGameFinishedText(model, context),
        ],
      ),
    );
  }

  Text _getGameFinishedText(PegSolitaireModel model, BuildContext context) {
    if (model.lost) {
      return new Text(
        EasyPegSolitaireLocalizations.translate(
            context, 'gameFinishedTextLost'),
        style: TextStyle(color: Colors.grey[700]),
      );
    } else {
      return new Text(
        EasyPegSolitaireLocalizations.translate(context, 'gameFinishedTextWon'),
        style: TextStyle(color: Colors.grey[700]),
      );
    }
  }

  Widget _getStarsForScore(int bestScore) {
    if (bestScore == 3) {
      return new Row(
        children: <Widget>[
          new Icon(Icons.star, color: Colors.amberAccent),
          new Icon(Icons.star, color: Colors.amberAccent),
          new Icon(Icons.star, color: Colors.amberAccent),
        ],
      );
    }
    if (bestScore == 2) {
      return new Row(
        children: <Widget>[
          new Icon(Icons.star, color: Colors.amberAccent),
          new Icon(Icons.star, color: Colors.amberAccent),
          new Icon(Icons.star_border, color: Colors.amberAccent),
        ],
      );
    }
    if (bestScore == 1) {
      return new Row(
        children: <Widget>[
          new Icon(Icons.star, color: Colors.amberAccent),
          new Icon(Icons.star_border, color: Colors.amberAccent),
          new Icon(Icons.star_border, color: Colors.amberAccent),
        ],
      );
    }
    return new Row(
      children: <Widget>[
        new Icon(Icons.star_border, color: Colors.amberAccent),
        new Icon(Icons.star_border, color: Colors.amberAccent),
        new Icon(Icons.star_border, color: Colors.amberAccent),
      ],
    );
  }
}

class BottomBar extends Container {
   BottomBar(BuildContext context, PegSolitaireModel model, Function undo,
      Function reset)
      : super(
            height: new WidgetSizeCalculator().getBottomBarHeight(context),
            width: new WidgetSizeCalculator().getWidgetSize(context),
            child: new Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                new MaterialButton(
                  padding: EdgeInsets.zero,
                  minWidth: 0,
                  child: new Stack(
                    alignment: new Alignment(0, 1),
                    children: <Widget>[
                      new Padding(
                        child: Icon(
                          Icons.undo,
                          color: Colors.grey,
                        ),
                        padding: EdgeInsets.only(
                            bottom: 10.0), // needed to move icon to top/start
                      ),
                      new Text(
                        '${model.getNumUndosLeft()}/${model.maxNumUndos}',
                        style: new TextStyle(
                          fontSize: 11.0,
                          color: Colors.grey[500],
                        ),
                      ),
                    ],
                  ),
                  onPressed: undo,
                ),
                new IconButton(
                  icon: new WinningIcon(model.lost),
                  padding: EdgeInsets.zero,
                  onPressed: () {
                    _showWinningIconDialog(context);
                  },
                ),
                new IconButton(
                  icon: Icon(
                    Icons.replay,
                    color: Colors.grey,
                  ),
                  padding: EdgeInsets.zero,
                  onPressed: reset,
                ),
              ],
            ));

  static void _showWinningIconDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: new Text(
            EasyPegSolitaireLocalizations.translate(
                context, 'winningIconTitle'),
            style: TextStyle(color: Colors.grey[700]),
          ),
          content: new Text(
            EasyPegSolitaireLocalizations.translate(context, 'winningIconText'),
            softWrap: true,
            style: TextStyle(color: Colors.grey[700]),
          ),
          actions: <Widget>[
            new FlatButton(
              child: new Text(
                EasyPegSolitaireLocalizations.translate(context, 'continue'),
                style: TextStyle(color: Colors.grey[700]),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}

class WinningIcon extends Icon {
  WinningIcon(bool gameLost)
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
