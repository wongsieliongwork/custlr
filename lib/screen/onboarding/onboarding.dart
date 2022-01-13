import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:custlr/screen/auth/login_register.dart';
import 'package:custlr/utils/shared_preference_utils.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Onboarding extends StatefulWidget {
  @override
  _OnboardingState createState() => _OnboardingState();
}

class _OnboardingState extends State<Onboarding> {
  // Onboarding image
  List imgPage = [
    'assets/images/Onboarding/No. 1.png',
    'assets/images/Onboarding/No. 2.png',
    'assets/images/Onboarding/No. 3.png'
  ];
  PageController _pageController;
  int currentIndex = 0;

  static const _kDuration = const Duration(milliseconds: 300);
  static const _kCurve = Curves.ease;

  nextFunction() {
    _pageController.nextPage(duration: _kDuration, curve: _kCurve);
  }

  previousFunction() {
    _pageController.previousPage(duration: _kDuration, curve: _kCurve);
  }

  skipFunction() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    pref.setBool('firstUser', true);
    // SharedPreferencesUtil.firstUser = true;
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => LoginRegister(false)));
  }

  onChangedFunction(int index) {
    setState(() {
      currentIndex = index;
    });
  }

  Future update() async {
    await FirebaseFirestore.instance
        .collection('timer')
        .doc('7s40lyfpSG3Uo6loAuOE')
        .get()
        .then((value) {
      print(value['count']);
      FirebaseFirestore.instance
          .collection('timer')
          .doc('7s40lyfpSG3Uo6loAuOE')
          .update({'count': value['count'] + 1});
    });
  }

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          PageView(
            controller: _pageController,
            onPageChanged: onChangedFunction,
            children: List.generate(imgPage.length, (index) {
              return Stack(
                fit: StackFit.expand,
                children: [
                  Image.asset(
                    imgPage[index],
                    fit: BoxFit.cover,
                  ),
                  Align(
                      alignment: Alignment.topCenter,
                      child: SafeArea(
                        child: Container(
                          padding: EdgeInsets.only(top: 20),
                          child: Image.asset(
                            'assets/images/white-logo.png',
                            scale: 10,
                          ),
                        ),
                      )),
                ],
              );
            }),
          ),

          Container(
            padding: EdgeInsets.all(40),
            child: Wrap(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Indicator(
                      positionIndex: 0,
                      currentIndex: currentIndex,
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Indicator(
                      positionIndex: 1,
                      currentIndex: currentIndex,
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Indicator(
                      positionIndex: 2,
                      currentIndex: currentIndex,
                    ),
                  ],
                ),
                SizedBox(),
                Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      InkWell(
                        onTap: () => skipFunction(),
                        child: CircleAvatar(
                          backgroundColor: Colors.white.withOpacity(0.5),
                          radius: 20,
                          child: Icon(
                            Icons.double_arrow,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      InkWell(
                        onTap: () async {
                          if (currentIndex == 2) {
                            SharedPreferences pref =
                                await SharedPreferences.getInstance();
                            SharedPreferencesUtil.firstUser = true;
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        LoginRegister(false)));
                          } else {
                            nextFunction();
                          }
                        },
                        child: CircleAvatar(
                          backgroundColor: Colors.white.withOpacity(0.5),
                          radius: 20,
                          child: Icon(
                            Icons.arrow_forward,
                            color: Colors.white,
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
          // Align(
          //   alignment: Alignment.bottomCenter,
          //   child: Container(
          //     margin: EdgeInsets.symmetric(horizontal: 50, vertical: 80),
          //     child: Row(
          //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //       crossAxisAlignment: CrossAxisAlignment.center,
          //       children: <Widget>[
          //         InkWell(
          //           onTap: () => skipFunction(),
          //           child: CircleAvatar(
          //             backgroundColor: Colors.white.withOpacity(0.5),
          //             radius: 20,
          //             child: Icon(
          //               Icons.double_arrow,
          //               color: Colors.white,
          //             ),
          //           ),
          //         ),
          //         SizedBox(
          //           width: 50,
          //         ),
          //         InkWell(
          //           onTap: () {
          //             if (currentIndex == 2) {
          //               Navigator.push(
          //                   context,
          //                   MaterialPageRoute(
          //                       builder: (context) => LoginRegister()));
          //             } else {
          //               nextFunction();
          //             }
          //           },
          //           child: CircleAvatar(
          //             backgroundColor: Colors.white.withOpacity(0.5),
          //             radius: 20,
          //             child: Icon(
          //               Icons.arrow_forward,
          //               color: Colors.white,
          //             ),
          //           ),
          //         )
          //       ],
          //     ),
          //   ),
          // )
        ],
      ),
    );
  }
}

class Indicator extends StatelessWidget {
  final int positionIndex, currentIndex;
  const Indicator({this.currentIndex, this.positionIndex});
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 12,
      width: 12,
      decoration: BoxDecoration(
          color: positionIndex == currentIndex ? Colors.white : Colors.grey,
          borderRadius: BorderRadius.circular(100)),
    );
  }
}
