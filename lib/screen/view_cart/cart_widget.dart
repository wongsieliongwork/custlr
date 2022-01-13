import 'package:custlr/api/cartAPI.dart';
import 'package:custlr/model/measurementModel.dart';
import 'package:custlr/screen/get_fitted/body_measurement.dart';
import 'package:custlr/screen/product_detail/product_detail.dart';
import 'package:flutter/material.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class CartWidget extends StatefulWidget {
  final List cartList;
  final Function onChanged;

  CartWidget({
    this.cartList,
    this.onChanged,
  });

  @override
  _CartWidgetState createState() => _CartWidgetState();
}

class _CartWidgetState extends State<CartWidget> {
  void increaseItem(int index) {
    setState(() {
      final data = {
        'CartID': widget.cartList[index]['CartID'],
        'quantity': (widget.cartList[index]['quantity'] + 1).toString(),
      };

      // add api
      CartAPI.editCart(data);

      widget.cartList[index]['quantity'] =
          widget.cartList[index]['quantity'] + 1;
      widget.onChanged();
    });
  }

  void decreaseItem(int index) {
    print(index);
    if (widget.cartList[index]['quantity'] == 1) {
      Alert(
          context: context,
          title: 'Do you want delete it?',
          type: AlertType.warning,
          buttons: [
            DialogButton(
              onPressed: () {
                CartAPI.removeCart(widget.cartList[index]['CartID']);
                Navigator.pop(context);
                setState(() {
                  widget.cartList.removeAt(index);
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
          'CartID': widget.cartList[index]['CartID'],
          'quantity': (widget.cartList[index]['quantity'] - 1).toString(),
        };
        // decrease api
        CartAPI.editCart(data);

        widget.cartList[index]['quantity'] =
            widget.cartList[index]['quantity'] - 1;
        widget.onChanged();
      });
    }
  }

  void deleteItem(index) {
    setState(() {
      CartAPI.removeCart(widget.cartList[index]['CartID']);
      widget.cartList.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: widget.cartList.length + 1,
      itemBuilder: (context, index) {
        if (index == widget.cartList.length) {
          return Container(
            height: 100,
          );
        }
        double totalPrice = double.parse(widget.cartList[index]['price']) *
            (widget.cartList[index]['quantity']);

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
                child: Container(
              margin: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
              child: Column(
                children: [
                  GestureDetector(
                    // onTap: () => onTapProduct(index),
                    onTap: () {
                      MeasurementModel ownbodyMeasurement = MeasurementModel(
                          gender: widget.cartList[index]['gender'],
                          height: widget.cartList[index]['height'].toString(),
                          chest: widget.cartList[index]['chest'],
                          shoulder: widget.cartList[index]['shoulder'],
                          armLength: widget.cartList[index]['arm_length'],
                          bicep: widget.cartList[index]['bicep'],
                          waist: widget.cartList[index]['waist'],
                          hip: widget.cartList[index]['hip'],
                          dressLength: widget.cartList[index]['dress_length'],
                          review: widget.cartList[index]['review']);

                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => BodyMeasurement(
                                  data: ownbodyMeasurement, isCart: true)));
                    },
                    child: Container(
                      child: Dismissible(
                        key: UniqueKey(),
                        // key: Key(cartList[index]['product_name']),
                        background: Container(
                          padding: EdgeInsets.all(20),
                          alignment: Alignment.centerLeft,
                          color: Colors.red,
                          child: Icon(
                            Icons.delete,
                            color: Colors.white,
                          ),
                        ),
                        secondaryBackground: Container(
                          padding: EdgeInsets.all(20),
                          alignment: Alignment.centerRight,
                          color: Colors.red,
                          child: Icon(
                            Icons.delete,
                            color: Colors.white,
                          ),
                        ),
                        onDismissed: (DismissDirection direction) {
                          deleteItem(index);
                          widget.onChanged();
                        },
                        child: Card(
                          child: Row(
                            children: [
                              Expanded(
                                flex: 2,
                                child: Image.network(
                                  'https://${widget.cartList[index]['product_image']}',
                                  height: 100,
                                  fit: BoxFit.cover,
                                  alignment: Alignment.topCenter,
                                ),
                              ),
                              Expanded(
                                flex: 4,
                                child: Container(
                                  padding: EdgeInsets.only(left: 20),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        '${widget.cartList[index]['product_name']}',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
                                      Text('MYR ' + '$totalPrice'),
                                      Text(
                                          '(${widget.cartList[index]['method'] == "b" ? "Body Measurement" : widget.cartList[index]['method'] == "d" ? "Dressing Measurement" : widget.cartList[index]['method'] == "a4" ? "A4 Fit" : ""})'),
                                    ],
                                  ),
                                ),
                              ),
                              Expanded(
                                  flex: 3,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      MaterialButton(
                                          minWidth: 10.0,
                                          height: 30.0,
                                          // onPressed: () =>
                                          //     decreaseItem(cartList, index),
                                          onPressed: () {
                                            decreaseItem(index);
                                          },
                                          // widget.decrease(index),
                                          shape: CircleBorder(),
                                          color: Colors.grey[200],
                                          child: Icon(Icons.remove)),
                                      Text(
                                        '${widget.cartList[index]['quantity']}',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 20),
                                      ),
                                      MaterialButton(
                                          minWidth: 10.0,
                                          height: 30.0,
                                          // onPressed: () =>
                                          //     increaseItem(cartList, index),
                                          onPressed: () {
                                            increaseItem(index);
                                          },
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
                  if (!widget
                      .cartList[index]['product_addon']['product'].isEmpty)
                    Column(
                      children: [
                        Text('- Add Ons-'),
                        Column(
                          children: List.generate(
                              widget.cartList[index]['product_addon']['product']
                                  .length, (i) {
                            dynamic addOn = widget.cartList[index]
                                ['product_addon']['product'][i];
                            return Card(
                                child: ListTile(
                              contentPadding: EdgeInsets.all(10),
                              leading: ClipOval(
                                child: Image.network(
                                  addOn['banner'],
                                ),
                              ),
                              title: Text(addOn['product_name']),
                              trailing: GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            ProductDetail(addOn),
                                      ));
                                },
                                child: Container(
                                  color: Colors.black,
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 20, vertical: 10),
                                  child: Text('ADD',
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold)),
                                ),
                              ),
                            ));
                          }),
                        )
                      ],
                    ),

                  // if (!cartList[index]['product_addon']
                  //         ['product']
                  //     .isEmpty)
                  //   GridView.builder(
                  //       physics:
                  //           NeverScrollableScrollPhysics(),
                  //       shrinkWrap: true,
                  //       itemCount: cartList[index]
                  //               ['product_addon']['product']
                  //           .length,
                  //       gridDelegate:
                  //           SliverGridDelegateWithFixedCrossAxisCount(
                  //         crossAxisCount: 2,
                  //         childAspectRatio:
                  //             (itemWidth / itemHeight),
                  //       ),
                  //       itemBuilder:
                  //           (BuildContext context, int i) {
                  //         dynamic addOn = cartList[index]
                  //             ['product_addon']['product'][i];
                  //         return GestureDetector(
                  //           onTap: () {
                  //             Navigator.push(
                  //                 context,
                  //                 MaterialPageRoute(
                  //                   builder: (context) =>
                  //                       ProductDetail(addOn),
                  //                 ));
                  //           },
                  //           child: Card(
                  //             child: Column(
                  //               children: [
                  //                 CachedNetworkImage(
                  //                   imageUrl: addOn['banner'],
                  //                   placeholder:
                  //                       (context, url) =>
                  //                           Container(
                  //                     color: Colors.grey,
                  //                   ),
                  //                   height: 250,
                  //                   width: itemWidth,
                  //                   fit: BoxFit.cover,
                  //                   alignment:
                  //                       Alignment.topCenter,
                  //                 ),
                  //                 Container(
                  //                   padding:
                  //                       EdgeInsets.all(10),
                  //                   child: Column(
                  //                     crossAxisAlignment:
                  //                         CrossAxisAlignment
                  //                             .start,
                  //                     children: [
                  //                       Container(
                  //                         height: 40,
                  //                         child: Text(
                  //                           addOn[
                  //                               'product_name'],
                  //                           style: TextStyle(
                  //                               fontWeight:
                  //                                   FontWeight
                  //                                       .bold),
                  //                         ),
                  //                       ),
                  //                       Text(
                  //                         'MYR 150.00',
                  //                         maxLines: 2,
                  //                         textAlign:
                  //                             TextAlign.left,
                  //                       ),
                  //                       Row(
                  //                         children: [
                  //                           RatingBar.builder(
                  //                             initialRating: addOn[
                  //                                     'rating']
                  //                                 .toDouble(),
                  //                             minRating: 1,
                  //                             direction: Axis
                  //                                 .horizontal,
                  //                             allowHalfRating:
                  //                                 true,
                  //                             ignoreGestures:
                  //                                 true,
                  //                             itemCount: 5,
                  //                             itemSize: 20.0,
                  //                             itemBuilder:
                  //                                 (context,
                  //                                         _) =>
                  //                                     Icon(
                  //                               Icons.star,
                  //                               color: Color(
                  //                                   0xFFce3235),
                  //                               size: 20,
                  //                             ),
                  //                             onRatingUpdate:
                  //                                 (rating) {
                  //                               print(rating);
                  //                             },
                  //                           ),
                  //                           Text(
                  //                               " (${addOn['rating']})")
                  //                         ],
                  //                       )
                  //                     ],
                  //                   ),
                  //                 )
                  //               ],
                  //             ),
                  //           ),
                  //         );
                  //       }),
                ],
              ),
            )),
          ],
        );
      },
    );
  }
}
