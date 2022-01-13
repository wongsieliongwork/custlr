import 'package:custlr/screen/drawer/my_addresses.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';

class AddressWidget extends StatelessWidget {
  final List addressList;
  final String addressData;
  final Function onChanged;
  AddressWidget({this.addressList, this.addressData, this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: addressList.isEmpty
          ? GestureDetector(
              onTap: () async {
                bool data = await Navigator.push(context,
                    MaterialPageRoute(builder: (context) => MyAddresses()));
                if (data == true) {
                  // getCartAPI();
                  onChanged();
                }
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
            )
          : Container(
              margin: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
              child: Column(
                children: [
                  Image.asset('assets/images/address.png'),
                  SizedBox(
                      width: double.infinity,
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 20),
                        color: Colors.white,
                        height: addressList[0]['address_same'] == 1 ? 300 : 270,
                        child: Row(
                          children: [
                            Expanded(
                              child: Html(
                                data: addressData,
                                style: {
                                  "div": Style(
                                    whiteSpace: WhiteSpace.PRE,
                                  ),
                                },
                              ),
                            ),
                            GestureDetector(
                                onTap: () async {
                                  bool data = await Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => MyAddresses()));
                                  if (data == true) {
                                    // getCartAPI();
                                    onChanged();
                                  }
                                },
                                child: Icon(Icons.edit))
                          ],
                        ),
                      )),
                  Image.asset('assets/images/address.png'),
                ],
              ),
            ),
    );
  }
}
