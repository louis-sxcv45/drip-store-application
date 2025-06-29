import 'package:drip_store/model/api/api_service.dart';
import 'package:drip_store/model/data/profile_user_response.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileUserProvider extends ChangeNotifier{
  final ApiService _apiService;
  static const String _tokenKey = 'token';

  ProfileUserProvider(this._apiService);

  ProfileUserResponse? _profileUser;
  bool _isLoading = false;
  ProfileUserResponse? get profileUser => _profileUser;
  bool get isLoading => _isLoading;

  Future<void> fetchProfile() async {
    _isLoading = true;
    notifyListeners();
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString(_tokenKey);

      if (token != null) {
        _profileUser = await _apiService.getProfile(token);
        debugPrint('Profile fetched successfully: ${_profileUser!.user!.name}');
        debugPrint('My Token: $token');
      }
    } catch (e) {
      debugPrint('Error fetching profile: $e');
      _profileUser = null;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void clearProfile() {
    _profileUser = null;
    debugPrint('Profile cleared');
    notifyListeners();
  }
}