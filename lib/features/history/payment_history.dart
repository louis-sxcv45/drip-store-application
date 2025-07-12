import 'package:drip_store/provider/auth_provider.dart';
import 'package:drip_store/provider/history_provider.dart';
import 'package:drip_store/styles_manager/assets_image_icon.dart';
import 'package:drip_store/styles_manager/font_manager.dart';
import 'package:drip_store/styles_manager/values_manager.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class PaymentHistory extends StatefulWidget {
  const PaymentHistory({super.key});

  @override
  State<PaymentHistory> createState() => _PaymentHistoryState();
}

class _PaymentHistoryState extends State<PaymentHistory> {
  @override
  void initState() {
    Future.microtask(() {
      // ignore: use_build_context_synchronously
      context.read<HistoryProvider>().fetchHistory();
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final historyData = context.watch<HistoryProvider>().history;
    final isLoading = context.watch<HistoryProvider>().isLoading;
    final isLoggedIn = context.watch<AuthProvider>().isLoggedIn;
    final history = (historyData?.data ?? []).where((item)=> item.status == 2).toList();
    return Scaffold(
      appBar: AppBar(title: const Text('Payment History')),

      body:
          !isLoggedIn
              ? const Center(
                child: Text('Please login to view your payment history'),
              )
              : isLoading 
              ? const Center(child: CircularProgressIndicator())
              : CustomScrollView(
                slivers: [
                  SliverList.builder(
                    itemCount: history.length,
                    itemBuilder: (context, index) {
                      final item = history[index];
                      final transactionItem = item.transactionItems.first;
                      final product = transactionItem.product;
              
                      return ListTile(
                        leading: Image.network(product.image),
                        title: Text(product.nameProduct),
                        subtitle: Text(
                          'Price: ${NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0).format(double.parse(product.price))}',
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            CircleAvatar(
                              backgroundImage: product.storeLogo.isEmpty
                              ?
                                const AssetImage(
                                  '${AssetsImageIcon.assetPath}/default_logo.jpg',
                                )

                              : NetworkImage(product.storeLogo),
                              radius: 12,
                            ),
                        
                            const SizedBox(width: AppSize.s8),
                        
                            Text(
                              product.nameStore,
                              style: const TextStyle(
                                fontSize: FontSizeManager.f14,
                                fontWeight: FontWeightManager.regular,
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ],
              ),
    );
  }
}
