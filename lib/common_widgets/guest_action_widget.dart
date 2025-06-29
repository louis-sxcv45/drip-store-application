import 'package:drip_store/styles_manager/colors_manager.dart';
import 'package:drip_store/styles_manager/font_manager.dart';
import 'package:drip_store/styles_manager/values_manager.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class GuestActionWidget extends StatelessWidget {
  final double width;
  final double height;
  final double iconSize;
  final double fontSize;
  const GuestActionWidget({
    super.key,
    required this.width,
    required this.height,
    required this.iconSize,
    required this.fontSize,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(
          width: width,
          height: height,
          child: CircleAvatar(
            backgroundColor: ColorsManager.platinum,
            child: Icon(
              Icons.person,
              size: iconSize,
              color: ColorsManager.grey,
            ),
          ),
        ),

        const SizedBox(width: AppSize.s12),

        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GestureDetector(
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppPadding.p12,
                  vertical: AppPadding.p8,
                ),

                decoration: BoxDecoration(
                  border: Border.all(
                    color:
                        Theme.of(context).brightness == Brightness.light
                            ? ColorsManager.black
                            : ColorsManager.white,
                    width: 1.5,
                  ),

                  borderRadius: BorderRadius.all(Radius.circular(AppSize.s12)),
                ),

                child: Text(
                  'LOGIN',
                  style: TextStyle(
                    fontSize: fontSize,
                    fontWeight: FontWeightManager.largeBold,
                    color:
                        Theme.of(context).brightness == Brightness.light
                            ? ColorsManager.black
                            : ColorsManager.white,
                  ),
                ),
              ),
              onTap: () => context.push('/login'),
            ),
          ],
        ),
      ],
    );
  }
}
