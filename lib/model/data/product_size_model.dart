class ProductSizeModel {
  final int id;
  final String size;

  ProductSizeModel({
    required this.id,
    required this.size
  });

  factory ProductSizeModel.fromJson(Map<String, dynamic> json){
    return ProductSizeModel(id: json['id'], size: json['size']);
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'size': size,
    };
  }
}