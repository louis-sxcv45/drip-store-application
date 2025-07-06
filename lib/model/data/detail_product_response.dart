import 'package:drip_store/model/data/detail_product_model.dart';

class DetailProductResponse {
  final String message;
  final DetailProductModel detailProduct;

  DetailProductResponse({required this.message, required this.detailProduct});

  factory DetailProductResponse.fromJson(Map<String, dynamic> json) {
    return DetailProductResponse(
      message: json['message'],
      detailProduct: DetailProductModel.fromJson(json['data']),
    );
  }
}
