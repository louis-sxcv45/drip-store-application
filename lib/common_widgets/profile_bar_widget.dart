import 'package:drip_store/common_widgets/menu_bar_widget.dart';
import 'package:drip_store/styles_manager/font_manager.dart';
import 'package:drip_store/styles_manager/values_manager.dart';
import 'package:flutter/material.dart';

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
        vertical: AppPadding.p12
      ),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                width: 100,
                height: 100,
                child: CircleAvatar(
                  backgroundImage: NetworkImage(image),
                ),
              ),
              
              const SizedBox(width: AppSize.s20,),
          
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    name,
                    style: TextStyle(
                      fontSize: FontSizeManager.f18,
                      fontWeight: FontWeightManager.bold
                    ),
                  ),
          
                  Text(
                    email,
                    style: TextStyle(
                      fontSize: FontSizeManager.f16,
                      fontWeight: FontWeightManager.regular
                    ),
                  )
                ],
              ),
            ],
          ),

          const SizedBox(
            height: AppSize.s28,
          ),

          MenuBarWidget(),
        ],
      ),
    );
  }
}
