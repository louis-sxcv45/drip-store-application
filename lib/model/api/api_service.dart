import 'dart:convert';

import 'package:drip_store/model/data/login_response.dart';
import 'package:drip_store/model/data/product_list_response.dart';
import 'package:drip_store/model/data/profile_user_response.dart';
import 'package:drip_store/model/data/register_response.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ApiService {
  static const String baseUrl = "http://192.168.0.115:8000/api";

  Future<LoginResponse> login(String email, String password) async {
    final url = Uri.parse("$baseUrl/login");

    final response = await http.post(
      url,
      headers: {"Accept": "application/json"},
      body: {"email": email, "password": password},
    );

    if (response.statusCode == 201) {
      return LoginResponse.fromJson(jsonDecode(response.body));
    } else {
      final errorResponse = jsonDecode(response.body);
      throw Exception(
        errorResponse['message'] ?? "Login failed, please try again.",
      );
    }
  }

  Future<RegisterResponse> register(
    String name,
    String email,
    String password,
    String confirmPassword,
  ) async {
    final url = Uri.parse("$baseUrl/register");

    final response = await http.post(
      url,
      headers: {"Accept": "application/json"},
      body: {
        "name": name,
        "email": email,
        "password": password,
        "password_confirmation": confirmPassword,
      },
    );

    final responseBody = jsonDecode(response.body);
    if (response.statusCode == 201) {
      return RegisterResponse.fromJson(responseBody);
    } else {
      throw Exception(
        responseBody['message'] ?? "Registration failed, please try again.",
      );
    }
  }

  Future<ProfileUserResponse> getProfile(String token) async {
    final url = Uri.parse("$baseUrl/profile");

    final response = await http.get(
      url,
      headers: {
        "Accept": "application/json",
        "Authorization": "Bearer $token"
      }
    );

    final responseBody = jsonDecode(response.body);
    debugPrint("Response Body: $responseBody");
    if (response.statusCode == 200) {
      return ProfileUserResponse.fromJson(responseBody);
    } else {
      throw Exception (
        responseBody['message'] ?? "Failed to fetch profile data, please try again."
      );
    }
  }

  Future<void> logout(String token) async {
    final url = Uri.parse("$baseUrl/logout");

    final response = await http.post(
      url,
      headers: {
        "Accept" : "application/json",
        "Authorization" : "Bearer $token"
      }
    );

    final responseBody = jsonDecode(response.body);
    if (response.statusCode == 200 || response.statusCode == 401) {
      return responseBody['message'];
    }
  }


  Future<ProductListResponse> getProducts() async {
    final url = Uri.parse("$baseUrl/products");

    final response = await http.get(
      url,
      headers: {
        "Accept" : "application/json",
      }
    );

    final responseBody = jsonDecode(response.body);

    if (response.statusCode == 200) {
      debugPrint("Products: $responseBody");

      return ProductListResponse.fromJson(responseBody);
    } else {
      throw Exception(
        responseBody['message'] ?? 'Failed to fetch profile data, please try again.'
      );
    }
  }
}
