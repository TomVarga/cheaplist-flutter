import 'package:cheaplist/redux/merchant_tem.dart';
import 'package:meta/meta.dart';

@immutable
class AppState {
  final int counter;
  final List<MerchantItem> merchantItems;

  AppState({
    this.counter = 0,
    this.merchantItems
  });

  AppState copyWith({int counter, List<MerchantItem> merchantItems}) =>
      new AppState(counter: counter ?? this
          .counter, merchantItems: merchantItems ?? this.merchantItems);
}
