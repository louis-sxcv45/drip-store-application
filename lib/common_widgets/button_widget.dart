import 'package:drip_store/styles_manager/colors_manager.dart';
import 'package:drip_store/styles_manager/values_manager.dart';
import 'package:flutter/material.dart';

class ButtonWidget extends StatelessWidget {
  final String title;
  final VoidCallback onTapped;
  const ButtonWidget({super.key, required this.title, required this.onTapped});

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
        decoration: BoxDecoration(
          color: ColorsManager.black,
          borderRadius: BorderRadius.circular(AppSize.s12),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: TextStyle(
                color: ColorsManager.white,
                fontSize: AppSize.s20,
              ),
            ),

            Icon(
              Icons.arrow_forward,
              color: ColorsManager.white,
              size: AppSize.s20,
            ),
          ],
        ),
      ),
    );
  }
}
