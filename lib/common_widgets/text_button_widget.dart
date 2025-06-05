import 'package:drip_store/styles_manager/colors_manager.dart';
import 'package:drip_store/styles_manager/values_manager.dart';
import 'package:flutter/material.dart';

class TextButtonWidget extends StatelessWidget {
  final double size;
  final Color? color;
  final String title;
  final VoidCallback onPressed;
  const TextButtonWidget({
    super.key,
    required this.title,
    required this.onPressed,
    required this.size,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.arrow_back_rounded,
            size: AppSize.s20,
            color: color ?? ColorsManager.black,
          ),

          SizedBox(
            width: AppSize.s8,
          ),

          Text(
            title,
            style: TextStyle(
              fontSize: size, 
              color: color ?? ColorsManager.black,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
