import 'package:custlr/utils/constants.dart';
import 'package:custlr/provider/ShoppingPageProvider.dart';
import 'package:custlr/common/dynamic_link_service.dart';
import 'package:custlr/screen/MainTabBar/main_tab_bar.dart';
import 'package:custlr/screen/shopping_screen/shopping_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ChooseGender extends StatefulWidget {
  @override
  _ChooseGenderState createState() => _ChooseGenderState();
}

class _ChooseGenderState extends State<ChooseGender> {
  List image = [
    'assets/images/lady-pic.jpg',
    'assets/images/male-pic.png',
  ];
  bool isFemale = true;
  PageController _pageController;
  static const _kDuration = const Duration(milliseconds: 300);
  static const _kCurve = Curves.ease;
  goFemaleFunction() {
    setState(() {
      isFemale = false;
    });
    _pageController.animateToPage(1, duration: _kDuration, curve: _kCurve);
  }

  goMaleFunction() {
    setState(() {
      isFemale = true;
    });
    _pageController.animateToPage(0, duration: _kDuration, curve: _kCurve);
  }

  @override
  void initState() {
    _pageController = PageController();

    super.initState();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Custlr().initializeConstants(context);
    return Scaffold(
      body: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          PageView(
            controller: _pageController,
            onPageChanged: (int value) {
              setState(() {
                if (value == 1) {
                  isFemale = false;
                } else {
                  isFemale = true;
                }
              });
            },
            children: List.generate(
              image.length,
              (index) => Image.asset(
                image[index],
                fit: BoxFit.cover,
              ),
            ),
          ),
          Container(
              child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GestureDetector(
                      onTap: () {
                        goMaleFunction();
                      },
                      child: Text(
                        'Ladies',
                        style: TextStyle(
                            fontWeight: isFemale ? FontWeight.bold : null,
                            color: isFemale ? Colors.white : Colors.grey,
                            fontSize: 20),
                      )),
                  Text(
                    ' | ',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        fontSize: 20),
                  ),
                  GestureDetector(
                      onTap: () {
                        goFemaleFunction();
                      },
                      child: Text(
                        'Men',
                        style: TextStyle(
                            fontWeight: isFemale ? null : FontWeight.bold,
                            color: isFemale ? Colors.grey : Colors.white,
                            fontSize: 20),
                      )),
                ],
              ),
              SizedBox(
                height: 20,
              ),
              Text(
                isFemale ? 'Swipe for Men >>' : '<< Swipe for Women',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(
                height: 120,
              ),
              GestureDetector(
                onTap: () {
                  Provider.of<ShoppingPageProvider>(context, listen: false)
                      .isFemale = isFemale;
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => MainTabBar()));
                },
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    'Explore',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              SizedBox(
                height: 100,
              ),
            ],
          )),
          Align(
            alignment: Alignment.topRight,
            child: Container(
              padding: EdgeInsets.only(top: 15, right: 30),
              child: SafeArea(
                child: Image.asset(
                  'assets/images/logo.jpg',
                  scale: 20,
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
