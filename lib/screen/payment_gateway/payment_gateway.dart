import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:io';
import 'package:webview_flutter/webview_flutter.dart';

class PaymentGateway extends StatefulWidget {
  PaymentGateway(this.url);
  final String url;
  @override
  _PaymentGatewayState createState() => _PaymentGatewayState();
}

class _PaymentGatewayState extends State<PaymentGateway> {
  num stackToView = 1;
  void _handleLoad(String value) {
    setState(() {
      stackToView = 0;
    });
  }

  final Completer<WebViewController> _controller =
      Completer<WebViewController>();

  double progress = 0;
  @override
  void initState() {
    super.initState();

    if (Platform.isAndroid) WebView.platform = SurfaceAndroidWebView();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: Icon(
            Icons.keyboard_arrow_left,
            size: 30,
            color: Colors.black,
          ),
        ),
        title: Text(
          "Payment Gateway",
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: Builder(builder: (BuildContext context) {
        return IndexedStack(
          index: stackToView,
          children: [
            WebView(
              initialUrl: widget.url,
              javascriptMode: JavascriptMode.unrestricted,
              onWebViewCreated: (WebViewController webViewController) {
                _controller.complete(webViewController);
              },
              // onPageStarted: (String url) async {
              //   setState(() {
              //     if (url.startsWith(
              //         'http://bestweb.my/homes_harmony/payment/ipay_response')) {
              //       Fluttertoast.showToast(msg: 'Successful Payment');

              //       // Navigator.of(context).pushAndRemoveUntil(
              //       //     MaterialPageRoute(builder: (context) => AfterPayment()),
              //       //     (Route<dynamic> route) => false);
              //     }
              //   });
              // },
              onPageFinished: _handleLoad,
              gestureNavigationEnabled: true,
            ),
            Container(
              color: Colors.white,
              child: Center(
                child: CircularProgressIndicator(),
              ),
            ),
          ],
        );
      }),
    );
  }
}
