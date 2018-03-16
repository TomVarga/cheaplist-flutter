import 'package:cheaplist/redux/merchant_tem.dart';

class RequestFirstMerchantDataEventsAction {}

class CancelFirstMerchantDataEventsAction {}

class FirstMerchantItemOnDataEventAction {
  final List<MerchantItem> firstMerchantItems;

  FirstMerchantItemOnDataEventAction(this.firstMerchantItems);

  @override
  String toString() =>
      'FirstMerchantItemOnDataEventAction{firstMerchantItems: $firstMerchantItems}';
}

class RequestSecondMerchantDataEventsAction {}

class CancelSecondMerchantDataEventsAction {}

class SecondMerchantItemOnDataEventAction {
  final List<MerchantItem> secondMerchantItems;

  SecondMerchantItemOnDataEventAction(this.secondMerchantItems);

  @override
  String toString() =>
      'SecondMerchantItemOnDataEventAction{secondMerchantItems: $secondMerchantItems}';
}

