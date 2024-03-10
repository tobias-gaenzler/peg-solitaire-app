library pegsolitaire_localization;

import 'package:flutter/foundation.dart' show SynchronousFuture;
import 'package:flutter/material.dart';

class EasyPegSolitaireLocalizations {
  EasyPegSolitaireLocalizations(this.locale);

  final Locale locale;

  static String translate(BuildContext context, String key) {
    return Localizations.of<EasyPegSolitaireLocalizations>(
            context, EasyPegSolitaireLocalizations)!
        .getTranslation(key);
  }

  static final Map<String, Map<String, String>> _localizedValues = {
    'en': {
      'title': 'Easy Peg Solitaire',
      'winningIconTitle': 'Winning Icon',
      'winningIconText':
          'This is the winning icon. A smiley indicates that you can still win the game.',
      'continue': 'Continue',
      'undoPopupTitle': 'No more undos left',
      'undoPopupText': 'You have used all undos.\n',
      'newGame': 'New game',
      'gameFinishedTitleLost': 'Game lost',
      'gameFinishedTextLost': 'Try again!',
      'gameFinishedTitleWon': 'Game won',
      'gameFinishedTextWon': 'Congratulations you won the game!',
      'settings': 'Settings',
      'menu': 'Menu',
      'pegColor': 'Peg color',
      'difficulty': 'Difficulty',
      'Difficulty.hard': 'hard',
      'Difficulty.difficult': 'difficult',
      'Difficulty.medium': 'medium',
      'Difficulty.easy': 'easy',
      'Difficulty.veryEasy': 'very easy',
      'achievements': 'Achievements',
      'bestGamePegsRemaining': 'Pegs remaining',
      'pegsRemaining': 'Pegs remaining',
      'bestScore': 'Best Score',
      'score': 'Score',
    },
    'de': {
      'title': 'Solitaire',
      'winningIconTitle': 'Gewinn Indikator',
      'winningIconText':
          'Dieses Icon zeigt an ob das Spiel noch gewonnen werden kann oder schon verloren ist.',
      'continue': 'Weiter',
      'undoPopupTitle': 'Zug rückgängig machen',
      'undoPopupText': 'Du kannst keine weiteren Züge rückgängig machen.\n',
      'newGame': 'Neues Spiel',
      'gameFinishedTitleLost': 'Spiel verloren',
      'gameFinishedTextLost': 'Versuch\'s noch einmal.',
      'gameFinishedTitleWon': 'Spiel gewonnen',
      'gameFinishedTextWon': 'Glückwunsch Du hast das Spiel gewonnen!',
      'settings': 'Einstellungen',
      'menu': 'Menü',
      'pegColor': 'Farbe der Stifte:',
      'difficulty': 'Schwierigkeit:',
      'Difficulty.hard': 'Hart',
      'Difficulty.difficult': 'Schwierig',
      'Difficulty.medium': 'Mittel',
      'Difficulty.easy': 'Einfach',
      'Difficulty.veryEasy': 'Sehr einfach',
      'achievements': 'Erfolge',
      'bestGamePegsRemaining': 'Steine übrig',
      'pegsRemaining': 'Steine übrig',
      'bestScore': 'Bestes Ergebnis',
      'score': 'Ergebnis',
    },
  };

  String getTranslation(String key) {
    if (_localizedValues[locale.languageCode] == null ||
        _localizedValues[locale.languageCode]![key] == null) {
      return "";
    } else {
      return _localizedValues[locale.languageCode]![key]!;
    }
  }
}

class EasyPegSolitaireLocalizationsDelegate
    extends LocalizationsDelegate<EasyPegSolitaireLocalizations> {
  const EasyPegSolitaireLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) => ['en', 'de'].contains(locale.languageCode);

  @override
  Future<EasyPegSolitaireLocalizations> load(Locale locale) {
    return SynchronousFuture<EasyPegSolitaireLocalizations>(
        EasyPegSolitaireLocalizations(locale));
  }

  @override
  bool shouldReload(EasyPegSolitaireLocalizationsDelegate old) => false;
}
