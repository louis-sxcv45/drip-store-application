import 'dart:convert';

import 'package:drip_store/model/data/detail_product_response.dart';
import 'package:drip_store/model/data/history_response.dart';
import 'package:drip_store/model/data/login_response.dart';
import 'package:drip_store/model/data/payment_response.dart';
import 'package:drip_store/model/data/product_list_response.dart';
import 'package:drip_store/model/data/profile_user_response.dart';
import 'package:drip_store/model/data/register_response.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ApiService {
  static const String baseUrl = "https://917f-2001-448a-10cc-3ec9-dca2-94ab-85fe-595b.ngrok-free.app/api";

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
    String phone,
    String address,
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
        "phone": phone,
        "address": address,
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

  Future<DetailProductResponse> getDetailProduct(int productId) async {
    final url = Uri.parse("$baseUrl/products/$productId");

    final response = await http.get(
      url,
      headers: {
        "Accept" : "application/json"
      }
    );

    final responseBody = jsonDecode(response.body);

    if (response.statusCode == 200) {
      return DetailProductResponse.fromJson(responseBody);
    } else {
      throw Exception(
        responseBody['message'] ?? 'Failed to fetch product details, please try again.'
      );
    }
  }

  Future<PaymentResponse> createPayment(
    List<int> productIds,
    int storeId,
    String token
  ) async {
    final url = Uri.parse("$baseUrl/transaksi/checkout");
    final response = await http.post(
      url,
      headers: {
        "Accept": "application/json",
        "Content-Type": "application/json",
        "Authorization": "Bearer $token"
      },
      body: jsonEncode({
        "product_ids": productIds,
        "store_id": storeId,
      })
    );

    final responseBody = jsonDecode(response.body);
    if (response.statusCode == 200 ){
      return PaymentResponse.fromJson(responseBody);
    } else {
      throw Exception(
        responseBody['message'] ?? 'Failed to create payment, please try again.'
      );
    }
  }

  Future<HistoryResponse> getHistory(String token) async {
    final url = Uri.parse('$baseUrl/transaksi/history');

    final response = await http.get(
      url,
      headers: {
        "Accept": "application/json",
        "Authorization" : "Bearer $token"
      }
    );
    final responseBody = jsonDecode(response.body);
    if (response.statusCode == 200) {
      return HistoryResponse.fromJson(responseBody);
    } else {
      throw Exception(
        responseBody['message'] ?? 'Failed to fetch transaction history, please try again.'
      );
    }
  }
}
