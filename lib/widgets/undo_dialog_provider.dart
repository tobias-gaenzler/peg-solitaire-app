import 'package:flutter/material.dart';
import 'package:pegsolitaire/config/pegsolitaire_localization.dart';

class UndoDialogProvider {
  void show(BuildContext context, int usedUndos, int maxUndos) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            EasyPegSolitaireLocalizations.translate(context, 'undoPopupTitle'),
            style: TextStyle(color: Colors.grey[700]),
          ),
          content: Text(
            EasyPegSolitaireLocalizations.translate(context, 'undoPopupText'),
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



