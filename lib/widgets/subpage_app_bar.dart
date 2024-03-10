import 'package:flutter/material.dart';
import 'package:pegsolitaire/config/pegsolitaire_localization.dart';
import 'package:pegsolitaire/config/widget_size_calculator.dart';

class SubpageAppBar extends PreferredSize {
  SubpageAppBar(BuildContext context, String titleKey, {super.key})
      : super(
            preferredSize: Size.fromHeight(
              WidgetSizeCalculator().getAppBarHeight(),
            ),
            child: AppBar(
              title: Text(
                EasyPegSolitaireLocalizations.translate(context, titleKey),
              ),
              backgroundColor: Colors.grey,
            ));
}
