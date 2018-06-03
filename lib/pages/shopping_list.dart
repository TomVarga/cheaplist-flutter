import 'dart:async';

import 'package:cheaplist/dto/daos.dart';
import 'package:cheaplist/pages/detail.dart';
import 'package:cheaplist/photo_hero.dart';
import 'package:cheaplist/shopping_list_manager.dart';
import 'package:cheaplist/util/authentication.dart';
import 'package:cheaplist/util/drawer_builder.dart';
import 'package:cheaplist/util/merchants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ShoppingList extends StatefulWidget {
  static String routeName = '/shoppinglist';

  ShoppingList({Key key}) : super(key: key);

  @override
  _ShoppingListState createState() => new _ShoppingListState();
}

class _ShoppingListState extends State<ShoppingList> {
  _ShoppingListState();

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: getDefaultAppBar(context),
        drawer: buildDrawer(context, ShoppingList.routeName),
        body: new ShoppingListItemList());
  }
}

class _WidgetWithMerchantItem extends StatelessWidget {
  final MerchantItem item;
  final Widget widget;

  _WidgetWithMerchantItem(MerchantItem item, Widget widget)
      : item = item,
        widget = widget;

  @override
  Widget build(BuildContext context) {
    return widget;
  }
}

class ShoppingListItemList extends StatelessWidget {
  ShoppingListItemList();

  @override
  Widget build(BuildContext context) {
    return new StreamBuilder<QuerySnapshot>(
      stream: getShoppingListItems(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (!snapshot.hasData) return const Text('Loading...');
        return new ListView(
          children: getListItems(context, snapshot.data.documents),
        );
      },
    );
  }

  Stream<QuerySnapshot> getShoppingListItems() {
    return Firestore.instance
        .collection("userData")
        .document(userId)
        .collection("shoppingList")
        .snapshots;
  }

  List<_WidgetWithMerchantItem> getListItems(BuildContext context,
      List<DocumentSnapshot> documents) {
    List<_WidgetWithMerchantItem> widgets = new List<_WidgetWithMerchantItem>();
    for (var document in documents) {
      MerchantItem item = new MerchantItem(document, null);
      _WidgetWithMerchantItem listItem = new _WidgetWithMerchantItem(
          item,
          new Dismissible(
            background: new Container(
                color: Colors.redAccent,
                child: new Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    new Text("Remove",
                        style:
                        new TextStyle(fontSize: 11.0, color: Colors.white)),
                    new Container(
                        margin: new EdgeInsets.all(8.0),
                        child: new Icon(Icons.delete, color: Colors.white)),
                  ],
                )),
            key: new Key('${item.id}dismissable'),
            onDismissed: (direction) {
              final snackBar = new SnackBar(
                  content: new Text('Item removed from shopping list'),
                  action: new SnackBarAction(
                      label: "Undo",
                      onPressed: () {
                        addToList(item);
                      }));
              removeFromList(item);
              Scaffold.of(context).showSnackBar(snackBar);
            },
            child: new InkWell(
              child: new Container(
                  margin: new EdgeInsets.all(1.0),
                  child:
                  new Ink(color: Colors.white, child: getListItem(item))),
              onTap: () {
                Navigator.push(
                  context,
                  new MaterialPageRoute(
                      builder: (context) => new DetailScreen(item: item)),
                );
              },
            ),
          ));
      widgets.add(listItem);
    }
    widgets.sort((a, b) => sortingFunction(a, b));
    return widgets;
  }

  final listPerUnitPriceTextStyle =
  new TextStyle(fontSize: 11.0, color: Colors.black.withOpacity(0.6));
  final listPriceTextStyle =
  new TextStyle(fontSize: 14.0, color: Colors.black.withOpacity(0.6));
  final listMerchantTextStyle =
  new TextStyle(fontSize: 12.0, color: Colors.black.withOpacity(0.8));

  Widget getListItem(MerchantItem item) {
    return new Row(
      children: <Widget>[
        new Checkbox(
            value: item.checked,
            onChanged: (newValue) {
              toggleChecked(item, newValue);
            }),
        listItemTexts(item),
        new PhotoHero(
          thumbnail: true,
          item: item,
          width: 50.0,
        ),
      ],
    );
  }

  Widget listItemTexts(MerchantItem item) {
    return new Expanded(
        child: new Container(
          margin: const EdgeInsets.all(2.0),
          child: new Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              new Text(
                item.name,
                overflow: TextOverflow.ellipsis,
                maxLines: 2,
              ),
              new Text(
                '${item.price} ${item.currency}',
                textAlign: TextAlign.start,
                style: listPriceTextStyle,
              ),
              new Text(
                '${item.pricePerUnit} ${item.currency} ${item
                    .unit}',
                textAlign: TextAlign.start,
                style: listPerUnitPriceTextStyle,
              ),
              new Text(
                '${getMerchant(item.merchantId).name}',
                textAlign: TextAlign.start,
                style: listMerchantTextStyle,
              ),
            ],
          ),
        ));
  }

  sortingFunction(_WidgetWithMerchantItem a, _WidgetWithMerchantItem b) {
    if (a.item.checked && !b.item.checked) {
      return 1;
    }
    if (a.item.checked && b.item.checked ||
        !a.item.checked && !b.item.checked) {
      return a.item.name.compareTo(b.item.name);
    }
    return -1;
  }
}
