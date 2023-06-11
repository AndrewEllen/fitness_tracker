
extension StringExtension on String {
  String capitalizeFirst() {
    return "${this[0].toUpperCase()}${substring(1).toLowerCase()}";
  }
  String capitalize() {

    if (isNotEmpty) {
      return replaceAll(RegExp(' +'), ' ').split(' ')
          .map((str) => str.capitalizeFirst())
          .join(' ');
    }

    return this;
  }
}