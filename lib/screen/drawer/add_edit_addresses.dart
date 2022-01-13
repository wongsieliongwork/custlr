import 'package:custlr/api/addressAPI.dart';
import 'package:flutter/material.dart';

class AddEditAddresses extends StatefulWidget {
  final dynamic data;
  final bool isAdd;
  AddEditAddresses(this.data, this.isAdd);
  @override
  _AddEditAddressesState createState() => _AddEditAddressesState();
}

class _AddEditAddressesState extends State<AddEditAddresses> {
  final nameController = TextEditingController();
  final shippingAddress = TextEditingController();
  final shippingCode = TextEditingController();
  final shippingState = TextEditingController();
  final shippingContact = TextEditingController();
  final billingAddress = TextEditingController();
  final billingCode = TextEditingController();
  final billingState = TextEditingController();
  final billingContact = TextEditingController();

  List addressList = [];

  bool isBilling = true;
  void getAddressIntoList(bool isCheckfrom) {
    if (!widget.isAdd) {
      nameController.text = '${widget.data['receiver_name'] ?? ''}';
      shippingAddress.text = '${widget.data['shipping_address'] ?? ''}';
      shippingCode.text = '${widget.data['shipping_code'] ?? ''}';
      shippingState.text = '${widget.data['shipping_state'] ?? ''}';
      shippingContact.text = '${widget.data['shipping_contactno'] ?? ''}';
      billingAddress.text = '${widget.data['billing_address'] ?? ''}';
      billingCode.text = '${widget.data['billing_code'] ?? ''}';
      billingState.text = '${widget.data['billing_state'] ?? ''}';
      billingContact.text = '${widget.data['billing_contactno'] ?? ''}';
      if (!isCheckfrom) {
        isBilling = widget.data['address_same'] == 1 ? true : false;
      }
    }

    addressList = [
      {
        'name': 'Name',
        'controller': nameController,
      },
      {
        'name': 'Addresses',
        'controller': shippingAddress,
      },
      {
        'name': 'Postcode',
        'controller': shippingCode,
      },
      {
        'name': 'State',
        'controller': shippingState,
      },
      {
        'name': 'Contact Number',
        'controller': shippingContact,
      },
      {
        'name': 'Billing Addresses',
        'controller': billingAddress,
      },
      {
        'name': 'Billing Postcode',
        'controller': billingCode,
      },
      {
        'name': 'Billing State',
        'controller': billingState,
      },
      {
        'name': 'Billing Contact Number',
        'controller': billingContact,
      },
    ];

    if (isBilling) {
      addressList.removeAt(5);
      addressList.removeAt(5);
      addressList.removeAt(5);
      addressList.removeAt(5);
    }
  }

  bool isLoading = false;
  @override
  void initState() {
    super.initState();
    getAddressIntoList(false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            widget.isAdd ? "Add Address" : 'Edit Address',
            style: TextStyle(color: Colors.black),
          ),
        ),
        body: Stack(
          children: [
            Container(
                color: Colors.grey[300],
                child: ListView(
                  children: [
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Container(
                        padding: EdgeInsets.only(top: 10, left: 10),
                        child: Row(
                          children: [
                            Checkbox(
                              activeColor: Colors.lightBlue,
                              checkColor: Colors.white,
                              value: isBilling,
                              onChanged: (bool value) {
                                setState(() {
                                  isBilling = value;
                                  getAddressIntoList(true);
                                });
                              },
                            ),
                            Text('Billing address Same as Shipping Address?'),
                          ],
                        ),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      child: ListView(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        children: List.generate(addressList.length, (index) {
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                height: 20,
                              ),
                              Text(
                                '  ' + addressList[index]['name'],
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              TextField(
                                maxLength:
                                    addressList[index]['name'] == 'Postcode' ||
                                            addressList[index]['name'] ==
                                                'Billing Postcode'
                                        ? 5
                                        : null,
                                textInputAction: TextInputAction.next,
                                textAlign: TextAlign.left,
                                controller: addressList[index]['controller'],
                                keyboardType: index == 2 ||
                                        index == 6 ||
                                        index == 4 ||
                                        index == 8
                                    ? TextInputType.number
                                    : TextInputType.text,
                                decoration: InputDecoration(
                                  hintText: addressList[index]['name'],
                                  hintStyle: TextStyle(fontSize: 16),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(20),
                                    borderSide: BorderSide(
                                      width: 0,
                                      style: BorderStyle.none,
                                    ),
                                  ),
                                  filled: true,
                                  contentPadding: EdgeInsets.all(16),
                                  fillColor: Colors.white,
                                ),
                              ),
                            ],
                          );
                        }),
                      ),
                    ),
                    Container(
                      height: 200,
                    )
                  ],
                )),
            Align(
              alignment: Alignment.bottomCenter,
              child: SafeArea(
                child: Container(
                  padding: EdgeInsets.only(bottom: 20),
                  child: InkWell(
                    highlightColor: Colors.transparent,
                    splashColor: Colors.transparent,
                    onTap: () async {
                      setState(() {
                        isLoading = true;
                      });

                      dynamic data = {};
                      if (isBilling) {
                        data = {
                          'receiver_name': nameController.text,
                          'shipping_address': shippingAddress.text,
                          'shipping_code': shippingCode.text,
                          'shipping_state': shippingState.text,
                          'shipping_contactno': shippingContact.text,
                          'billing_address': shippingAddress.text,
                          'billing_code': shippingCode.text,
                          'billing_state': shippingState.text,
                          'billing_contactno': shippingContact.text,
                          'address_same': '1',
                          'id':
                              widget.isAdd ? "" : widget.data['user_address_ID']
                        };
                      } else {
                        data = {
                          'receiver_name': nameController.text,
                          'shipping_address': shippingAddress.text,
                          'shipping_code': shippingCode.text,
                          'shipping_state': shippingState.text,
                          'shipping_contactno': shippingContact.text,
                          'billing_address': billingAddress.text,
                          'billing_code': billingCode.text,
                          'billing_state': billingState.text,
                          'billing_contactno': billingContact.text,
                          'address_same': isBilling ? '1' : '0',
                          'id':
                              widget.isAdd ? "" : widget.data['user_address_ID']
                        };
                      }

                      print(data);
                      if (widget.isAdd) {
                        AddressAPI.addAddress(data).then((value) {
                          if (value['status'] == '1') {
                            Navigator.pop(context, true);
                            isLoading = false;
                          }
                        });
                      } else {
                        AddressAPI.editAddress(data).then((value) {
                          if (value['status'] == '1') {
                            Navigator.pop(context, true);
                            isLoading = false;
                          }
                        });
                      }
                    },
                    child: PhysicalModel(
                      color: Colors.black,
                      elevation: 5,
                      shadowColor: Colors.grey,
                      borderRadius: BorderRadius.circular(30),
                      child: Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: 40, vertical: 15),
                          child: isLoading
                              ? Container(
                                  child: CircularProgressIndicator(
                                    color: Colors.white,
                                  ),
                                )
                              : Text(
                                  'Confirm',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold),
                                )),
                    ),
                  ),
                ),
              ),
            )
          ],
        ));
  }
}
