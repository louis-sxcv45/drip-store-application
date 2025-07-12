import 'package:drip_store/common_widgets/button_buy_widget.dart';
import 'package:drip_store/provider/auth_provider.dart';
import 'package:drip_store/provider/list_cart_provider.dart';
import 'package:drip_store/provider/payment_provider.dart';
import 'package:drip_store/styles_manager/colors_manager.dart';
import 'package:drip_store/styles_manager/font_manager.dart';
import 'package:drip_store/styles_manager/values_manager.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  late int userId;
  @override
  void initState() {
    super.initState();
    // You can add any initialization logic here if needed
    Future.microtask(() {
      // ignore: use_build_context_synchronously
      userId = context.read<AuthProvider>().loginResponse?.user.id ?? 0;
      // ignore: use_build_context_synchronously
      context.read<ListCartProvider>().getCartItems(userId);
    });
  }

  int getTotalPrice(List cartProvider) {
    return cartProvider.fold(0, (total, item) {
      return total + double.parse(item.price).toInt();
    });
  }

  @override
  Widget build(BuildContext context) {
    final cartItems = context.watch<ListCartProvider>().cartItems;
    final isLoggedin = context.watch<AuthProvider>().isLoggedIn;
    final isLoading = context.watch<PaymentProvider>().isLoading;
    return Scaffold(
      appBar: AppBar(title: const Text('Cart Screen')),
      body:
          !isLoggedin
              ? const Center(child: Text('Please login to view your cart'))
              : cartItems.isEmpty
              ? const Center(child: Text('Your cart is empty'))
              : Column(
                children: [
                  Expanded(
                    child: CustomScrollView(
                      slivers: [
                        SliverList.builder(
                          itemCount: cartItems.length,
                          itemBuilder: (context, index) {
                            final item = cartItems[index];
                            return ListTile(
                              leading: Image.network(item.image),
                              title: Text(item.nameProduct),
                              subtitle: Text(
                                'Price: ${NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0).format(double.parse(item.price))}',
                              ),
                              trailing: IconButton(
                                onPressed: () async {
                                  await context
                                      .read<ListCartProvider>()
                                      .removeCartItem(item.id);

                                  // ignore: use_build_context_synchronously
                                  await context
                                      .read<ListCartProvider>()
                                      .getCartItems(userId);
                                },
                                icon: Icon(
                                  Icons.delete,
                                  color: ColorsManager.red,
                                ),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),

                  Container(
                    padding: const EdgeInsets.all(AppPadding.p16),
                    decoration: BoxDecoration(
                      color: ColorsManager.white,
                      boxShadow: [
                        BoxShadow(
                          color: ColorsManager.grey.withOpacity(0.2),
                          blurRadius: 10,
                          offset: const Offset(0, -2),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Total Price: ',
                              style: TextStyle(
                                fontSize: AppSize.s16,
                                fontWeight: FontWeightManager.bold,
                              ),
                            ),

                            Text(
                              NumberFormat.currency(
                                locale: 'id_ID',
                                symbol: 'Rp ',
                                decimalDigits: 0,
                              ).format(getTotalPrice(cartItems)),
                              style: const TextStyle(
                                fontSize: AppSize.s18,
                                fontWeight: FontWeightManager.bold,
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: AppSize.s16),

                        isLoading
                            ? const Center(child: CircularProgressIndicator())
                            : ButtonBuyWidget(
                              title: 'Checkout',
                              onTapped: () async {
                                final paymentProvider =
                                    context.read<PaymentProvider>();

                                final productIds =
                                    cartItems.map((item) => item.id).toList();
                                final storeId = cartItems.first.storeId;

                                await paymentProvider.processPayment(
                                  productIds,
                                  storeId,
                                );

                                final snapToken =
                                    paymentProvider.payment?.snapToken;

                                debugPrint('productIds: $productIds');
                                debugPrint('Store ID: $storeId');
                                debugPrint('Snap Token: $snapToken');

                                if (snapToken != null) {
                                  // ignore: use_build_context_synchronously
                                  context.push(
                                    '/cart/payment/$snapToken',
                                  );
                                } else {
                                  // ignore: use_build_context_synchronously
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text(
                                        'Payment processing failed',
                                      ),
                                    ),
                                  );
                                }
                              },
                            ),
                      ],
                    ),
                  ),
                ],
              ),
    );
  }
}
