import 'dart:convert';
import 'package:drip_store/model/data/product_size_model.dart';

class DetailProductModel {
  final int id;
  final String nameProduct;
  final String price;
  final String description;
  final String category;
  final int quantity;
  final String image;
  final String nameStore;
  final int storeId;
  final String storeLogo;
  final int? userId;
  List<ProductSizeModel> productSizes;

  DetailProductModel({
    required this.id,
    required this.nameProduct,
    required this.price,
    required this.description,
    required this.category,
    required this.quantity,
    required this.image,
    required this.nameStore,
    required this.storeId,
    required this.storeLogo,
    required this.userId,
    required this.productSizes,
  });

  factory DetailProductModel.fromJson(Map<String, dynamic> json) {
    List<ProductSizeModel> sizes = [];
    
    // Handle product_sizes field - it could be a JSON string or already parsed
    if (json['product_sizes'] != null) {
      try {
        // If it's a string (from SQLite), decode it first
        if (json['product_sizes'] is String) {
          final decodedSizes = jsonDecode(json['product_sizes']) as List;
          sizes = decodedSizes.map((size) => ProductSizeModel.fromJson(size)).toList();
        } 
        // If it's already a List (from API), use it directly
        else if (json['product_sizes'] is List) {
          sizes = List<ProductSizeModel>.from(
            json['product_sizes'].map((size) => ProductSizeModel.fromJson(size)),
          );
        }
      } catch (e) {
        // print('Error parsing product_sizes: $e');
        sizes = []; // Default to empty list if parsing fails
      }
    }

    return DetailProductModel(
      id: json['id'] ?? 0,
      nameProduct: json['name_product'] ?? '',
      price: json['price'] ?? '',
      description: json['description'] ?? '',
      category: json['category'] ?? '',
      quantity: json['quantity'] ?? 0,
      image: json['image'] ?? '',
      nameStore: json['name_store'] ?? '',
      storeId: json['store_id'] ?? 0,
      storeLogo: json['logo'] ?? '',
      userId: json['user_id'], // Optional field, can be null
      productSizes: sizes,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name_product': nameProduct,
      'price': price,
      'description': description,
      'category': category,
      'quantity': quantity,
      'image': image,
      'name_store': nameStore,
      'store_id': storeId,
      'logo': storeLogo,
      'user_id': userId,
      'product_sizes': jsonEncode(productSizes.map((size) => size.toJson()).toList()),
    };
  }
}