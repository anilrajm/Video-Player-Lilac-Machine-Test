class Validators {
  // Validate empty

  static String? validateEmpty(String? value) {
    if (value == null || value.isEmpty) {
      return 'Required field';
    }
    return null;
  }

  // Phone validation
  static String? validatePhoneNumber(String? value) {
    if (value == null || value.isEmpty) {
      return 'Phone number is required';
    }

    final RegExp regex = RegExp(r'^\d{10}$');
    if (!regex.hasMatch(value)) {
      return 'Please enter a valid phone number';
    }

    return null;
  }



}
