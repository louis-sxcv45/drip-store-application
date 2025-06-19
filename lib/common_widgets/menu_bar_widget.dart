import 'package:drip_store/common_widgets/menu_widget.dart';
import 'package:drip_store/styles_manager/colors_manager.dart';
import 'package:drip_store/styles_manager/font_manager.dart';
import 'package:drip_store/styles_manager/values_manager.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class MenuBarWidget extends StatelessWidget {
  const MenuBarWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
      decoration: BoxDecoration(
        color: ColorsManager.white,
        borderRadius: BorderRadius.circular(AppSize.s8),
        boxShadow: [
          BoxShadow(
            color: ColorsManager.black.withValues(alpha: 0.05),
            blurRadius: 44,
            offset: const Offset(0, 4),
            spreadRadius: 11,
          ),
        ],
      ),
      width: 400,
      height: 350,
      child: Column(
        children: [
          MenuWidget(
            icon: Icons.person,
            title: 'Edit Account',
            caption: 'Make changes to your account',
            onTap: () {
              context.push('/profile/edit_account');
            },
          ),

          const SizedBox(height: AppSize.s24),

          MenuWidget(
            icon: Icons.password_sharp,
            title: 'Password',
            caption: 'Make changes your password',
            onTap: () {
              context.push('/profile/password');
            },
          ),

          const SizedBox(height: AppSize.s80),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Logout',
                style: TextStyle(
                  fontSize: FontSizeManager.f20,
                  fontWeight: FontWeightManager.bold,
                  height: 1.6,
                ),
              ),

              IconButton(
                icon: Icon(
                  Icons.logout,
                  color: ColorsManager.black,
                  size: AppSize.s30
              ),
                onPressed: () {},
              ),
            ],
          ),

          const SizedBox(height: AppSize.s12),
          
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Delete Account',
                style: TextStyle(
                  fontSize: FontSizeManager.f20,
                  color: ColorsManager.red,
                  fontWeight: FontWeightManager.bold,
                  height: 1.6,
                ),
              ),

              IconButton(
                icon: Icon(
                  Icons.delete,
                  color: ColorsManager.red, 
                  size: AppSize.s30
              ),
                onPressed: () {},
              ),
            ],
          ),
        ],
      ),
    );
  }
}
