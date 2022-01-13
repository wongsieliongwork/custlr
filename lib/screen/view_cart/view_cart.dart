import 'package:cached_network_image/cached_network_image.dart';
import 'package:custlr/api/addressAPI.dart';
import 'package:custlr/api/cartAPI.dart';
import 'package:custlr/model/measurementModel.dart';
import 'package:custlr/provider/Measurement.dart';
import 'package:custlr/provider/viewcartProvider.dart';
import 'package:custlr/screen/drawer/my_addresses.dart';
import 'package:custlr/screen/get_fitted/body_measurement.dart';
import 'package:custlr/screen/payment_gateway/payment_gateway.dart';
import 'package:custlr/screen/product_detail/product_detail.dart';
import 'package:custlr/screen/view_cart/address_widget.dart';
import 'package:custlr/screen/view_cart/cart_widget.dart';
import 'package:custlr/screen/view_cart/checkout_widget.dart';
import 'package:custlr/widget/loading.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class ViewCart extends StatefulWidget {
  @override
  _ViewCartState createState() => _ViewCartState();
}

class _ViewCartState extends State<ViewCart> {
  final registerCoupon = TextEditingController();
  // List<bool> isChecked;

  List cartList = [];
  List addressList = [];

  bool isLoading = true;
  String addressData;
  void getCartAPI() {
    CartAPI.viewCart().then((value) {
      setState(() {
        isLoading = false;
        cartList = value['cartItem'];
        // isChecked = List<bool>.filled(cartList.length, false);
      });
    });
    AddressAPI.addressListAPI().then((value) {
      setState(() {
        addressList = value['User_address'];
        addressData = """<div>
<p><b>Shipping Detail</b></p>
${addressList[0]['shipping_address'] ?? ''}
${addressList[0]['shipping_code'] ?? ''}
${addressList[0]['shipping_state'] ?? ''}
+6${addressList[0]['shipping_contactno'] ?? ''}

<p><b>Billing Detail</b></p>
${addressList[0]['billing_address'] ?? ''}
${addressList[0]['billing_code'] ?? ''}
${addressList[0]['billing_state'] ?? ''}
+6${addressList[0]['billing_contactno'] ?? ''}

<b>${addressList[0]['address_same'] == 0 ? '' : 'Same as Shipping address'}</b>
                                                </div>""";
      });
    });
  }

  double get sumTotalAmount {
    var total = 0.0;
    cartList.forEach((element) {
      total += element['quantity'] * double.parse(element['price']);
    });
    return total;
  }

  void onTapProduct(int index) {
    MeasurementModel ownbodyMeasurement = MeasurementModel(
        gender: cartList[index]['gender'],
        height: cartList[index]['height'].toString(),
        chest: cartList[index]['chest'],
        shoulder: cartList[index]['shoulder'],
        armLength: cartList[index]['arm_length'],
        bicep: cartList[index]['bicep'],
        waist: cartList[index]['waist'],
        hip: cartList[index]['hip'],
        dressLength: cartList[index]['dress_length'],
        review: cartList[index]['review']);

    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) =>
                BodyMeasurement(data: ownbodyMeasurement, isCart: true)));
  }

  @override
  void initState() {
    super.initState();
    getCartAPI();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: GestureDetector(
            onTap: () {
              Navigator.pop(context, true);
            },
            child: Icon(
              Icons.keyboard_arrow_left,
              size: 40,
            )),
        title: GestureDetector(
          onTap: () {
            print(cartList);
          },
          child: Text(
            'Cart',
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
          ),
        ),
      ),
      body: Stack(
        children: [
          Container(
              color: Colors.grey[200],
              child: isLoading
                  ? Container(
                      child: CustlrLoading.circularLoading(),
                    )
                  : cartList.isEmpty
                      ? Container(
                          child: Center(child: Text('Empty')),
                        )
                      : ListView(
                          children: [
                            SizedBox(
                              height: 10,
                            ),
                            // Address Widget
                            AddressWidget(
                              addressData: addressData,
                              addressList: addressList,
                              onChanged: () {
                                setState(() {
                                  getCartAPI();
                                });
                              },
                            ),

                            // View Cart
                            CartWidget(
                              cartList: cartList,
                              onChanged: () {
                                setState(() {});
                              },
                            ),
                            SizedBox(
                              height: 80,
                            )
                          ],
                        )),
          Align(
            alignment: Alignment.bottomCenter,
            child: CheckoutWidget(
              cartList: cartList,
              addressList: addressList,
              getCart: () => getCartAPI(),
            ),
          ),
        ],
      ),
    );
  }

