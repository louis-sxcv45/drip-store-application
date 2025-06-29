import 'package:drip_store/styles_manager/font_manager.dart';
import 'package:drip_store/styles_manager/values_manager.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CardProductWidget extends StatelessWidget {
  final String title;
  final String price;
  final String nameStore;
  final String storeLogo;
  final String image;

  const CardProductWidget({
    super.key,
    required this.title,
    required this.price,
    required this.nameStore,
    required this.storeLogo,
    required this.image,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Image.network(
            image,
            fit: BoxFit.cover,
            width: double.infinity,
          ),

          const SizedBox(
            height: AppSize.s2,
          ),

          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppPadding.p8,
            ),
            child: Text(
              title,
              style: const TextStyle(
                fontSize: FontSizeManager.f18,
                fontWeight: FontWeightManager.bold,
              ),
            ),
          ),

          const SizedBox(
            height: AppSize.s2,
          ),

          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppPadding.p8,
            ),
            child: Text(
              NumberFormat.currency(
                locale: 'id_ID',
                symbol: 'Rp ',
                decimalDigits: 0,
              ).format(double.parse(price)),
              style: const TextStyle(
                fontSize: FontSizeManager.f16,
                fontWeight: FontWeightManager.regular,
              ),
            ),
          ),

          const SizedBox(
            height: AppSize.s8,
          ),

          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppPadding.p8,
            ),
            child: Row(
              children: [
                CircleAvatar(
                  backgroundImage: NetworkImage(storeLogo),
                  radius: 12,
                ),

                const SizedBox(
                  width: AppSize.s8,
                ),

                Text(
                  nameStore,
                  style: const TextStyle(
                    fontSize: FontSizeManager.f14,
                    fontWeight: FontWeightManager.regular,
                  ),
                )
              ],
            )
          ),
          
        ],
      ));
  }
}
