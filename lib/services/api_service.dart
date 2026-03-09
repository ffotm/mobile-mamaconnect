// lib/services/api_service.dart
//
// This service is pre-configured to connect to your FastAPI backend.
// Just update BASE_URL to your FastAPI server URL when ready.
// All endpoints mirror typical FastAPI REST conventions.

import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/user_model.dart';

class ApiService {
  static const String baseUrl = 'http://10.0.2.2:8000';

  static const Map<String, String> _headers = {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  };

  String? _authToken;

  Map<String, String> get _authHeaders => {
        ..._headers,
        if (_authToken != null) 'Authorization': 'Bearer $_authToken',
      };

  void setToken(String token) {
    _authToken = token;
  }

  void clearToken() {
    _authToken = null;
  }

  Future<Map<String, dynamic>> register({
    required String fullName,
    required String email,
    required String password,
    required String role, // 'client' or 'midwife'
  }) async {
    final response = await http.post(
      Uri.parse('$baseUrl/auth/register'),
      headers: _headers,
      body: jsonEncode({
        'full_name': fullName,
        'email': email,
        'password': password,
        'role': role,
      }),
    );
    return _handleResponse(response);
  }

  /// POST /auth/login
  Future<Map<String, dynamic>> login({
    required String email,
    required String password,
  }) async {
    final response = await http.post(
      Uri.parse('$baseUrl/auth/login'),
      headers: _headers,
      body: jsonEncode({
        'email': email,
        'password': password,
      }),
    );
    return _handleResponse(response);
  }

  /// POST /auth/google
  Future<Map<String, dynamic>> googleSignIn({
    required String idToken,
  }) async {
    final response = await http.post(
      Uri.parse('$baseUrl/auth/google'),
      headers: _headers,
      body: jsonEncode({'id_token': idToken}),
    );
    return _handleResponse(response);
  }

  // ─── USER ENDPOINTS ───────────────────────────────────────────────────────

  /// GET /users/me
  Future<UserModel> getProfile() async {
    final response = await http.get(
      Uri.parse('$baseUrl/users/me'),
      headers: _authHeaders,
    );
    final data = _handleResponse(response);
    return UserModel.fromJson(data);
  }

  /// PATCH /users/me
  Future<UserModel> updateProfile({
    String? birthday,
    String? illnesses,
    String? allergies,
    String? timeOfPregnancy,
  }) async {
    final response = await http.patch(
      Uri.parse('$baseUrl/users/me'),
      headers: _authHeaders,
      body: jsonEncode({
        if (birthday != null) 'birthday': birthday,
        if (illnesses != null) 'illnesses': illnesses,
        if (allergies != null) 'allergies': allergies,
        if (timeOfPregnancy != null) 'time_of_pregnancy': timeOfPregnancy,
      }),
    );
    final data = _handleResponse(response);
    return UserModel.fromJson(data);
  }

  // ─── PREGNANCY ENDPOINTS ─────────────────────────────────────────────────

  /// GET /pregnancy/status
  Future<Map<String, dynamic>> getPregnancyStatus() async {
    final response = await http.get(
      Uri.parse('$baseUrl/pregnancy/status'),
      headers: _authHeaders,
    );
    return _handleResponse(response);
  }

  // ─── HEALTH REPORT ───────────────────────────────────────────────────────

  /// GET /reports/pdf  (returns bytes)
  Future<List<int>> downloadHealthReport() async {
    final response = await http.get(
      Uri.parse('$baseUrl/reports/pdf'),
      headers: _authHeaders,
    );
    if (response.statusCode == 200) {
      return response.bodyBytes;
    }
    throw ApiException('Failed to download report: ${response.statusCode}');
  }

  // ─── WEIGHT TRACKER ──────────────────────────────────────────────────────

  /// POST /weight
  Future<Map<String, dynamic>> addWeight({
    required double weight,
    required String date,
  }) async {
    final response = await http.post(
      Uri.parse('$baseUrl/weight'),
      headers: _authHeaders,
      body: jsonEncode({'weight': weight, 'date': date}),
    );
    return _handleResponse(response);
  }

  /// GET /weight
  Future<List<dynamic>> getWeightHistory() async {
    final response = await http.get(
      Uri.parse('$baseUrl/weight'),
      headers: _authHeaders,
    );
    final data = _handleResponse(response);
    return data['records'] ?? [];
  }

  // ─── KICK COUNTER ─────────────────────────────────────────────────────────

  /// POST /kicks
  Future<Map<String, dynamic>> logKick() async {
    final response = await http.post(
      Uri.parse('$baseUrl/kicks'),
      headers: _authHeaders,
      body: jsonEncode({'timestamp': DateTime.now().toIso8601String()}),
    );
    return _handleResponse(response);
  }

  // ─── CONTRACTIONS ─────────────────────────────────────────────────────────

  /// POST /contractions
  Future<Map<String, dynamic>> logContraction({
    required int durationSeconds,
    required int intervalSeconds,
  }) async {
    final response = await http.post(
      Uri.parse('$baseUrl/contractions'),
      headers: _authHeaders,
      body: jsonEncode({
        'duration_seconds': durationSeconds,
        'interval_seconds': intervalSeconds,
        'timestamp': DateTime.now().toIso8601String(),
      }),
    );
    return _handleResponse(response);
  }

  // ─── HELPERS ──────────────────────────────────────────────────────────────

  Map<String, dynamic> _handleResponse(http.Response response) {
    if (response.statusCode >= 200 && response.statusCode < 300) {
      if (response.body.isEmpty) return {};
      return jsonDecode(response.body) as Map<String, dynamic>;
    }
    String message = 'Request failed';
    try {
      final body = jsonDecode(response.body);
      message = body['detail'] ?? body['message'] ?? message;
    } catch (_) {}
    throw ApiException(message, statusCode: response.statusCode);
  }
}

class ApiException implements Exception {
  final String message;
  final int? statusCode;

  ApiException(this.message, {this.statusCode});

  @override
  String toString() => 'ApiException($statusCode): $message';
}
