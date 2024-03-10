import 'package:flutter/material.dart';

import '../config/pegsolitaire_localization.dart';
import '../config/widget_size_calculator.dart';

class HomePageDrawer extends StatelessWidget {
  final Widget settingsPage;
  final Widget achievementsPage;
  final Function refresh;

  const HomePageDrawer({
    super.key,
    required this.settingsPage,
    required this.achievementsPage,
    required this.refresh,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: true,
      top: true,
      minimum: EdgeInsets.zero,
      child: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          shrinkWrap: true,
          children: <Widget>[
            SizedBox(
              height: WidgetSizeCalculator().getAppBarHeight(),
              child: DrawerHeader(
                padding: EdgeInsets.zero,
                margin: EdgeInsets.zero,
                decoration: const BoxDecoration(color: Colors.grey),
                child: Center(
                  child: Text(
                    EasyPegSolitaireLocalizations.translate(context, 'menu'),
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.settings),
              title: Text(
                  EasyPegSolitaireLocalizations.translate(context, 'settings')),
              onTap: () {
                Navigator.pop(context);
                Navigator.of(context)
                    .push(
                      MaterialPageRoute(builder: (context) => settingsPage),
                    )
                    .then((val) => refresh());
              },
            ),
            ListTile(
              leading: const Icon(Icons.star_border_outlined),
              title: Text(
                  EasyPegSolitaireLocalizations.translate(context, 'achievements')),
              onTap: () {
                Navigator.pop(context);
                Navigator.of(context)
                    .push(
                      MaterialPageRoute(builder: (context) => achievementsPage),
                    )
                    .then((val) => refresh());
              },
            ),
          ],
        ),
      ),
    );
  }
}