// Add number of product
  void increaseItem(List cartList, int index) {
    setState(() {
      final data = {
        'CartID': cartList[index]['CartID'],
        'quantity': (cartList[index]['quantity'] + 1).toString(),
      };

      // add api
      CartAPI.editCart(data);

      cartList[index]['quantity'] = cartList[index]['quantity'] + 1;
    });
  }

// Deduct number of product
  void decreaseItem(List cartList, int index) {
    print(index);
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
                setState(() {
                  cartList.removeAt(index);
                });
              },
              child: Text(
                "YES",
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
            )
          ]).show();
    } else {
      setState(() {
        final data = {
          'CartID': cartList[index]['CartID'],
          'quantity': (cartList[index]['quantity'] - 1).toString(),
        };
        // decrease api
        CartAPI.editCart(data);

        cartList[index]['quantity'] = cartList[index]['quantity'] - 1;
      });
    }
  }
}
/*
import 'package:custlr/api/cartAPI.dart';
import 'package:custlr/provider/Measurement.dart';
import 'package:custlr/provider/viewcartProvider.dart';
import 'package:custlr/screen/get_fitted/body_measurement.dart';
import 'package:custlr/screen/payment_gateway/payment_gateway.dart';
import 'package:custlr/widget/loading.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';

class ViewCart extends StatefulWidget {
  @override
  _ViewCartState createState() => _ViewCartState();
}

class _ViewCartState extends State<ViewCart> {
  List<bool> isChecked;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    List cartList =
        Provider.of<ViewCartProvider>(context, listen: false).cartList;
    isChecked = List<bool>.filled(cartList.length, false);
  }

  @override
  Widget build(BuildContext context) {
    // Provider From ViewCart
    final dataViewCart = Provider.of<ViewCartProvider>(context);
    final dataMeasurement = Provider.of<Measurement>(context);
    List cartList = dataViewCart.cartList;
    return Scaffold(
      appBar: AppBar(
        leading: GestureDetector(
            onTap: () {
              Navigator.pop(context, true);
            },
            child: Icon(
              Icons.keyboard_arrow_left,
              size: 40,
            )),
        title: GestureDetector(
          onTap: () {
            print(dataViewCart.cartLength);
          },
          child: Text(
            'Cart',
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
          ),
        ),
      ),
      body: Stack(
        children: [
          Container(
            color: Colors.grey[200],
            child: cartList.isEmpty
                ? Container(
                    child: Center(child: Text('Empty')),
                  )
                : ListView.builder(
                    itemCount: cartList.length + 1,
                    itemBuilder: (context, index) {
                      if (index == cartList.length) {
                        return Container(
                          height: 100,
                        );
                      }
                      return Row(
                        children: [
                          // Checkbox(
                          //     value: isChecked[index],
                          //     onChanged: (value) {
                          //       setState(() {
                          //         isChecked[index] = !isChecked[index];
                          //         print(value);
                          //       });
                          //     }),
                          Expanded(
                            child: GestureDetector(
                              onTap: () {
                                dataMeasurement.data = cartList[index];
                                dataMeasurement.remarks = '';
                                dataMeasurement.bodyPattern.clear();
                                dataMeasurement.getProductElement(
                                    cartList[index]['ProductID']);

                                dynamic ownbodyMeasurement = {
                                  'chest': cartList[index]['chest'],
                                  'shoulder': cartList[index]['shoulder'],
                                  'arm_length': cartList[index]
                                      ['arm_length'],
                                  'bicep': cartList[index]['bicep'],
                                  'waist': cartList[index]['ProductID'],
                                };
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => BodyMeasurement(
                                            ownbodyMeasurement, false, true)));

                                // Alert(
                                //     context: context,
                                //     title: "${cartList[index]['product_name']}",
                                //     content: Column(
                                //       crossAxisAlignment: CrossAxisAlignment.start,
                                //       children: [
                                //         SizedBox(
                                //           height: 10,
                                //         ),
                                //         Text(
                                //             'Total Price: RM ${cartList[index]['total_amount']}'),
                                //         SizedBox(
                                //           height: 10,
                                //         ),
                                //         Text(
                                //           'Chest:      ${cartList[index]['chest']} ➡ ${cartList[index]['chest_dress']}',
                                //         ),
                                //         Text(
                                //           'Shoulder: ${cartList[index]['shoulder']} ➡ ${cartList[index]['shoulder_dress']}',
                                //         ),
                                //         Text(
                                //           'Bicep:       ${cartList[index]['bicep']} ➡ ${cartList[index]['bicep_dress']}',
                                //         ),
                                //         Text(
                                //           'Waist:       ${cartList[index]['waist']} ➡ ${cartList[index]['waist_dress']}',
                                //         ),
                                //         Text(
                                //           'Unit:          ${cartList[index]['unit']}',
                                //         ),
                                //       ],
                                //     )).show();
                              },

                              child: Container(
                                margin: EdgeInsets.symmetric(
                                    horizontal: 15, vertical: 5),
                                child: Dismissible(
                                  key: Key(cartList[index]['product_name']),
                                  background: Container(
                                    color: Colors.red,
                                  ),
                                  onDismissed: (DismissDirection direction) {
                                    setState(() {
                                      CartAPI.removeCart(
                                          cartList[index]['CartID']);
                                      cartList.removeAt(index);
                                    });
                                  },
                                  child: Card(
                                    child: Row(
                                      children: [
                                        Expanded(
                                          child: Image.network(
                                            'https://${cartList[index]['product_image']}',
                                            height: 100,
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                        Expanded(
                                          flex: 2,
                                          child: Container(
                                            padding: EdgeInsets.only(left: 20),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  '${cartList[index]['product_name']}',
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                                Text('MYR ' +
                                                    dataViewCart
                                                        .eachTotal(index)
                                                        .toString()),
                                              ],
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                            flex: 2,
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                MaterialButton(
                                                    minWidth: 10.0,
                                                    height: 30.0,
                                                    onPressed: () =>
                                                        decreaseItem(
                                                            cartList,
                                                            index,
                                                            dataViewCart),
                                                    shape: CircleBorder(),
                                                    color: Colors.grey[200],
                                                    child: Icon(Icons.remove)),
                                                Text(
                                                  '${cartList[index]['quantity']}',
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 20),
                                                ),
                                                MaterialButton(
                                                    minWidth: 10.0,
                                                    height: 30.0,
                                                    onPressed: () =>
                                                        increaseItem(
                                                            cartList,
                                                            index,
                                                            dataViewCart),
                                                    shape: CircleBorder(),
                                                    color: Colors.grey[200],
                                                    child: Icon(Icons.add)),
                                              ],
                                            ))
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              // child: ListTile(
                            ),
                          ),
                        ],
                      );
                    },
                  ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 15),
              color: Colors.white,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
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
                        'MYR ${dataViewCart.sumTotalAmount}',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 20),
                      ),
                    ],
                  ),
                  InkWell(
                    highlightColor: Colors.transparent,
                    splashColor: Colors.transparent,
                    onTap: () {
                      if (dataViewCart.cartLength == 0) {
                        Fluttertoast.showToast(
                            msg: 'Cart is Empty', gravity: ToastGravity.CENTER);
                      } else {
                        CustlrLoading.showLoaderDialog(context);
                        CartAPI.gateway(dataViewCart.sumTotalAmount)
                            .then((value) async {
                          CustlrLoading.hideLoaderDialog(context);
                          dataViewCart.getViewCartAPI();
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      PaymentGateway(value['url'])));
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
            ),
          ),
        ],
      ),
    );
  }

// Add number of product
  void increaseItem(List cartList, int index, final dataViewCart) {
    final data = {
      'CartID': cartList[index]['CartID'],
      'quantity': (cartList[index]['quantity'] + 1).toString(),
    };

    // add api
    CartAPI.editCart(data);

    // add provider
    dataViewCart.increaseProduct(index);
  }

// Deduct number of product
  void decreaseItem(List cartList, int index, final dataViewCart) {
    if (index == 1) {
    } else {
      final data = {
        'CartID': cartList[index]['CartID'],
        'quantity': (cartList[index]['quantity'] - 1).toString(),
      };
      // decrease api
      CartAPI.editCart(data);

      // decrease provider
      dataViewCart.decreaseProduct(index, context);
    }
  }
}
*/
