
extension PhoneValidator on String {
  bool isValidPhoneNumber() {
    if (RegExp(r'(^[\+]?[(]?[0-9]{3}[)]?[-\s\.]?[0-9]{3}[-\s\.]?[0-9]{4,6}$)').hasMatch(this)) {
      return true;
    }
    return false;
  }
}