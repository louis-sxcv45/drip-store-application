import 'package:drip_store/provider/auth_provider.dart';
import 'package:drip_store/provider/profile_user_provider.dart';
import 'package:drip_store/styles_manager/colors_manager.dart';
import 'package:drip_store/styles_manager/font_manager.dart';
import 'package:drip_store/styles_manager/values_manager.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProfileBarWidget extends StatelessWidget {
  final String image;
  final String name;
  final String email;
  const ProfileBarWidget({
    required this.image,
    required this.name,
    required this.email,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(
        horizontal: AppMargin.m12,
        vertical: AppPadding.p12,
      ),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                width: 100,
                height: 100,
                child: CircleAvatar(backgroundImage: NetworkImage(image)),
              ),

              const SizedBox(width: AppSize.s20),

              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    name,
                    style: TextStyle(
                      fontSize: FontSizeManager.f18,
                      fontWeight: FontWeightManager.bold,
                    ),
                  ),

                  Text(
                    email,
                    style: TextStyle(
                      fontSize: FontSizeManager.f16,
                      fontWeight: FontWeightManager.regular,
                    ),
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: AppSize.s28),

          GestureDetector(
            child: Container(
              margin: const EdgeInsets.only(top: AppMargin.m40),
              padding: const EdgeInsets.symmetric(horizontal: AppSize.s20),
              width: double.infinity,
              height: AppSize.s60,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: Theme.of(context).brightness == Brightness.dark
                      ? ColorsManager.black
                      : ColorsManager.platinum,
                borderRadius: BorderRadius.circular(AppSize.s12),
              ),
              child: Text(
                'Logout',
                style: TextStyle(
                  color: Theme.of(context).brightness == Brightness.dark
                      ? ColorsManager.white
                      : ColorsManager.black,
                  fontSize: AppSize.s20,
                ),
              ),
            ),
            onTap: () async {
              await context.read<AuthProvider>().logout();
              // ignore: use_build_context_synchronously
              context.read<ProfileUserProvider>().clearProfile();
            },
          ),
        ],
      ),
    );
  }
}
