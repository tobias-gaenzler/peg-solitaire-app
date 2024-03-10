library achievments_page;

import 'package:flutter/material.dart';
import 'package:pegsolitaire/config/pegsolitaire_localization.dart';
import 'package:pegsolitaire/config/pegsolitaire_preferences.dart';
import 'package:pegsolitaire/widgets/subpage_app_bar.dart';

class AchievementsPage extends StatefulWidget {
  const AchievementsPage({super.key});

  @override
  State<StatefulWidget> createState() {
    return _AchievementsPage();
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
    EasyPegSolitaireSharedPreferences easyPegSolitaireSharedPreferences =
        EasyPegSolitaireSharedPreferences();
    final String pegsRemaining =
        await easyPegSolitaireSharedPreferences.getBestGamePegsRemaining();
    setState(() {
      _pegsRemaining = pegsRemaining;
      _bestScore = easyPegSolitaireSharedPreferences.getScore(_pegsRemaining);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: SubpageAppBar(context, 'achievements'),
      body: Container(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  EasyPegSolitaireLocalizations.translate(context, 'bestScore'),
                  //style: Theme.of(context).textTheme.subhead,
                  style: TextStyle(
                      color: Colors.grey[700],
                      fontSize: 16,
                      fontWeight: FontWeight.bold),
                ),
                _getStarsForScore(),
              ],
            ),
            Container(height: 20.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  EasyPegSolitaireLocalizations.translate(
                      context, 'bestGamePegsRemaining'),
                  //style: Theme.of(context).textTheme.subhead,
                  style: TextStyle(
                      color: Colors.grey[700],
                      fontSize: 16,
                      fontWeight: FontWeight.bold),
                ),
                Text(_pegsRemaining),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _getStarsForScore() {
    if (_bestScore == 3) {
      return const Row(
        children: <Widget>[
          Icon(Icons.star, color: Colors.amberAccent),
          Icon(Icons.star, color: Colors.amberAccent),
          Icon(Icons.star, color: Colors.amberAccent),
        ],
      );
    }
    if (_bestScore == 2) {
      return const Row(
        children: <Widget>[
          Icon(Icons.star, color: Colors.amberAccent),
          Icon(Icons.star, color: Colors.amberAccent),
          Icon(Icons.star_border, color: Colors.amberAccent),
        ],
      );
    }
    if (_bestScore == 1) {
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
