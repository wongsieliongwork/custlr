import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:custlr/api/api.dart';
import 'package:custlr/provider/ShoppingPageProvider.dart';
import 'package:custlr/widget/loading.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

class HomeScreen extends StatefulWidget {
  final Function(int) onChanged;
  HomeScreen(this.onChanged);
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List imgList = [
    'assets/images/banner/1.jpeg',
    'assets/images/banner/2.jpeg',
    'assets/images/banner/3.jpeg'
  ];

  List femaleBanner = [];
  List maleBanner = [];
  dynamic tredingBanner = {};
  String imageLogo = '';
  bool isLoading = true;

  void getBannerAPI() {
    API.bannerAPI('home').then((data) {
      femaleBanner = data['woman'];
      maleBanner = data['man'];

      API.tredingAPI('trending').then((value) {
        tredingBanner = value;
        API.tredingAPI('logo').then((logo) {
          imageLogo = logo;
          setState(() {
            isLoading = false;
          });
        });
      });
    });
  }

  List processList = [
    {
      'title': '1. Select Your Product',
      'description':
          'Browse through our fine selection of products that will make your day!',
      'image': 'assets/images/HowToWork/works_img1.png',
    },
    {
      'title': '2. Get Your Fitted!',
      'description':
          'Let us know your measurements and we will get you fitted using Artificial Intelligence and Machine Learning for the best fit.',
      'image': 'assets/images/HowToWork/works_img2.png',
    },
    {
      'title': '3. Checkout!',
      'description':
          'Review your measurements, customizations and simply checkout with no hassle! Easy and Contactless!',
      'image': 'assets/images/HowToWork/works_img3.png',
    },
  ];
// Today Date
  DateTime now = new DateTime.now();

// Carousel
  CarouselController buttonCarouselController1 = CarouselController();
  CarouselController buttonCarouselController2 = CarouselController();

  // Top Customer Reviews

