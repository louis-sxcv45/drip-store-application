import 'package:drip_store/model/api/api_service.dart';
import 'package:drip_store/model/data/detail_product_response.dart';
import 'package:drip_store/model/data/product_list_response.dart';
import 'package:drip_store/model/data/product_model.dart';
import 'package:flutter/material.dart';

class ProductListProvider extends ChangeNotifier{
  final ApiService _apiService;

  ProductListProvider(this._apiService);

  ProductListResponse? _product;
  ProductListResponse? get product => _product;

  DetailProductResponse? _detailProduct;
  DetailProductResponse? get detailProduct => _detailProduct;

  List<ProductModel> _allProducts = [];
  List<ProductModel> _visibleProducts = [];
  bool _isSearching = false;
  String _searchQuery = '';

  List<ProductModel> get productList => _visibleProducts;
  bool get isSearching => _isSearching;
  String get searchQuery => _searchQuery;


  bool _isLoading = false;
  bool get isLoading => _isLoading;

  Future<void> fetchProduct() async {
    _isLoading = true;
    try{
      final product = await _apiService.getProducts();
        _product = product;
        _allProducts = product.data;
        _visibleProducts = List.from(_allProducts);
        debugPrint('Product fetched successfully: ${_product!.data.length}');
    } catch (e) {
      debugPrint('Error fetching product: $e');
      _product = null;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchDetailProduct(int productId) async {
    _isLoading = true;

    debugPrint('Fetching details for product ID: $productId');
    debugPrint('is loading before API call: $_isLoading');
    try {
      final detailProduct = await _apiService.getDetailProduct(productId);
      debugPrint('Detail product fetched successfully: ${detailProduct.detailProduct.id}');
      _detailProduct = detailProduct;
    } catch (e) {
      _detailProduct = null;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void search(String query) {
    _searchQuery = query;
    _isSearching = query.isNotEmpty;

    if (query.isEmpty) {
      _visibleProducts = List.from(_allProducts);
    } else {
      final lower = query.toLowerCase();
      _visibleProducts = _allProducts.where((product) {
        return product.nameProduct.toLowerCase().contains(lower);
      }).toList();
    }

    notifyListeners();
  }

  void clearSearch() {
    search('');
  }
}