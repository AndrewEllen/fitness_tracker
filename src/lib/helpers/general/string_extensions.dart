
import 'dart:math';

extension StringListExtension on List<String> {

  double highestListSimilarity(List<String> listTwo) {

    List<String> listOne = this;

    double highestSimilarity = 0;

    List<double> similarity = [];

    for (String listOneItem in listOne) {


      for (String listTwoItem in listTwo) {

        similarity.add(listTwoItem.stringSimilarity(listOneItem));

      }

      highestSimilarity = similarity.reduce(max);

      }

    return highestSimilarity;
  }
}

extension StringExtension on String {
  String capitalizeFirst() {
    return "${this[0].toUpperCase()}${substring(1).toLowerCase()}";
  }

  String capitalize() {

    if (isNotEmpty) {

      return trim().split(" ").map((element) => element.capitalizeFirst()).toList().join(" ");

    }

    return this;
  }

  List<String> triGram() {

    List<String> triGramGen(txt) {
      List<String> triGramList = [];
      String value = txt.toLowerCase();
      int triGramLength = 4;

      for (int i = 0; i <= value.length - triGramLength; i++) {

        triGramList.add(value.substring(i, i + triGramLength));

      }
      return triGramList;
    }

    return triGramGen(this);

  }

  //Levenshtein code adapted from
  //https://github.com/Makepad-fr/dart_levenshtein/blob/master/lib/src/levenshtein_base.dart

  String get getSubString {
    return substring(1);
  }

  int levenshteinDistance(String secondString) {

    if (isEmpty) return secondString.length;
    if (secondString.isEmpty) return length;
    if (this[0] == secondString[0]) return getSubString.levenshteinDistance(secondString.getSubString);

    int distance = 1 + [
      levenshteinDistance(secondString.getSubString),
      getSubString.levenshteinDistance(secondString),
      getSubString.levenshteinDistance(secondString.getSubString),
    ].reduce(min);

    return distance;
  }

  //stringSimilarity Adapted from
  //https://essannouni.medium.com/how-to-measure-the-similarity-between-two-strings-with-dart-4946adf2709d#:~:text=Levenshtein%20distance&text=In%20dart%2C%20Strings%20are%20mainly,as%20string1%20and%20false%20otherwise.

  double stringSimilarity(String secondString) {

    String firstString = toLowerCase();
    secondString = secondString.toLowerCase();

    return (1 - firstString.levenshteinDistance(secondString) / (max(firstString.length, secondString.length)));

  }

}

extension ExtendedIterable<E> on Iterable<E> {
  /// Like Iterable<T>.map but the callback has index as second argument
  Iterable<T> mapIndexed<T>(T Function(E e, int i) f) {
    var i = 0;
    return map((e) => f(e, i++));
  }

  void forEachIndexed(void Function(E e, int i) f) {
    var i = 0;
    forEach((e) => f(e, i++));
  }
}

//https://stackoverflow.com/questions/59423310/remove-list-from-another-list-in-dart
extension WhereNotInExt<T> on Iterable<T> {
  Iterable<T> whereNotIn(Iterable<T> reject) {
    final rejectSet = reject.toSet();
    return where((el) => !rejectSet.contains(el));
  }
}