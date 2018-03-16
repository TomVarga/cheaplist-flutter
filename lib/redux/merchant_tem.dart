class MerchantItem {
  String name;
  int price;
  String merchantId;

  MerchantItem(name, price, merchantId) {
    this.name = name;
    this.price = price;
    this.merchantId = merchantId;
  }

  @override
  String toString() {
    return 'MerchantItem{name: $name, price: $price, merchantId: $merchantId}';
  }

}