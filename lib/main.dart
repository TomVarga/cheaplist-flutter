import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

final ThemeData kIOSTheme = new ThemeData(
  primarySwatch: Colors.orange,
  primaryColor: Colors.grey[100],
  primaryColorBrightness: Brightness.light,
);

final ThemeData kDefaultTheme = new ThemeData(
  primarySwatch: Colors.blue,
  accentColor: Colors.orangeAccent[400],
);

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'CheapList',
      theme: defaultTargetPlatform == TargetPlatform.iOS
          ? kIOSTheme
          : kDefaultTheme,
      home: new MyHomePage(title: 'CheapList'),
    );
  }
}

class MerchantItemList extends StatelessWidget {
  var merchantId;

  MerchantItemList(String merchantId) {
    this.merchantId = merchantId;
  }

  @override
  Widget build(BuildContext context) {
    return new StreamBuilder<QuerySnapshot>(
      stream: getMerchantItems(merchantId),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (!snapshot.hasData) return const Text('Loading...');
        return new ListView(
          children: snapshot.data.documents.map((DocumentSnapshot document) {
            return new GestureDetector(
              child: new Padding(
                  padding: new EdgeInsets.all(10.0),
                  child: new Column(mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        new Text(document['name']),
                        new Text('${document['price']}')
                      ])),
            );
          }).toList(),
        );
      },
    );
  }

}

Stream<QuerySnapshot> getMerchantItems(String merchantId) {
  return Firestore.instance
      .collection("merchantItems/" + merchantId + "/items")
      .snapshots;
}

class MyHomePage extends StatelessWidget {

  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text(title),
        elevation: Theme
            .of(context)
            .platform == TargetPlatform.iOS ? 0.0 : 4.0,
      ),
      body:
      new Row(
        children: <Widget>[
          new Expanded (
            child: new MerchantItemList("3QFbXk5gw0KXfNCZTiOi"),
          ),
          new Expanded (
            child: new MerchantItemList("oS53CrXawnyVOXVf6VKw"),
          ),
        ],
      ),
    );
  }
}