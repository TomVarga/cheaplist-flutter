import 'dart:async';

import 'package:cheaplist/redux/actions.dart';
import 'package:cheaplist/redux/app_state.dart';
import 'package:cheaplist/redux/merchant_tem.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:redux_epics/redux_epics.dart';
import 'package:rxdart/rxdart.dart';

final allEpics = combineEpics<AppState>(
    [
      firstMerchantItemEpic,
      secondMerchantItemEpic
    ]);


Stream<dynamic> firstMerchantItemEpic(Stream<dynamic> actions,
    EpicStore<AppState> store) {
  return new Observable(actions)
      .ofType(new TypeToken<RequestFirstMerchantDataEventsAction>())
      .flatMapLatest((RequestFirstMerchantDataEventsAction requestAction) {
    return getMerchantItems("3QFbXk5gw0KXfNCZTiOi")
        .map((items) => new FirstMerchantItemOnDataEventAction(items))
        .takeUntil(actions.where((action) =>
    action is
    CancelFirstMerchantDataEventsAction));
  });
}

Stream<dynamic> secondMerchantItemEpic(Stream<dynamic> actions,
    EpicStore<AppState> store) {
  return new Observable(actions)
      .ofType(new TypeToken<RequestSecondMerchantDataEventsAction>())
      .flatMapLatest((RequestSecondMerchantDataEventsAction requestAction) {
    return getMerchantItems("oS53CrXawnyVOXVf6VKw")
        .map((items) => new SecondMerchantItemOnDataEventAction(items))
        .takeUntil(actions.where((action) =>
    action is
    CancelSecondMerchantDataEventsAction));
  });
}

Observable<List<MerchantItem>> getMerchantItems(String merchantId) {
  var observable = new Observable(Firestore.instance
      .collection
    ("merchantItems/" + merchantId + "/items")
      .snapshots
      .map((QuerySnapshot querySnapshot) {
    var documents = querySnapshot.documents;
    List<MerchantItem> list = new List();
    documents.forEach((DocumentSnapshot doc) {
      var merchantItem = new MerchantItem(doc.data['name'], doc
          .data['price'], merchantId);
      print(merchantItem);
      return list.add(merchantItem);
    }
    );
    return list;
  }
  ));
  return observable;
}

