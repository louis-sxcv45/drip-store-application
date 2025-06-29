import 'package:drip_store/model/api/api_service.dart';
import 'package:drip_store/model/data/product_list_response.dart';
import 'package:flutter/material.dart';

class ProductListProvider extends ChangeNotifier{
  final ApiService _apiService;

  ProductListProvider(this._apiService);

  ProductListResponse? _product;

  ProductListResponse? get product => _product;
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  Future<void> fetchProduct() async {
    _isLoading = true;
    try{
      final product = await _apiService.getProducts();
        _product = product;
        debugPrint('Product fetched successfully: ${_product!.data.length}');
    } catch (e) {
      debugPrint('Error fetching product: $e');
      _product = null;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}