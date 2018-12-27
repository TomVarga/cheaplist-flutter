import 'package:cheaplist/dto/daos.dart';
import 'package:cheaplist/util/authentication.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

const IMAGE_DOWNLOADING_DISABLED = "IMAGE_DOWNLOADING_DISABLED";

bool imageDownloadingDisabled = false;

toggleChecked(CheckedUserSetting userSetting, bool newValue) {
  userSetting.checked = newValue;
  Firestore.instance
      .collection("userData")
      .document(userId)
      .collection("userSettings")
      .document(userSetting.id)
      .setData(userSetting.toMap());
}

getSetting(String name) {
  return Firestore.instance
      .collection("userData")
      .document(userId)
      .collection("userSettings")
      .document(name)
      .snapshots();
}
