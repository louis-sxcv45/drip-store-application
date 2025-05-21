class UserModel {
  final int id;
  final String name;
  final String email;
  final String? phone;
  final String? address;
  final String? profilePicture;
  final DateTime createdAt;
  final DateTime updatedAt;


  UserModel({
    required this.id,
    required this.name,
    required this.email,
    this.phone,
    this.address,
    this.profilePicture,
    required this.createdAt,
    required this.updatedAt,
  });

  factory UserModel.fromJson(Map<String, dynamic> json){
    return UserModel(
      id: json['id'],
    name: json['name'],
    email: json['email'],
    phone: json['phone'],
    address: json['address'],
    profilePicture: json['profile_picture'],
    createdAt: DateTime.parse(json['created_at']),
    updatedAt: DateTime.parse(json['updated_at']),
    );
  }
}