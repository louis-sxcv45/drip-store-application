import 'package:drip_store/model/data/history_data.dart';

class HistoryResponse {
    String message;
    List<HistoryData> data;

    HistoryResponse({
        required this.message,
        required this.data,
    });

    factory HistoryResponse.fromJson(Map<String, dynamic> json) => HistoryResponse(
        message: json["message"],
        data: List<HistoryData>.from(json["data"].map((x) => HistoryData.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "message": message,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
    };
}