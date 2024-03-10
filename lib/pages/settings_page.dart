library settings_page;

import 'package:flutter/material.dart';
import 'package:pegsolitaire/config/pegsolitaire_localization.dart';
import 'package:pegsolitaire/config/pegsolitaire_preferences.dart';
import 'package:pegsolitaire/widgets/subpage_app_bar.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<StatefulWidget> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  String _pegColor = 'blue';
  Difficulty _difficulty = Difficulty.medium;

  @override
  void initState() {
    super.initState();
    _loadPreferences();
  }

  _loadPreferences() async {
    final String pegColor =
        await EasyPegSolitaireSharedPreferences().getPegColor();
    final Difficulty difficulty =
        await EasyPegSolitaireSharedPreferences().getDifficulty();
    setState(() {
      _pegColor = pegColor;
      _difficulty = difficulty;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: SubpageAppBar(context, 'settings'),
      body: Container(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  EasyPegSolitaireLocalizations.translate(context, 'pegColor'),
                  //style: Theme.of(context).textTheme.subhead,
                  style: TextStyle(
                      color: Colors.grey[700],
                      fontSize: 16,
                      fontWeight: FontWeight.bold),
                ),
                DropdownButton<String>(
                  items: <String>[
                    'blue',
                    'green',
                    'grey',
                    'orange',
                    'red',
                    'yellow'
                  ].map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: _getPegColorIcon(value),
                    );
                  }).toList(),
                  value: _pegColor,
                  onChanged: (newPegColor) {
                    if (newPegColor != null) {
                      EasyPegSolitaireSharedPreferences()
                          .setPegColor(newPegColor);
                      _pegColor = newPegColor;
                      setState(() {});
                    }
                  },
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  EasyPegSolitaireLocalizations.translate(
                      context, 'difficulty'),
                  style: TextStyle(
                      color: Colors.grey[700],
                      fontSize: 16,
                      fontWeight: FontWeight.bold),
                ),
                DropdownButton<Difficulty>(
                    items: Difficulty.values.map((Difficulty difficulty) {
                      return DropdownMenuItem<Difficulty>(
                        value: difficulty,
                        child: Text(
                          EasyPegSolitaireLocalizations.translate(
                            context,
                            difficulty.toString(),
                          ),
                          textAlign: TextAlign.center,
                          style:
                              TextStyle(color: Colors.grey[600], fontSize: 14),
                        ),
                      );
                    }).toList(),
                    value: _difficulty,
                    onChanged: (newDifficulty) {
                      if (newDifficulty != null) {
                        EasyPegSolitaireSharedPreferences()
                            .setDifficulty(newDifficulty);
                        _difficulty = newDifficulty;
                        setState(() {});
                      }
                    }),
              ],
            ),
          ],
        ),
      ),
    );
  }

  IconButton _getPegColorIcon(String color) {
    return IconButton(
        icon: Image.asset(
          'assets/peg_$color.png',
          height: 32.0,
          width: 32.0,
        ),
        onPressed: null);
  }
}
