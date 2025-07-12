import 'package:drip_store/model/data/detail_product_model.dart';
import 'package:drip_store/model/sqlite/local_database_service.dart';
import 'package:flutter/material.dart';

class ListCartProvider extends ChangeNotifier {
  final LocalDatabaseService _service;

  ListCartProvider(
    this._service
  );

  String _message = '';
  String get message => _message;

  List<DetailProductModel> _cartItems = [];
  List<DetailProductModel> get cartItems => _cartItems;

  DetailProductModel? _selectedItem;
  DetailProductModel? get selectedItem => _selectedItem;

  Future<void> saveCartItem(DetailProductModel item, int userId) async {
    try {
      final result = await _service.insertItem(item, userId);
      final isError = result == 0;

      if (isError) {
        _message = 'Failed to add item to cart';
        debugPrint('Error: $_message');
      } else {
        _message = 'Item added to cart successfully';
        debugPrint('Success: $_message');
      }
      notifyListeners();
    } catch (e) {
      _message = 'Failed to add your favorite';
      notifyListeners();
    }
  }
  
  Future<void> getCartItems(int userId) async {
    try {
      _cartItems = await _service.getAllProducts(userId);
      _message = 'Cart items loaded successfully';
      debugPrint('Success: $_message');
      notifyListeners();
    } catch (e) {
      _message = 'Failed to load cart items';
      debugPrint('Error: $_message');
      notifyListeners();
    }
  }

  Future<void> getCartItemById(int id) async {
    try {
      _selectedItem = await _service.getDataId(id);
      _message = 'Cart item loaded successfully';
      debugPrint('Success: $_message');
      notifyListeners();
    } catch (e) {
      _message = 'Failed to load cart item';
      debugPrint('Error: $_message');
      notifyListeners();
    }
  }

  Future<void> removeCartItem(int id) async {
    try {
      await _service.removeItem(id);
      _message = 'Item removed from cart successfully';
      debugPrint('Success: $_message');
      notifyListeners();
    } catch (e) {
      _message = 'Failed to remove item from cart';
      debugPrint('Error: $_message');
      notifyListeners();
    }
  }
}