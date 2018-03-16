import 'package:cheaplist/redux/actions.dart';
import 'package:cheaplist/redux/app_state.dart';
import 'package:cheaplist/redux/merchant_tem.dart';
import 'package:redux/redux.dart';


AppState appStateReducer(AppState state, dynamic action) {
  return new AppState(
      firstMerchantItems: firstMerchantItemReducer(state.firstMerchantItems,
          action),
      secondMerchantItems: secondMerchantItemReducer(state.secondMerchantItems,
          action)
  );
}

final firstMerchantItemReducer = combineTypedReducers<List<MerchantItem>>([
  new ReducerBinding<List<MerchantItem>, FirstMerchantItemOnDataEventAction>
    (_setFirstMerchantItems),
]);

List<MerchantItem> _setFirstMerchantItems(List<MerchantItem> oldList,
    FirstMerchantItemOnDataEventAction action) {
  return action.firstMerchantItems;
}


final secondMerchantItemReducer = combineTypedReducers<List<MerchantItem>>([
  new ReducerBinding<List<MerchantItem>, SecondMerchantItemOnDataEventAction>
    (_setSecondMerchantItems),
]);

List<MerchantItem> _setSecondMerchantItems(List<MerchantItem> oldList,
    SecondMerchantItemOnDataEventAction action) {
  return action.secondMerchantItems;
}
