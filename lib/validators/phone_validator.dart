bool isPhone(String phone) {
  String patttern = r'(^(?:[+0]9)?[0-9]{10,12}$)';
  RegExp regExp = new RegExp(patttern);
  if (phone.length == 0) {
    return false;
  } else if (!regExp.hasMatch(phone)) {
    return false;
  }
  return true;
}
