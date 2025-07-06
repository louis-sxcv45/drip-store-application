import 'package:drip_store/styles_manager/colors_manager.dart';
import 'package:drip_store/styles_manager/values_manager.dart';
import 'package:flutter/material.dart';

class ButtonBuyWidget extends StatelessWidget {
  final String title;
  final VoidCallback onTapped;
  const ButtonBuyWidget({super.key, required this.title, required this.onTapped});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTapped,
      child: Container(
        padding: const EdgeInsets.symmetric(
            horizontal: AppSize.s20,
        ),
        width: double.infinity,
        height: AppSize.s60,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: ColorsManager.black,
          borderRadius: BorderRadius.circular(AppSize.s12),
        ),
        child: Text(
          title,
          style: TextStyle(
            color: ColorsManager.white,
            fontSize: AppSize.s20,
          ),
        ),
      ),
    );
  }
}