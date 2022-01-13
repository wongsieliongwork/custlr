import 'package:cached_network_image/cached_network_image.dart';
import 'package:custlr/api/api.dart';
import 'package:custlr/screen/product_detail/product_detail.dart';
import 'package:custlr/screen/show_all/show_all.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class NewTopFeatured extends StatelessWidget {
  NewTopFeatured(this.name, this.data, this.alldata);
  final String name;
  final data;
  final alldata;
  final ScrollController scrollContoller = ScrollController();
  final List product = [
    {
      'name': "Hanes Men's Short Sleeve Beefv-t",
      'image': 'assets/images/product/1.jpeg',
      'price': '20',
      'discount': '',
    },
    {
      'name': "Hanes Men's Short Sleeve Beefv-t",
      'image': 'assets/images/product/2.jpeg',
      'price': '40',
      'discount': '20',
    },
    {
      'name': "Hanes Men's Short Sleeve Beefv-t",
      'image': 'assets/images/product/3.jpg',
      'price': '50',
      'discount': '10'
    },
  ];
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Container(
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: 15,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                  onTap: () {
                    API.theDifferent();
                  },
                  child: Text(
                    name,
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        color: Colors.black54),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ShowAll(name, alldata)));
                  },
                  child: Text(
                    'Show All >',
                    style: TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.black54),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Scrollbar(
            isAlwaysShown: true,
            controller: scrollContoller,
            child: Container(
              height: size.width / 1.1,
              child: ListView.builder(
                  controller: scrollContoller,
                  scrollDirection: Axis.horizontal,
                  shrinkWrap: true,
                  itemCount: data.length,
                  itemBuilder: (context, index) {
                    // double discountPrice = (double.parse(data[index]['price']) -
                    //     (double.parse(data[index]['price']) *
                    //         (data[index]['promotions_discount'] ?? 0 / 100)));
                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ProductDetail(data[index]),
                            ));
                      },
                      child: Container(
                          child: Column(
                        children: [
                          Container(
                            height: size.width / 1.6,
                            padding: EdgeInsets.only(right: 10),
                            child: CachedNetworkImage(
                              imageUrl: data[index]['banner'],
                              placeholder: (context, url) => Container(
                                color: Colors.grey,
                              ),
                              width: size.width / 2,
                              fit: BoxFit.cover,
                              alignment: Alignment.topCenter,
                            ),
                            // child: Image.network(
                            //   Custlr.imgUrl + data[index]['banner'],
                            //   width: size.width / 2,
                            //   fit: BoxFit.cover,
                            //   alignment: Alignment.topCenter,
                            // ),
                          ),
                          Expanded(
                              child: Stack(
                            alignment: Alignment.centerRight,
                            children: [
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(
                                    height: 5,
                                  ),
                                  Container(
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 7),
                                    width: size.width / 2,
                                    child: Text(
                                      "${data[index]['product_name']}",
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 5,
                                  ),
                                  Text(
                                    '  RM ${data[index]['price']}',
                                    textAlign: TextAlign.left,
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      decoration: data[index]
                                                  ['promotions_discount'] ==
                                              null
                                          ? null
                                          : TextDecoration.lineThrough,
                                      decorationThickness: 2.00,
                                    ),
                                  ),

                                  // Row(
                                  //   children: List.generate(
                                  //       5,
                                  //       (index) => Icon(
                                  //             Icons.star,
                                  //             color: Color(0xFFb2b200),
                                  //           )),
                                  // ),

                                  data[index]['promotions_discount'] == null
                                      ? Container(
                                          height: 5,
                                        )
                                      : Text(
                                          '  RM ${data[index]['promotions_price']}',
                                          textAlign: TextAlign.left,
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold),
                                        ),
                                  Row(
                                    children: [
                                      RatingBar.builder(
                                        initialRating:
                                            double.parse(data[index]['rating']),
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
                                      Text(
                                        " (${data[index]['review']})",
                                        style: TextStyle(color: Colors.grey),
                                      )
                                    ],
                                  )
                                ],
                              ),
                              Container(
                                  padding: EdgeInsets.only(right: 10),
                                  child: Icon(Icons.keyboard_arrow_right))
                            ],
                          ))
                        ],
                      )),
                    );
                  }),
            ),
          ),
          SizedBox(
            height: 40,
          ),
          // Row(
          //   children: List.generate(
          //       data.length < 3
          //           ? 3
          //           : data.length > 3
          //               ? 3
          //               : data.length, (index) {
          //     if (data.length <= index) {
          //       return Expanded(
          //         child: Container(
          //           margin: EdgeInsets.all(10),
          //           child: Column(
          //             crossAxisAlignment: CrossAxisAlignment.start,
          //             children: [
          //               Image.network(
          //                 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQuGIC4x3fb2DPkG9j8nqu82sUF3Iz5Uj6RUQ&usqp=CAU',
          //                 height: 150,
          //                 fit: BoxFit.cover,
          //               ),
          //               SizedBox(
          //                 height: 10,
          //               ),
          //               Text(
          //                 "Coming Soon",
          //                 maxLines: 1,
          //                 overflow: TextOverflow.ellipsis,
          //                 style: TextStyle(fontWeight: FontWeight.bold),
          //               ),
          //               SizedBox(
          //                 height: 5,
          //               ),
          //               Text(
          //                 '  ',
          //                 textAlign: TextAlign.left,
          //                 style: TextStyle(fontWeight: FontWeight.bold),
          //               ),
          //             ],
          //           ),
          //         ),
          //       );
          //     }
          //     return Expanded(
          //       child: GestureDetector(
          //         onTap: () {
          //           Navigator.push(
          //               context,
          //               MaterialPageRoute(
          //                 builder: (context) => ProductDetail(data[index]),
          //               ));
          //         },
          //         child: Container(
          //           margin: EdgeInsets.all(10),
          //           child: Column(
          //             crossAxisAlignment: CrossAxisAlignment.start,
          //             children: [
          //               Image.network(
          //                 Custlr.imgUrl + data[index]['banner'],
          //                 height: 150,
          //                 fit: BoxFit.cover,
          //               ),
          //               SizedBox(
          //                 height: 10,
          //               ),
          //               Text(
          //                 "  ${data[index]['product_name']}",
          //                 maxLines: 1,
          //                 overflow: TextOverflow.ellipsis,
          //                 style: TextStyle(fontWeight: FontWeight.bold),
          //               ),
          //               SizedBox(
          //                 height: 5,
          //               ),
          //               Text(
          //                 '  RM ${data[index]['price']}',
          //                 textAlign: TextAlign.left,
          //                 style: TextStyle(
          //                   fontWeight: FontWeight.bold,
          //                   decoration: data[index]['promotions_price'] == null
          //                       ? null
          //                       : TextDecoration.lineThrough,
          //                 ),
          //               ),
          //               Text(
          //                 data[index]['promotions_price'] == null
          //                     ? ''
          //                     : '  RM ${data[index]['promotions_price']}',
          //                 textAlign: TextAlign.left,
          //                 style: TextStyle(fontWeight: FontWeight.bold),
          //               ),
          //             ],
          //           ),
          //         ),
          //       ),
          //     );
          //   }),
          // )
        ],
      ),
    );
  }
}
