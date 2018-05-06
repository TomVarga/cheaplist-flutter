import 'package:cheaplist/constants.dart';
import 'package:cheaplist/main.dart';
import 'package:cheaplist/pages/settings_page.dart';
import 'package:cheaplist/pages/shopping_list.dart';
import 'package:cheaplist/util/authentication.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;

Drawer buildDrawer(BuildContext context, String route) {
  return new Drawer(
    child: new ListView(
      primary: false,
      children: <Widget>[
        new DrawerHeader(
          padding: const EdgeInsets.all(0.0),
          child: getDrawerHeader(context),
        ),
        new ListTile(
          selected: ComparePage.routeName == route,
          title: new Text('Compare', textAlign: TextAlign.start),
          leading: new Icon(Icons.compare),
          onTap: () {
            Navigator.of(context).pushReplacementNamed(ComparePage.routeName);
          },
        ),
        new ListTile(
          selected: ShoppingList.routeName == route,
          title: new Text('Shopping list', textAlign: TextAlign.start),
          leading: new Icon(Icons.list),
          onTap: () {
            Navigator.of(context).pushReplacementNamed(ShoppingList.routeName);
          },
        ),
        new ListTile(
          selected: SettingsPage.routeName == route,
          title: new Text('Settings', textAlign: TextAlign.start),
          leading: new Icon(Icons.settings),
          onTap: () {
            Navigator.of(context).pushReplacementNamed(SettingsPage.routeName);
          },
        ),
        new Divider(),
        new ListTile(
          title: new Text('Logout', textAlign: TextAlign.start),
          leading: new Icon(Icons.exit_to_app),
          onTap: () async {
            await signOutWithGoogle();
            Navigator.of(context).pushReplacementNamed('/');
          },
        ),
      ],
    ),
  );
}

Widget getDrawerHeader(context) {
  return new Container(
      color: Theme.of(context).accentColor,
      child: new FutureBuilder<FirebaseUser>(
        future: _auth.currentUser(),
        builder: (BuildContext context, AsyncSnapshot<FirebaseUser> snapshot) {
          if (snapshot.hasError || snapshot.data == null) {
            return new Container();
          } else {
            return new Container(
                margin: const EdgeInsets.all(8.0),
                child: new Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    new Text(
                      '${snapshot.data.displayName}',
                      style: Theme
                          .of(context)
                          .textTheme
                          .apply(bodyColor: AppColors.lightTextColor)
                          .title,
                    ),
                    new Text(
                      '${snapshot.data.email}',
                      style: Theme
                          .of(context)
                          .textTheme
                          .apply(bodyColor: AppColors.fadedTextColor)
                          .subhead,
                    ),
                  ],
                ));
          }
        },
      ));
}

Widget getDefaultAppBar(BuildContext context) {
  return new PreferredSize(
      child: new Hero(
        tag: getAppBarHeroTag(),
        child: new Material(
          child: new AppBar(
            title: new Text(getAppName()),
            elevation:
                Theme.of(context).platform == TargetPlatform.iOS ? 0.0 : 4.0,
          ),
        ),
      ),
      preferredSize: new Size.fromHeight(kToolbarHeight));
}
