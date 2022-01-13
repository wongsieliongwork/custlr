import 'package:custlr/api/cartAPI.dart';
import 'package:flutter/material.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class ViewCartProvider extends ChangeNotifier {
  List cartList = [];

  void getViewCartAPI() {
    CartAPI.viewCart().then((value) {
      cartList = value['cartItem'];

      notifyListeners();
    });
  }

  void addCart(dynamic data) {
    cartList.add(data);
    notifyListeners();
  }

  void increaseProduct(int index) {
    cartList[index]['quantity'] = cartList[index]['quantity'] + 1;

    cartList[index]['total_amount'] =
        (double.parse(cartList[index]['total_amount']) +
                double.parse(cartList[index]['price']))
            .toString();
    notifyListeners();
  }

  void decreaseProduct(int index, BuildContext context) {
    if (cartList[index]['quantity'] == 1) {
      Alert(
          context: context,
          title: 'Do you want delete it?',
          type: AlertType.warning,
          buttons: [
            DialogButton(
              onPressed: () {
                CartAPI.removeCart(cartList[index]['CartID']);
                Navigator.pop(context);
                cartList.removeAt(index);

                notifyListeners();
              },
              child: Text(
                "YES",
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
            )
          ]).show();
    } else {
      cartList[index]['quantity'] = cartList[index]['quantity'] - 1;
      cartList[index]['total_amount'] =
          (double.parse(cartList[index]['total_amount']) -
                  double.parse(cartList[index]['price']))
              .toString();
    }

    notifyListeners();
  }

  double eachTotal(int index) {
    var total =
        double.parse(cartList[index]['price']) * cartList[index]['quantity'];
    return total;
  }

  double get sumTotalAmount {
    var total = 0.0;
    cartList.forEach((element) {
      total += element['quantity'] * double.parse(element['price']);
    });
    return total;
  }

  int get cartLength {
    int length = 0;
    length = cartList.length;
    return length;
  }
}
