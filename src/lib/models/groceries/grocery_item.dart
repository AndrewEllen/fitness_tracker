
class GroceryItem {

  Map<String, dynamic> toMap() {
    return {
      'uuid': uuid,
      'barcode': barcode,
      'foodName': foodName.toLowerCase(),
      'cupboard': cupboard,
      'fridge': fridge,
      'freezer': freezer,
      'needed': needed,
    };
  }

  GroceryItem({
    required this.uuid,
    required this.barcode,
    required this.foodName,
    required this.cupboard,
    required this.fridge,
    required this.freezer,
    required this.needed,
  });

  String uuid;
  String barcode;
  String foodName;
  bool cupboard;
  bool fridge;
  bool freezer;
  bool needed;
}
