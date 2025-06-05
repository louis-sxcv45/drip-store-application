import 'package:drip_store/model/data/user_model.dart';

class RegisterResponse {
  final UserModel? user;
  final String token;
  final String message;

  RegisterResponse({
    required this.user,
    required this.token,
    required this.message,
  });

  factory RegisterResponse.fromJson(Map<String, dynamic> json) {
    return RegisterResponse(
      user: UserModel.fromJson(json['user']),
      token: json['token'],
      message: json['message'],
    );
  }
}
