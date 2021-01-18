library pegsolitaire_settings_page;

import 'package:flutter/material.dart';
import 'package:pegsolitaire/pegsolitaire_app_widgets.dart';
import 'package:pegsolitaire/pegsolitaire_localization.dart';
import 'package:pegsolitaire/pegsolitaire_preferences.dart';

class SettingsPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new _SettingsPageState();
  }
}

class _SettingsPageState extends State<SettingsPage> {
  String _pegColor;
  Difficulty _difficulty;

  @override
  void initState() {
    super.initState();
    _loadPreferences();
  }

  _loadPreferences() async {
    final String pegColor = await new EasyPegSolitaireSharedPreferences().getPegColor();
    final Difficulty difficulty = await new EasyPegSolitaireSharedPreferences().getDifficulty();
    setState(() {
      _pegColor = pegColor;
      _difficulty = difficulty;
    });
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new DefaultAppBar(context, 'settings'),
      body: new Container(
        padding: EdgeInsets.all(10.0),
        child: new Column(
          children: <Widget>[
            new Row(
              children: <Widget>[
                new Text(
                  EasyPegSolitaireLocalizations.translate(context, 'pegColor'),
                  //style: Theme.of(context).textTheme.subhead,
                  style: TextStyle(color: Colors.grey[700], fontSize: 16, fontWeight: FontWeight.bold),
                ),
                new DropdownButton<String>(
                  items: <String>['blue', 'green', 'grey', 'orange', 'red', 'yellow'].map((String value) {
                    return new DropdownMenuItem<String>(
                      value: value,
                      child: _getPegColorIcon(value),
                    );
                  }).toList(),
                  value: _pegColor,
                  onChanged: (newPegColor) {
                    new EasyPegSolitaireSharedPreferences().setPegColor(newPegColor);
                    _pegColor = newPegColor;
                    setState(() {});
                  },
                ),
              ],
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
            ),
            new Row(
              children: <Widget>[
                new Text(
                  EasyPegSolitaireLocalizations.translate(context, 'difficulty'),
                  style: TextStyle(color: Colors.grey[700], fontSize: 16, fontWeight: FontWeight.bold),
                ),
                new DropdownButton<Difficulty>(
                    items: Difficulty.values.map((Difficulty difficulty) {
                      return new DropdownMenuItem<Difficulty>(
                        value: difficulty,
                        child: new Text(
                          EasyPegSolitaireLocalizations.translate(
                            context,
                            difficulty.toString(),
                          ),
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.grey[600], fontSize: 14),
                        ),
                      );
                    }).toList(),
                    value: _difficulty,
                    onChanged: (newDifficulty) {
                      new EasyPegSolitaireSharedPreferences().setDifficulty(newDifficulty);
                      _difficulty = newDifficulty;
                      setState(() {});
                    }),
              ],
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
            ),
          ],
        ),
      ),
    );
  }

  IconButton _getPegColorIcon(String color) {
    return new IconButton(
        icon: new Image.asset(
          'assets/peg_$color.png',
          height: 32.0,
          width: 32.0,
        ),
        onPressed: null);
  }
}
