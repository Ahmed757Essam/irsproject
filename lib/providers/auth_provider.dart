import 'package:flutter/material.dart';
import 'package:isrprojectnew/api/api_service.dart';
import 'package:isrprojectnew/providers/token_provider.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthProvider with ChangeNotifier {
  bool _isAuthenticated = false;
  Map<String, dynamic>? _userProfile;

  bool get isAuthenticated => _isAuthenticated;
  Map<String, dynamic>? get userProfile => _userProfile;

  // Initialize auth state
  Future<void> initialize() async {
    final prefs = await SharedPreferences.getInstance();
    _isAuthenticated = prefs.getString('accessToken') != null;
    if (_isAuthenticated) {
      await loadUserProfile();
    }
    notifyListeners();
  }

  // Register user
  Future<void> register({
    required String firstName,
    required String lastName,
    required String username,
    required String jobTitle,
    required String email,
    required String password,
  }) async {
    try {
      await ApiService.registerUser(
        firstName: firstName,
        lastName: lastName,
        username: username,
        jobTitle: jobTitle,
        email: email,
        password: password,
      );
    } catch (e) {
      rethrow;
    }
  }

  // Login user
// Login user
  Future<void> login(BuildContext context, {
    required String email,
    required String password
  }) async {
    try {
      final response = await ApiService.loginUser(
          email: email,
          password: password
      );

      final accessToken = response['accessToken'];
      final refreshToken = response['refreshToken'];

      if (accessToken == null || accessToken.isEmpty) {
        throw Exception("No access token received");
      }

      // Save tokens to SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('accessToken', accessToken);
      if (refreshToken != null) {
        await prefs.setString('refreshToken', refreshToken);
      }

      // Update TokenProvider
      final tokenProvider = Provider.of<TokenProvider>(context, listen: false);
      tokenProvider.setToken(accessToken);

      notifyListeners();
    } catch (e) {
      // Remove the nested Exception wrapping
      throw Exception(e.toString().replaceAll('Exception: ', ''));
    }
  }





  // Load user profile
  Future<void> loadUserProfile() async {
    try {
      _userProfile = await ApiService.getUserProfile();
      notifyListeners();
    } catch (e) {
      rethrow;
    }
  }

  // Update profile
  Future<void> updateProfile({
    String? firstName,
    String? lastName,
    String? email,
    String? username,
    String? resumeFile,
  }) async {
    try {
      await ApiService.updateProfile(
        firstName: firstName,
        lastName: lastName,
        email: email,
        username: username,
        resumeFile: resumeFile,
      );
      await loadUserProfile();
    } catch (e) {
      rethrow;
    }
  }

  // Logout
  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('accessToken');
    await prefs.remove('refreshToken');
    _isAuthenticated = false;
    _userProfile = null;
    notifyListeners();
  }

  // Refresh token
  Future<void> refreshToken() async {
    try {
      await ApiService.refreshToken();
    } catch (e) {
      await logout();
      rethrow;
    }
  }
}




