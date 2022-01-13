import 'package:custlr/screen/product_detail/product_detail.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class ShowProduct extends StatefulWidget {
  ShowProduct(this.data);
  final data;
  @override
  _ShowProductState createState() => _ShowProductState();
}

class _ShowProductState extends State<ShowProduct> {
  final List product = [
    {
      'name': "Hanes Men's Short Sleeve Beefv-t",
      'image': 'assets/images/product/1.jpeg',
      'price': '20',
      'discount': '30',
    },
    {
      'name': "Hanes Men's Short Sleeve Beefv-t",
      'image': 'assets/images/product/2.jpeg',
      'price': '40',
      'discount': '60',
    },
    {
      'name': "Hanes Men's Short Sleeve Beefv-t",
      'image': 'assets/images/product/3.jpg',
      'price': '50',
      'discount': '100',
    },
    {
      'name': "Hanes Men's Short Sleeve Beefv-t",
      'image': 'assets/images/product/1.jpeg',
      'price': '100',
      'discount': '200',
    },
    {
      'name': "Hanes Men's Short Sleeve Beefv-t",
      'image': 'assets/images/product/2.jpeg',
      'price': '40',
      'discount': '',
    },
    {
      'name': "Hanes Men's Short Sleeve Beefv-t",
      'image': 'assets/images/product/3.jpg',
      'price': '50',
      'discount': ''
    },
    {
      'name': "Hanes Men's Short Sleeve Beefv-t",
      'image': 'assets/images/product/2.jpeg',
      'price': '40',
      'discount': '60',
    },
    {
      'name': "Hanes Men's Short Sleeve Beefv-t",
      'image': 'assets/images/product/3.jpg',
      'price': '50',
      'discount': '100',
    },
    {
      'name': "Hanes Men's Short Sleeve Beefv-t",
      'image': 'assets/images/product/1.jpeg',
      'price': '100',
      'discount': '200',
    },
  ];
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    /*24 is for notification bar on Android*/
    final double itemHeight = (size.height - kToolbarHeight - 24) / 2;
    final double itemWidth = size.width / 2;
    return Container(
      padding: EdgeInsets.symmetric(vertical: 10),
      child: GridView.builder(
          itemCount: widget.data.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: 10,
            crossAxisSpacing: 10,
            childAspectRatio: ((size.width / 2.1) / (size.width / 1.1)),
          ),
          itemBuilder: (context, index) {
            // double discountPrice = (double.parse(widget.data[index]['price']) -
            //     (double.parse(widget.data[index]['price']) *
            //         (int.parse(
            //                 widget.data[index]['promotions_discount'] ?? "0") /
            //             100)));
            return GestureDetector(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            ProductDetail(widget.data[index])));
              },
              child: Container(
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Image.network(
                      widget.data[index]['banner'],
                      fit: BoxFit.cover,
                      height: (size.width / 2) * 1.24,
                      width: size.width,
                      alignment: Alignment.topCenter,
                    ),

                    Expanded(
                        child: Stack(
                      alignment: Alignment.centerRight,
                      children: [
                        Container(
                          padding: EdgeInsets.only(left: 10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                height: 20,
                              ),
                              Text(
                                widget.data[index]['product_name'],
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(fontWeight: FontWeight.bold),
                                maxLines: 2,
                                textAlign: TextAlign.left,
                              ),
                              Text(
                                'RM ${widget.data[index]['price']}',
                                textAlign: TextAlign.left,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  decoration: widget.data[index]
                                              ['promotions_discount'] ==
                                          null
                                      ? null
                                      : TextDecoration.lineThrough,
                                  decorationThickness: 2.00,
                                ),
                              ),
                              widget.data[index]['promotions_discount'] == null
                                  ? Container(
                                      height: 5,
                                    )
                                  : Text(
                                      'RM ${widget.data[index]['promotions_price']}',
                                      textAlign: TextAlign.left,
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                              SizedBox(
                                height: 2,
                              ),
                              Row(
                                children: [
                                  RatingBar.builder(
                                    initialRating: double.parse(widget
                                        .data[index]['rating']
                                        .toString()),
                                    minRating: 1,
                                    direction: Axis.horizontal,
                                    allowHalfRating: true,
                                    ignoreGestures: true,
                                    itemCount: 5,
                                    itemSize: 20.0,
                                    itemBuilder: (context, _) => Icon(
                                      Icons.star,
                                      color: Color(0xFFce3235),
                                      size: 20,
                                    ),
                                    onRatingUpdate: (rating) {
                                      print(rating);
                                    },
                                  ),
                                  Text(" (${widget.data[index]['review']})")
                                ],
                              )
                            ],
                          ),
                        ),
                        Icon(Icons.keyboard_arrow_right)
                      ],
                    ))
                    // Text(
                    //   product[index]['discount'] == ''
                    //       ? ""
                    //       : 'RM ${product[index]['discount']}',
                    //   style: TextStyle(
                    //       color: Colors.grey,
                    //       decoration: TextDecoration.lineThrough),
                    // ),
                  ],
                ),
              ),
            );
          }),
    );
  }
}
