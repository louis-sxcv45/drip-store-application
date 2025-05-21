import 'dart:convert';

import 'package:drip_store/model/data/login_response.dart';
import 'package:http/http.dart' as http;

class ApiService {
  static const String baseUrl = "http://192.168.100.115:8000/api";

  Future<LoginResponse> login(String email, String password) async {
    final url = Uri.parse("$baseUrl/login");

    final response = await http.post(
      url,
      headers: {
        "Accept": "application/json"
      },
      body: {
        "email": email,
        "password": password,
      }
    );

    if (response.statusCode == 201) {
      return LoginResponse.fromJson(jsonDecode(response.body));
    } else {
      final errorResponse = jsonDecode(response.body);
      throw Exception(
        errorResponse['message'] ?? "Login failed, please try again."
      );
    }
  }
}