import 'package:drip_store/model/api/api_service.dart';
import 'package:drip_store/model/data/history_response.dart';
import 'package:flutter/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HistoryProvider extends ChangeNotifier{
  final ApiService _apiService;
  static const String _token = "token";

  HistoryProvider(this._apiService);

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  HistoryResponse? _history;
  HistoryResponse? get history => _history;

  Future<void> fetchHistory() async {
    _isLoading = true;
    notifyListeners();

    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString(_token);

      if (token != null) {
        _history = await _apiService.getHistory(token);
        debugPrint('History fetched successfully: ${_history!.data.length}');
      } else {
        debugPrint('No token found, cannot fetch history');
      }
    } catch (e) {
      debugPrint('Error fetching history: $e');
      _history = null;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}