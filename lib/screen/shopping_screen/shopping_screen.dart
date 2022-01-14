import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:custlr/api/api.dart';
import 'package:custlr/provider/ShoppingPageProvider.dart';
import 'package:custlr/provider/viewcartProvider.dart';
import 'package:custlr/screen/drawer/drawer.dart';
import 'package:custlr/screen/shopping_screen/new_top_featured.dart';
import 'package:custlr/screen/product_detail/product_detail.dart';
import 'package:custlr/screen/show_all/show_all.dart';
import 'package:custlr/screen/view_cart/view_cart.dart';
import 'package:custlr/utils/shared_preference_utils.dart';
import 'package:flutter/material.dart';
import 'package:material_floating_search_bar/material_floating_search_bar.dart';
import 'package:provider/provider.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shimmer/shimmer.dart';

class ShoppingScreen extends StatefulWidget {
  @override
  _ShoppingScreenState createState() => _ShoppingScreenState();
}

class _ShoppingScreenState extends State<ShoppingScreen> {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  String email = '';

  void sharedPreference() async {
    SharedPreferences pref = await SharedPreferences.getInstance();

    setState(() {
      email = pref.getString('email');
    });
  }

  List imgList = [
    'assets/images/banner/1.jpeg',
    'assets/images/banner/2.jpeg',
    'assets/images/banner/3.jpeg'
  ];
  @override
  void initState() {
    super.initState();
    callProviderHome();
    sharedPreference();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final data = Provider.of<ShoppingPageProvider>(context);
    final dataViewCart = Provider.of<ViewCartProvider>(context);
    final productList = data.productList;
    final topList = data.topList;
    final featuredList = data.featuredList;
    final isLoading = data.isLoading;
    final bannerList = data.bannerList;

    return Scaffold(
      key: scaffoldKey,
      backgroundColor: Colors.white,
      drawer: CustlrDrawer(),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        leading: Row(
          children: [
            SizedBox(
              width: 10,
            ),
            GestureDetector(
              onTap: () {
                scaffoldKey.currentState.openDrawer();
              },
              child: Icon(
                Icons.menu,
                color: Colors.black,
              ),
            ),
          ],
        ),
        title: GestureDetector(
          onTap: () {
            print(dataViewCart.cartLength);
          },
          child: Center(
            child: Image.asset(
              'assets/images/black-logo.png',
              scale: 2,
            ),
          ),
        ),
        actions: [
          SizedBox(
            width: 10,
          ),
          Container(
            padding: EdgeInsets.all(10),
            child: GestureDetector(
              onTap: () async {
                if (SharedPreferencesUtil.isLogIn) {
                  bool value = await Navigator.push(context,
                      MaterialPageRoute(builder: (context) => ViewCart()));

                  if (value == true) {
                    setState(() {});
                  }
                } else {
                  Alert(
                      context: context,
                      title: 'You are the guest\nPlease log in first.',
                      buttons: [
                        DialogButton(
                          child: Text(
                            "LOG IN",
                            style: TextStyle(color: Colors.white, fontSize: 20),
                          ),
                          onPressed: () =>
                              Navigator.pushNamed(context, 'Log In'),
                          width: 100,
                        ),
                      ]).show();
                }
              },
              child: Icon(
                Icons.shopping_cart_outlined,
                color: Colors.black,
              ),
            ),
          ),
          SizedBox(
            width: 10,
          ),
        ],
      ),
      body: isLoading
          ? Container(
              child: ListView(
                children: [
                  Shimmer.fromColors(
                    baseColor: Colors.grey[300],
                    highlightColor: Colors.grey[100],
                    child: Container(
                      height: size.width,
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
                      height: size.width / 3,
                      width: size.width,
                      color: Colors.grey,
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Column(
                    children: [
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 15),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Shimmer.fromColors(
                              baseColor: Colors.grey[300],
                              highlightColor: Colors.grey[100],
                              child: Container(
                                height: 20,
                                width: 100,
                                color: Colors.grey,
                              ),
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
                      SizedBox(
                        height: 20,
                      ),
                      Shimmer.fromColors(
                        baseColor: Colors.grey[300],
                        highlightColor: Colors.grey[100],
                        child: Container(
                          height: size.width / 1.2,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  )
                ],
              ),
            )
          : RefreshIndicator(
              onRefresh: callProviderHome,
              child: ListView(
                shrinkWrap: true,
                children: [
                  bannerList.isEmpty
                      ? Container(
                          height: size.width,
                          color: Colors.grey,
                        )
                      : Builder(
                          builder: (context) {
                            return CarouselSlider(
                                options: CarouselOptions(
                                  height: size.width,
                                  viewportFraction: 1.0,
                                  enlargeCenterPage: false,
                                  autoPlay: true,
                                ),
                                items:
                                    List.generate(bannerList.length, (index) {
                                  return CachedNetworkImage(
                                    imageUrl: bannerList[index]['banner_url'],
                                    placeholder: (context, url) => Container(
                                      height: size.width,
                                      color: Colors.grey,
                                    ),
                                    errorWidget: (context, url, error) =>
                                        Container(
                                      height: size.width,
                                      color: Colors.grey,
                                    ),
                                  );
                                }));
                          },
                        ),
                  SizedBox(
                    height: 10,
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  ShowAll('New arrivals', productList)));
                    },
                    child: Stack(
                      alignment: Alignment.topLeft,
                      children: [
                        Image.asset(
                          'assets/images/new_arrivals.png',
                          height: size.width / 3,
                          width: size.width,
                          fit: BoxFit.cover,
                          alignment: Alignment.topCenter,
                        ),
                        Container(
                          padding: EdgeInsets.all(10),
                          child: Text(
                            'NEW ARRIVALS',
                            style: TextStyle(fontSize: 18),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Container(
                    child: Column(
                      children: [
                        NewTopFeatured('Top Selling', topList, productList),
                        // SizedBox(
                        //   height: 10,
                        // ),
                        NewTopFeatured('Featured', featuredList, productList),
                        SizedBox(
                          height: 20,
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        ShowAll('New arrivals', productList)));
                          },
                          child: Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 20, vertical: 15),
                            decoration: BoxDecoration(
                                color: Colors.black,
                                borderRadius: BorderRadius.circular(20)),
                            child: Text(
                              'See ALL >>',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  Future callProviderHome() async {
    Provider.of<ShoppingPageProvider>(context, listen: false).isLoading = true;
    Provider.of<ShoppingPageProvider>(context, listen: false).getAPI();
    Provider.of<ViewCartProvider>(context, listen: false).getViewCartAPI();
    // Provider.of<ViewCartProvider>(context, listen: false).isLoading = true;
  }

  List searchList = [];
  void getSearchAPI(final name) async {
    API.searchProduct(name).then((value) {
      searchList = value['product'];
      setState(() {});
    });
  }

  Widget buildFloatingSearchBar() {
    final isPortrait =
        MediaQuery.of(context).orientation == Orientation.portrait;
    return FloatingSearchBar(
      hint: 'Search...',
      scrollPadding: const EdgeInsets.only(top: 16, bottom: 56),
      transitionDuration: const Duration(milliseconds: 800),
      transitionCurve: Curves.easeInOut,
      physics: const BouncingScrollPhysics(),
      axisAlignment: isPortrait ? 0.0 : -1.0,
      openAxisAlignment: 0.0,
      width: isPortrait ? 600 : 500,
      debounceDelay: const Duration(milliseconds: 500),
      onQueryChanged: (query) {
        setState(() {
          if (query == '') {
            searchList = [];
          } else {
            getSearchAPI(query);
          }
        });
      },
      transition: CircularFloatingSearchBarTransition(),
      actions: [
        FloatingSearchBarAction.searchToClear(
          showIfClosed: true,
        ),
      ],
      builder: (context, transition) {
        return ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Material(
            color: Colors.white,
            elevation: 4.0,
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: List.generate(searchList.length, (index) {
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  ProductDetail(searchList[index])));
                    },
                    child: SizedBox(
                      width: double.infinity,
                      child: Container(
                          decoration: BoxDecoration(
                              border: Border(
                            bottom:
                                BorderSide(color: Colors.grey.withOpacity(0.5)),
                          )),
                          padding: EdgeInsets.all(20),
                          child: Text(searchList[index]['product_name'])),
                    ),
                  );
                })),
          ),
        );
      },
    );
  }
}
