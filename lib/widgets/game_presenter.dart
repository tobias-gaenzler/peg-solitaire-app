import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:pegsolitaire/config/pegsolitaire_preferences.dart';
import 'package:pegsolitaire/config/widget_size_calculator.dart';
import 'package:pegsolitaire/pages/achievements_page.dart';
import 'package:pegsolitaire/pages/settings_page.dart';
import 'package:pegsolitaire/pegsolitaire/game_model.dart';
import 'package:pegsolitaire/pegsolitaire/location.dart';

import 'bottom_bar.dart';
import 'game_finished_dialog_provider.dart';
import 'home_page_drawer.dart';
import 'main_app_bar.dart';
import 'pegsolitaire_board.dart';
import 'undo_dialog_provider.dart';

class GamePresenter extends StatefulWidget {
  const GamePresenter({super.key});

  @override
  State<StatefulWidget> createState() => _GamePresenterState();
}

class _GamePresenterState extends State<GamePresenter> {
  PegSolitaireBoard? pegSolitaireBoardWidget;

  // model holds board and current game state
  // TODO: get model from provider
  GameModel model = GameModel();
  UndoDialogProvider undoDialogProvider = UndoDialogProvider();

  _GamePresenterState() {
    model.readWinningPositions(rootBundle);
    _loadPreferences();
  }

  _loadPreferences() async {
    model.pegColor = await EasyPegSolitaireSharedPreferences().getPegColor();
    model.maxNumUndos = await EasyPegSolitaireSharedPreferences().getMaxNumUndos();
    model.bestGamePegsRemaining = await EasyPegSolitaireSharedPreferences().getBestGamePegsRemaining();
    setState(() {});
  }

  void _updateStateAfterPrefChange() async {
    setState(() {
      _loadPreferences();
    });
  }

  @override
  Widget build(BuildContext context) {
    // create board widget
    double widgetSize = WidgetSizeCalculator().getWidgetSize(context);
    pegSolitaireBoardWidget = PegSolitaireBoard(
      widgetSize: widgetSize,
      model: model,
      onLocationClick: (Location location) => _handleLocationClick(location),
    );

    Container bottomBar = BottomBar(
      context,
      _undoButtonPressed,
      _resetGame,
    );

    return Scaffold(
      appBar: MainAppBar(context, 'title'),
      drawer: HomePageDrawer(
        settingsPage: const SettingsPage(),
        achievementsPage: const AchievementsPage(),
        refresh: _updateStateAfterPrefChange,
      ),
      body: SafeArea(
        bottom: true,
        top: true,
        minimum: const EdgeInsets.all(0.0),
        child: Column(
          children: <Widget>[
            Expanded(
              child: Center(
                child: pegSolitaireBoardWidget,
              ),
            ),
            bottomBar,
          ],
        ),
      ),
    );
  }

  void _resetGame() {
    model.reset();
    setState(() {});
  }

  void _undoButtonPressed() {
    if ((model.numUndos == (model.maxNumUndos - 1)) && model.isUndoAllowed()) {
      undoDialogProvider.show(context, model.numUndos, model.maxNumUndos);
    }
    if (model.isUndoAllowed()) {
      model.deleteMove();
      setState(() {});
    } else {
      return;
    }
  }

  void _handleLocationClick(Location location) {
    if (model.getContentAtLocation(location.row, location.column).isPeg()) {
      _handlePegClicked(location);
    } else if (model.getContentAtLocation(location.row, location.column).isHole() &&
        model.selectedPegLocation != null) {
      _handleHoleClicked(location);
    }
  }

  // hole clicked + peg previously selected => move if possible
  void _handleHoleClicked(Location location) {
    if (model.selectedPegLocation == null) {
      return;
    }
    // hole clicked + peg previously selected => move if possible
    Location moveStartLocation = model.selectedPegLocation!;
    Location moveEndLocation = location;
    // determine resulting position
    String? newPosition = model.findBoardPositionAfterMove(moveStartLocation, moveEndLocation);
    if (newPosition != null) {
      // add move
      model.addMove(newPosition);
      // select (moved peg will be highlighted)
      model.selectedPegLocation = location;
      //check if new positions is in winning positions
      if (!model.isInWinningPositions(newPosition)) {
        model.lost = true;
        setState(() {});
      }
      if (model.isGameFinished()) {
        EasyPegSolitaireSharedPreferences preferences = EasyPegSolitaireSharedPreferences();
        if (model.bestGamePegsRemaining == '---' ||
            model.getPegsRemaining() < int.parse(model.bestGamePegsRemaining!)) {
          // update score only if this score is better then the current best score
          String newBestGamePegsRemaining = (32 - model.move).toString();
          preferences.setBestGamePegsRemaining(newBestGamePegsRemaining);
          model.bestGamePegsRemaining = newBestGamePegsRemaining;
        }
        GameFinishedDialogProvider().show(context, model, () => _resetGame());
      }
      model.notify();
    }
  }

  void _handlePegClicked(Location location) {
    // peg clicked
    if (model.selectedPegLocation == location) {
      // deselect
      model.selectedPegLocation = null;
    } else {
      // select (clicked peg will be highlighted)
      model.selectedPegLocation = location;
    }
    model.notify();
  }
}
