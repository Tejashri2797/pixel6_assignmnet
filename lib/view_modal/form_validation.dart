

String? validateFullName(String? value){
  if(value == null || value.isEmpty){
    return "Please enter full name";
  }
  return null;
}

String? validateEmail(String? value) {
  if (value == null || value.isEmpty) {
    return "Please enter an email";
  } else if (value.length > 255) {
    return "Email can't be longer than 255 characters";
  } else {
    final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+');
    if (!emailRegex.hasMatch(value)) {
      return "Please enter a valid email";
    }
  }
  return null;
}
String? validateMobileNumber(String? value) {
  if (value == null || value.isEmpty) {
    return "Please enter a mobile number";
  } else if (value.length != 10) {
    return "Mobile number must be 10 digits";
  } else {
    final mobileRegex = RegExp(r'^[6-9]\d{9}$');
    if (!mobileRegex.hasMatch(value)) {
      return "Please enter a valid mobile number";
    }
  }
  return null;
}
String? validatePanNumber(String? value) {
  if (value == null || value.isEmpty) {
    return "Please enter a PAN number";
  }
  final panRegex = RegExp(r'^[A-Z]{5}[0-9]{4}[A-Z]{1}$');
  if (!panRegex.hasMatch(value)) {
    return "Please enter a valid PAN number";
  }
  return null;
}
String? validateAddress(String? value){
  if(value == null || value.isEmpty){
    return "Enter your Address";
  }
  return null;
}

String? validatePostCode(String? value) {
  if (value == null || value.isEmpty) {
    return "Please enter a Post Code number";
  }

  // Regular expression to match exactly 6 digits
  final pinCodeRegex = RegExp(r'^\d{6}$');

  if (!pinCodeRegex.hasMatch(value)) {
    return "Please enter a valid Post Code number";
  }

  return null;
}
