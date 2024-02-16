import 'dart:convert';

extension ListExtensions on List {
  get() {
    return jsonDecode(jsonEncode(this));
  }
}