  List topList = [
    {
      'name': 'Suki',
      'role': 'Head Of Marketing',
      'image': 'https://www.custlr.com/images/home/review/picture1.jpg',
      'comment':
          "Online tailored for ladies! It's finally here in Malaysia. The service and communication is amazing. Much recommended!"
    },
    {
      'name': 'Xiao Min',
      'role': 'Head Of Events',
      'image': 'https://www.custlr.com/images/home/review/picture2.jpg',
      'comment':
          "I purchased a black dress from Custlr for date night and the quality is great! The fitting is custom made, no more off the shelf clothes that dont't fit!"
    },
    {
      'name': 'Jesslyn',
      'role': 'Founder Of Consmetic',
      'image': 'https://www.custlr.com/images/home/review/picture3.jpg',
      'comment':
          "I was recommended to Custlr by a friend. I got myself a jump suit and gown. The fitting is spot on! Will shop again!"
    },
    {
      'name': 'Jean',
      'role': 'Miss Elegance Malaysia',
      'image': 'https://www.custlr.com/images/home/review/picture4.jpg',
      'comment':
          "Never thought I'd see the day where Malaysia finally has a dedicated online tailor with guaranteed fitting! Well Done Custlr Team! Thank you!"
    },
    {
      'name': 'Ken Tan',
      'role': 'Director Of ABV',
      'image': 'https://www.custlr.com/images/home/review/picture5.jpg',
      'comment':
          "I was a bit sceptical at first, but Sara helped me throughout the fitting and customizing process. Full 3 piece suit. Come on James Bond look!"
    },
  ];
  @override
  void initState() {
    super.initState();
    getBannerAPI();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return isLoading
        ? Container(
            child: ListView(
              children: [
                Container(
                  padding: EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Shimmer.fromColors(
                        baseColor: Colors.grey[300],
                        highlightColor: Colors.grey[100],
                        child: Container(
                          height: 40,
                          width: 100,
                          color: Colors.grey,
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Shimmer.fromColors(
                        baseColor: Colors.grey[300],
                        highlightColor: Colors.grey[100],
                        child: Container(
                          height: 20,
                          width: 100,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
                Shimmer.fromColors(
                  baseColor: Colors.grey[300],
                  highlightColor: Colors.grey[100],
                  child: Container(
                    height: size.height / 1.5,
                    color: Colors.grey,
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Shimmer.fromColors(
                  baseColor: Colors.grey[300],
                  highlightColor: Colors.grey[100],
                  child: Container(
                    height: size.height / 1.5,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          )
        : Scaffold(
            body: ListView(
              children: [
                Container(
                  padding: EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Image.asset(
                        'assets/images/black-logo.png',
                        height: 40,
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        DateFormat('EEEE, d MMM yyyy').format(now),
                        style: TextStyle(color: Colors.grey),
                      ),
                    ],
                  ),
                ),
                Column(
                  children: List.generate(2, (index) {
                    List banner = [];
                    if (index == 0) {
                      banner = femaleBanner;
                    } else if (index == 1) {
                      banner = maleBanner;
                    }
                    return Container(
                      height: size.height / 1.5,
                      child: Stack(
                        children: [
                          Container(
                            margin: EdgeInsets.only(bottom: 10),
                            child: CarouselSlider(
                                carouselController: index == 0
                                    ? buttonCarouselController1
                                    : buttonCarouselController2,
                                options: CarouselOptions(
                                  height: size.height / 1.5,
                                  viewportFraction: 1.0,
                                  enlargeCenterPage: false,
                                  autoPlay: true,
                                ),
                                items: List.generate(banner.length, (index) {
                                  return CachedNetworkImage(
                                    imageUrl: banner[index]['banner_url'],
                                    placeholder: (context, url) {
                                      return Container(
                                        color: Colors.grey,
                                      );
                                    },
                                    fit: BoxFit.cover,
                                    width: size.width,
                                  );
                                })),
                          ),
                          Positioned(
                            bottom: 60,
                            right: 20,
                            child: GestureDetector(
                              onTap: () {
                                if (index == 0) {
                                  Provider.of<ShoppingPageProvider>(context,
                                          listen: false)
                                      .isFemale = true;
                                } else if (index == 1) {
                                  Provider.of<ShoppingPageProvider>(context,
                                          listen: false)
                                      .isFemale = false;
                                }

                                widget.onChanged(2);
                              },
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 30, vertical: 15),
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(40)),
                                child: Text(
                                  'Learn More',
                                ),
                              ),
                            ),
                          ),
                          // < > button
                          Align(
                            alignment: Alignment.centerLeft,
                            child: GestureDetector(
                              onTap: () {
                                if (index == 0) {
                                  buttonCarouselController1.previousPage(
                                      duration: Duration(milliseconds: 300),
                                      curve: Curves.linear);
                                } else {
                                  buttonCarouselController2.previousPage(
                                      duration: Duration(milliseconds: 300),
                                      curve: Curves.linear);
                                }
                              },
                              child: Icon(
                                Icons.keyboard_arrow_left,
                                size: 50,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          Align(
                            alignment: Alignment.centerRight,
                            child: GestureDetector(
                              onTap: () {
                                if (index == 0) {
                                  buttonCarouselController1.nextPage(
                                      duration: Duration(milliseconds: 300),
                                      curve: Curves.linear);
                                } else {
                                  buttonCarouselController2.nextPage(
                                      duration: Duration(milliseconds: 300),
                                      curve: Curves.linear);
                                }
                              },
                              child: Icon(
                                Icons.keyboard_arrow_right,
                                size: 50,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  }),
                ),
                SizedBox(
                  height: 20,
                ),
                Text(
                  '    How It Work',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                Column(
                  children: List.generate(
                      processList.length,
                      (index) => Container(
                            padding: EdgeInsets.all(15),
                            child: Row(
                              children: [
                                ClipOval(
                                  child: Image.asset(
                                    processList[index]['image'],
                                    height: 100,
                                    width: 100,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                Expanded(
                                  child: Container(
                                    padding: EdgeInsets.all(20),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Text(
                                          processList[index]['title'],
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold),
                                        ),
                                        Text(
                                          processList[index]['description'],
                                        )
                                      ],
                                    ),
                                  ),
                                )
                              ],
                            ),
                          )),
                ),
                Text(
                  '    Top Customer Reviews',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                Column(
                  children: List.generate(
                      topList.length,
                      (index) => Container(
                            padding: EdgeInsets.all(15),
                            child: Row(
                              children: [
                                ClipOval(
                                  child: Image.network(
                                    topList[index]['image'],
                                    height: 100,
                                    width: 100,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                Expanded(
                                  child: Container(
                                    padding: EdgeInsets.all(20),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            Text(
                                              topList[index]['name'],
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            SizedBox(
                                              width: 10,
                                            ),
                                            RatingBar.builder(
                                              initialRating: 5,
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
                                          ],
                                        ),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        Text(
                                          topList[index]['comment'],
                                        )
                                      ],
                                    ),
                                  ),
                                )
                              ],
                            ),
                          )),
                ),
                Text(
                  '    Top Trending by custlr',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: 20,
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: StaggeredGridView.count(
                    shrinkWrap: true,
                    crossAxisCount: 3,
                    children: List.generate(tredingBanner.length, (index) {
                      return Container(
                        child: CachedNetworkImage(
                          imageUrl: tredingBanner.values.toList()[index],
                          placeholder: (context, url) => Container(
                            color: Colors.grey,
                          ),
                          fit: BoxFit.cover,
                        ),
                      );
                    }),
                    mainAxisSpacing: 4.0,
                    crossAxisSpacing: 4.0,
                    staggeredTiles: [
                      StaggeredTile.count(2, 1),
                      StaggeredTile.count(1, 1),
                      StaggeredTile.count(1, 1),
                      StaggeredTile.count(2, 1),
                    ],
                  ),
                ),
                Divider(),
                Text(
                  '    As Seen On',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                Container(
                    padding: EdgeInsets.all(15),
                    child: Image.network(imageLogo)),
                SizedBox(
                  height: 20,
                ),
              ],
            ),
          );
  }
}
