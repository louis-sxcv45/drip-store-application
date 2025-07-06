import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class MidtransPaymentScreen extends StatefulWidget {
  final String snapToken;

  const MidtransPaymentScreen({super.key, required this.snapToken});

  @override
  State<MidtransPaymentScreen> createState() => _MidtransPaymentScreenState();
}

class _MidtransPaymentScreenState extends State<MidtransPaymentScreen> {
  late final WebViewController _controller;

  @override
  void initState() {
    super.initState();

    const midtransClientKey = "SB-Mid-client-ERC02LJfMc8UGEkz"; // Ganti sesuai milikmu

    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..addJavaScriptChannel(
        'MidtransChannel',
        onMessageReceived: (JavaScriptMessage message) {
          if (message.message == 'payment_done') {
            Navigator.pop(context, 'payment_done');
          }
        },
      )
      ..loadHtmlString(_htmlContent(widget.snapToken, midtransClientKey));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Pembayaran')),
      body: WebViewWidget(controller: _controller),
    );
  }
}

String _htmlContent(String snapToken, String clientKey) {
  return '''
    <html>
      <head>
        <meta name="viewport" content="width=device-width, initial-scale=1">
        <script type="text/javascript"
          src="https://app.sandbox.midtrans.com/snap/snap.js"
          data-client-key="$clientKey"></script>
      </head>
      <body onload="pay()">
        <script type="text/javascript">
          function pay() {
            snap.pay('$snapToken', {
              onSuccess: function(result){
                MidtransChannel.postMessage('payment_done');
              },
              onPending: function(result){
                console.log('pending');
              },
              onError: function(result){
                console.log('error');
              },
              onClose: function(){
                console.log('popup closed');
              }
            });
          }
        </script>
      </body>
    </html>
  ''';
}
