library pegsolitaire_size_calculator;

import 'package:flutter/material.dart';

class WidgetSizeCalculator {
  double getWidgetSize(BuildContext context) {
    if (MediaQuery.of(context).orientation == Orientation.portrait) {
      // use max. width in portrait mode
      return MediaQuery.of(context).size.width;
    }
    return MediaQuery
        .of(context)
        .size
        .height - 100.0; // subtract app bar and bottom bar with some margin
  }

  double getBottomBarHeight(BuildContext context) {
    return 32.0; // icons need 24 + some margin
  }

  double getAppBarHeight() {
    return 38.0;
  }
}
