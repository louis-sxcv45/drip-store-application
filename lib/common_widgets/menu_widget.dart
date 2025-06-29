import 'package:drip_store/styles_manager/colors_manager.dart';
import 'package:drip_store/styles_manager/font_manager.dart';
import 'package:drip_store/styles_manager/values_manager.dart';
import 'package:flutter/material.dart';

class MenuWidget extends StatelessWidget {
  final IconData icon;
  final String title;
  final String caption;
  final VoidCallback onTap;
  const MenuWidget({
    required this.icon,
    required this.title,
    required this.caption,
    required this.onTap,
    super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: AppPadding.p2),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              margin: const EdgeInsets.only(
                top: AppMargin.m2,
              ),
              child: Icon(
                icon,
                size: 40,
              ),
            ),
      
            const SizedBox(
              width: AppSize.s12,
            ),
      
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: FontSizeManager.f14,
                      fontWeight: FontWeightManager.medium,
                      height: 1.6,
                    ),
                  ),
              
                  Text(
                    caption,
                    style: TextStyle(
                      fontSize: FontSizeManager.f12,
                      fontWeight: FontWeightManager.regular,
                      height: 1.4,
                      color: ColorsManager.grey
                    ),
                  )
                ],
              ),
            ),
      
            Container(
              margin: const EdgeInsets.only(
                top: AppMargin.m10,
              ),
              child: Icon(
                  Icons.arrow_forward_ios,
                  size: 20,
                ),
            ),
          ],
        ),
      ),
    );
  }
}