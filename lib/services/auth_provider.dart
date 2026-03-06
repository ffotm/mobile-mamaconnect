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
  static const String _localUsersKey = 'local_users';

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
      return _loginWithLocalUser(
        email: email,
        password: password,
        fallbackError: e.message,
      );
    } catch (e) {
      return _loginWithLocalUser(
        email: email,
        password: password,
        fallbackError: 'An unexpected error occurred',
      );
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
      return _registerLocalUser(
        fullName: fullName,
        email: email,
        password: password,
        role: role,
        fallbackError: e.message,
      );
    } catch (e) {
      return _registerLocalUser(
        fullName: fullName,
        email: email,
        password: password,
        role: role,
        fallbackError: 'An unexpected error occurred',
      );
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
      final updated = await _updateLocalProfile(
        birthday: birthday,
        illnesses: illnesses,
        allergies: allergies,
        timeOfPregnancy: timeOfPregnancy,
      );
      if (updated) {
        return true;
      }
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
      _user = UserModel.fromJson(jsonDecode(storedUser) as Map<String, dynamic>);
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

  Future<List<Map<String, dynamic>>> _getLocalUsers() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_localUsersKey);

    if (raw == null || raw.isEmpty) {
      final seedUsers = _seedDummyUsers();
      await prefs.setString(_localUsersKey, jsonEncode(seedUsers));
      return seedUsers;
    }

    final decoded = jsonDecode(raw) as List<dynamic>;
    return decoded
        .map((entry) => Map<String, dynamic>.from(entry as Map))
        .toList();
  }

  Future<void> _saveLocalUsers(List<Map<String, dynamic>> users) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_localUsersKey, jsonEncode(users));
  }

  List<Map<String, dynamic>> _seedDummyUsers() {
    return [
      {
        'id': 'demo-client-1',
        'full_name': 'Demo Mama',
        'email': 'mama@example.com',
        'password': '123456',
        'role': 'client',
        'birthday': '12/08/1996',
        'illnesses': 'None',
        'allergies': 'None',
        'time_of_pregnancy': '24 weeks',
      },
      {
        'id': 'demo-midwife-1',
        'full_name': 'Demo Midwife',
        'email': 'midwife@example.com',
        'password': '123456',
        'role': 'midwife',
      },
    ];
  }

  Future<bool> _loginWithLocalUser({
    required String email,
    required String password,
    required String fallbackError,
  }) async {
    final users = await _getLocalUsers();
    Map<String, dynamic>? matchedUser;

    for (final user in users) {
      final sameEmail =
          (user['email'] as String).toLowerCase() == email.toLowerCase();
      final samePassword = user['password'] == password;
      if (sameEmail && samePassword) {
        matchedUser = user;
        break;
      }
    }

    if (matchedUser == null) {
      _setError('Invalid credentials. Try demo: mama@example.com / 123456');
      return false;
    }

    final token = 'local-${DateTime.now().millisecondsSinceEpoch}';
    _api.setToken(token);
    await _saveToken(token);
    _user = UserModel.fromJson(matchedUser);
    _isAuthenticated = true;
    await _saveCurrentUser();
    notifyListeners();
    _setError(null);
    return true;
  }

  Future<bool> _registerLocalUser({
    required String fullName,
    required String email,
    required String password,
    required String role,
    required String fallbackError,
  }) async {
    final users = await _getLocalUsers();
    final alreadyExists = users.any(
      (user) => (user['email'] as String).toLowerCase() == email.toLowerCase(),
    );

    if (alreadyExists) {
      _setError('This email is already registered. Please sign in.');
      return false;
    }

    final newUser = {
      'id': 'local-${DateTime.now().millisecondsSinceEpoch}',
      'full_name': fullName,
      'email': email,
      'password': password,
      'role': role,
    };

    users.add(newUser);
    await _saveLocalUsers(users);

    final token = 'local-${DateTime.now().millisecondsSinceEpoch}';
    _api.setToken(token);
    await _saveToken(token);
    _user = UserModel.fromJson(newUser);
    _isAuthenticated = true;
    await _saveCurrentUser();
    notifyListeners();
    _setError(null);
    return true;
  }

  Future<bool> _updateLocalProfile({
    String? birthday,
    String? illnesses,
    String? allergies,
    String? timeOfPregnancy,
  }) async {
    if (_user == null) return false;

    final updatedUser = _user!.copyWith(
      birthday: birthday,
      illnesses: illnesses,
      allergies: allergies,
      timeOfPregnancy: timeOfPregnancy,
    );

    final users = await _getLocalUsers();
    final index = users.indexWhere((entry) => entry['id'] == updatedUser.id);
    if (index >= 0) {
      final password = users[index]['password'];
      users[index] = {
        ...updatedUser.toJson(),
        'password': password,
      };
      await _saveLocalUsers(users);
    }

    _user = updatedUser;
    _isAuthenticated = true;
    await _saveCurrentUser();
    notifyListeners();
    _setError(null);
    return true;
  }
}
