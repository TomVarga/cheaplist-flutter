import 'package:cheaplist/util/drawer_builder.dart';
import 'package:flutter/material.dart';

class SettingsPage extends StatefulWidget {
  static String routeName = '/settings';

  SettingsPage({Key key}) : super(key: key);

  @override
  _SettingsPageState createState() => new _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  _SettingsPageState();

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: getDefaultAppBar(context),
        drawer: buildDrawer(context, SettingsPage.routeName),
        body: new Text("Settings"));
  }
}
