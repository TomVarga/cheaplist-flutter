import 'dart:async';

import 'package:cheaplist/dto/daos.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_search_bar/flutter_search_bar.dart';

final ThemeData kIOSTheme = new ThemeData(
  primarySwatch: Colors.orange,
  primaryColor: Colors.grey[100],
  primaryColorBrightness: Brightness.light,
);

final ThemeData kDefaultTheme = new ThemeData(
  primarySwatch: Colors.blue,
  accentColor: Colors.orangeAccent[400],
);

String getAppBarHeroTag() {
  return "appBarTag";
}

String getAppName() {
  return 'CheapList';
}

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: getAppName(),
      theme: defaultTargetPlatform == TargetPlatform.iOS
          ? kIOSTheme
          : kDefaultTheme,
      home: new MyHomePage(title: getAppName()),
    );
  }
}

class PhotoHero extends StatelessWidget {
  const PhotoHero({Key key, this.item, this.thumbnail, this.width})
      : super(key: key);

  final MerchantItem item;
  final double width;
  final bool thumbnail;

  Widget build(BuildContext context) {
    return new SizedBox(
      width: width,
      child: new Hero(
        tag: item.merchantId + '/' + item.id,
        child: new Material(
          color: Colors.transparent,
          child: new InkWell(
            child: buildImage(),
          ),
        ),
      ),
    );
  }

  Image buildImage() {
    if (item.thumbnail == null && item.imageURL == null) {
      return new Image.asset('graphics/image-broken-variant.png');
    }
    return new Image.network(
      thumbnail ? item.thumbnail : item.imageURL,
      fit: BoxFit.contain,
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
            children: <Widget>[
              new Align(
                alignment: startList ? Alignment.topRight : Alignment.topLeft,
                child: new Text(
                  item.name,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 2,
                  textAlign: startList ? TextAlign.end : TextAlign.start,
                ),
              ),
              new Align(
                alignment: startList ? Alignment.topRight : Alignment.topLeft,
                child: new Text(
                  '${item.price} ${item.currency}',
                  textAlign: startList ? TextAlign.end : TextAlign.start,
                  style: listPriceTextStyle,
                ),
              ),
              new Align(
                alignment: startList ? Alignment.topRight : Alignment.topLeft,
                child: new Text(
                  '${item.pricePerUnit} ${item.currency} ${item
                      .unit}',
                  textAlign: startList ? TextAlign.end : TextAlign.start,
                  style: listPerUnitPriceTextStyle,
                ),
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

class DetailScreen extends StatelessWidget {
  DetailScreen({Key key, this.item}) : super(key: key);

  final MerchantItem item;

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: getDetailAppBar(context),
        body: new Card(
            child: new Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            _DetailViewCardTitle(item),
            new Container(
              padding: const EdgeInsets.all(16.0),
              alignment: Alignment.topLeft,
              child: new Text('${item.pricePerUnit} ${item.currency}'),
            ),
            new Container(
              padding: const EdgeInsets.all(16.0),
              alignment: Alignment.center,
              child: new PhotoHero(
                thumbnail: true,
                item: item,
                width: 200.0,
              ),
            ),
//            new _NutritionInformation(item),
            getManufacturerInformation(item)
          ],
        )));
  }

  Widget getDetailAppBar(BuildContext context) {
    return new PreferredSize(
        child: new Hero(
          tag: getAppBarHeroTag(),
          child: new Material(
            child: new AppBar(
              title: new Text(getAppName()),
              elevation:
              Theme
                  .of(context)
                  .platform == TargetPlatform.iOS ? 0.0 : 4.0,
            ),
          ),
        ),
        preferredSize: new Size.fromHeight(kToolbarHeight));
  }

  Widget getManufacturerInformation(item) {
    if (item.manufacturerInformation == null ||
        item.manufacturerInformation.contact == null) {
      return new Divider(
        height: 1.0,
      );
    }
    return new _ManufacturerInformation(item);
  }
}

class _ManufacturerInformation extends StatelessWidget {
  _ManufacturerInformation(this.item);

  final MerchantItem item;

  @override
  Widget build(BuildContext context) {
    return new Material(
        child: new Container(
          padding: const EdgeInsets.all(16.0),
          alignment: Alignment.topLeft,
          child: new Column(
            children: <Widget>[
              new Text("Manufacturer information"),
              new Text('${item.manufacturerInformation.contact}')
            ],
          ),
        ));
  }
}

class _NutritionInformation extends StatelessWidget {
  _NutritionInformation(this.item);

  final MerchantItem item;

  @override
  Widget build(BuildContext context) {
    return new Material(
      child: new Column(
        children: <Widget>[
          new Text("Nutrition information"),
          new Text("Energy ${item.nutritionInformation.energy}")
        ],
      ),
    );
  }
}

class _DetailViewCardTitle extends ListTile {
  _DetailViewCardTitle(MerchantItem item)
      : super(
          title: new Text(item.name),
    subtitle: new Text('${item.price} ${item.currency}'),
        );
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _SearchBarHomeState createState() => new _SearchBarHomeState(title);
}

class _SearchBarHomeState extends State<MyHomePage> {
  String title;

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

  _SearchBarHomeState(String title) {
    this.title = title;
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
