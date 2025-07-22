import 'package:drip_store/model/api/api_service.dart';
import 'package:drip_store/model/data/payment_response.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PaymentProvider extends ChangeNotifier{
  final ApiService _apiService;
  PaymentProvider(this._apiService);
  static const String _token = "token";

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  PaymentResponse? _payment;
  PaymentResponse? get payment => _payment;

  Future<void> processPayment(List<int>productIds) async {
    _isLoading = true;
    notifyListeners();

    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString(_token);

      if (token != null) {
        _payment = await _apiService.createPayment(productIds, token);
      }
    } catch (e) {
      debugPrint('Error processing payment: $e');
      _payment = null;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}