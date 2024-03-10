import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:pegsolitaire/config/pegsolitaire_localization.dart';
import 'package:pegsolitaire/pegsolitaire/game_model.dart';
import 'package:pegsolitaire/widgets/game_presenter.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
      ChangeNotifierProvider(
          create: (context) => GameModel(),
          child: const PegSolitaireApp())
  );
}

class PegSolitaireApp extends StatelessWidget {
  const PegSolitaireApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        onGenerateTitle: (BuildContext context) => EasyPegSolitaireLocalizations.translate(context, 'title'),
        localizationsDelegates: const [
          EasyPegSolitaireLocalizationsDelegate(),
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate
        ],
        supportedLocales: const [
          Locale('en', 'US'),
          Locale('de', 'DE'),
        ],
        home: const GamePresenter());
  }
}
