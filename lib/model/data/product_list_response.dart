import 'package:drip_store/model/data/product_model.dart';

class ProductListResponse {
  final String message;
  List<ProductModel> data;

  ProductListResponse({required this.message, required this.data});

  factory ProductListResponse.fromJson(Map<String, dynamic> json) {
    return ProductListResponse(
      message: json['message'],
      data: List<ProductModel>.from(
        json['data'].map((x) => ProductModel.fromJson(x)),
      ),
    );
  }
}
