import 'package:drip_store/model/data/user_model.dart';

class ProfileUserResponse {
  UserModel? user;

  ProfileUserResponse({required this.user});

  factory ProfileUserResponse.fromJson(Map<String, dynamic> json) {
    return ProfileUserResponse(user: UserModel.fromJson(json['user']));
  }
}
