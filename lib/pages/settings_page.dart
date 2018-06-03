import 'package:cheaplist/dto/daos.dart';
import 'package:cheaplist/user_settings_manager.dart';
import 'package:cheaplist/util/drawer_builder.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class SettingsPage extends StatefulWidget {
  static String routeName = '/settings';

  SettingsPage({Key key}) : super(key: key);

  @override
  _SettingsPageState createState() => new _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  _SettingsPageState();

  CheckedUserSetting checkedUserSetting;

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: getDefaultAppBar(context),
      drawer: buildDrawer(context, SettingsPage.routeName),
      body: new InkWell(
          onTap: () {
            if (CheckedUserSetting != null) {
              onTap(!checkedUserSetting.checked);
            }
          },
          child: new Container(
            margin: new EdgeInsets.all(1.0),
            child: Ink(color: Colors.white, child: getImageDownloadSetting()),
          )),
    );
  }

  getImageDownloadSetting() {
    return new StreamBuilder<DocumentSnapshot>(
      stream: getSetting(IMAGE_DOWNLOADING_DISABLED),
      builder:
          (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
        if (!snapshot.hasData) return const Text('Loading...');
        checkedUserSetting = new CheckedUserSetting(snapshot.data);
        return new Row(
          children: <Widget>[
            new Checkbox(
              value: checkedUserSetting.checked,
              onChanged: (newValue) {
                onTap(newValue);
              },
            ),
            new Text("Disable image downloading")
          ],
        );
      },
    );
  }

  void onTap(bool newValue) {
    checkedUserSetting.id = IMAGE_DOWNLOADING_DISABLED;
    toggleChecked(checkedUserSetting, newValue);
  }
}
