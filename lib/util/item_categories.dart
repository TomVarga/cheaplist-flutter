List<dynamic> itemCategories;
Map<String, bool> itemCategoriesFilter;

getItemCategories() {
  return itemCategories;
}

setItemCategories(List<dynamic> documents) {
  itemCategories = documents;
}

getItemCategoriesFilter() {
  return itemCategoriesFilter;
}

setItemCategoriesFilter(Map<String, dynamic> documents) {
  itemCategoriesFilter = Map.castFrom(documents);
}
