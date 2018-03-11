import 'dart:async';

import 'package:cheaplist/redux/actions.dart';
import 'package:cheaplist/redux/app_state.dart';
import 'package:cheaplist/redux/merchant_tem.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:redux_epics/redux_epics.dart';
import 'package:rxdart/rxdart.dart';

final allEpics = combineEpics<AppState>(
    [counterEpic, incrementEpic, merchantItemEpic]);

Stream<dynamic> incrementEpic(Stream<dynamic> actions,
    EpicStore<AppState> store) {
  return new Observable(actions)
      .ofType(new TypeToken<IncrementCounterAction>())
      .flatMap((_) {
    return new Observable.fromFuture(Firestore.instance.document("users/tudor")
        .updateData({'counter': store.state.counter + 1})
        .then((_) => new CounterDataPushedAction())
        .catchError((error) => new CounterOnErrorEventAction(error)));
  });
}

Stream<dynamic> counterEpic(Stream<dynamic> actions,
    EpicStore<AppState> store) {
  return new Observable(actions) // 1
      .ofType(new TypeToken<RequestCounterDataEventsAction>())
      .flatMapLatest((RequestCounterDataEventsAction requestAction) {
    return getUserClicks() // 4
        .map((counter) => new CounterOnDataEventAction(counter))
        .takeUntil(
        actions.where((action) => action is CancelCounterDataEventsAction));
  });
}

Observable<int> getUserClicks() {
  return new Observable(Firestore.instance
      .document("users/tudor")
      .snapshots)
      .map((DocumentSnapshot doc) => doc['counter'] as int);
}

Stream<dynamic> merchantItemEpic(Stream<dynamic> actions, EpicStore<AppState>
store) {
  return new Observable(actions)
      .ofType(new TypeToken<RequestMerchantDataEventsAction>())
      .flatMapLatest((RequestMerchantDataEventsAction requestAction) {
    return getItems()
        .map((items) => new MerchantItemOnDataEventAction(items))
        .takeUntil(actions.where((action) =>
    action is
    CancelMerchantDataEventsAction));
  });
}

Observable<List<MerchantItem>> getItems() {
  var observable = new Observable(Firestore.instance
      .collection
    ("merchantItems/3QFbXk5gw0KXfNCZTiOi/items")
      .snapshots
      .map((QuerySnapshot
  querySnapshot) {
    var documents = querySnapshot.documents;
    List<MerchantItem> list = new List();
    documents.forEach((DocumentSnapshot doc) =>
        list.add(new MerchantItem(doc.data['name'], doc.data['price']))
    );
    return list;
  }
  ));
  return observable;
}

