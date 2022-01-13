import 'package:custlr/api/cartAPI.dart';
import 'package:custlr/screen/payment_gateway/payment_gateway.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class CheckoutWidget extends StatefulWidget {
  final List cartList;
  final List addressList;
  final Function getCart;
  CheckoutWidget({
    this.cartList,
    this.addressList,
    this.getCart,
  });

  @override
  _CheckoutWidgetState createState() => _CheckoutWidgetState();
}

class _CheckoutWidgetState extends State<CheckoutWidget> {
  final registerCoupon = TextEditingController();
  double get sumTotalAmount {
    var total = 0.0;
    widget.cartList.forEach((element) {
      total += element['quantity'] * double.parse(element['price']);
    });
    return total;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.symmetric(vertical: 15, horizontal: 25),
        color: Colors.white,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Total',
                      style: TextStyle(
                          color: Colors.grey, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      'MYR $sumTotalAmount',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                    ),
                  ],
                ),
                InkWell(
                  highlightColor: Colors.transparent,
                  splashColor: Colors.transparent,
                  onTap: () {
                    if (widget.cartList.isEmpty) {
                      Fluttertoast.showToast(
                          msg: 'Cart is Empty', gravity: ToastGravity.CENTER);
                    } else if (widget.addressList.isEmpty) {
                      Fluttertoast.showToast(
                          msg: 'No address yet', gravity: ToastGravity.CENTER);
                    } else {
                      CartAPI.gateway(sumTotalAmount).then((value) async {
                        bool data = await Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => PaymentGateway(
                                    value['url']
                                        .toString()
                                        .replaceAll(" ", "+"))));

                        if (data = true) {
                          setState(() {
                            widget.getCart();
                          });
                        }
                      });
                    }
                  },
                  child: PhysicalModel(
                    borderRadius: BorderRadius.circular(20),
                    shadowColor: Colors.grey,
                    elevation: 2,
                    color: Colors.redAccent,
                    child: Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                      child: Text(
                        'Checkout',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                )
              ],
            ),
            SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Voucher Discount'),
                Container(
                  height: 40,
                  width: 200,
                  child: TextField(
                    textAlign: TextAlign.center,
                    controller: registerCoupon,
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                        contentPadding: const EdgeInsets.all(0),
                        hintText: 'Coupon Code',
                        hintStyle: TextStyle(fontSize: 16),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                          borderSide: BorderSide(
                            color: Colors.grey,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                          borderSide: BorderSide(
                            color: Colors.grey,
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                          borderSide: BorderSide(
                            color: Colors.grey,
                          ),
                        ),
                        filled: true,
                        fillColor: Colors.white,
                        suffixIcon: Container(
                          margin: EdgeInsets.all(4),
                          child: CircleAvatar(
                            backgroundColor: Colors.grey,
                            radius: 20,
                            child: IconButton(
                              padding: EdgeInsets.zero,
                              icon: Icon(Icons.done),
                              color: Colors.white,
                              onPressed: () {
                                final data = {
                                  'code': registerCoupon.text,
                                  'amount': '$sumTotalAmount',
                                };
                                print(data);
                                registerCoupon.clear();
                                CartAPI.registerCoupon(data).then((value) {
                                  Fluttertoast.showToast(msg: value['msg']);
                                });
                              },
                            ),
                          ),
                        )),
                  ),
                ),
              ],
            ),
          ],
        ));
  }
}
