import 'package:custlr/api/cartAPI.dart';
import 'package:custlr/screen/payment_gateway/payment_gateway.dart';
import 'package:custlr/widget/loading.dart';
import 'package:flutter/material.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class OrderScreen extends StatefulWidget {
  @override
  _OrderScreenState createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {
  List orderList = [];
  List orderItemList = [];

  bool isLoading = true;
  void getOrder() {
    CartAPI.viewOrder().then((value) {
      orderList = value['Orders'];
      orderItemList = value['Order_items'];
      orderList.forEach((dynamic data) {
        data['order_items'] = orderItemList
            .where((element) => element['OrderID'] == data['OrderID'])
            .toList();
      });
      setState(() {
        isLoading = false;
        print(orderList);
      });
    });
  }

  @override
  void initState() {
    super.initState();
    getOrder();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
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
          onTap: () {},
          child: Text(
            'Orders',
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
          ),
        ),
      ),

      body: isLoading
          ? Container(
              child: CustlrLoading.circularLoading(),
            )
          : ListView.builder(
              itemCount: orderList.length,
              itemBuilder: (context, index) {
                return Container(
                  margin: EdgeInsets.all(10),
                  child: Card(
                    child: Container(
                      padding: EdgeInsets.all(10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Order #${orderList[index]['order_no']}',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Container(
                              decoration: BoxDecoration(
                                  color: Color(0xFFf89810),
                                  borderRadius: BorderRadius.circular(5)),
                              margin: EdgeInsets.symmetric(vertical: 5),
                              padding: EdgeInsets.symmetric(
                                  horizontal: 7, vertical: 5),
                              child: Text('${orderList[index]['status']}')),
                          Text('Placed on ${orderList[index]['date']}'),
                          Divider(
                            thickness: 2,
                          ),
                          Column(
                            children: List.generate(
                                orderList[index]['order_items'].length, (i) {
                              return Container(
                                padding: EdgeInsets.symmetric(vertical: 5),
                                child: Row(
                                  children: [
                                    Image.network(
                                      'https://${orderList[index]['order_items'][i]['product_image']}',
                                      height: 100,
                                      width: 100,
                                      fit: BoxFit.cover,
                                      alignment: Alignment.topCenter,
                                    ),
                                    SizedBox(width: 10),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            '${orderList[index]['order_items'][i]['product_name']}',
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold),
                                          ),
                                          SizedBox(
                                            height: 10,
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                  'MYR ${orderList[index]['order_items'][i]['price']}  X  ${orderList[index]['order_items'][i]['quantity']}'),
                                              Text(
                                                  ' MYR ${orderList[index]['order_items'][i]['total_price']}')
                                            ],
                                          ),
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                              );
                            }),
                          ),
                          Divider(
                            thickness: 2,
                          ),
                          Container(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                orderList[index]['status'] != 'Payment Pending'
                                    ? Container()
                                    : GestureDetector(
                                        onTap: () {
                                          CustlrLoading.showLoaderDialog(
                                              context);
                                          CartAPI.continuePayment(
                                                  orderList[index]['OrderID'])
                                              .then((value) async {
                                            CustlrLoading.hideLoaderDialog(
                                                context);
                                            bool data = await Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        PaymentGateway(
                                                            value['url'])));
                                            if (data = true) {
                                              setState(() {
                                                getOrder();
                                              });
                                            }
                                          });
                                        },
                                        child: Container(
                                          padding: EdgeInsets.symmetric(
                                              vertical: 5, horizontal: 10),
                                          decoration: BoxDecoration(
                                              color: Color(0xFF17a2b8),
                                              borderRadius:
                                                  BorderRadius.circular(5)),
                                          child: Text(
                                            'Continue Payment',
                                            style:
                                                TextStyle(color: Colors.white),
                                          ),
                                        ),
                                      ),
                                Text(
                                    'Total: MYR ${orderList[index]['total_amount']}'),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                );
              }),
      // body: isLoading
      //     ? Container(
      //         child: CustlrLoading.circularLoading(),
      //       )
      //     : ListView.builder(
      //         itemCount: orderList.length,
      //         itemBuilder: (context, index) {
      //           return GestureDetector(
      //             onTap: () {
      //               Alert(
      //                   context: context,
      //                   title: "${orderList[index]['product_name']}",
      //                   content: Column(
      //                     crossAxisAlignment: CrossAxisAlignment.start,
      //                     children: [
      //                       SizedBox(
      //                         height: 10,
      //                       ),
      //                       Text(
      //                           'Total Price: RM ${orderList[index]['total_amount']}'),
      //                       SizedBox(
      //                         height: 10,
      //                       ),
      //                       Text(
      //                         'Chest:      ${orderList[index]['chest']} ➡ ${orderList[index]['chest_dress']}',
      //                       ),
      //                       Text(
      //                         'Shoulder: ${orderList[index]['shoulder']} ➡ ${orderList[index]['shoulder_dress']}',
      //                       ),
      //                       Text(
      //                         'Bicep:       ${orderList[index]['bicep']} ➡ ${orderList[index]['bicep_dress']}',
      //                       ),
      //                       Text(
      //                         'Waist:       ${orderList[index]['waist']} ➡ ${orderList[index]['waist_dress']}',
      //                       ),
      //                       Text(
      //                         'Unit:          ${orderList[index]['unit']}',
      //                       ),
      //                     ],
      //                   )).show();
      //             },

      //             child: Container(
      //               margin: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
      //               child: Card(
      //                 child: Row(
      //                   children: [
      //                     Expanded(
      //                       child: Image.network(
      //                         'https://${orderList[index]['product_image']}',
      //                         height: 100,
      //                         alignment: Alignment.topCenter,
      //                         fit: BoxFit.cover,
      //                       ),
      //                     ),
      //                     Expanded(
      //                       flex: 3,
      //                       child: Container(
      //                         padding: EdgeInsets.all(20),
      //                         child: Column(
      //                           crossAxisAlignment: CrossAxisAlignment.start,
      //                           children: [
      //                             Text('Payment Pending'),
      //                             SizedBox(
      //                               height: 5,
      //                             ),
      //                             Text(
      //                               '${orderList[index]['product_name']}',
      //                               style:
      //                                   TextStyle(fontWeight: FontWeight.bold),
      //                             ),
      //                             SizedBox(
      //                               height: 5,
      //                             ),
      //                             Row(
      //                               mainAxisAlignment:
      //                                   MainAxisAlignment.spaceBetween,
      //                               children: [
      //                                 Text(
      //                                     '${orderList[index]['price']} X ${orderList[index]['quantity']}'),
      //                                 Text(
      //                                   '${orderList[index]['total_price']}',
      //                                   style: TextStyle(
      //                                       fontWeight: FontWeight.bold),
      //                                 ),
      //                               ],
      //                             )
      //                           ],
      //                         ),
      //                       ),
      //                     ),
      //                   ],
      //                 ),
      //               ),
      //             ),
      //             // child: ListTile(
      //           );
      //         },
      //       ),
    );
  }
}

