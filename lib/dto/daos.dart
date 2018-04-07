import 'package:cloud_firestore/cloud_firestore.dart';

class MerchantItem {
  String id;
  String merchantId;
  String name;
  num price;
  num pricePerUnit;
  String unit;
  String currency;
  String description;
  String thumbnail;
  String imageURL;
  String path;
  ItemCategory category;
  NutritionInformation nutritionInformation;
  ManufacturerInformation manufacturerInformation;
  List<PriceHistoryEntry> priceHistory;

  MerchantItem(DocumentSnapshot document, String merchantId) {
    this.id = document['id'];
    this.merchantId = merchantId;
    this.name = document['name'];
    this.price = document['price'];
    this.pricePerUnit = document['pricePerUnit'];
    this.unit = document['unit'];
    this.currency = document['currency'];
    this.description = document['description'];
    this.thumbnail = document['thumbnail'];
    this.imageURL = document['imageURL'];
    this.path = document['path'];
    String category = document['category'];
    for (var value in ItemCategory.values) {
      if ("$value" == "ItemCategory.$category") {
        this.category = value;
        break;
      }
    }
    if (document['nutritionInformation'] != null) {
      this.nutritionInformation = new NutritionInformation(
          document['nutritionInformation']['energy'],
          document['nutritionInformation']['fat'],
          document['nutritionInformation']['carbs'],
          document['nutritionInformation']['protein'],
          document['nutritionInformation']['salt']);
    }
    if (document['manufacturerInformation'] != null) {
      this.manufacturerInformation = new ManufacturerInformation(
          document['manufacturerInformation']['address'],
          document['manufacturerInformation']['supplier'],
          document['manufacturerInformation']['contact']);
    }
    if (document['priceHistory'] != null) {
      this.priceHistory = new List<PriceHistoryEntry>();
      for (var value in document['priceHistory']) {
        PriceHistoryEntry priceHistoryEntry = new PriceHistoryEntry(value['t']
            , value['price']);
        priceHistory.add(priceHistoryEntry);
      }
    }
  }
}

class Merchant {
  final String id;
  final String name;
  final String website;

  Merchant(this.id, this.name, this.website);
}

class ManufacturerInformation {
  final String address;
  final String supplier;
  final String contact;

  ManufacturerInformation(this.address, this.supplier, this.contact);
}

class NutritionInformation {
  final num energy;
  final num fat;
  final num carbs;
  final num protein;
  final num salt;

  NutritionInformation(this.energy, this.fat, this.carbs, this.protein,
      this.salt);
}

class PriceHistoryEntry {
  final int t;
  final num price;

  PriceHistoryEntry(this.t, this.price);
}

enum ItemCategory {
  FRUIT_VEGETABLES,
  DAIRY_EGGS,
  BAKERY,
  MEAT,
  BASIC_GROCERIES,
  DRINKS,
  ALCOHOL,
  FROZEN_FOOD,
  HOME,
  BEAUTY,
  BABY,
  PET,
  HOBB,
}
