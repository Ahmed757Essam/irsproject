import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ApiService {
  static const String baseUrl = 'http://localhost:8080';

  // Helper method to get headers with auth token
  static Future<Map<String, String>> _getHeaders() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('accessToken') ?? '';
    return {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };
  }

  // User Registration true
  static Future<Map<String, dynamic>> registerUser({
    required String firstName,
    required String lastName,
    required String username,
    required String jobTitle,
    required String email,
    required String password,
  }) async {
    final url = Uri.parse('$baseUrl/users/');
    final response = await http.post(
      url,
      body: jsonEncode({
        'firstName': firstName,
        'lastName': lastName,
        'username': username,
        'jobTitle': jobTitle,
        'email': email,
        'password': password,
      }),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 201) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to register: ${response.body}');
    }
  }

  // User Login true
  static Future<Map<String, dynamic>> loginUser({
    required String email,
    required String password,
  }) async {
    final url = Uri.parse('$baseUrl/users/login/');
    final response = await http.post(
      url,
      body: jsonEncode({
        'email': email,
        'password': password,
      }),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      // Save tokens to shared preferences
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('accessToken', data['accessToken']);
      await prefs.setString('refreshToken', data['refreshToken']);
      return data;
    } else {
      throw Exception('Failed to login: ${response.body}');
    }
  }

  // Refresh Token
  static Future<Map<String, dynamic>> refreshToken() async {
    final prefs = await SharedPreferences.getInstance();
    final refreshToken = prefs.getString('refreshToken') ?? '';
    
    final url = Uri.parse('$baseUrl/users/refresh/');
    final response = await http.post(
      url,
      body: jsonEncode({
        'refreshToken': refreshToken,
      }),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      await prefs.setString('accessToken', data['accessToken']);
      return data;
    } else {
      throw Exception('Failed to refresh token: ${response.body}');
    }
  }

  // Get User Profile
  static Future<Map<String, dynamic>> getUserProfile() async {
    final url = Uri.parse('$baseUrl/users/me/');
    final response = await http.get(
      url,
      headers: await _getHeaders(),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to get profile: ${response.body}');
    }
  }

  // Update User Profile 
  static Future<Map<String, dynamic>> updateProfile({
    String? firstName,
    String? lastName,
    String? email,
    String? username,
    String? resumeFile,
  }) async {
    final url = Uri.parse('$baseUrl/users/me/');
    final request = http.MultipartRequest('PATCH', url);
    
    // Add headers
    final headers = await _getHeaders();
    request.headers.addAll(headers);
    
    // Add fields
    if (firstName != null) request.fields['firstName'] = firstName;
    if (lastName != null) request.fields['lastName'] = lastName;
    if (email != null) request.fields['email'] = email;
    if (username != null) request.fields['username'] = username;
    
    // Add file if provided
    if (resumeFile != null) {
      request.files.add(await http.MultipartFile.fromPath(
        'resumeFile',
        resumeFile,
      ));
    }

    final response = await request.send();
    final responseData = await response.stream.bytesToString();

    if (response.statusCode == 200) {
      return jsonDecode(responseData);
    } else {
      throw Exception('Failed to update profile: $responseData');
    }
  }

  // Get Recommended Jobs true 
  static Future<List<dynamic>> getRecommendedJobs() async {
    final url = Uri.parse('$baseUrl/jobs/recommended');
    final response = await http.get(
      url,
      headers: await _getHeaders(),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to get recommended jobs: ${response.body}');
    }
  }

  // Create Job (for admin)
  static Future<Map<String, dynamic>> createJob({
    required String title,
    required String description,
    required String company,
    required String applyUrl,
  }) async {
    final url = Uri.parse('$baseUrl/jobs');
    final response = await http.post(
      url,
      body: jsonEncode({
        'title': title,
        'description': description,
        'company': company,
        'applyUrl': applyUrl,
      }),
      headers: await _getHeaders(),
    );

    if (response.statusCode == 201) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to create job: ${response.body}');
    }
  }

  // Bulk Create Jobs (for admin)
  static Future<List<dynamic>> createJobsBulk(List<Map<String, dynamic>> jobs) async {
    final url = Uri.parse('$baseUrl/jobs/bulk');
    final response = await http.post(
      url,
      body: jsonEncode({'jobs': jobs}),
      headers: await _getHeaders(),
    );

    if (response.statusCode == 201) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to create jobs in bulk: ${response.body}');
    }
  }
}