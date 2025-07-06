import 'package:drip_store/common_widgets/button_buy_widget.dart';
import 'package:drip_store/provider/auth_provider.dart';
import 'package:drip_store/provider/bottom_navigation_provider.dart';
import 'package:drip_store/provider/list_cart_provider.dart';
import 'package:drip_store/provider/product_list_provider.dart';
import 'package:drip_store/styles_manager/font_manager.dart';
import 'package:drip_store/styles_manager/values_manager.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class DetailProductScreen extends StatefulWidget {
  final int productId;
  const DetailProductScreen({super.key, required this.productId});

  @override
  State<DetailProductScreen> createState() => _DetailProductScreenState();
}

class _DetailProductScreenState extends State<DetailProductScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      // ignore: use_build_context_synchronously
      context.read<ProductListProvider>().fetchDetailProduct(widget.productId);
    });
  }

  @override
  Widget build(BuildContext context) {
    final getDetailProduct = context.watch<ProductListProvider>().detailProduct;
    final isLoading = context.watch<ProductListProvider>().isLoading;
    final isLoggedIn = context.watch<AuthProvider>().isLoggedIn;
    final detailProduct = getDetailProduct?.detailProduct;

    return Scaffold(
      appBar: AppBar(title: Text('Detail Product')),
      body:
          isLoading || detailProduct == null
              ? const Center(child: CircularProgressIndicator())
              : SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Image.network(
                      detailProduct.image,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),

                    const SizedBox(height: AppSize.s8),

                    Container(
                      margin: const EdgeInsets.symmetric(
                        horizontal: AppMargin.m8,
                        vertical: AppMargin.m8,
                      ),
                      child: Row(
                        children: [
                          Text(
                            detailProduct.nameProduct,
                            style: TextStyle(
                              fontSize: AppSize.s20,
                              fontWeight: FontWeightManager.bold,
                            ),
                          ),

                          const SizedBox(width: 150),

                          Expanded(
                            child: Text(
                              detailProduct.quantity > 0
                                  ? 'Stock Available'
                                  : 'Out of Stock',
                              style: TextStyle(
                                fontSize: AppSize.s14,
                                fontWeight: FontWeightManager.regular,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    Container(
                      margin: const EdgeInsets.only(
                        top: AppMargin.m8,
                        left: AppMargin.m8,
                      ),
                      child: Text(
                        NumberFormat.currency(
                          locale: 'id_ID',
                          symbol: 'Rp ',
                          decimalDigits: 0,
                        ).format(double.parse(detailProduct.price)),
                        style: TextStyle(
                          fontSize: AppSize.s14,
                          fontWeight: FontWeightManager.regular,
                        ),
                      ),
                    ),

                    const SizedBox(height: AppSize.s8),

                    Container(
                      margin: const EdgeInsets.only(
                        top: AppMargin.m8,
                        left: AppMargin.m8,
                      ),
                      child: Text(
                        'Category: ${detailProduct.category}',
                        style: TextStyle(
                          fontSize: AppSize.s14,
                          fontWeight: FontWeightManager.regular,
                        ),
                      ),
                    ),

                    const SizedBox(height: AppSize.s28),

                    Container(
                      margin: const EdgeInsets.only(
                        top: AppMargin.m8,
                        left: AppMargin.m8,
                      ),
                      child: Text(
                        'Description',
                        style: TextStyle(
                          fontSize: AppSize.s16,
                          fontWeight: FontWeightManager.bold,
                        ),
                      ),
                    ),

                    const SizedBox(height: AppSize.s8),

                    Container(
                      margin: const EdgeInsets.only(
                        top: AppMargin.m8,
                        left: AppMargin.m8,
                        right: AppMargin.m8,
                      ),
                      child: Text(
                        detailProduct.description,
                        style: TextStyle(
                          fontSize: AppSize.s14,
                          fontWeight: FontWeightManager.regular,
                        ),
                        textAlign: TextAlign.justify,
                      ),
                    ),

                    const SizedBox(height: AppSize.s30),

                    Container(
                      margin: const EdgeInsets.only(
                        top: AppMargin.m8,
                        left: AppMargin.m8,
                        bottom: AppMargin.m8,
                      ),
                      child: Row(
                        children: [
                          CircleAvatar(
                            backgroundImage: NetworkImage(
                              detailProduct.storeLogo,
                            ),
                            radius: 34,
                          ),

                          const SizedBox(width: AppSize.s12),

                          Text(
                            detailProduct.nameStore,
                            style: TextStyle(
                              fontSize: AppSize.s20,
                              fontWeight: FontWeightManager.medium,
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: AppSize.s40),

                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppMargin.m8,
                      ),
                      margin: const EdgeInsets.only(bottom: AppMargin.m12),
                      child: ButtonBuyWidget(
                        title: 'Buy Product',
                        onTapped: () async {

                          if (!isLoggedIn){
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Please login to buy product'),
                              ),
                            );
                            return;
                          }

                          final product =
                              context
                                  .read<ProductListProvider>()
                                  .detailProduct
                                  ?.detailProduct;

                          if (product != null) {
                            final cartProvider =
                                context.read<ListCartProvider>();
                            await cartProvider.saveCartItem(product);

                            // ignore: use_build_context_synchronously
                            context.go('/cart');
                            // ignore: use_build_context_synchronously
                            context.read<BottomNavigationProvider>().setIndexNav(1);

                            // ignore: use_build_context_synchronously
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text(cartProvider.message)),
                            );
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Product not found'),
                              ),
                            );
                          }
                        },
                      ),
                    ),
                  ],
                ),
              ),
    );
  }
}
