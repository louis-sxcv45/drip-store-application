import 'package:drip_store/model/data/transaction_item.dart';

class HistoryData {
    int id;
    int userId;
    int storeId;
    int status;
    String totalAmount;
    DateTime createdAt;
    DateTime updatedAt;
    List<TransactionItem> transactionItems;

    HistoryData({
        required this.id,
        required this.userId,
        required this.storeId,
        required this.status,
        required this.totalAmount,
        required this.createdAt,
        required this.updatedAt,
        required this.transactionItems,
    });

    factory HistoryData.fromJson(Map<String, dynamic> json) => HistoryData(
        id: json["id"],
        userId: json["user_id"],
        storeId: json["store_id"],
        status: json["status"],
        totalAmount: json["total_amount"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
        transactionItems: List<TransactionItem>.from(json["transaction_items"].map((x) => TransactionItem.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "user_id": userId,
        "store_id": storeId,
        "status": status,
        "total_amount": totalAmount,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
        "transaction_items": List<dynamic>.from(transactionItems.map((x) => x.toJson())),
    };
}