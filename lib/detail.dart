import 'package:cheaplist/constants.dart';
import 'package:cheaplist/dto/daos.dart';
import 'package:cheaplist/photo_hero.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class DetailScreen extends StatefulWidget {
  DetailScreen({Key key, this.item}) : super(key: key);

  final MerchantItem item;

  @override
  _DetailState createState() => new _DetailState(item);
}

class _DetailState extends State<DetailScreen> {
  var isOnShoppingList = false;

  _DetailState(this.item);

  final MerchantItem item;

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: getDetailAppBar(context),
        floatingActionButton: new FloatingActionButton(
            onPressed: () => setState(() {
                  isOnShoppingList = !isOnShoppingList;
                }),
            child: isOnShoppingList
                ? new Icon(Icons.remove)
                : new Icon(Icons.add)),
        body: new SingleChildScrollView(
            child: new Card(
                child: new Container(
                    margin: new EdgeInsets.all(8.0),
                    child: new Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        new Text(item.name),
                        new Divider(
                          color: Colors.black,
                        ),
                        new Text(
                          '${item.price} ${item.currency}',
                          style: new TextStyle(fontSize: 22.0),
                        ),
                        new Text('${item.pricePerUnit} ${item.currency} ${item
                            .unit}'),
                        new Container(
                          padding: const EdgeInsets.all(16.0),
                          alignment: Alignment.center,
                          child: new PhotoHero(
                            thumbnail: false,
                            item: item,
                            width: 200.0,
                          ),
                        ),
                        buildNutritionInformation(),
                        getManufacturerInformation()
                      ],
                    )))));
  }

  Widget buildNutritionInformation() {
    if (item.nutritionInformation == null || !hasNutritionInformationData()) {
      return new Container();
    }
    return new _NutritionInformation(item);
  }

  bool hasNutritionInformationData() {
    return item.nutritionInformation.energy != null ||
        item.nutritionInformation.salt != null ||
        item.nutritionInformation.protein != null ||
        item.nutritionInformation.carbs != null ||
        item.nutritionInformation.fat != null;
  }

  Widget getDetailAppBar(BuildContext context) {
    return new PreferredSize(
        child: new Hero(
          tag: getAppBarHeroTag(),
          child: new Material(
            child: new AppBar(
              title: new Text(getAppName()),
              elevation:
                  Theme.of(context).platform == TargetPlatform.iOS ? 0.0 : 4.0,
            ),
          ),
        ),
        preferredSize: new Size.fromHeight(kToolbarHeight));
  }

  Widget getManufacturerInformation() {
    if (item.manufacturerInformation == null ||
        item.manufacturerInformation.contact == null) {
      return new Container();
    }
    return new _ManufacturerInformation(item);
  }
}

class _ManufacturerInformation extends StatelessWidget {
  _ManufacturerInformation(this.item);

  final MerchantItem item;

  @override
  Widget build(BuildContext context) {
    return new Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        new Text("Manufacturer information",
            style: new TextStyle(fontSize: 18.0)),
        new Text("${item.manufacturerInformation.contact}"),
      ],
    );
  }
}

class _NutritionInformation extends StatelessWidget {
  _NutritionInformation(this.item);

  final MerchantItem item;

  @override
  Widget build(BuildContext context) {
    return new Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        new Text("Nutrition information", style: new TextStyle(fontSize: 18.0)),
        getNutritionInformationRow("Energy", item.nutritionInformation.energy),
        getNutritionInformationRow("Fat", item.nutritionInformation.fat),
        getNutritionInformationRow("Carbs", item.nutritionInformation.carbs),
        getNutritionInformationRow(
            "Protein", item.nutritionInformation.protein),
        getNutritionInformationRow("Salt", item.nutritionInformation.salt),
      ],
    );
  }

  Widget getNutritionInformationRow(String name, num value) {
    if (value == null) {
      return new Container();
    }
    return new Column(
      children: <Widget>[
        getNutritionInformationTexts(name, value),
        new Divider(color: Colors.black),
      ],
    );
  }

  Row getNutritionInformationTexts(String name, num value) {
    return new Row(
      children: <Widget>[
        new Text(name),
        new Expanded(
          child: new Text(
            "${value}",
            textAlign: TextAlign.end,
          ),
        )
      ],
    );
  }
}
