import 'package:cheaplist/dto/daos.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

Merchant firstMerchant;
Merchant secondMerchant;

Merchant getMerchant(String id) {
  if (firstMerchant == null && secondMerchant == null) {
    return null;
  }
  if (firstMerchant.id == id) {
    return firstMerchant;
  } else if (secondMerchant.id == id) {
    return secondMerchant;
  }
  return null;
}

setMerchants(List<DocumentSnapshot> documents) {
  firstMerchant = new Merchant(documents[0]);
  secondMerchant = new Merchant(documents[1]);
}
