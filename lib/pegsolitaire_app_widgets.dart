library pegsolitaire_app_widgets;

import 'package:flutter/material.dart';
import 'package:pegsolitaire/easy_peg_solitaire_icons_icons.dart';
import 'package:pegsolitaire/pegsolitaire_achievments_page.dart';
import 'package:pegsolitaire/pegsolitaire_localization.dart';
import 'package:pegsolitaire/pegsolitaire_size_calculator.dart';

class EasyPegSolitaireAppBar extends PreferredSize {
  EasyPegSolitaireAppBar(BuildContext context,
      String titleKey,) : super(
      preferredSize: Size.fromHeight(
        new WidgetSizeCalculator().getAppBarHeight(),
      ),
      child: new AppBar(
          title: new Text(
            EasyPegSolitaireLocalizations.translate(context, titleKey),
          ),
          backgroundColor: Colors.grey,
          actions: <Widget>[
            new Padding(
                padding: EdgeInsets.only(right: 10.0),
                child: new IconButton(
                  icon: Icon(
                    EasyPegSolitaireIcons.award,
                    color: Colors.black12,
                  ),
                  onPressed: () {
                    Navigator.of(context).push(
                      new MaterialPageRoute(builder: (context) => new AchievementsPage()),
                    );
                  },
                )),
          ]));
}

class DefaultAppBar extends PreferredSize {
  DefaultAppBar(BuildContext context,
      String titleKey,) : super(
      preferredSize: Size.fromHeight(
        new WidgetSizeCalculator().getAppBarHeight(),
      ),
      child: new AppBar(
        title: new Text(
          EasyPegSolitaireLocalizations.translate(context, titleKey),
        ),
        backgroundColor: Colors.grey,
      ));
}

class HomePageDrawer extends StatelessWidget {
  final Widget settingsPage;
  final Function refresh;

  HomePageDrawer({
    this.settingsPage,
    this.refresh,
  });

  @override
  Widget build(BuildContext context) {
    return new SafeArea(
      bottom: true,
      top: true,
      minimum: EdgeInsets.zero,
      child: new Drawer(
        child: new ListView(
          padding: EdgeInsets.zero,
          shrinkWrap: true,
          children: <Widget>[
            new Container(
              height: new WidgetSizeCalculator().getAppBarHeight(),
              child: new DrawerHeader(
                child: new Center(
                  child: new Text(
                    EasyPegSolitaireLocalizations.translate(context, 'menu'),
                    style: new TextStyle(color: Colors.white),
                  ),
                ),
                padding: EdgeInsets.zero,
                margin: EdgeInsets.zero,
                decoration: new BoxDecoration(color: Colors.grey),
              ),
            ),
            new ListTile(
              leading: new Icon(Icons.settings),
              title: new Text(EasyPegSolitaireLocalizations.translate(context, 'settings')),
              onTap: () {
                Navigator.pop(context);
                Navigator.of(context)
                    .push(
                  new MaterialPageRoute(builder: (context) => settingsPage),
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
