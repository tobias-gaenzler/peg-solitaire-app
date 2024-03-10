import 'package:flutter/material.dart';
import 'package:pegsolitaire/config/pegsolitaire_localization.dart';
import 'package:pegsolitaire/config/widget_size_calculator.dart';
import 'package:pegsolitaire/pegsolitaire/game_model.dart';
import 'package:provider/provider.dart';

import 'winning_icon.dart';

class BottomBar extends Container {
  BottomBar(BuildContext context, void Function()? undo, void Function()? reset, {super.key})
      : super(
            height: WidgetSizeCalculator().getBottomBarHeight(context),
            width: WidgetSizeCalculator().getWidth(context),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: <Widget>[
                FittedBox(
                  child: MaterialButton(
                    onPressed: undo,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Icon(
                          Icons.undo,
                          color: Colors.grey,
                          size: WidgetSizeCalculator().getBottomBarHeight(context),
                        ), //TODO: not working
                        Consumer<GameModel>(
                            builder: (context, model, child) => Text(
                                  '${model.getNumUndosLeft()}/${model.maxNumUndos}',
                                  style: TextStyle(
                                      color: Colors.grey[500],
                                      fontWeight: FontWeight.bold,
                                      fontSize: WidgetSizeCalculator().getBottomBarHeight(context) * 0.5),
                                )), // text
                      ],
                    ),
                  ),
                ),
                Consumer<GameModel>( //TODO: not working: uses different model than presenter!!
                    builder: (context, model, child) => IconButton(
                          icon: WinningIcon(model.lost),
                          padding: EdgeInsets.zero,
                          iconSize: WidgetSizeCalculator().getBottomBarHeight(context),
                          onPressed: () {
                            _showWinningIconDialog(context);
                          },
                        )),
                IconButton(
                  icon: const Icon(
                    Icons.replay,
                    color: Colors.grey,
                  ),
                  padding: EdgeInsets.zero,
                  iconSize: WidgetSizeCalculator().getBottomBarHeight(context),
                  onPressed: reset,
                ),
              ],
            ));

  static void _showWinningIconDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            EasyPegSolitaireLocalizations.translate(context, 'winningIconTitle'),
            style: TextStyle(color: Colors.grey[700]),
          ),
          content: Text(
            EasyPegSolitaireLocalizations.translate(context, 'winningIconText'),
            softWrap: true,
            style: TextStyle(color: Colors.grey[700]),
          ),
          actions: <Widget>[
            TextButton(
              child: Text(
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
