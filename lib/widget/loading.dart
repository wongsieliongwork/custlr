import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class CustlrLoading {
  static showLoaderDialog(BuildContext context) {
    showDialog(
      // True can pop, false cannot pop
      barrierDismissible: true,
      barrierColor: Colors.white,
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          elevation: 0,
          backgroundColor: Colors.transparent,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'assets/images/black-logo.png',
                scale: 1,
              ),
              // FadeTransitionLogo(),
              SizedBox(
                height: 10,
              ),
              SpinKitFadingCircle(color: Colors.black)
            ],
          ),
        );
      },
    );
  }

  static hideLoaderDialog(BuildContext context) {
    Navigator.pop(context);
  }

  static circularLoading() {
    return Container(
      child: SpinKitFadingCircle(
        color: Colors.black,
        size: 50.0,
      ),
    );
  }

  static whiteCircularLoading() {
    return Container(
      child: SpinKitFadingCircle(
        color: Colors.white,
        size: 50.0,
      ),
    );
  }
}
