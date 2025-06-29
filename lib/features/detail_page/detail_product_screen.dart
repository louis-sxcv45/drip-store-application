import 'package:flutter/material.dart';

class DetailProductScreen extends StatelessWidget {
  final int productId;
  const DetailProductScreen({super.key, required this.productId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(
          'Detail Product Screen for Product ID: $productId',
          style: const TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}