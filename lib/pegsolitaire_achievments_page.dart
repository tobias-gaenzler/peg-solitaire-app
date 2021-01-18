library pegsolitaire_achievments_page;

import 'package:flutter/material.dart';
import 'package:pegsolitaire/pegsolitaire_app_widgets.dart';
import 'package:pegsolitaire/pegsolitaire_localization.dart';
import 'package:pegsolitaire/pegsolitaire_preferences.dart';

class AchievementsPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new _AchievementsPage();
  }
}

class _AchievementsPage extends State<AchievementsPage> {
  String _pegsRemaining = '---';
  int _bestScore = 0;

  @override
  void initState() {
    super.initState();
    _loadPreferences();
  }

  _loadPreferences() async {
    EasyPegSolitaireSharedPreferences easyPegSolitaireSharedPreferences = new EasyPegSolitaireSharedPreferences();
    final String pegsRemaining = await easyPegSolitaireSharedPreferences.getBestGamePegsRemaining();
    setState(() {
      _pegsRemaining = pegsRemaining;
      _bestScore = easyPegSolitaireSharedPreferences.getScore(_pegsRemaining);
    });
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new DefaultAppBar(context, 'achievements'),
      body: new Container(
        padding: EdgeInsets.all(20.0),
        child: new Column(
          children: <Widget>[
            new Row(
              children: <Widget>[
                new Text(
                  EasyPegSolitaireLocalizations.translate(context, 'bestScore'),
                  //style: Theme.of(context).textTheme.subhead,
                  style: TextStyle(color: Colors.grey[700], fontSize: 16, fontWeight: FontWeight.bold),
                ),
                _getStarsForScore(),
              ],
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
            ),
            new Container(height: 20.0),
            new Row(
              children: <Widget>[
                new Text(
                  EasyPegSolitaireLocalizations.translate(context, 'bestGamePegsRemaining'),
                  //style: Theme.of(context).textTheme.subhead,
                  style: TextStyle(color: Colors.grey[700], fontSize: 16, fontWeight: FontWeight.bold),
                ),
                new Text(_pegsRemaining),
              ],
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
            ),
          ],
        ),
      ),
    );
  }

  Widget _getStarsForScore() {
    if (_bestScore == 3) {
      return new Row(
        children: <Widget>[
          new Icon(Icons.star, color: Colors.amberAccent),
          new Icon(Icons.star, color: Colors.amberAccent),
          new Icon(Icons.star, color: Colors.amberAccent),
        ],
      );
    }
    if (_bestScore == 2) {
      return new Row(
        children: <Widget>[
          new Icon(Icons.star, color: Colors.amberAccent),
          new Icon(Icons.star, color: Colors.amberAccent),
          new Icon(Icons.star_border, color: Colors.amberAccent),
        ],
      );
    }
    if (_bestScore == 1) {
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
