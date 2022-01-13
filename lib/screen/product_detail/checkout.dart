import 'package:cached_network_image/cached_network_image.dart';
import 'package:custlr/api/cartAPI.dart';
import 'package:custlr/widget/showDialog.dart';
import 'package:custlr/utils/constants.dart';
import 'package:custlr/provider/ShoppingPageProvider.dart';
import 'package:custlr/provider/Measurement.dart';
import 'package:custlr/provider/viewcartProvider.dart';
import 'package:custlr/screen/MainTabBar/main_tab_bar.dart';
import 'package:custlr/screen/auth/login_register.dart';
import 'package:custlr/screen/shopping_screen/shopping_screen.dart';
import 'package:custlr/screen/payment_gateway/payment_gateway.dart';
import 'package:custlr/screen/view_cart/view_cart.dart';
import 'package:custlr/utils/shared_preference_utils.dart';
import 'package:custlr/widget/loading.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dio/dio.dart' as dio;
import 'package:path/path.dart';

class Checkout extends StatefulWidget {
  Checkout(this.onChanged);
  final Function(int) onChanged;
  @override
  _CheckoutState createState() => _CheckoutState();
}

class _CheckoutState extends State<Checkout> {
  bool isLoading = false;
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final dataMeasurement = Provider.of<Measurement>(context);
    final dataViewCart = Provider.of<ViewCartProvider>(context);
    final dataHome = Provider.of<ShoppingPageProvider>(context);
    final measureList = dataMeasurement.bodyMeasurement;
    final data = dataMeasurement.data;
    Map bodyPattern = dataMeasurement.bodyPattern;
    return Stack(
      children: [
        ListView(
          children: [
            Row(
              children: [
                GestureDetector(
                  onTap: () {
                    widget.onChanged(1);
                  },
                  child: Icon(
                    Icons.keyboard_arrow_left,
                    size: 40,
                  ),
                ),
                Expanded(
                    child: Text(
                  'Product Summary',
                  textAlign: TextAlign.center,
                )),
              ],
            ),
            ListView(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              children: [
                Container(
                  padding: EdgeInsets.all(20),
                  child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Image.network(
                          data['banner'],
                          height: 100,
                          width: 100,
                          alignment: Alignment.topCenter,
                          fit: BoxFit.cover,
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('${data['product_name']}'),
                              SizedBox(
                                height: 10,
                              ),
                              Text(
                                'RM ${data['promotions_discount'] == null ? data['price'] : data['promotions_price']} ' +
                                    '(${dataMeasurement.isA4Fit ? "A4 Fit" : dataMeasurement.isDressingMeasurement ? "Dressing  Measurement" : "Body Measurement"})',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        )
                      ]),
                ),
                bodyPattern.values.toList().isEmpty
                    ? Container()
                    : Divider(
                        thickness: 10,
                      ),
                bodyPattern.values.toList().isEmpty
                    ? Container()
                    : Container(
                        padding: EdgeInsets.all(10),
                        child: GestureDetector(
                          onTap: () {
                            print(bodyPattern.values.toList()[1]['image']);
                          },
                          child: Text(
                            'STYLING SUMMARY',
                          ),
                        )),
                bodyPattern.values.toList().isEmpty
                    ? Container()
                    : Container(
                        padding: EdgeInsets.symmetric(horizontal: 10),
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: List.generate(
                                5,
                                (index) => Container(
                                      height: 100,
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          CachedNetworkImage(
                                            imageUrl: bodyPattern.values
                                                .toList()[index]['image'],
                                            placeholder: (context, url) =>
                                                Container(
                                              color: Colors.white,
                                            ),
                                            errorWidget:
                                                (context, url, error) =>
                                                    Container(
                                              color: Colors.white,
                                              child: Image.asset(
                                                  'assets/images/placeholder-image.png'),
                                            ),
                                            height: 50,
                                            width: 50,
                                          ),
                                          // Image.network(
                                          //   bodyPattern.values
                                          //       .toList()[index]['image']
                                          //       .toString()
                                          //       .replaceAll(
                                          //         'product',
                                          //         'products',
                                          //       ),
                                          //   scale: 30,
                                          // ),
                                          Container(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  bodyPattern.values
                                                      .toList()[index]['name'],
                                                  style:
                                                      TextStyle(fontSize: 12),
                                                ),
                                                Text(
                                                  bodyPattern.keys
                                                      .toList()[index]
                                                      .toString(),
                                                  style: TextStyle(
                                                      color: Colors.grey,
                                                      fontSize: 12),
                                                ),
                                              ],
                                            ),
                                          )
                                        ],
                                      ),
                                    ))),
                      ),
                // Column(
                //     children: List.generate(
                //         bodyPattern.length,
                //         (index) => Container(
                //               child: ListTile(
                //                 leading: Image.network(Custlr.imgUrl +
                //                     bodyPattern.values
                //                         .toList()[index]['image']
                //                         .toString()
                //                         .replaceAll('product', 'products')),
                //                 title: Text(bodyPattern.keys
                //                     .toList()[index]
                //                     .toString()),
                //                 subtitle: Text(
                //                     bodyPattern.values.toList()[index]['name']),
                //               ),
                //             ))),
                Divider(),
                dataMeasurement.remarks == ""
                    ? Container()
                    : ListTile(
                        title: Text('Remarks'),
                        subtitle: Text(dataMeasurement.remarks),
                      ),
                Divider(
                  thickness: 10,
                ),
                SizedBox(
                  height: 10,
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'MEASUREMENTS SUMMARY',
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      GestureDetector(
                        onTap: () => ShowDialog().theDifference(context),
                        child: Text(
                          "What's the difference?",
                          style: TextStyle(color: Colors.blue),
                        ),
                      ),
                    ],
                  ),
                ),
                // If isA4 Fit
                dataMeasurement.isA4Fit
                    ? Container(
                        padding: EdgeInsets.all(10),
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                  '${measureList[0]['name']}: ${measureList[0]['final']} cm'),
                              Text(
                                  '${measureList[1]['name']}: ${measureList[1]['final']} kg'),
                              SizedBox(
                                height: 20,
                              ),
                              Row(
                                children: [
                                  Expanded(
                                    child: Column(
                                      children: [
                                        Text(measureList[2]['name']),
                                        Container(
                                          padding: EdgeInsets.all(10),
                                          child: Image.file(
                                            measureList[2]['final'],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Expanded(
                                    child: Column(
                                      children: [
                                        Text(measureList[3]['name']),
                                        Container(
                                          padding: EdgeInsets.all(10),
                                          child: Image.file(
                                            measureList[3]['final'],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              )
                            ]),
                      )
                    : Column(
                        children: [
                          SizedBox(
                            height: 10,
                          ),
                          Row(
                            children: [
                              Expanded(flex: 2, child: Container()),
                              Expanded(flex: 1, child: Text('Body')),
                              // Expanded(flex: 1, child: Text('Final Product'))
                            ],
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          ListView.separated(
                              physics: NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              itemBuilder: (context, index) {
                                return Container(
                                  child: Row(
                                    children: [
                                      Expanded(
                                          flex: 2,
                                          child: Text(
                                              '  ${measureList[index]['name']}')),
                                      Expanded(
                                          flex: 1,
                                          child: Text(
                                              '${measureList[index]['body']}')),
                                      // Expanded(
                                      //     flex: 1,
                                      //     child: Text(
                                      //         '${measureList[index]['final']}'))
                                    ],
                                  ),
                                );
                              },
                              separatorBuilder: (context, index) {
                                return Divider();
                              },
                              itemCount: measureList.length),
                        ],
                      ),
                Container(
                  height: 100,
                ),
              ],
            ),
          ],
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: GestureDetector(
            onTap: () async {
              setState(() {
                isLoading = true;
              });
              if (SharedPreferencesUtil.isLogIn) {
                if (dataMeasurement.isA4Fit) {
                  final param = {
                    'ProductID': data['ProductID'],
                    'quantity': '1',
                    'height': '${measureList[0]['final']}',
                    'weight': '${measureList[1]['final']}',
                    'front_img': measureList[2]['final'] != null
                        ? await dio.MultipartFile.fromFile(
                            measureList[2]['final'].path,
                            filename: basename(measureList[2]['final'].path))
                        : '',
                    'side_img': measureList[3]['final'] != null
                        ? await dio.MultipartFile.fromFile(
                            measureList[3]['final'].path,
                            filename: basename(measureList[3]['final'].path))
                        : '',
                    'chest': '0',
                    'shoulder': "0",
                    'arm_length': "0",
                    'bicep': "0",
                    'waist': "0",
                    'height_dress': "0",
                    'chest_dress': "0",
                    'shoulder_dress': "0",
                    'arm_length_dress': "0",
                    'bicep_dress': "0",
                    'waist_dress': "0",
                    'unit': 'cm',
                    'collar_patternid': "2",
                    'cuff_patternid': '2',
                    'sleeve_patternid': '2',
                    'fitting_patternid': '2',
                    'chestpocket_patternid': '2',
                    'Image': '${data['banner']}',
                    'review': dataMeasurement.remarks,
                    'method': 'a4',
                    'hip': "0",
                    'dress_length': "0",
                    'hip_dress': "0",
                    'dress_length_dress': "0",
                  };
                  print("Param" + '$param');
                  CartAPI.addToCart(param).then((value) {
                    if (value['status'] == "1") {
                      setState(() {
                        isLoading = false;
                      });

                      // Navigator.of(context).pushAndRemoveUntil(
                      //     MaterialPageRoute(builder: (context) => MainTabBar()),
                      //     (Route<dynamic> route) => false);

                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => ViewCart()));
                      // CustlrLoading.hideLoaderDialog(context);
                      Fluttertoast.showToast(msg: 'Successful');
                    } else {
                      setState(() {
                        isLoading = false;
                      });
                      // CustlrLoading.hideLoaderDialog(context);
                      Fluttertoast.showToast(msg: value['msg']);
                    }
                  });
                } else {
                  print(measureList);
                  final param = {
                    'ProductID': data['ProductID'],
                    'quantity': '1',
                    'height': '${measureList[0]['body']}',
                    'chest': '${measureList[1]['body']}',
                    'shoulder': "${measureList[2]['body']}",
                    'arm_length': "${measureList[3]['body']}",
                    'bicep': "${measureList[5]['body']}",
                    'waist': "${measureList[4]['body']}",
                    'height_dress': '${measureList[0]['final']}',
                    'chest_dress': '${measureList[1]['final']}',
                    'shoulder_dress': '${measureList[2]['final']}',
                    'arm_length_dress': '${measureList[3]['final']}',
                    'bicep_dress': '${measureList[5]['final']}',
                    'waist_dress': '${measureList[4]['final']}',
                    'unit': 'cm',
                    'collar_patternid': "2",
                    'cuff_patternid': '2',
                    'sleeve_patternid': '2',
                    'fitting_patternid': '2',
                    'chestpocket_patternid': '2',
                    'Image': '${data['banner']}',
                    'review': dataMeasurement.remarks,
                    'method': dataMeasurement.isDressingMeasurement ? "d" : "b",
                    if (dataHome.isFemale) 'hip': "${measureList[5]['body']}",
                    if (dataHome.isFemale)
                      'dress_length': "${measureList[6]['body']}",
                    if (dataHome.isFemale)
                      'hip_dress': "${measureList[5]['final']}",
                    if (dataHome.isFemale)
                      'dress_length_dress': "${measureList[6]['final']}",
                  };
                  print("Param" + '$param');
                  CartAPI.addToCart(param).then((value) {
                    if (value['status'] == "1") {
                      setState(() {
                        isLoading = false;
                      });

                      // Navigator.of(context).pushAndRemoveUntil(
                      //     MaterialPageRoute(builder: (context) => MainTabBar()),
                      //     (Route<dynamic> route) => false);

                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => ViewCart()));
                      // CustlrLoading.hideLoaderDialog(context);
                      Fluttertoast.showToast(msg: 'Successful');
                    } else {
                      setState(() {
                        isLoading = false;
                      });
                      // CustlrLoading.hideLoaderDialog(context);
                      Fluttertoast.showToast(msg: value['msg']);
                    }
                  });
                }
              } else {
                isLoading = false;
                Alert(
                    context: context,
                    title: 'You are the guest\nPlease log in first.',
                    buttons: [
                      DialogButton(
                        child: Text(
                          "LOG IN",
                          style: TextStyle(color: Colors.white, fontSize: 20),
                        ),
                        onPressed: () async {
                          Navigator.pop(context);

                          bool value = await Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => LoginRegister(true)));

                          setState(() {
                            if (value != null) {}
                          });
                        },
                        width: 100,
                      ),
                      DialogButton(
                        child: Text(
                          "HOME",
                          style: TextStyle(color: Colors.white, fontSize: 20),
                        ),
                        onPressed: () {
                          Navigator.pop(context);
                          Navigator.pop(context);
                        },
                        width: 100,
                      ),
                    ]).show();
              }
            },
            child: Container(
              height: 70,
              color: Colors.blue,
              child: isLoading
                  ? Container(
                      child: CustlrLoading.whiteCircularLoading(),
                    )
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.shopping_cart,
                          color: Colors.white,
                        ),
                        Text(
                          'ADD TO CART',
                          style: TextStyle(color: Colors.white),
                        ),
                      ],
                    ),
            ),
          ),
        ),
      ],
    );
  }
}
