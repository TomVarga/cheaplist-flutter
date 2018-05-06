import 'package:cheaplist/util/drawer_builder.dart';
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
        body: new Text("Shopping list"));
  }
}
