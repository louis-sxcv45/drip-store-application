import 'package:drip_store/common_widgets/card_product_widget.dart';
import 'package:drip_store/common_widgets/search_bar_widget.dart';
import 'package:drip_store/common_widgets/user_profile_info.dart';
import 'package:drip_store/provider/auth_provider.dart';
import 'package:drip_store/provider/greeting_time_provider.dart';
import 'package:drip_store/provider/product_list_provider.dart';
import 'package:drip_store/provider/profile_user_provider.dart';
import 'package:drip_store/styles_manager/font_manager.dart';
import 'package:drip_store/styles_manager/values_manager.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      // ignore: use_build_context_synchronously
      context.read<ProfileUserProvider>().fetchProfile();

      // ignore: use_build_context_synchronously
      context.read<ProductListProvider>().fetchProduct();

      context.read<AuthProvider>().initializeAuth();
    });
  }

  @override
  Widget build(BuildContext context) {
    final greeting = context.watch<GreetingTimeProvider>().greeting;
    final isLoading = context.watch<ProductListProvider>().isLoading;
    final getProduct = context.watch<ProductListProvider>().product;
    final nameUser = context.watch<AuthProvider>().loginResponse?.user.name;
    final photo = context.watch<AuthProvider>().loginResponse?.user.profilePicture;

    final searchController = TextEditingController();
    return Scaffold(
      body: SafeArea(
        child:
            isLoading
                ? const Center(child: CircularProgressIndicator())
                : Container(
                  margin: const EdgeInsets.symmetric(
                    horizontal: AppMargin.m10,
                    vertical: AppMargin.m22,
                  ),
                  child: Column(
                    children: [
                      UserProfileInfo(
                        avatar:
                            photo ??
                            'https://wallpapers.com/images/hd/naruto-pictures-ifftdoc33971s72e.jpg',
                        name: nameUser ?? 'Guest',
                        day: greeting,
                      ),

                      const SizedBox(height: AppSize.s20),

                      SearchBarWidget(
                        controller: searchController,
                        hintText: 'Search for products...',
                      ),

                      const SizedBox(
                        height: AppSize.s20,
                      ),

                      Expanded(
                        child: CustomScrollView(
                          slivers: [
                            SliverGrid.count(
                              crossAxisCount: 2,
                              childAspectRatio: 0.7,
                              crossAxisSpacing: AppMargin.m8,
                              children: 
                              getProduct!.data.isEmpty
                                  ? [
                                      const Center(
                                        child: Text(
                                          'No products available',
                                          style: TextStyle(
                                            fontSize: AppSize.s18,
                                            fontWeight: FontWeightManager.regular,
                                          ),
                                        ),
                                      )
                                    ]
                                  : getProduct.data
                                      .map((product) => GestureDetector(
                                        child: CardProductWidget(
                                          title: product.nameProduct, 
                                          price: product.price, 
                                          nameStore: product.nameStore, 
                                          storeLogo: product.storeLogo, 
                                          image: product.image
                                        ),
                                        onTap: () => context.push('/product/${product.id}'),
                                      ))
                                      .toList()
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
      ),
    );
  }
}
