
class ListExerciseItem {
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'category': category,
      'calories': calories,
    };
  }
  ListExerciseItem({
    required this.name,
    required this.category,
    required this.calories,
  });

  String name;
  String category;
  String calories;

}
