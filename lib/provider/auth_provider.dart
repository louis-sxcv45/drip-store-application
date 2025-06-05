import 'package:drip_store/model/api/api_service.dart';
import 'package:drip_store/model/data/login_response.dart';
import 'package:drip_store/model/data/register_response.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthProvider extends ChangeNotifier {
  final ApiService _apiService;
  static const String _tokenKey = 'token';

  AuthProvider(this._apiService) {
    _initializeAuth();
  }

  LoginResponse? _loginResponse;
  RegisterResponse? _registerResponse;
  String? _loginError;
  String? _regisError;
  String? _emailError;
  String? _passwordError;
  bool _isLoading = false;
  bool _isInitialized = false;

  LoginResponse? get loginResponse => _loginResponse;
  RegisterResponse? get registerResponse => _registerResponse;
  String? get loginError => _loginError;
  String? get regisError => _regisError;
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
        _loginResponse = LoginResponse(user: null, token: token);
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
    _loginError = null;
    notifyListeners();

    try {
      _loginResponse = await _apiService.login(email, password);
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_tokenKey, _loginResponse!.token);

      debugPrint("Login successful: ${_loginResponse!.user?.name}");
      debugPrint("Token: ${_loginResponse!.token}");
    } catch (e) {
      final message = e.toString();

      if (message.contains("Bad Credentials")) {
        _emailError = "Invalid email or password.";
        _passwordError = "Invalid email or password.";
      } else if (message.contains("email")) {
        _emailError = "The email field must be a valid email address.";
      } else {
        _loginError = message;
      }

      debugPrint("Error: $_loginError");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> register(
    String name,
    String email,
    String password,
    String confirmPassword,
  ) async {
    _isLoading = true;
    _regisError = null;
    notifyListeners();

    try {
      _registerResponse = await _apiService.register(
        name,
        email,
        password,
        confirmPassword,
      );
      debugPrint("Registration successful: ${_registerResponse!.user?.name}");
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_tokenKey, _registerResponse!.token);
      debugPrint("Token: ${_registerResponse!.token}");

      _loginResponse = LoginResponse(
        user: _registerResponse!.user,
        token: _registerResponse!.token,
      );
    } catch (e) {
      _regisError = e.toString().replaceFirst('Exception: ', '');
      debugPrint("Registration error: $_regisError");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
