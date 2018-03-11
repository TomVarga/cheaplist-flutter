import 'package:cheaplist/redux/actions.dart';
import 'package:cheaplist/redux/app_state.dart';
import 'package:cheaplist/redux/merchant_tem.dart';
import 'package:redux/redux.dart';


AppState appStateReducer(AppState state, dynamic action) {
  return new AppState(
      counter: counterReducer(state.counter, action),
      merchantItems: merchantItemReducer(state.merchantItems, action)
  );
}

final counterReducer = combineTypedReducers<int>([
  new ReducerBinding<int, CounterOnDataEventAction>(_setCounter),
]);

final merchantItemReducer = combineTypedReducers<List<MerchantItem>>([
  new ReducerBinding<List<MerchantItem>, MerchantItemOnDataEventAction>
    (_setMerchantItems),
]);

int _setCounter(int oldCounter, CounterOnDataEventAction action) {
  return action.counter;
}

List<MerchantItem> _setMerchantItems(List<MerchantItem> oldList,
    MerchantItemOnDataEventAction action) {
  return action.merchantItems;
}

