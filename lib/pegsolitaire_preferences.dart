library pegsolitaire_preferences;

import 'dart:core';

import 'package:shared_preferences/shared_preferences.dart';

class EasyPegSolitaireSharedPreferences {
  final String _pegColorPrefs = "pegColor";
  final String _difficultyPrefs = "difficulty";
  final String _bestGamePegsRemainingPrefs = "bestGamePegsRemaining";

  Future<String> _getPreference(String preferenceKey, String defaultValue) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(preferenceKey) ?? defaultValue;
  }

  Future<bool> _setPreference(String perferenceKey, String value) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setString(perferenceKey, value);
  }

  Future<Difficulty> getDifficulty() async {
    return _difficultyFromString(await _getPreference(_difficultyPrefs, Difficulty.MEDIUM.toString()));
  }

  Future<bool> setDifficulty(Difficulty value) async {
    return _setPreference(_difficultyPrefs, value.toString());
  }

  Future<int> getMaxNumUndos() async {
    Difficulty difficulty = await getDifficulty();
    switch (difficulty) {
      case Difficulty.HARD:
        return 1;
      case Difficulty.DIFFICULT:
        return 3;
      case Difficulty.MEDIUM:
        return 5;
      case Difficulty.EASY:
        return 7;
      case Difficulty.VERY_EASY:
        return 10;
      default:
        return 5;
    }
  }

  Future<String> getPegColor() async {
    return _getPreference(_pegColorPrefs, 'blue');
  }

  Future<bool> setPegColor(String value) async {
    return _setPreference(_pegColorPrefs, value);
  }

  Future<String> getBestGamePegsRemaining() async {
    return _getPreference(_bestGamePegsRemainingPrefs, '---');
  }

  Future<bool> setBestGamePegsRemaining(String value) async {
    return _setPreference(_bestGamePegsRemainingPrefs, value);
  }

  int getScore(String pegsRemaining) {
    switch (pegsRemaining) {
      case '1':
        return 3;
      case '2':
      case '3':
        return 2;
      case '4':
      case '5':
        return 1;
      default:
        return 0;
    }
  }
}

enum Difficulty { HARD, DIFFICULT, MEDIUM, EASY, VERY_EASY }

Difficulty _difficultyFromString(String value) {
  return Difficulty.values.firstWhere((e) => e.toString() == value);
}
