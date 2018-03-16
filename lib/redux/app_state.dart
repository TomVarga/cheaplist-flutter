import 'package:cheaplist/redux/merchant_tem.dart';
import 'package:meta/meta.dart';

@immutable
class AppState {
  final List<MerchantItem> firstMerchantItems;
  final List<MerchantItem> secondMerchantItems;

  AppState({
    this.firstMerchantItems,
    this.secondMerchantItems
  });

  AppState copyWith({List<MerchantItem> firstMerchantItems,
    List<MerchantItem> secondMerchantItems}) =>
      new AppState(firstMerchantItems: firstMerchantItems ?? this
          .firstMerchantItems, secondMerchantItems: secondMerchantItems
          ?? this.secondMerchantItems);
}
