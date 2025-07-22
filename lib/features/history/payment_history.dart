import 'dart:io';

import 'package:drip_store/model/data/history_data.dart';
import 'package:drip_store/provider/auth_provider.dart';
import 'package:drip_store/provider/history_provider.dart';
import 'package:drip_store/styles_manager/assets_image_icon.dart';
import 'package:drip_store/styles_manager/font_manager.dart';
import 'package:drip_store/styles_manager/values_manager.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:open_filex/open_filex.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
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

  Map<String, List<HistoryData>> groupHistoryByDate(List<HistoryData> history) {
    final Map<String, List<HistoryData>> grouped = {};

    for (var item in history) {
      // Format tanggal saja tanpa waktu (misalnya: "2025-07-22")
      final key = DateFormat('yyyy-MM-dd').format(item.createdAt.toLocal());

      if (!grouped.containsKey(key)) {
        grouped[key] = [];
      }
      grouped[key]!.add(item);
    }

    return grouped;
  }

  @override
  Widget build(BuildContext context) {
    final historyData = context.watch<HistoryProvider>().history;
    final isLoading = context.watch<HistoryProvider>().isLoading;
    final isLoggedIn = context.watch<AuthProvider>().isLoggedIn;
    final history =
        (historyData?.data ?? []).where((item) => item.status == 2).toList();

    final groupedEntries =
        groupHistoryByDate(history).entries.toList()
          ..sort((a, b) => b.key.compareTo(a.key)); // urutkan dari terbaru

    return Scaffold(
      appBar: AppBar(title: const Text('Payment History')),
      body:
          !isLoggedIn
              ? const Center(
                child: Text('Please login to view your payment history'),
              )
              : isLoading
              ? const Center(child: CircularProgressIndicator())
              : groupedEntries.isEmpty
                  ? const Center(child: Text('No payment history found'))
                  : ListView(
                      children: groupedEntries.map((entry) {
                        final transactions = entry.value;
                        final formattedDate = DateFormat(
                        'EEEE, dd MMMM yyyy',
                        'id_ID',
                      ).format(DateTime.parse(entry.key).toLocal());

                      return ExpansionTile(
                        title: Text(
                          formattedDate,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        children:
                            transactions.map((item) {
                              final transactionItem =
                                  item.transactionItems.first;
                              final product = transactionItem.product;

                              return ListTile(
                                leading: Image.network(
                                  product.image,
                                  width: 48,
                                  height: 48,
                                ),
                                title: Text(product.nameProduct),
                                subtitle: Text(
                                  'Price: ${NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0).format(double.parse(product.price))}',
                                ),
                                trailing: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    IconButton(
                                      icon: const Icon(Icons.picture_as_pdf),
                                      onPressed: () async {
                                        await generateInvoicePdf(context, item);
                                      },
                                    ),
                                    CircleAvatar(
                                      backgroundImage:
                                          product.storeLogo.isEmpty
                                              ? const AssetImage(
                                                    '${AssetsImageIcon.assetPath}/default_logo.jpg',
                                                  )
                                                  as ImageProvider
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
                            }).toList(),
                      );
                    }).toList(),
              ),
    );
  }
}

Future<void> generateInvoicePdf(BuildContext context, HistoryData item) async {
  final pdf = pw.Document();
  final transactionItem = item.transactionItems.first;
  final product = transactionItem.product;
  final storeName = product.nameStore;
  final date = DateFormat(
    'EEEE, dd MMMM yyyy - HH:mm',
    'id_ID',
  ).format(item.createdAt.toLocal());
  final price = double.parse(product.price);
  final total = price * transactionItem.quantity;
  final invoiceNumber =
      'INV-${item.id}-${item.createdAt.millisecondsSinceEpoch}';
  final currencyFormat = NumberFormat.decimalPattern('id');

  pdf.addPage(
    pw.Page(
      pageFormat: PdfPageFormat.a4,
      build: (pw.Context context) {
        return pw.Padding(
          padding: const pw.EdgeInsets.all(32),
          child: pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              // Header
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Text(
                        storeName,
                        style: pw.TextStyle(
                          fontSize: 24,
                          fontWeight: pw.FontWeight.bold,
                        ),
                      ),
                      pw.SizedBox(height: 4),
                      pw.Text(
                        'Invoice #: $invoiceNumber',
                        style: pw.TextStyle(fontSize: 12),
                      ),
                      pw.Text(
                        'Tanggal: $date',
                        style: pw.TextStyle(fontSize: 12),
                      ),
                    ],
                  ),
                  pw.Container(
                    padding: const pw.EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    decoration: pw.BoxDecoration(
                      border: pw.Border.all(color: PdfColors.green, width: 2),
                      borderRadius: pw.BorderRadius.circular(8),
                    ),
                    child: pw.Text(
                      'LUNAS',
                      style: pw.TextStyle(
                        color: PdfColors.green,
                        fontWeight: pw.FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                  ),
                ],
              ),

              pw.SizedBox(height: 20),
              pw.Divider(),

              // Table Header
              pw.SizedBox(height: 16),
              pw.Text(
                'Detail Pembelian',
                style: pw.TextStyle(
                  fontSize: 16,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
              pw.SizedBox(height: 8),

              pw.TableHelper.fromTextArray(
                headers: ['Produk', 'Qty', 'Harga Satuan', 'Subtotal'],
                data: [
                  [
                    product.nameProduct,
                    '${transactionItem.quantity}',
                    'Rp ${currencyFormat.format(price)}',
                    'Rp ${currencyFormat.format(total)}',
                  ],
                ],
                headerStyle: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                headerDecoration: pw.BoxDecoration(color: PdfColors.grey300),
                cellAlignment: pw.Alignment.centerLeft,
                cellHeight: 30,
                columnWidths: {
                  0: const pw.FlexColumnWidth(3),
                  1: const pw.FlexColumnWidth(1),
                  2: const pw.FlexColumnWidth(2),
                  3: const pw.FlexColumnWidth(2),
                },
              ),

              // Total
              pw.SizedBox(height: 16),
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.end,
                children: [
                  pw.Container(
                    padding: const pw.EdgeInsets.all(8),
                    decoration: pw.BoxDecoration(
                      border: pw.Border.all(color: PdfColors.black, width: 1),
                    ),
                    child: pw.Text(
                      'Total: Rp ${currencyFormat.format(total)}',
                      style: pw.TextStyle(
                        fontWeight: pw.FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ],
              ),

              // Footer
              pw.Spacer(),
              pw.Divider(),
              pw.Center(
                child: pw.Text(
                  'Terima kasih atas pembelian Anda!',
                  style: pw.TextStyle(
                    fontSize: 12,
                    fontStyle: pw.FontStyle.italic,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    ),
  );

  try {
    final dir = await getTemporaryDirectory();
    final file = File("${dir.path}/$invoiceNumber.pdf");
    await file.writeAsBytes(await pdf.save());

    final result = await OpenFilex.open(file.path);

    if (result.type != ResultType.done) {
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal membuka PDF: ${result.message}')),
      );
    }
  } catch (e) {
    ScaffoldMessenger.of(
      // ignore: use_build_context_synchronously
      context,
    ).showSnackBar(SnackBar(content: Text('Error: $e')));
  }
}
