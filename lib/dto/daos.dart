import 'package:cloud_firestore/cloud_firestore.dart';

class UserSetting {
  String id;
}

class CheckedUserSetting extends UserSetting {
  bool checked;

  CheckedUserSetting(DocumentSnapshot document) {
    if (document.data != null) {
      this.id = document['id'];
      if (document['checked'] == null) {
        this.checked = false;
      } else {
        this.checked = document['checked'];
      }
    }
    else {
      this.checked = false;
    }
  }

  Map<String, dynamic> toMap() =>
      {
        'id': this.id,
        'checked': this.checked,
      };
}

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
  bool checked;
  String category;
  NutritionInformation nutritionInformation;
  ManufacturerInformation manufacturerInformation;
  List<PriceHistoryEntry> priceHistory;

  MerchantItem(DocumentSnapshot document, String merchantId) {
    this.id = document['id'];
    this.merchantId = merchantId;
    if (this.merchantId == null) {
      this.merchantId = document['merchantId'];
    }
    this.name = document['name'];
    this.price = document['price'];
    this.pricePerUnit = document['pricePerUnit'];
    this.unit = document['unit'];
    this.currency = document['currency'];
    this.description = document['description'];
    this.thumbnail = document['thumbnail'];
    this.imageURL = document['imageURL'];
    this.path = document['path'];
    this.category = document['category'];
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
        PriceHistoryEntry priceHistoryEntry =
        new PriceHistoryEntry(value['t'], value['price']);
        priceHistory.add(priceHistoryEntry);
      }
    }

    if (document['checked'] == null) {
      this.checked = false;
    } else {
      this.checked = document['checked'];
    }
  }

  Map<String, dynamic> toMap() =>
      {
        'id': this.id,
        'merchantId': this.merchantId,
        'name': this.name,
        'price': this.price,
        'pricePerUnit': this.pricePerUnit,
        'unit': this.unit,
        'currency': this.currency,
        'description': this.description,
        'thumbnail': this.thumbnail,
        'imageURL': this.imageURL,
        'path': this.path,
        'category': this.category,
        'nutritionInformation': this.nutritionInformation == null
            ? null
            : this.nutritionInformation.toMap(),
        'manufacturerInformation': this.manufacturerInformation == null
            ? null
            : this.manufacturerInformation.toMap(),
        'priceHistory': this.priceHistory == null
            ? null
            : getPriceHistoryListAsMap(this.priceHistory),
        'checked': this.checked,
      };
}

List<Map<String, dynamic>> getPriceHistoryListAsMap(
    List<PriceHistoryEntry> priceHistory) {
  List<Map<String, dynamic>> list = new List<Map<String, dynamic>>();
  for (var value in priceHistory) {
    list.add(value.toMap());
  }
  return list;
}

class Merchant {
  String id;
  String name;
  String website;

  Merchant(DocumentSnapshot document) {
    this.id = document['id'];
    this.name = document['name'];
    this.website = document['website'];
  }
}

class ManufacturerInformation {
  final String address;
  final String supplier;
  final String contact;

  ManufacturerInformation(this.address, this.supplier, this.contact);

  Map<String, dynamic> toMap() =>
      {
        'address': this.address,
        'supplier': this.supplier,
        'contact': this.contact,
      };
}

class NutritionInformation {
  final num energy;
  final num fat;
  final num carbs;
  final num protein;
  final num salt;

  NutritionInformation(this.energy, this.fat, this.carbs, this.protein,
      this.salt);

  Map<String, dynamic> toMap() =>
      {
        'energy': this.energy,
        'fat': this.fat,
        'carbs': this.carbs,
        'protein': this.protein,
        'salt': this.salt,
      };
}

class PriceHistoryEntry {
  final int t;
  final num price;

  PriceHistoryEntry(this.t, this.price);

  Map<String, dynamic> toMap() =>
      {
        't': this.t,
        'price': this.price,
      };
}
