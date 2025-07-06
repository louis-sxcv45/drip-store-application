import 'package:drip_store/model/data/detail_product_model.dart';

class TransactionItem {
    int id;
    int transactionId;
    int productId;
    int price;
    DateTime createdAt;
    DateTime updatedAt;
    int quantity;
    DetailProductModel product;

    TransactionItem({
        required this.id,
        required this.transactionId,
        required this.productId,
        required this.price,
        required this.createdAt,
        required this.updatedAt,
        required this.quantity,
        required this.product,
    });

    factory TransactionItem.fromJson(Map<String, dynamic> json) => TransactionItem(
        id: json["id"],
        transactionId: json["transaction_id"],
        productId: json["product_id"],
        price: json["price"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
        quantity: json["quantity"],
        product: DetailProductModel.fromJson(json["product"]),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "transaction_id": transactionId,
        "product_id": productId,
        "price": price,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
        "quantity": quantity,
        "product": product.toJson(),
    };
}