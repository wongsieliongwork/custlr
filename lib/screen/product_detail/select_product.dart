import 'dart:developer';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:custlr/api/api.dart';
import 'package:custlr/api/measurementAPI.dart';
import 'package:custlr/api/reviewAPI.dart';
import 'package:custlr/screen/product_detail/add_review.dart';
import 'package:custlr/utils/constants.dart';
import 'package:custlr/common/dynamic_link_service.dart';
import 'package:custlr/provider/Measurement.dart';
import 'package:custlr/utils/shared_preference_utils.dart';
import 'package:custlr/widget/loading.dart';
import 'package:flutter/material.dart';
import 'package:flutter_countdown_timer/index.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';
import 'package:provider/provider.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:share/share.dart';
import 'dart:async';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:dio/dio.dart' as dio;
import 'package:flutter/services.dart' show rootBundle;
import 'package:path/path.dart';
import 'dart:ui' as ui;
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:http/http.dart' as http;

class SelectProduct extends StatefulWidget {
  SelectProduct(
    this.data,
    this.onChanged,
  );
  final Function(int) onChanged;
  final dynamic data;
  @override
  _SelectProductState createState() => _SelectProductState();
}

class _SelectProductState extends State<SelectProduct>
    with SingleTickerProviderStateMixin {
  // Asset to File Function
  Future<File> getImageFileFromAssets(String path) async {
    final byteData = await rootBundle.load('assets/$path');

    final file = File('${(await getTemporaryDirectory()).path}/image.png');
    await file.writeAsBytes(byteData.buffer
        .asUint8List(byteData.offsetInBytes, byteData.lengthInBytes));

    return file;
  }

  final commentController = TextEditingController();
  //Timer And Review
  int endTime = 0;
  String endText = '';
  int timer = 0;
  List reviewList = [];
  bool isLoading = true;
  void timerAndReviewAPI(final id) async {
    ReviewAPI.review(id).then((data) {
      reviewList = data['Product_reviews'];
      reviewList = reviewList
        ..sort((a, b) {
          return b['ProductReviewID'].compareTo(a['ProductReviewID']);
        });
    });

    API.timerProduct(id).then((value) {
      setState(() {
        if (value['status'] == 0) {
          isLoading = false;
          timer = 0;
        } else {
          isLoading = false;
          timer = value['PromotionInSec'];
        }

        endTime = DateTime.now().millisecondsSinceEpoch + 1000 * timer;
      });
    });
  }

  // Slider
  List sliderList = [];
  String urlThumbnail = '';
  void importImageToSlider() {
    sliderList.add('${widget.data['banner']}');

    for (int i = 1; i <= 3; i++) {
      if (widget.data['thumbnail$i'] !=
          'https://custlr.com/admin/images/products/${widget.data['ProductID']}/') {
        sliderList.add('${widget.data['thumbnail$i']}');
      } else {}
    }
    // sliderList = [
    //   '${widget.data['banner']}',
    //   '${widget.data['thumbnail1']}',
    //   '${widget.data['thumbnail2']}',
    //   '${widget.data['thumbnail3']}'
    // ];
  }

  TabController controller;

  int index = 0;
  ui.Image image;

// Image Picker
  File img;

  final picker = ImagePicker();

  Future getCamera() async {
    PickedFile pickedFile;
    pickedFile = await picker.getImage(source: ImageSource.camera);

    setState(() {
      img = File(pickedFile.path);
    });
  }

  Future getGallery() async {
    PickedFile pickedFile;
    pickedFile = await picker.getImage(source: ImageSource.gallery);

    setState(() {
      img = File(pickedFile.path);
    });
  }

  // double discountPrice;
  void calculateDiscount() {
    // discountPrice = (double.parse(widget.data['price']) -
    //     (double.parse(widget.data['price']) *
    //         (int.parse(widget.data['promotions_discount'] ?? "0") / 100)));
  }

  bool isOneClickCheckout = false;
  @override
  void initState() {
    super.initState();

    controller = TabController(length: 2, vsync: this);
    controller.addListener(changeIndex);
    importImageToSlider();
    timerAndReviewAPI(widget.data['ProductID']);
    calculateDiscount();
    // getSharedPreference();
  }

  void changeIndex() {
    setState(() {
      // get index of active tab & change current appbar title
      index = controller.index;
    });
  }

  // void getSharedPreference() async {
  //   SharedPreferences pref = await SharedPreferences.getInstance();
  //   userId = pref.getString('UserID');
  //   setState(() {});
  // }

  // String userId = '';

  int _current = 0;
  final CarouselController _controller = CarouselController();
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final height = size.height;
    final width = size.width;

    return Stack(children: [
      isLoading
          ? Container(
              child: CustlrLoading.circularLoading(),
            )
          : DefaultTabController(
              length: 2,
              child: Container(
                child: ListView(
                  children: [
                    // Image Slider
                    Container(
                      height: size.width * 1.25,
                      child: Stack(
                        fit: StackFit.expand,
                        children: [
                          GestureDetector(
                            onDoubleTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          ZoomImage(sliderList)));
                            },
                            child: CarouselSlider(
                              options: CarouselOptions(
                                  onPageChanged: (index, reason) {
                                    setState(() {
                                      _current = index;
                                    });
                                  },
                                  height: size.width * 1.25,
                                  viewportFraction: 1.0,
                                  autoPlay: true,
                                  enlargeCenterPage: true),
                              items: List.generate(sliderList.length, (index) {
                                return CachedNetworkImage(
                                  imageUrl: sliderList[index],
                                  placeholder: (context, url) => Image.asset(
                                      'assets/images/placeholder-image.png'),
                                  errorWidget: (context, url, error) =>
                                      Image.asset(
                                          'assets/images/placeholder-image.png'),
                                  fit: BoxFit.cover,
                                  width: size.width,
                                  alignment: Alignment.topCenter,
                                );
                              }),
                            ),
                          ),
                          Align(
                            alignment: Alignment.bottomCenter,
                            child: Container(
                              margin: EdgeInsets.only(bottom: 20),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children:
                                    sliderList.asMap().entries.map((entry) {
                                  return GestureDetector(
                                    onTap: () =>
                                        _controller.animateToPage(entry.key),
                                    child: Container(
                                      width: 12.0,
                                      height: 12.0,
                                      margin: EdgeInsets.symmetric(
                                          vertical: 8.0, horizontal: 4.0),
                                      decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: (Theme.of(context)
                                                          .brightness ==
                                                      Brightness.dark
                                                  ? Colors.white
                                                  : Colors.black)
                                              .withOpacity(_current == entry.key
                                                  ? 0.9
                                                  : 0.4)),
                                    ),
                                  );
                                }).toList(),
                              ),
                            ),
                          ),
                          Align(
                            alignment: Alignment.topLeft,
                            child: GestureDetector(
                              onTap: () {
                                Navigator.pop(context);
                              },
                              child: Icon(
                                Icons.keyboard_arrow_left,
                                size: 40,
                              ),
                            ),
                          ),
                          Positioned(
                            bottom: 10,
                            right: 10,
                            child: GestureDetector(
                              onTap: () async {
                                // Image Url To File
                                final response = await http
                                    .get(Uri.parse('${widget.data['banner']}'));
                                final documentDirectory =
                                    (await getExternalStorageDirectory()).path;
                                File file = new File(
                                    '$documentDirectory/${widget.data['product_name']}.png');
                                file.writeAsBytesSync(response.bodyBytes);
                                DynamicLinkService()
                                    .createDynamicLink(
                                        true, widget.data.toString())
                                    .then((value) {
                                  Share.shareFiles([
                                    '$documentDirectory/${widget.data['product_name']}.png'
                                  ],
                                      subject: 'Custlr',
                                      text:
                                          'Name: ${widget.data['product_name']}\nPrice: RM ${widget.data['price']}\n $value');
                                });
                                // print('${widget.data}');
                                // DynamicLinkService()
                                //     .createDynamicLink(true, widget.data)
                                //     .then((value) {
                                //   Share.share('$value',
                                //       subject: 'Look what I made!');
                                // });
                              },
                              child: Container(
                                padding: EdgeInsets.only(bottom: 10),
                                child: Icon(
                                  Icons.share,
                                  size: 30,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    GestureDetector(
                      onTap: () {
                        log('$sliderList');
                      },
                      child: Text(widget.data['product_name'],
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 18)),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    // For no promotion
                    Visibility(
                      visible: widget.data['promotions_discount'] == null
                          ? true
                          : false,
                      child: Text(
                        "RM ${widget.data['price']}",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 18),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    //For promotion
                    Visibility(
                      visible: widget.data['promotions_discount'] == null
                          ? false
                          : true,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              CountdownTimer(
                                endTime: endTime,
                                widgetBuilder: (_, CurrentRemainingTime time) {
                                  if (time == null) {
                                    return Text('The sale is end now.');
                                  }
                                  return Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                          margin: EdgeInsets.symmetric(
                                              horizontal: 10),
                                          padding: EdgeInsets.all(5),
                                          color: Colors.red,
                                          child: Text(
                                            'SALE',
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold),
                                          )),
                                      Row(
                                        children: [
                                          SizedBox(
                                            width: 10,
                                          ),
                                          Text('[',
                                              style: TextStyle(
                                                  color: Colors.red,
                                                  fontSize: 20)),
                                          Row(
                                            children: List.generate(4, (index) {
                                              List timerList = [
                                                {
                                                  'name': 'days',
                                                  'timer': time.days.toString(),
                                                },
                                                {
                                                  'name': 'hours',
                                                  'timer':
                                                      time.hours.toString(),
                                                },
                                                {
                                                  'name': 'min',
                                                  'timer': time.min.toString(),
                                                },
                                                {
                                                  'name': 'sec',
                                                  'timer': time.sec.toString(),
                                                },
                                              ];
                                              return Container(
                                                padding: EdgeInsets.all(5),
                                                child: Column(
                                                  children: [
                                                    Text(
                                                        timerList[index]
                                                                    ['timer'] ==
                                                                'null'
                                                            ? '00'
                                                            : timerList[index]
                                                                    ['timer']
                                                                .toString()
                                                                .padLeft(
                                                                    2, '0'),
                                                        style: TextStyle(
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            fontSize: 14)),
                                                    Text(timerList[index]
                                                        ['name']),
                                                  ],
                                                ),
                                              );
                                            }),
                                          ),
                                          Text(']',
                                              style: TextStyle(
                                                  color: Colors.red,
                                                  fontSize: 14)),
                                        ],
                                      )
                                    ],
                                  );
                                },
                              ),
                            ],
                          ),
                          SizedBox(
                            width: 40,
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text("RM ${widget.data['price']}",
                                  style: TextStyle(
                                      decoration: TextDecoration.lineThrough,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18)),
                              SizedBox(
                                width: 10,
                              ),
                              Text("RM ${widget.data['promotions_price']}",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                    color: Colors.grey,
                                  )),
                            ],
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Column(
                      children: [
                        TabBar(
                          controller: controller,
                          labelColor: Colors.black,
                          tabs: [
                            Text('Description'),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text('Reviews'),
                                // Row(
                                //     mainAxisAlignment: MainAxisAlignment.center,
                                //     children: List.generate(
                                //         5,
                                //         (index) => Icon(
                                //               Icons.star,
                                //               size: 15,
                                //               color: Colors.orange,
                                //             ))),
                                RatingBar.builder(
                                  initialRating: double.parse(
                                      widget.data['rating'].toString()),
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
                                    '${widget.data['rating']} of 5.0 (${reviewList.length} Review)'),
                                SizedBox(
                                  width: 5,
                                ),
                              ],
                            )
                          ],
                        ),
                        Container(
                          height: 350,
                          child: TabBarView(
                            controller: controller,
                            children: [
                              Container(
                                child: Html(data: """<div>
                        <p/>  • SKU: ${widget.data['sku']}</p>
                        <p/>  • Color: ${widget.data['color']}</p>
                        <p/>  • Care Label: ${widget.data['care_label']}</p>
                        <p/>  • Material: ${widget.data['material']}</p>
                  
                        </div>"""),
                              ),
                              Container(
                                child: ListView.separated(
                                    separatorBuilder: (context, index) {
                                      return Divider(
                                        thickness: 2,
                                      );
                                    },
                                    shrinkWrap: false,
                                    itemCount: reviewList.length + 1,
                                    itemBuilder: (context, index) {
                                      if (index == reviewList.length) {
                                        return SizedBox(
                                          height: 100,
                                        );
                                      }
                                      return Column(
                                        children: [
                                          ListTile(
                                              leading: ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(20),
                                                child: Image.asset(
                                                    'assets/images/placeholder_human.jpeg'),
                                              ),
                                              title: Text(
                                                  reviewList[index]['name']),
                                              subtitle: Text(
                                                  'Reviewed in Malaysia on ${reviewList[index]['date']}'),
                                              trailing: (SharedPreferencesUtil
                                                          .userId ==
                                                      reviewList[index]
                                                              ['UserID']
                                                          .toString())
                                                  ? GestureDetector(
                                                      onTap: () =>
                                                          deleteReview(index),
                                                      child: Icon(Icons.cancel))
                                                  : null),
                                          Container(
                                            padding: EdgeInsets.all(10),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Row(children: [
                                                  Row(
                                                      children: List.generate(
                                                    reviewList[index]
                                                        ['star_rating'],
                                                    (index) => Icon(
                                                      Icons.star,
                                                      color: Colors.orange,
                                                      size: 20,
                                                    ),
                                                  )),
                                                  // Text(
                                                  //     " Best 'big men' t'shirts EVER!",
                                                  //     style: TextStyle(
                                                  //         fontWeight:
                                                  //             FontWeight.bold)),
                                                ]),
                                                SizedBox(
                                                  height: 10,
                                                ),
                                                Text(
                                                  '${reviewList[index]['reviews']}',
                                                  textAlign: TextAlign.left,
                                                ),
                                                SizedBox(height: 10),
                                                reviewList[index]['user_pic'] ==
                                                        null
                                                    ? Container()
                                                    : CachedNetworkImage(
                                                        imageUrl:
                                                            '${Custlr.imgUrl}${reviewList[index]['user_pic']}',
                                                      )
                                                // : Image.network(
                                                //     '${Custlr.devUrl}${reviewList[index]['user_pic']}')
                                              ],
                                            ),
                                          )
                                        ],
                                      );
                                    }),
                              ),
                            ],
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
      Align(
        alignment: Alignment.bottomCenter,
        child: PhysicalModel(
          shadowColor: Colors.black,
          elevation: 100,
          color: Colors.white,
          child: index == 1
              ? GestureDetector(
                  onTap: () async {
                    bool value = await Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => AddReview(widget.data)));

                    setState(() {
                      if (value = true) {
                        setState(() {
                          ReviewAPI.review(widget.data['ProductID'])
                              .then((data) {
                            setState(() {
                              widget.data['rating'] = data['rating'];
                              reviewList = data['Product_reviews'];
                              reviewList = reviewList
                                ..sort((a, b) {
                                  return b['ProductReviewID']
                                      .compareTo(a['ProductReviewID']);
                                });
                            });
                          });
                        });
                      }
                    });
                  },
                  child: SizedBox(
                    width: double.infinity,
                    child: Container(
                      alignment: Alignment.center,
                      height: 40,
                      color: Colors.black,

                      child: Text(
                        'Add Review',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, color: Colors.white),
                      ),
                      // child: Column(
                      //   mainAxisSize: MainAxisSize.min,
                      //   children: [
                      //     TextField(
                      //       textInputAction: TextInputAction.next,
                      //       textAlign: TextAlign.left,
                      //       controller: commentController,
                      //       keyboardType: TextInputType.text,
                      //       decoration: InputDecoration(
                      //         prefixStyle: TextStyle(color: Colors.white),
                      //         prefixIcon: GestureDetector(
                      //             onTap: () {
                      //               showModalBottomSheet(
                      //                   context: context,
                      //                   builder: (context) {
                      //                     return StatefulBuilder(builder:
                      //                         (BuildContext context,
                      //                             StateSetter modalState) {
                      //                       return Column(
                      //                           mainAxisSize: MainAxisSize.min,
                      //                           children: [
                      //                             GestureDetector(
                      //                               onTap: () {
                      //                                 getCamera();
                      //                                 Navigator.pop(context);
                      //                               },
                      //                               child: ListTile(
                      //                                 leading:
                      //                                     Icon(Icons.camera_alt),
                      //                                 title: Text('Take Camera'),
                      //                               ),
                      //                             ),
                      //                             GestureDetector(
                      //                               onTap: () {
                      //                                 getGallery();
                      //                                 Navigator.pop(context);
                      //                               },
                      //                               child: ListTile(
                      //                                 leading: Icon(Icons.image),
                      //                                 title: Text('From Gallery'),
                      //                               ),
                      //                             ),
                      //                           ]);
                      //                     });
                      //                   });
                      //             },
                      //             child: Icon(Icons.camera_alt)),
                      //         hintText: 'Comment',
                      //         hintStyle: TextStyle(fontSize: 16),
                      //         border: OutlineInputBorder(
                      //           borderRadius: BorderRadius.circular(20),
                      //           borderSide: BorderSide(
                      //             width: 0,
                      //             style: BorderStyle.none,
                      //           ),
                      //         ),
                      //         suffixIcon: GestureDetector(
                      //           onTap: () async => addReview(context),
                      //           child: Container(
                      //             margin: EdgeInsets.all(5),
                      //             decoration: BoxDecoration(
                      //                 borderRadius: BorderRadius.circular(20),
                      //                 color: Colors.black),
                      //             child: Icon(
                      //               Icons.keyboard_arrow_right,
                      //               color: Colors.white,
                      //             ),
                      //           ),
                      //         ),
                      //         filled: true,
                      //         contentPadding: EdgeInsets.symmetric(
                      //             vertical: 10, horizontal: 20),
                      //         fillColor: Colors.grey[200],
                      //       ),
                      //     ),
                      //     SizedBox(
                      //       height: 10,
                      //     ),
                      //     img != null ? Image.file(img) : Container()
                      //   ],
                      // ),
                    ),
                  ),
                )
              : Container(
                  margin: EdgeInsets.all(10),
                  height: 40,
                  child: Row(
                    children: [
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            oneClickCheckout(context);
                          },
                          child: SizedBox(
                            height: double.infinity,
                            child: Container(
                              margin: EdgeInsets.symmetric(horizontal: 10),
                              decoration: BoxDecoration(
                                color: Colors.blue,
                                borderRadius: BorderRadius.circular(30),
                              ),
                              child: Center(
                                  child: isOneClickCheckout
                                      ? Container(
                                          child: SpinKitFadingCircle(
                                            color: Colors.white,
                                            size: 30.0,
                                          ),
                                        )
                                      : Text(
                                          'One Click Checkout',
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 12),
                                        )),
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            setState(() {
                              // Go page 2
                              widget.onChanged(1);
                              // _processIndex = (_processIndex + 1) % _processes.length;
                            });
                          },
                          child: SizedBox(
                            height: double.infinity,
                            child: Container(
                              margin: EdgeInsets.symmetric(horizontal: 10),
                              decoration: BoxDecoration(
                                color: Colors.black,
                                borderRadius: BorderRadius.circular(30),
                              ),
                              child: Center(
                                  child: Text(
                                'Get Fitted',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold),
                              )),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
        ),
      ),
    ]);
  }

  void oneClickCheckout(context) {
    Provider.of<Measurement>(context, listen: false).isA4Fit = false;
    setState(() {
      isOneClickCheckout = true;
      MeasurementAPI.measurementListAPI().then((value) {
        print(value);
        if (value['user_measurement'].isEmpty) {
          setState(() {
            isOneClickCheckout = false;
            Fluttertoast.showToast(
              toastLength: Toast.LENGTH_LONG,
              msg: "Please set profile measurement first",
            );
          });
        } else {
          setState(() {
            isOneClickCheckout = false;
            // Go page 3
            final convertionList =
                Provider.of<Measurement>(context, listen: false)
                    .productConversion;
            List measureList = [
              {
                'name': 'Height',
                'conversion':
                    double.parse(convertionList['height_conversion'] ?? '0.00'),
                'body': double.parse(
                    value['user_measurement'][0]['height'].toString()),
                'final': double.parse(
                        value['user_measurement'][0]['height'].toString()) +
                    double.parse(convertionList['height_conversion'] ?? '0.00'),
              },
              {
                'name': 'Chest',
                'conversion':
                    double.parse(convertionList['chest_conversion'] ?? '0.00'),
                'body': double.parse(
                    value['user_measurement'][0]['chest'].toString()),
                'final': double.parse(
                        value['user_measurement'][0]['chest'].toString()) +
                    double.parse(convertionList['chest_conversion'] ?? '0.00'),
              },
              {
                'name': 'Shoulder',
                'conversion': double.parse(
                    convertionList['shoulder_conversion'] ?? '0.00'),
                'body': double.parse(
                    value['user_measurement'][0]['shoulder'].toString()),
                'final': double.parse(
                        value['user_measurement'][0]['shoulder'].toString()) +
                    double.parse(
                        convertionList['shoulder_conversion'] ?? '0.00'),
              },
              {
                'name': 'Bicep',
                'conversion':
                    double.parse(convertionList['bicep_conversion'] ?? '0.00'),
                'body': double.parse(
                    value['user_measurement'][0]['bicep'].toString()),
                'final': double.parse(
                        value['user_measurement'][0]['bicep'].toString()) +
                    double.parse(convertionList['bicep_conversion'] ?? '0.00'),
              },
              {
                'name': 'Arm Length',
                'conversion': double.parse(
                    convertionList['arm_length_conversion'] ?? '0.00'),
                'body': double.parse(
                    value['user_measurement'][0]['arm_length'].toString()),
                'final': double.parse(
                        value['user_measurement'][0]['arm_length'].toString()) +
                    double.parse(
                        convertionList['arm_length_conversion'] ?? '0.00'),
              },
              {
                'name': 'Waist',
                'conversion':
                    double.parse(convertionList['waist_conversion'] ?? '0.00'),
                'body': double.parse(
                    value['user_measurement'][0]['waist'].toString()),
                'final': double.parse(
                        value['user_measurement'][0]['waist'].toString()) +
                    double.parse(convertionList['waist_conversion'] ?? '0.00'),
              },
              {
                'name': 'Hip',
                'conversion':
                    double.parse(convertionList['hip_conversion'] ?? '0.00'),
                'body': double.parse(
                    value['user_measurement'][0]['hip'].toString()),
                'final': double.parse(
                        value['user_measurement'][0]['hip'].toString()) +
                    double.parse(convertionList['hip_conversion'] ?? '0.00'),
              },
              {
                'name': 'Dress Length',
                'conversion': double.parse(
                    convertionList['dress_length_conversion'] ?? '0.00'),
                'body': double.parse(
                    value['user_measurement'][0]['dress_length'].toString()),
                'final': double.parse(value['user_measurement'][0]
                            ['dress_length']
                        .toString()) +
                    double.parse(
                        convertionList['dress_length_conversion'] ?? '0.00'),
              },
            ];
            print(measureList);
            final dataMeasurement =
                Provider.of<Measurement>(context, listen: false);
            dataMeasurement.bodyMeasurement = measureList;
            widget.onChanged(2);
          });
        }
      });
    });
  }

  addReview(BuildContext context) async {
    double rate = 2.5;
    Alert(
      context: context,
      title: 'Rating',
      content: RatingBar.builder(
        initialRating: 2.5,
        minRating: 1,
        direction: Axis.horizontal,
        // allowHalfRating: true,
        itemCount: 5,
        itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
        itemBuilder: (context, _) => Icon(
          Icons.star,
          color: Colors.amber,
        ),
        onRatingUpdate: (rating) {
          rate = rating;
        },
      ),
      buttons: [
        DialogButton(
            child: Text(
              'SENT',
              style:
                  TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
            ),
            onPressed: () async {
              FocusManager.instance.primaryFocus.unfocus();
              Navigator.pop(context);
              // File file = await getImageFileFromAssets('images/logo.jpg');
              final data = {
                'reviews': commentController.text,
                'star_rating': rate,
                'user_pic': img != null
                    ? await dio.MultipartFile.fromFile(img.path,
                        filename: basename(img.path))
                    : '',
                // : await dio.MultipartFile.fromFile(file.path,
                //     filename: basename(file.path)),
                'ProductID': widget.data['ProductID'],
                'vertified': '1',
              };
              commentController.text = '';
              setState(() {
                img = null;
              });
              ReviewAPI.addReview(data).then((value) {
                if (value['status'] == 1) {
                  ReviewAPI.review(widget.data['ProductID']).then((data) {
                    setState(() {
                      widget.data['rating'] = data['rating'];
                      reviewList = data['Product_reviews'];
                      reviewList = reviewList
                        ..sort((a, b) {
                          return b['ProductReviewID']
                              .compareTo(a['ProductReviewID']);
                        });
                    });
                  });
                }
              });
            })
      ],
    ).show().then((value) async {});
  }

  deleteReview(int index) {
    ReviewAPI.deleteReview(reviewList[index]['ProductReviewID']).then((value) {
      if (value['status'] == 1) {
        ReviewAPI.review(widget.data['ProductID']).then((data) {
          setState(() {
            widget.data['rating'] = data['rating'];
            reviewList = data['Product_reviews'];
            reviewList = reviewList
              ..sort((a, b) {
                return b['ProductReviewID'].compareTo(a['ProductReviewID']);
              });
          });
        });
        Fluttertoast.showToast(msg: value['msg']);
      }
    });
  }
}

