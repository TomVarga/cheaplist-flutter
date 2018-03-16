import 'package:cheaplist/redux/actions.dart';
import 'package:cheaplist/redux/app_state.dart';
import 'package:cheaplist/redux/app_state_reducer.dart';
import 'package:cheaplist/redux/middleware.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:redux_epics/redux_epics.dart';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  final store = new Store<AppState>(
      appStateReducer,
      initialState: new AppState(),
      middleware: [new EpicMiddleware(allEpics)]
  );

  @override
  Widget build(BuildContext context) {
    return new StoreProvider(
      store: store,
      child: new MaterialApp(
        title: 'CheapList',
        theme: new ThemeData.light(),
        home: new SampleAppPage(),
      ),
    );
  }
}

class SampleAppPage extends StatefulWidget {
  SampleAppPage({Key key}) : super(key: key);

  @override
  _SampleAppPageState createState() => new _SampleAppPageState();
}

class _SampleAppPageState extends State<SampleAppPage> {

  @override
  Widget build(BuildContext context) {
    return new StoreBuilder(
        onInit: (store) =>
            mainStoreInitDispatch(store),
        onDispose: (store) =>
            mainStoreDisposeDispatch(store),
        builder: (context, Store<AppState> store) {
          return new Scaffold(
            appBar: new AppBar(
              title: new Text("CheapList"),
            ),
            body: new Row(
              children: <Widget>[
                new Expanded (
                    child: new ListView.builder(
                        key: new Key("firstMerchantItemList"),
                        itemCount: getFirstMerchantItemsLength(store.state),
                        itemBuilder: (BuildContext context, int position) {
                          return getFirstMerchantRow(store, position);
                        })
                ),
                new Expanded (
                    child: new ListView.builder(
                        key: new Key("secondMerchantItemList"),
                        itemCount: getSecondMerchantItemsLength(store.state),
                        itemBuilder: (BuildContext context, int position) {
                          return getSecondMerchantRow(store, position);
                        })
                ),
              ],
            ),
          );
        }
    );
  }

  int getFirstMerchantItemsLength(AppState state) {
    if (state == null) {
      return 0;
    }
    if (state.firstMerchantItems == null) {
      return 0;
    }
    return state.firstMerchantItems.length;
  }

  Widget getFirstMerchantRow(Store store, int i) {
    return new GestureDetector(
      child: new Padding(
          padding: new EdgeInsets.all(10.0),
          child: new Column(mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                new Text(store.state.firstMerchantItems[i].name),
                new Text('${store.state.firstMerchantItems[i].price}')
              ])),
    );
  }

  int getSecondMerchantItemsLength(AppState state) {
    if (state == null) {
      return 0;
    }
    if (state.secondMerchantItems == null) {
      return 0;
    }
    return state.secondMerchantItems.length;
  }

  Widget getSecondMerchantRow(Store store, int i) {
    return new GestureDetector(
      child: new Padding(
          padding: new EdgeInsets.all(10.0),
          child: new Column(mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                new Text(store.state.secondMerchantItems[i].name),
                new Text('${store.state.secondMerchantItems[i].price}')
              ])),
    );
  }

  void mainStoreInitDispatch(Store store) {
    store.dispatch(new RequestFirstMerchantDataEventsAction());
    store.dispatch(new RequestSecondMerchantDataEventsAction());
  }

  mainStoreDisposeDispatch(Store store) {
    store.dispatch(new CancelFirstMerchantDataEventsAction());
    store.dispatch(new CancelSecondMerchantDataEventsAction());
  }

}

