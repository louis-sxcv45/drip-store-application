class ProductModel {
  int id;
  String nameProduct;
  String price;
  String image;
  String nameStore;
  String storeLogo;

  ProductModel({
    required this.id,
    required this.nameProduct,
    required this.price,
    required this.image,
    required this.nameStore,
    required this.storeLogo,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: json['id'],
      nameProduct: json['name_product'],
      price: json['price'],
      image: json['image'],
      nameStore: json['name_store'],
      storeLogo: json['logo'],
    );
  }
}
