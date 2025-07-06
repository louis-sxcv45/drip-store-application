class PaymentResponse {
  final String? message;
  final String? snapToken;

  PaymentResponse({
    required this.message,
    required this.snapToken
  });

  factory PaymentResponse.fromJson(Map<String, dynamic>json) {
    return PaymentResponse(
      message: json['message'],
      snapToken: json['snap_token'],
    );
  }
}