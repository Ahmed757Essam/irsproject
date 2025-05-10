import 'package:flutter/material.dart';

class TokenProvider with ChangeNotifier {
  String _token = '';

  String get token => _token;

  // Set a new token and notify listeners
  void setToken(String newToken) {
    _token = newToken;
    notifyListeners(); // Notify all listeners that the token has changed
  }

  // Clear the token and notify listeners
  void clearToken() {
    _token = '';
    notifyListeners();
  }
}
