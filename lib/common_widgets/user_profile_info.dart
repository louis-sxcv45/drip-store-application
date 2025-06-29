import 'package:drip_store/common_widgets/guest_action_widget.dart';
import 'package:drip_store/provider/auth_provider.dart';
import 'package:drip_store/styles_manager/font_manager.dart';
import 'package:drip_store/styles_manager/values_manager.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class UserProfileInfo extends StatelessWidget {
  final String avatar;
  final String name;
  final String day;
  const UserProfileInfo({
    super.key,
    required this.avatar,
    required this.name,
    required this.day,
  });

  @override
  Widget build(BuildContext context) {
    final isLoggedin = context.watch<AuthProvider>().isLoggedIn;
    return isLoggedin
      ? Row(
        children: [
          SizedBox(
            width: AppSize.s60,
            height: AppSize.s60,
            child: CircleAvatar(backgroundImage: NetworkImage(avatar)),
          ),

          const SizedBox(width: AppSize.s12),

          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                day,
                style: TextStyle(
                  fontSize: FontSizeManager.f16,
                  fontWeight: FontWeightManager.bold,
                ),
              ),

              Text(
                name,
                style: TextStyle(
                  fontSize: FontSizeManager.f16,
                  fontWeight: FontWeightManager.regular,
                ),
              ),
            ],
          ),
        ],
      ) : GuestActionWidget(
        width: AppSize.s60,
        height: AppSize.s60,
        iconSize: AppSize.s32,
        fontSize: FontSizeManager.f14,
      );
  }
}
