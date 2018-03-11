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
        title: 'Flutter: Firebase & Redux in sync',
        theme: new ThemeData(
          primarySwatch: Colors.blue,
        ),
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
            store.dispatch(new RequestMerchantDataEventsAction()),
        onDispose: (store) =>
            store.dispatch(new CancelMerchantDataEventsAction()),
        builder: (context, Store<AppState> store) {
          return new Scaffold(
              appBar: new AppBar(
                title: new Text("CheapList"),
              ),
              body: new ListView.builder(
                  itemCount: getLength(store.state),
                  itemBuilder: (BuildContext context, int position) {
                    return getRow(store, position);
                  })
          );
        }
    );
  }

  int getLength(AppState state) {
    if (state == null) {
      return 0;
    }
    if (state.merchantItems == null) {
      return 0;
    }
    return state.merchantItems.length;
  }

  Widget getRow(Store store, int i) {
    return new GestureDetector(
      child: new Padding(
          padding: new EdgeInsets.all(10.0),
          child: new Column(mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                new Text(store.state.merchantItems[i].name),
                new Text('${store.state.merchantItems[i].price}')
              ])),
    );
  }

}
