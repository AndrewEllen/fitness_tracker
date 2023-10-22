
class ListExerciseItem {
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'category': category,
      'calories': calories,
      'extraInfoField': extraInfoField,
      'hideDelete': hideDelete,
    };
  }
  ListExerciseItem({
    required this.name,
    required this.category,
    required this.calories,
    this.extraInfoField = "",
    this.hideDelete = false,
  });

  String name;
  String category;
  String calories;
  String extraInfoField;
  bool hideDelete;

}
