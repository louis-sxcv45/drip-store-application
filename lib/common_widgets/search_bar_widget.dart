import 'package:drip_store/styles_manager/font_manager.dart';
import 'package:drip_store/styles_manager/values_manager.dart';
import 'package:flutter/material.dart';

class SearchBarWidget extends StatelessWidget {
  final TextEditingController? controller;
  final String? hintText;

  const SearchBarWidget({super.key, required this.controller, required this.hintText});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: AppPadding.p15),
      margin: const EdgeInsets.symmetric(vertical: AppMargin.m8),
      child: TextField(
        controller: controller,
        style: TextStyle(
          fontSize: FontSizeManager.f14,
        ),
        decoration: InputDecoration(
          hintText: hintText,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(AppSize.s12),
            ),
          ),
          prefixIcon: const Icon(
            Icons.search,
          ),
        ),
      ),
    );
  }
}
