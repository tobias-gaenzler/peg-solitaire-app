library widget_size_calculator;

import 'package:flutter/material.dart';

class WidgetSizeCalculator {
  double getWidgetSize(BuildContext context) {
    if (MediaQuery.of(context).orientation == Orientation.portrait) {
      if (MediaQuery.of(context).size.height - getAppBarHeight() - getBottomBarHeight(context) > MediaQuery.of(context).size.width) {
        return MediaQuery.of(context).size.width;
      } else {
        return MediaQuery.of(context).size.width - getAppBarHeight() - getBottomBarHeight(context);
      }
    } else {
      return MediaQuery.of(context).size.height - getAppBarHeight() - getBottomBarHeight(context); // subtract app bar and bottom bar with some margin
    }
  }

  double getWidth(BuildContext context) {
    if (MediaQuery.of(context).orientation == Orientation.portrait) {
      return MediaQuery.of(context).size.width;
    } else {
      return MediaQuery.of(context).size.height;
    }
  }

  double getBottomBarHeight(BuildContext context) {
    if (MediaQuery.of(context).orientation == Orientation.portrait) {
      return MediaQuery.of(context).size.width / 7;
    } else {
      return MediaQuery.of(context).size.height / 12;
    }
  }

  double getAppBarHeight() {
    return 38.0;
  }
}
