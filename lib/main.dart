import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:pegsolitaire/pegsolitaire_app_widgets.dart';
import 'package:pegsolitaire/pegsolitaire_board.dart';
import 'package:pegsolitaire/pegsolitaire_board_widget.dart';
import 'package:pegsolitaire/pegsolitaire_game_widgets.dart';
import 'package:pegsolitaire/pegsolitaire_localization.dart';
import 'package:pegsolitaire/pegsolitaire_model.dart';
import 'package:pegsolitaire/pegsolitaire_preferences.dart';
import 'package:pegsolitaire/pegsolitaire_settings_page.dart';
import 'package:pegsolitaire/pegsolitaire_size_calculator.dart';
//import 'package:flutter/rendering.dart';

void main() {
  //debugPaintSizeEnabled = true;
  runApp(new PegSolitaireApp());
}

class PegSolitaireApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      onGenerateTitle: (BuildContext context) => EasyPegSolitaireLocalizations.translate(context, 'title'),
      localizationsDelegates: [
        const EasyPegSolitaireLocalizationsDelegate(),
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      supportedLocales: [
        const Locale('en', ''),
        const Locale('de', ''),
      ],
      home: new PegSolitairePresenter(),
    );
  }
}

class PegSolitairePresenter extends StatefulWidget {
  @override
  _PegSolitairePresenterState createState() => new _PegSolitairePresenterState();
}

class _PegSolitairePresenterState extends State<PegSolitairePresenter> {
  PegSolitaireBoardWidget pegSolitaireBoardWidget;

  // model holds board and current game state
  PegSolitaireModel model = new PegSolitaireModel();
  UndoDialogProvider undoDialogProvider = new UndoDialogProvider();

  _PegSolitairePresenterState() {
    model.readWinningPositions(rootBundle);
    _loadPreferences();
  }

  _loadPreferences() async {
    model.pegColor = await new EasyPegSolitaireSharedPreferences().getPegColor();
    model.maxNumUndos = await new EasyPegSolitaireSharedPreferences().getMaxNumUndos();
    model.bestGamePegsRemaining = await new EasyPegSolitaireSharedPreferences().getBestGamePegsRemaining();
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
    double widgetSize = new WidgetSizeCalculator().getWidgetSize(context);
    pegSolitaireBoardWidget = new PegSolitaireBoardWidget(
      widgetSize: widgetSize,
      model: this.model,
      onLocationClick: (Location location) => _handleLocationClick(location),
    );

    Container bottomBar = new BottomBar(
      context,
      model,
      _undoButtonPressed,
      _resetGame,
    );

    return new Scaffold(
      appBar: new EasyPegSolitaireAppBar(context, 'title'),
      drawer: new HomePageDrawer(
        settingsPage: new SettingsPage(),
        refresh: _updateStateAfterPrefChange,
      ),
      body: new SafeArea(
        bottom: true,
        top: true,
        minimum: EdgeInsets.all(0.0),
        child: new Column(
          children: <Widget>[
            new Expanded(
              child: new Center(
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
      return null;
    }
  }

  void _handleLocationClick(Location location) {
    if (model.getContent(location.row, location.column).isPeg()) {
      _handlePegClicked(location);
    } else if (model.getContent(location.row, location.column).isHole() && model.selectedPegLocation != null) {
      _handleHoleClicked(location);
    }
  }

  // hole clicked + peg previously selected => move if possible
  void _handleHoleClicked(Location location) {
    // hole clicked + peg previously selected => move if possible
    Location start = model.selectedPegLocation;
    Location end = location;
    // determine resulting position
    String newPosition = model.findBoardPositionAfterMove(start, end);
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
        EasyPegSolitaireSharedPreferences preferences = new EasyPegSolitaireSharedPreferences();
        if (model.bestGamePegsRemaining == '---' || model.getPegsRemaining() < int.parse(model.bestGamePegsRemaining)) {
          // update score only if this score is better then the current best score
          String newBestGamePegsRemaining = (32 - model.move).toString();
          preferences.setBestGamePegsRemaining(newBestGamePegsRemaining);
          model.bestGamePegsRemaining = newBestGamePegsRemaining;
        }
        new GameFinishedDialogProvider().show(context, model, () => _resetGame());
      }
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
  }
}
