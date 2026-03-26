// lib/services/auth_provider.dart
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user_model.dart';
import 'api_service.dart';

class AuthProvider extends ChangeNotifier {
  final ApiService _api = ApiService();
  static const String _authTokenKey = 'auth_token';
  static const String _authUserKey = 'auth_user';

  UserModel? _user;
  bool _isLoading = false;
  String? _error;
  bool _isAuthenticated = false;

  UserModel? get user => _user;
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get isAuthenticated => _isAuthenticated;

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  void _setError(String? msg) {
    _error = msg;
    notifyListeners();
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }

  Future<bool> login(String email, String password) async {
    _setLoading(true);
    _setError(null);
    try {
      final response = await _api.login(email: email, password: password);
      final token = response['access_token'];
      _api.setToken(token);
      await _saveToken(token);
      _user = UserModel.fromJson(response['user']);
      _isAuthenticated = true;
      await _saveCurrentUser();
      notifyListeners();
      return true;
    } on ApiException catch (e) {
      _setError(e.message);
      return false;
    } catch (e) {
      _setError('Unable to connect to backend. Please check server URL.');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  Future<bool> register({
    required String fullName,
    required String email,
    required String password,
    required String role,
  }) async {
    _setLoading(true);
    _setError(null);
    try {
      final response = await _api.register(
        fullName: fullName,
        email: email,
        password: password,
        role: role,
      );
      final token = response['access_token'];
      _api.setToken(token);
      await _saveToken(token);
      _user = UserModel.fromJson(response['user']);
      _isAuthenticated = true;
      await _saveCurrentUser();
      notifyListeners();
      return true;
    } on ApiException catch (e) {
      _setError(e.message);
      return false;
    } catch (e) {
      _setError('Unable to connect to backend. Please check server URL.');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  Future<bool> updateProfile({
    String? birthday,
    String? illnesses,
    String? allergies,
    String? timeOfPregnancy,
  }) async {
    _setLoading(true);
    _setError(null);
    try {
      _user = await _api.updateProfile(
        birthday: birthday,
        illnesses: illnesses,
        allergies: allergies,
        timeOfPregnancy: timeOfPregnancy,
      );
      await _saveCurrentUser();
      notifyListeners();
      return true;
    } on ApiException catch (e) {
      _setError(e.message);
      return false;
    } finally {
      _setLoading(false);
    }
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_authTokenKey);
    await prefs.remove(_authUserKey);
    _api.clearToken();
    _user = null;
    _isAuthenticated = false;
    notifyListeners();
  }

  Future<bool> tryAutoLogin() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString(_authTokenKey);
    if (token == null) return false;

    _api.setToken(token);

    final storedUser = prefs.getString(_authUserKey);
    if (storedUser != null) {
      _user =
          UserModel.fromJson(jsonDecode(storedUser) as Map<String, dynamic>);
      _isAuthenticated = true;
      notifyListeners();
      return true;
    }

    try {
      _user = await _api.getProfile();
      _isAuthenticated = true;
      await _saveCurrentUser();
      notifyListeners();
      return true;
    } catch (_) {
      await logout();
      return false;
    }
  }

  Future<void> _saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_authTokenKey, token);
  }

  Future<void> _saveCurrentUser() async {
    if (_user == null) return;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_authUserKey, jsonEncode(_user!.toJson()));
  }
}
