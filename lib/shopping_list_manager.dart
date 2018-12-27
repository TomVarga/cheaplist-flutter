import 'dart:async';

import 'package:cheaplist/dto/daos.dart';
import 'package:cheaplist/util/authentication.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

addToList(MerchantItem item) {
  Firestore.instance
      .collection("userData")
      .document(userId)
      .collection("shoppingList")
      .document(item.id)
      .setData(item.toMap());
}

removeFromList(MerchantItem item) {
  Firestore.instance
      .collection("userData")
      .document(userId)
      .collection("shoppingList")
      .document(item.id)
      .delete();
}

Stream<DocumentSnapshot> getShoppingListItemStream(MerchantItem item) {
  return Firestore.instance
      .collection("userData")
      .document(userId)
      .collection("shoppingList")
      .document(item.id)
      .snapshots();
}

toggleChecked(MerchantItem item, bool newValue) {
  item.checked = newValue;
  Firestore.instance
      .collection("userData")
      .document(userId)
      .collection("shoppingList")
      .document(item.id)
      .setData(item.toMap());
}
