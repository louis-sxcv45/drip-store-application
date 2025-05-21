import 'dart:convert';
import 'dart:io';

import 'package:drip_store/model/api/api_service.dart';
import 'package:drip_store/model/data/login_response.dart';
import 'package:drip_store/model/data/user_model.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthProvider extends ChangeNotifier {
  final ApiService _apiService;
  static const String _tokenKey = 'token';

  AuthProvider(this._apiService) {
    _initializeAuth();
  }

  LoginResponse? _loginResponse;
  String? _errorMessage;
  String? _emailError;
  String? _passwordError;
  bool _isLoading = false;
  bool _isInitialized = false;

  LoginResponse? get loginResponse => _loginResponse;
  String? get errorMessage => _errorMessage;
  String? get emailError => _emailError;
  String? get passwordError => _passwordError;
  bool get isLoading => _isLoading;
  bool get isLoggedIn =>
      _loginResponse != null && _loginResponse!.token.isNotEmpty;
  bool get isInitialized => _isInitialized;

  Future<void> _initializeAuth() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString(_tokenKey);
      
      if (token != null) {
        _loginResponse = LoginResponse(
          user: UserModel.fromJson(jsonDecode(token)), 
          token: token
        );
      }
    } catch (e) {
      await SharedPreferences.getInstance().then((prefs) {
        prefs.remove(_tokenKey);
      });
    } finally {
      _isInitialized = true;
      notifyListeners();
    }
  }

  Future<void> login(String email, String password) async {
    _isLoading = true;
    _emailError = null;
    _passwordError = null;
    _errorMessage = null;
    notifyListeners();

    try {
      _loginResponse = await _apiService.login(email, password);
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_tokenKey, _loginResponse!.token);

      debugPrint("Login successful: ${_loginResponse!.user.name}");
      debugPrint("Token: ${_loginResponse!.token}");
    } on SocketException catch (_) {
      _errorMessage = "No internet connection.";
      debugPrint("Error: $_errorMessage");
    } catch (e) {
      final message = e.toString();

      if (message.contains("Bad Credentials")) {
        _emailError = "Invalid email or password.";
        _passwordError = "Invalid email or password.";
      } else if (message.contains("email")) {
        _emailError = "The email field must be a valid email address.";
      } else {
        _errorMessage = message;
      }

      debugPrint("Error: $_errorMessage");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
