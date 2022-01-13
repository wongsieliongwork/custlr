import 'package:custlr/api/addressAPI.dart';
import 'package:custlr/screen/drawer/add_edit_addresses.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class MyAddresses extends StatefulWidget {
  @override
  _MyAddressesState createState() => _MyAddressesState();
}

class _MyAddressesState extends State<MyAddresses> {
  int initialIndex = 0;
  List addressList = [];
  bool isLoading = true;

  void getAddressList() {
    AddressAPI.addressListAPI().then((value) {
      addressList = value['User_address'];

      setState(() {
        isLoading = false;
      });
    });
  }

  @override
  void initState() {
    super.initState();
    getAddressList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 2,
        backgroundColor: Colors.white,
        title: Text(
          'My Addresses',
          style: TextStyle(color: Colors.black),
        ),
        leading: GestureDetector(
          onTap: () {
            Navigator.pop(context, true);
          },
          child: Icon(
            Icons.keyboard_arrow_left,
            size: 40,
          ),
        ),
      ),
      body: ListView(
        children: [
          SizedBox(
            height: 10,
          ),
          GestureDetector(
            onTap: () {
              addAddress();
            },
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 10),
              child: DottedBorder(
                color: Colors.blue,
                strokeWidth: 1,
                dashPattern: [
                  5,
                ],
                child: Container(
                  height: 100,
                  child: Center(
                    child: Text(
                      '+ Add Address',
                      style: TextStyle(
                          color: Colors.blue,
                          fontSize: 20,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  color: Colors.lightBlue.shade100.withOpacity(0.3),
                ),
              ),
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Column(
            children: List.generate(addressList.length, (index) {
              final data =
                  """<div><p>Name: ${addressList[index]['receiver_name'] ?? ''}</p>
<p><b>Shipping Detail</b></p>
${addressList[index]['shipping_address'] ?? ''}
${addressList[index]['shipping_code'] ?? ''}
${addressList[index]['shipping_state'] ?? ''}
+6${addressList[index]['shipping_contactno'] ?? ''}

<p><b>Billing Detail</b></p>
${addressList[index]['billing_address'] ?? ''}
${addressList[index]['billing_code'] ?? ''}
${addressList[index]['billing_state'] ?? ''}
+6${addressList[index]['billing_contactno'] ?? ''}

<b>${addressList[index]['address_same'] == 0 ? '' : 'Same as Shipping address' ?? ""}</b>
</div>""";
              return Container(
                  padding: EdgeInsets.all(10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            padding: EdgeInsets.only(top: 12),
                            child: Icon(
                              Icons.room,
                              color: Colors.blue,
                            ),
                          ),
                          Expanded(
                              child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Html(
                                data: data,
                                style: {
                                  "div": Style(
                                    whiteSpace: WhiteSpace.PRE,
                                  ),
                                },
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              index != 0
                                  ? Container()
                                  : Container(
                                      margin: EdgeInsets.only(left: 10),
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 10, vertical: 5),
                                      decoration: BoxDecoration(
                                        border:
                                            Border.all(color: Colors.lightBlue),
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      child: Text(
                                        'Default Shipping address',
                                        style:
                                            TextStyle(color: Colors.lightBlue),
                                      ),
                                    ),
                            ],
                          )),
                          Container(
                            padding: EdgeInsets.only(top: 12),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    editAddress(index);
                                  },
                                  child: Text(
                                    'Edit',
                                    style: TextStyle(
                                      color: Colors.blue,
                                      decoration: TextDecoration.underline,
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                if (index != 0)
                                  GestureDetector(
                                    onTap: () {
                                      deleteAddress(index);
                                    },
                                    child: Text(
                                      'Remove',
                                      style: TextStyle(
                                        color: Colors.blue,
                                        decoration: TextDecoration.underline,
                                      ),
                                    ),
                                  ),
                                SizedBox(
                                  height: 10,
                                ),
                                GestureDetector(
                                  onTap: () {
                                    AddressAPI.defaultAddress(addressList[index]
                                            ['user_address_ID'])
                                        .then((value) {
                                      setState(() {
                                        Fluttertoast.showToast(
                                            msg: value['msg']);
                                        getAddressList();
                                      });
                                    });
                                  },
                                  child: Text(
                                    index == 0 ? '         ' : 'Set Default',
                                    style: TextStyle(
                                      color: Colors.blue,
                                      decoration: index == 0
                                          ? null
                                          : TextDecoration.underline,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Divider(
                        thickness: 1,
                      )
                    ],
                  ));
            }),
          )
        ],
      ),
//       body: Stack(
//         children: [
//           isLoading
//               ? CustlrLoading.whiteCircularLoading()
//               : addressList.isEmpty
//                   ? Container(
//                       child: Center(child: Text('Not Address Yet')),
//                     )
//                   : ListView(
//                       children: [
//                         Container(
//                           padding: EdgeInsets.all(20),
//                           child: ListView.builder(
//                               shrinkWrap: true,
//                               physics: NeverScrollableScrollPhysics(),
//                               itemCount: addressList.length,
//                               itemBuilder: (context, index) {
//                                 final data =
//                                     """<div><p>Name: ${addressList[index]['receiver_name']}</p>
// <p><b>Shipping Detail</b></p>
// ${addressList[index]['shipping_address']}, ${addressList[index]['shipping_code']},
// ${addressList[index]['shipping_state']},
// +6${addressList[index]['shipping_contactno']}

// <p><b>Billing Detail</b></p>
// ${addressList[index]['billing_address']}, ${addressList[index]['billing_code']},
// ${addressList[index]['billing_state']},
// +6${addressList[index]['billing_contactno']}

// <b>${addressList[index]['address_same'] == 0 ? '' : 'Same as Shipping address'}</b>
// </div>""";
//                                 return Container(
//                                   padding: EdgeInsets.only(bottom: 20),
//                                   child: Row(
//                                     children: [
//                                       Radio(
//                                           activeColor: Colors.green,
//                                           value: index,
//                                           groupValue: initialIndex,
//                                           onChanged: (value) {
//                                             setState(() {
//                                               initialIndex = value;
//                                               AddressAPI.defaultAddress(
//                                                       addressList[index]
//                                                           ['user_address_ID'])
//                                                   .then((value) {
//                                                 Fluttertoast.showToast(
//                                                     msg: value['msg']);
//                                               });
//                                             });
//                                           }),
//                                       Expanded(
//                                         child: PhysicalModel(
//                                           borderRadius:
//                                               BorderRadius.circular(20),
//                                           color: Colors.white,
//                                           shadowColor: Colors.black,
//                                           elevation: 5,
//                                           child: Container(
//                                             padding: const EdgeInsets.all(15),
//                                             child: Row(
//                                               mainAxisAlignment:
//                                                   MainAxisAlignment
//                                                       .spaceBetween,
//                                               children: [
//                                                 Expanded(
//                                                   child: Column(
//                                                     crossAxisAlignment:
//                                                         CrossAxisAlignment
//                                                             .start,
//                                                     children: [
//                                                       Html(
//                                                         data: data,
//                                                         style: {
//                                                           "div": Style(
//                                                             whiteSpace:
//                                                                 WhiteSpace.PRE,
//                                                           ),
//                                                         },
//                                                       ),
//                                                     ],
//                                                   ),
//                                                 ),
//                                                 Column(
//                                                   children: [
//                                                     GestureDetector(
//                                                       onTap: () async {
//                                                         editAddress(index);
//                                                       },
//                                                       child: Container(
//                                                           padding:
//                                                               EdgeInsets.all(5),
//                                                           decoration: BoxDecoration(
//                                                               color:
//                                                                   Colors.orange,
//                                                               borderRadius:
//                                                                   BorderRadius
//                                                                       .circular(
//                                                                           10)),
//                                                           child: Icon(
//                                                             Icons.edit,
//                                                             color: Colors.white,
//                                                           )),
//                                                     ),
//                                                     SizedBox(
//                                                       height: 10,
//                                                     ),
//                                                     GestureDetector(
//                                                       onTap: () async {
//                                                         deleteAddress(index);
//                                                       },
//                                                       child: Container(
//                                                           padding:
//                                                               EdgeInsets.all(5),
//                                                           decoration: BoxDecoration(
//                                                               color: Colors.red,
//                                                               borderRadius:
//                                                                   BorderRadius
//                                                                       .circular(
//                                                                           10)),
//                                                           child: Icon(
//                                                             Icons.delete,
//                                                             color: Colors.white,
//                                                           )),
//                                                     ),
//                                                   ],
//                                                 )
//                                               ],
//                                             ),
//                                           ),
//                                         ),
//                                       )
//                                     ],
//                                   ),
//                                 );
//                               }),
//                         ),
//                       ],
//                     ),
//           Align(
//             alignment: Alignment.bottomCenter,
//             child: SafeArea(
//               child: Container(
//                 padding: EdgeInsets.only(bottom: 20),
//                 child: InkWell(
//                   highlightColor: Colors.transparent,
//                   splashColor: Colors.transparent,
//                   onTap: () {
//                     addAddress();
//                   },
//                   child: PhysicalModel(
//                     color: Colors.black,
//                     shadowColor: Colors.grey,
//                     elevation: 5,
//                     borderRadius: BorderRadius.circular(30),
//                     child: Container(
//                       padding:
//                           EdgeInsets.symmetric(vertical: 15, horizontal: 30),
//                       child: Text(
//                         'Add Addresses',
//                         style: TextStyle(color: Colors.white),
//                       ),
//                     ),
//                   ),
//                 ),
//               ),
//             ),
//           ),
//         ],
//       ),
    );
  }

  void addAddress() async {
    bool value = await Navigator.push(context,
        MaterialPageRoute(builder: (context) => AddEditAddresses([], true)));

    if (value == true) {
      setState(() {
        getAddressList();
      });
    }
  }

  void editAddress(int index) async {
    bool value = await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => AddEditAddresses(addressList[index], false)));

    if (value == true) {
      setState(() {
        getAddressList();
      });
    }
  }

  void deleteAddress(int index) {
    Alert(
        context: context,
        type: AlertType.warning,
        title: "WARNING",
        desc: "Do you want delete it?",
        buttons: [
          DialogButton(
            child: Text(
              "YES",
              style: TextStyle(color: Colors.white, fontSize: 20),
            ),
            onPressed: () {
              Navigator.pop(context);
              AddressAPI.deleteAddress(addressList[index]['user_address_ID'])
                  .then((value) {
                if (value['status'] == '1') {
                  setState(() {
                    getAddressList();
                  });
                }
              });
            },
            width: 100,
          ),
          DialogButton(
            child: Text(
              "NO",
              style: TextStyle(color: Colors.white, fontSize: 20),
            ),
            onPressed: () => Navigator.pop(context),
            width: 100,
          ),
        ]).show();
  }
}
/*
import 'package:custlr/api/addressAPI.dart';
import 'package:custlr/screen/drawer/add_edit_addresses.dart';
import 'package:custlr/widget/loading.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class MyAddresses extends StatefulWidget {
  @override
  _MyAddressesState createState() => _MyAddressesState();
}

class _MyAddressesState extends State<MyAddresses> {
  int initialIndex = 0;
  List addressList = [];
  bool isLoading = true;

  void getAddressList() {
    AddressAPI.addressListAPI().then((value) {
      addressList = value['User_address'];

      setState(() {
        isLoading = false;
      });
    });
  }

  @override
  void initState() {
    super.initState();
    getAddressList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.orangeAccent,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          'My Addresses',
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: Stack(
        children: [
          isLoading
              ? CustlrLoading.whiteCircularLoading()
              : addressList.isEmpty
                  ? Container(
                      child: Center(child: Text('Not Address Yet')),
                    )
                  : ListView(
                      children: [
                        Container(
                          padding: EdgeInsets.all(20),
                          child: ListView.builder(
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              itemCount: addressList.length,
                              itemBuilder: (context, index) {
                                final data =
                                    """<div><p>Name: ${addressList[index]['receiver_name']}</p>
<p><b>Shipping Detail</b></p>
${addressList[index]['shipping_address']}, ${addressList[index]['shipping_code']},
${addressList[index]['shipping_state']},
+6${addressList[index]['shipping_contactno']}

<p><b>Billing Detail</b></p>
${addressList[index]['billing_address']}, ${addressList[index]['billing_code']},
${addressList[index]['billing_state']},
+6${addressList[index]['billing_contactno']}

<b>${addressList[index]['address_same'] == 0 ? '' : 'Same as Shipping address'}</b>
</div>""";
                                return Container(
                                  padding: EdgeInsets.only(bottom: 20),
                                  child: Row(
                                    children: [
                                      Radio(
                                          activeColor: Colors.green,
                                          value: index,
                                          groupValue: initialIndex,
                                          onChanged: (value) {
                                            setState(() {
                                              initialIndex = value;
                                              AddressAPI.defaultAddress(
                                                      addressList[index]
                                                          ['user_address_ID'])
                                                  .then((value) {
                                                Fluttertoast.showToast(
                                                    msg: value['msg']);
                                              });
                                            });
                                          }),
                                      Expanded(
                                        child: PhysicalModel(
                                          borderRadius:
                                              BorderRadius.circular(20),
                                          color: Colors.white,
                                          shadowColor: Colors.black,
                                          elevation: 5,
                                          child: Container(
                                            padding: const EdgeInsets.all(15),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Expanded(
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Html(
                                                        data: data,
                                                        style: {
                                                          "div": Style(
                                                            whiteSpace:
                                                                WhiteSpace.PRE,
                                                          ),
                                                        },
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                Column(
                                                  children: [
                                                    GestureDetector(
                                                      onTap: () async {
                                                        editAddress(index);
                                                      },
                                                      child: Container(
                                                          padding:
                                                              EdgeInsets.all(5),
                                                          decoration: BoxDecoration(
                                                              color:
                                                                  Colors.orange,
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          10)),
                                                          child: Icon(
                                                            Icons.edit,
                                                            color: Colors.white,
                                                          )),
                                                    ),
                                                    SizedBox(
                                                      height: 10,
                                                    ),
                                                    GestureDetector(
                                                      onTap: () async {
                                                        deleteAddress(index);
                                                      },
                                                      child: Container(
                                                          padding:
                                                              EdgeInsets.all(5),
                                                          decoration: BoxDecoration(
                                                              color: Colors.red,
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          10)),
                                                          child: Icon(
                                                            Icons.delete,
                                                            color: Colors.white,
                                                          )),
                                                    ),
                                                  ],
                                                )
                                              ],
                                            ),
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                );
                              }),
                        ),
                      ],
                    ),
          Align(
            alignment: Alignment.bottomCenter,
            child: SafeArea(
              child: Container(
                padding: EdgeInsets.only(bottom: 20),
                child: InkWell(
                  highlightColor: Colors.transparent,
                  splashColor: Colors.transparent,
                  onTap: () {
                    addAddress();
                  },
                  child: PhysicalModel(
                    color: Colors.black,
                    shadowColor: Colors.grey,
                    elevation: 5,
                    borderRadius: BorderRadius.circular(30),
                    child: Container(
                      padding:
                          EdgeInsets.symmetric(vertical: 15, horizontal: 30),
                      child: Text(
                        'Add Addresses',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void addAddress() async {
    bool value = await Navigator.push(context,
        MaterialPageRoute(builder: (context) => AddEditAddresses([], true)));

    if (value == true) {
      setState(() {
        getAddressList();
      });
    }
  }

  void editAddress(int index) async {
    bool value = await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => AddEditAddresses(addressList[index], false)));

    if (value == true) {
      setState(() {
        getAddressList();
      });
    }
  }

  void deleteAddress(int index) {
    Alert(
        context: context,
        type: AlertType.warning,
        title: "WARNING",
        desc: "Do you want delete it?",
        buttons: [
          DialogButton(
            child: Text(
              "YES",
              style: TextStyle(color: Colors.white, fontSize: 20),
            ),
            onPressed: () {
              Navigator.pop(context);
              AddressAPI.deleteAddress(addressList[index]['user_address_ID'])
                  .then((value) {
                if (value['status'] == '1') {
                  setState(() {
                    getAddressList();
                  });
                }
              });
            },
            width: 100,
          ),
          DialogButton(
            child: Text(
              "NO",
              style: TextStyle(color: Colors.white, fontSize: 20),
            ),
            onPressed: () => Navigator.pop(context),
            width: 100,
          ),
        ]).show();
  }
}
*/
