import 'package:flutter/material.dart';
import 'package:lilac_machine_test/authentication/models/user_data.dart';

class SaveUserProvider with ChangeNotifier {
  UserData _userData = UserData();

  UserData get userData => _userData;

  void updateUserData(UserData userData) {
    _userData = userData;
    notifyListeners();
  }

  void clearUserData() {
    _userData = UserData();
    notifyListeners();
  }
}
