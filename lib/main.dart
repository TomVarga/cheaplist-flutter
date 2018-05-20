import 'dart:async';

import 'package:cheaplist/constants.dart';
import 'package:cheaplist/dto/daos.dart';
import 'package:cheaplist/pages/detail.dart';
import 'package:cheaplist/pages/settings_page.dart';
import 'package:cheaplist/pages/shopping_list.dart';
import 'package:cheaplist/pages/splash_page.dart';
import 'package:cheaplist/photo_hero.dart';
import 'package:cheaplist/shopping_list_manager.dart';
import 'package:cheaplist/util/drawer_builder.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_search_bar/flutter_search_bar.dart';

Future<void> main() async {
  runApp(new MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: getAppName(),
      theme: theme(context),
      home: new SplashPage(),
      routes: <String, WidgetBuilder>{
        ComparePage.routeName: (BuildContext context) => new ComparePage(),
        SettingsPage.routeName: (BuildContext context) => new SettingsPage(),
        ShoppingList.routeName: (BuildContext context) => new ShoppingList(),
      },
    );
  }
}

class MerchantItemList extends StatelessWidget {
  final String merchantId;
  final String filter;
  final bool startList;

  MerchantItemList(merchantId, filter, startList)
      : merchantId = merchantId,
        filter = filter,
        startList = startList;

  @override
  Widget build(BuildContext context) {
    return new StreamBuilder<QuerySnapshot>(
      stream: getMerchantItems(merchantId),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (!snapshot.hasData) return const Text('Loading...');
        return new ListView(
          children:
          getListItems(context, filter, snapshot.data.documents, startList),
        );
      },
    );
  }

  List<StatelessWidget> getListItems(BuildContext context, String filter,
      List<DocumentSnapshot> documents, bool startList) {
    List<StatelessWidget> widgets = new List<StatelessWidget>();
    for (var document in documents) {
      if (shouldShow(document, filter)) {
        MerchantItem item = new MerchantItem(document, merchantId);
        GestureDetector listItem = new GestureDetector(
          child: new Container(
              margin: getEdgeInsets(startList),
              color: Colors.white,
              child: getListItem(item, startList)),
          onTap: () {
            Navigator.push(
              context,
              new MaterialPageRoute(
                  builder: (context) => new DetailScreen(item: item)),
            );
          },
          onLongPress: () {
            final snackBar = new SnackBar(
                content: new Text('Item added to shopping list'),
                action: new SnackBarAction(
                    label: "Undo",
                    onPressed: () {
                      removeFromList(item);
                    }));
            addToList(item);
            Scaffold.of(context).showSnackBar(snackBar);
          },
        );
        widgets.add(listItem);
      }
    }
    return widgets;
  }

  EdgeInsets getEdgeInsets(bool startList) {
    if (startList) {
      return const EdgeInsets.fromLTRB(
        0.0,
        1.0,
        1.0,
        1.0,
      );
    } else {
      return const EdgeInsets.fromLTRB(
        1.0,
        1.0,
        0.0,
        1.0,
      );
    }
  }

  Row getListItem(MerchantItem item, bool startList) {
    var listPerUnitPriceTextStyle =
    new TextStyle(fontSize: 11.0, color: Colors.black.withOpacity(0.6));
    var listPriceTextStyle =
    new TextStyle(fontSize: 14.0, color: Colors.black.withOpacity(0.6));
    if (startList) {
      return new Row(
        children: <Widget>[
          new PhotoHero(
            thumbnail: true,
            item: item,
            width: 50.0,
          ),
          listItemTexts(
              item, listPriceTextStyle, listPerUnitPriceTextStyle, startList)
        ],
      );
    } else {
      return new Row(
        children: <Widget>[
          listItemTexts(
              item, listPriceTextStyle, listPerUnitPriceTextStyle, startList),
          new PhotoHero(
            thumbnail: true,
            item: item,
            width: 50.0,
          ),
        ],
      );
    }
  }

  Flexible listItemTexts(MerchantItem item, TextStyle listPriceTextStyle,
      TextStyle listPerUnitPriceTextStyle, bool startList) {
    return new Flexible(
        child: new Container(
          margin: const EdgeInsets.all(2.0),
          child: new Column(
            crossAxisAlignment:
            startList ? CrossAxisAlignment.end : CrossAxisAlignment.start,
            children: <Widget>[
              new Text(
                item.name,
                overflow: TextOverflow.ellipsis,
                maxLines: 2,
                textAlign: startList ? TextAlign.end : TextAlign.start,
              ),
              new Text(
                '${item.price} ${item.currency}',
                textAlign: startList ? TextAlign.end : TextAlign.start,
                style: listPriceTextStyle,
              ),
              new Text(
                '${item.pricePerUnit} ${item.currency} ${item
                    .unit}',
                textAlign: startList ? TextAlign.end : TextAlign.start,
                style: listPerUnitPriceTextStyle,
              ),
            ],
          ),
        ));
  }

  bool shouldShow(DocumentSnapshot document, String filter) {
    if (filter == null) {
      return true;
    }
    return document['name'].toLowerCase().contains(filter);
  }
}

Stream<QuerySnapshot> getMerchantItems(String merchantId) {
  return Firestore.instance
      .collection("merchantItems/" + merchantId + "/items")
      .snapshots;
}

class ComparePage extends StatefulWidget {
  static const String routeName = '/compare';

  @override
  _SearchBarHomeState createState() => new _SearchBarHomeState();
}

class _SearchBarHomeState extends State<ComparePage> {
  String title = getAppName();

  SearchBar searchBar;
  String filter;
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  AppBar buildAppBar(BuildContext context) {
    return new AppBar(
        title: new Text(title), actions: [searchBar.getSearchAction(context)]);
  }

  void onSubmitted(String value) {
    setState(() {
      if (value == null || value == "") {
        title = getAppName();
      } else {
        title = value;
      }
      filter = value;
    });
  }

  _SearchBarHomeState() {
    searchBar = new SearchBar(
        inBar: false,
        buildDefaultAppBar: buildAppBar,
        setState: setState,
        onSubmitted: onSubmitted,
        clearOnSubmit: false);
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: getMainAppBar(context),
      key: _scaffoldKey,
      drawer: buildDrawer(context, ComparePage.routeName),
      body: new Row(
        children: <Widget>[
          new Expanded(
            child: new MerchantItemList("3QFbXk5gw0KXfNCZTiOi", filter, true),
          ),
          new Expanded(
            child: new MerchantItemList("oS53CrXawnyVOXVf6VKw", filter, false),
          ),
        ],
      ),
    );
  }

  Widget getMainAppBar(BuildContext context) {
    return new PreferredSize(
        child: new Hero(
          tag: getAppBarHeroTag(),
          child: new Material(
            child: searchBar.build(context),
          ),
        ),
        preferredSize: new Size.fromHeight(kToolbarHeight));
  }
}
