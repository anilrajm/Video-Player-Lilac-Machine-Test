
import 'package:flutter/material.dart';

class AuthenticationProvider with ChangeNotifier {

  String _receivedID = '';
  String get receivedID => _receivedID;
  void setReceivedID(String id) {
    _receivedID = id;
    notifyListeners();
  }









}
