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
  final TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      context.read<ProfileUserProvider>().fetchProfile();
      context.read<ProductListProvider>().fetchProduct();
      context.read<AuthProvider>().initializeAuth();
    });
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final greeting = context.watch<GreetingTimeProvider>().greeting;
    final isLoading = context.watch<ProductListProvider>().isLoading;
    final getProduct = context.watch<ProductListProvider>().product?.data;
    final nameUser = context.watch<AuthProvider>().loginResponse?.user.name;
    // final photo = context.watch<AuthProvider>().loginResponse?.user.profilePicture;

    final isSearching = context.watch<ProductListProvider>();
    final List products = isSearching.isSearching
        ? isSearching.productList
        : getProduct ?? [];

    return Scaffold(
      body: SafeArea(
        child: isLoading || getProduct == null
            ? const Center(child: CircularProgressIndicator())
            : Container(
                margin: const EdgeInsets.symmetric(
                  horizontal: AppMargin.m10,
                  vertical: AppMargin.m22,
                ),
                child: Column(
                  children: [
                    UserProfileInfo(
                      avatar: 'https://wallpapers.com/images/hd/naruto-pictures-ifftdoc33971s72e.jpg',
                      name: nameUser ?? 'Guest',
                      day: greeting,
                    ),

                    const SizedBox(height: AppSize.s20),

                    SearchBarWidget(
                      controller: searchController,
                      hintText: 'Search for products...',
                      onChanged: (value) => isSearching.search(value),
                      onClear: () {
                        searchController.clear();
                        isSearching.clearSearch();
                      },
                    ),

                    const SizedBox(height: AppSize.s20),

                    if (isSearching.searchQuery.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: AppMargin.m8),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            '${getProduct.length} results found for "${isSearching.searchQuery}"',
                            style: const TextStyle(
                              fontSize: AppSize.s14,
                              fontWeight: FontWeightManager.medium,
                              color: Colors.grey,
                            ),
                          ),
                        ),
                      ),

                    const SizedBox(height: AppSize.s8),

                    Expanded(
                      child: products.isEmpty
                          ? _noProductWidget(isSearching.isSearching, isSearching.searchQuery, context)
                          : CustomScrollView(
                              slivers: [
                                SliverGrid.count(
                                  crossAxisCount: 2,
                                  childAspectRatio: 0.7,
                                  crossAxisSpacing: AppMargin.m8,
                                  children: products.map((product) {
                                    return GestureDetector(
                                      onTap: () => context.push('/product/${product.id}'),
                                      child: CardProductWidget(
                                        title: product.nameProduct,
                                        price: product.price,
                                        nameStore: product.nameStore,
                                        storeLogo: product.storeLogo,
                                        image: product.image,
                                      ),
                                    );
                                  }).toList(),
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

  Widget _noProductWidget(bool isSearching, String searchQuery, BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            isSearching ? Icons.search_off : Icons.inventory_2_outlined,
            size: 64,
            color: Colors.grey[400],
          ),
          const SizedBox(height: AppSize.s16),
          Text(
            isSearching
                ? 'No products found for "$searchQuery"'
                : 'No products available',
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: AppSize.s16,
              fontWeight: FontWeightManager.regular,
              color: Colors.grey,
            ),
          ),
          if (isSearching)
            const SizedBox(height: AppSize.s8),
          if (isSearching)
            TextButton(
              onPressed: () {
                searchController.clear();
                context.read<ProductListProvider>().clearSearch();
              },
              child: const Text('Clear search'),
            ),
        ],
      ),
    );
  }
}