/*

import 'package:custlr/api/cartAPI.dart';
import 'package:flutter/material.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class OrderScreen extends StatefulWidget {
  @override
  _OrderScreenState createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {
  List orderList = [];
  bool isLoading = true;
  void getOrder() {
    CartAPI.viewOrder().then((value) {
      orderList = value['Order_items'];
      setState(() {});
    });
  }

  @override
  void initState() {
    super.initState();
    getOrder();
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
          onTap: () {},
          child: Text(
            'Orders',
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
          ),
        ),
      ),
      body: ListView.builder(
        itemCount: orderList.length,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              Alert(
                  context: context,
                  title: "${orderList[index]['product_name']}",
                  content: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                          'Total Price: RM ${orderList[index]['total_amount']}'),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        'Chest:      ${orderList[index]['chest']} ➡ ${orderList[index]['chest_dress']}',
                      ),
                      Text(
                        'Shoulder: ${orderList[index]['shoulder']} ➡ ${orderList[index]['shoulder_dress']}',
                      ),
                      Text(
                        'Bicep:       ${orderList[index]['bicep']} ➡ ${orderList[index]['bicep_dress']}',
                      ),
                      Text(
                        'Waist:       ${orderList[index]['waist']} ➡ ${orderList[index]['waist_dress']}',
                      ),
                      Text(
                        'Unit:          ${orderList[index]['unit']}',
                      ),
                    ],
                  )).show();
            },

            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
              child: Card(
                child: Row(
                  children: [
                    Expanded(
                      child: Image.network(
                        'https://${orderList[index]['product_image']}',
                        height: 100,
                        alignment: Alignment.topCenter,
                        fit: BoxFit.cover,
                      ),
                    ),
                    Expanded(
                      flex: 3,
                      child: Container(
                        padding: EdgeInsets.all(20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Payment Pending'),
                            SizedBox(
                              height: 5,
                            ),
                            Text(
                              '${orderList[index]['product_name']}',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                    '${orderList[index]['price']} X ${orderList[index]['quantity']}'),
                                Text(
                                  '${orderList[index]['total_price']}',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            // child: ListTile(
          );
        },
      ),
    );
  }
}
*/