class ZoomImage extends StatefulWidget {
  ZoomImage(this.images);
  final List images;
  @override
  _ZoomImageState createState() => _ZoomImageState();
}

class _ZoomImageState extends State<ZoomImage> {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
        backgroundColor: Colors.black,
        body: Stack(
          children: [
            Container(
              child: PhotoViewGallery.builder(
                scrollPhysics: BouncingScrollPhysics(),
                builder: (BuildContext context, int index) {
                  return PhotoViewGalleryPageOptions(
                    basePosition: Alignment.center,
                    initialScale: PhotoViewComputedScale.covered / 2,
                    imageProvider: NetworkImage(
                      widget.images[index],
                    ),

                    // Covered = the smallest possible size to fit the whole screen
                    maxScale: PhotoViewComputedScale.covered * 2,
                  );
                },
                backgroundDecoration: BoxDecoration(
                  color: Colors.transparent,
                ),
                itemCount: widget.images.length,
                loadingBuilder: (context, event) => Center(
                  child: Container(
                    width: 20.0,
                    height: 20.0,
                    child: CircularProgressIndicator(
                      value: event == null
                          ? 0
                          : event.cumulativeBytesLoaded /
                              event.expectedTotalBytes,
                    ),
                  ),
                ),
              ),
            ),
            SafeArea(
              child: IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: Icon(
                    Icons.keyboard_arrow_left,
                    color: Colors.white,
                    size: 40,
                  )),
            )
          ],
        ));
  }
}
