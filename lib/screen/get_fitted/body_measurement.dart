import 'dart:developer';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:custlr/api/measurementAPI.dart';
import 'package:custlr/widget/showDialog.dart';
import 'package:custlr/model/measurementModel.dart';
import 'package:custlr/utils/constants.dart';
import 'package:custlr/provider/Measurement.dart';
import 'package:custlr/provider/ShoppingPageProvider.dart';
import 'package:custlr/screen/profile_screen/my_measurement.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

class BodyMeasurement extends StatefulWidget {
  BodyMeasurement(
      {this.data,
      this.isStandardSizing = false,
      this.isCart = false,
      this.isDressingMeasurement = false});
  final MeasurementModel data;
  final bool isStandardSizing;
  final bool isCart;
  final bool isDressingMeasurement;

  @override
  _BodyMeasurementState createState() => _BodyMeasurementState();
}

class _BodyMeasurementState extends State<BodyMeasurement> {
  int _current = 0;
  final remarkController = TextEditingController();

  final enterSize = TextEditingController();

// Measure List
  List measureList = [];

  void getMeasure(double height, double width) {
    bool isFemale;
    if (widget.isCart) {
      if (widget.data.gender == "Woman") {
        isFemale = true;
      } else {
        isFemale = false;
      }
      remarkController.text = widget.data.review;
    } else {
      // remarkController.text = Provider.of<Measurement>(context, listen: false)
      //     .data['review']
      //     .toString();
      print('Data == >${widget.data}');
      isFemale =
          Provider.of<ShoppingPageProvider>(context, listen: false).isFemale;
    }

    dynamic convertionList;
    if (widget.isDressingMeasurement) {
      convertionList = {
        "chest_conversion": "0.00",
        "shoulder_conversion": "0.00",
        "arm_length_conversion": "0.00",
        "bicep_conversion": "0.00",
        "waist_conversion": "0.00"
      };
    } else {
      convertionList =
          Provider.of<Measurement>(context, listen: false).productConversion;
    }

    if (isFemale) {
      measureList = [
        {
          'name': 'Height',
          'parameter': 'height',
          'image': 'assets/images/bodyMeasurement/Height.png',
          'top': height / 20,
          'left': width / 30,
          'conversion':
              double.parse(convertionList['height_conversion'] ?? '0.00'),
          'body': double.parse(widget.data.height.toString()),
          'final': double.parse(widget.data.height.toString()) +
              double.parse(convertionList['height_conversion'] ?? '0.00'),
        },
        {
          'name': 'Chest',
          'parameter': 'chest',
          'image': 'assets/images/bodyMeasurement/chest.png',
          'top': height / 5,
          'left': width / 2.6,
          'conversion':
              double.parse(convertionList['chest_conversion'] ?? '0.00'),
          'body': double.parse(widget.data.chest.toString()),
          'final': double.parse(widget.data.chest.toString()) +
              double.parse(convertionList['chest_conversion'] ?? '0.00'),
        },
        {
          'name': 'Shoulder',
          'parameter': 'shoulder',
          'image': 'assets/images/bodyMeasurement/shoulder.png',
          'top': height / 9,
          'left': width / 30,
          'conversion':
              double.parse(convertionList['shoulder_conversion'] ?? '0.00'),
          'body': double.parse(widget.data.shoulder.toString()),
          'final': double.parse(widget.data.shoulder.toString()) +
              double.parse(convertionList['shoulder_conversion'] ?? '0.00'),
        },
        // {
        //   'name': 'Bicep',
        //   'parameter': 'bicep',
        //   'image': 'assets/images/bodyMeasurement/arm.png',
        //   'top': height / 5,
        //   'left': width / 1.4,
        //   'conversion':
        //       double.parse(convertionList['bicep_conversion'] ?? '0.00'),
        //   'body': double.parse(widget.data.bicep.toString()),
        //   'final': double.parse(widget.data.bicep.toString()) +
        //       double.parse(convertionList['bicep_conversion'] ?? '0.00'),
        // },
        {
          'name': 'Arm Length',
          'parameter': 'arm_length',
          'image': 'assets/images/bodyMeasurement/arm_length.png',
          'top': height / 9,
          'left': width / 1.7,
          'conversion':
              double.parse(convertionList['arm_length_conversion'] ?? '0.00'),
          'body': double.parse(widget.data.armLength.toString()),
          'final': double.parse(widget.data.armLength.toString()) +
              double.parse(convertionList['arm_length_conversion'] ?? '0.00'),
        },
        {
          'name': 'Waist',
          'parameter': 'waist',
          'image': 'assets/images/bodyMeasurement/waist.png',
          'top': height / 3.5,
          'left': width / 2.6,
          'conversion':
              double.parse(convertionList['waist_conversion'] ?? '0.00'),
          'body': double.parse(widget.data.waist.toString()),
          'final': double.parse(widget.data.waist.toString()) +
              double.parse(convertionList['waist_conversion'] ?? '0.00'),
        },
        {
          'name': 'Hip',
          'parameter': 'hip',
          'image': 'assets/images/bodyMeasurement/Hip.png',
          'top': height / 2.5,
          'left': width / 2.6,
          'conversion':
              double.parse(convertionList['hip_conversion'] ?? '0.00'),
          'body': double.parse(widget.data.hip.toString()),
          'final': double.parse(widget.data.hip.toString()) +
              double.parse(convertionList['hip_conversion'] ?? '0.00'),
        },
        {
          'name': 'Dress Length',
          'parameter': 'dress_length',
          'image': 'assets/images/bodyMeasurement/Dress Length.png',
          'top': height / 2,
          'left': width / 3,
          'conversion':
              double.parse(convertionList['dress_length_conversion'] ?? '0.00'),
          'body': double.parse(widget.data.dressLength.toString()),
          'final': double.parse(widget.data.dressLength.toString()) +
              double.parse(convertionList['dress_length_conversion'] ?? '0.00'),
        },
      ];
    } else {
      measureList = [
        {
          'name': 'Height',
          'parameter': 'height',
          'image': 'assets/images/bodyMeasurement/Height.png',
          'top': height / 35,
          'left': width / 30,
          'conversion':
              double.parse(convertionList['height_conversion'] ?? '0.00'),
          'body': double.parse(widget.data.height.toString()),
          'final': double.parse(widget.data.height.toString()) +
              double.parse(convertionList['height_conversion'] ?? '0.00'),
        },
        {
          'name': 'Chest',
          'parameter': 'chest',
          'image': 'assets/images/bodyMeasurement/chest.png',
          'top': height / 3.5,
          'left': width / 2.6,
          'conversion':
              double.parse(convertionList['chest_conversion'] ?? '0.00'),
          'body': double.parse(widget.data.chest.toString()),
          'final': double.parse(widget.data.chest.toString()) +
              double.parse(convertionList['chest_conversion'] ?? '0.00'),
        },
        {
          'name': 'Shoulder',
          'parameter': 'shoulder',
          'image': 'assets/images/bodyMeasurement/shoulder.png',
          'top': height / 5,
          'left': width / 1.9,
          'conversion':
              double.parse(convertionList['shoulder_conversion'] ?? '0.00'),
          'body': double.parse(widget.data.shoulder.toString()),
          'final': double.parse(widget.data.shoulder.toString()) +
              double.parse(convertionList['shoulder_conversion'] ?? '0.00'),
        },
        {
          'name': 'Arm Length',
          'parameter': 'arm_length',
          'image': 'assets/images/bodyMeasurement/arm_length.png',
          'top': height / 1.7,
          'left': width / 2.2,
          'conversion':
              double.parse(convertionList['arm_length_conversion'] ?? '0.00'),
          'body': double.parse(widget.data.armLength.toString()),
          'final': double.parse(widget.data.armLength.toString()) +
              double.parse(convertionList['arm_length_conversion'] ?? '0.00'),
        },
        {
          'name': 'Waist',
          'parameter': 'waist',
          'image': 'assets/images/bodyMeasurement/waist.png',
          'top': height / 2,
          'left': width / 3,
          'conversion':
              double.parse(convertionList['waist_conversion'] ?? '0.00'),
          'body': double.parse(widget.data.waist.toString()),
          'final': double.parse(widget.data.waist.toString()) +
              double.parse(convertionList['waist_conversion'] ?? '0.00'),
        },
        {
          'name': 'Bicep',
          'parameter': 'bicep',
          'image': 'assets/images/bodyMeasurement/arm.png',
          'top': height / 2.5,
          'left': width / 1.65,
          'conversion':
              double.parse(convertionList['bicep_conversion'] ?? '0.00'),
          'body': double.parse(widget.data.bicep.toString()),
          'final': double.parse(widget.data.bicep.toString()) +
              double.parse(convertionList['bicep_conversion'] ?? '0.00'),
        },
      ];
    }
  }

// Profile Measurement
  String _chosenValue = '';

  List profileList = [];

  void getProfileAPI() {
    MeasurementAPI.measurementListAPI().then((value) {
      profileList = value['user_measurement'];
      setState(() {
        if (profileList.isEmpty) {
          _chosenValue = "Add Profile";
        } else {
          _chosenValue = "Select Profile";
        }
      });
    });
  }

  bool isHide = false;
  @override
  void initState() {
    super.initState();
    getProfileAPI();
    getMeasure(Custlr.height, Custlr.width);
  }

  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  final focusNode = FocusNode();
  @override
  Widget build(BuildContext context) {
    //getMeasure(Custlr.height, Custlr.width);
    final isKeyboard = MediaQuery.of(context).viewInsets.bottom != 0;
    final dataMeasurement = Provider.of<Measurement>(context);
    final dataHome = Provider.of<ShoppingPageProvider>(context);
    final data = dataMeasurement.data;
    Map bodyPattern = dataMeasurement.bodyPattern;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: GestureDetector(
          onTap: () {
            log('$measureList');
          },
          child: GestureDetector(
            onTap: () {
              print(widget.data);
            },
            child: Text(
              widget.isDressingMeasurement
                  ? "Dress Measurement"
                  : 'Body Measurement',
              style: TextStyle(color: Colors.black),
            ),
          ),
        ),
        actions: [
          // GestureDetector(
          //     onTap: () {
          //       setState(() {
          //         isHide = !isHide;
          //       });
          //     },
          //     child: Icon(!isHide ? Icons.visibility : Icons.visibility_off)),
          // SizedBox(
          //   width: 10,
          // ),
          GestureDetector(
              onTap: () => ShowDialog().theDifference(context),
              child: Icon(Icons.info)),
          SizedBox(
            width: 10,
          ),
        ],
      ),
      body: Stack(
        children: [
          Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              Expanded(
                child: Image.network(
                  data['banner'] ?? 'https://${data['product_image']}',
                  fit: BoxFit.cover,
                ),
              ),
            ],
          ),
          if (!widget.isCart)
            Visibility(
              visible: !isHide,
              child: Align(
                alignment: Alignment.topRight,
                child: GestureDetector(
                  onTap: () async {
                    if (profileList.isEmpty) {
                      bool value = await Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => MyMeasurement(false)));
                      setState(() {
                        if (value == true) {
                          getProfileAPI();
                        }
                      });
                    }
                  },
                  child: Container(
                    height: 40,
                    margin: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Colors.white,
                      border: Border.all(
                        color: Colors.black,
                      ),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton(
                        hint: Text(_chosenValue.toString()),
                        onChanged: (final value) {
                          setState(() {
                            print(value);
                            _chosenValue = value['name'];
                            Fluttertoast.showToast(
                                msg: 'Selected successfully',
                                gravity: ToastGravity.CENTER);

                            measureList.forEach((data) {
                              data['body'] = value[data['parameter']];
                              print(data['conversion']);

                              data['final'] = value[data['parameter']];

                              // data['final'] = double.parse(
                              //         value[data['parameter']]) +
                              //     double.parse(
                              //         measureList[0]['conversion'].toString());
                            });
                          });
                        },
                        items: profileList.map(
                          (e) {
                            return DropdownMenuItem<dynamic>(
                              value: e,
                              child: Row(
                                children: [
                                  Text(
                                    e['name'],
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ).toList(),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          Visibility(
            visible: !isHide,
            child: Stack(
              children: List.generate(measureList.length, (index) {
                return Positioned(
                    top: measureList[index]['top'],
                    left: measureList[index]['left'],
                    child: InkWell(
                      highlightColor: Colors.transparent,
                      splashColor: Colors.transparent,
                      onTap: () {
                        FocusScope.of(context).unfocus();
                        if (!widget.isCart) showModelSizeBody(index);
                      },
                      child: PhysicalModel(
                        color: Colors.white,
                        shadowColor: Colors.grey,
                        elevation: 10,
                        borderRadius: BorderRadius.circular(20),
                        child: Container(
                          padding: EdgeInsets.symmetric(
                              vertical: 10, horizontal: 20),
                          child: Text(
                            '${measureList[index]['name']}: ${measureList[index]['body']} "',
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 14),
                          ),
                        ),
                      ),
                    ));
              }),
            ),
          ),
          Align(
            alignment: Alignment.centerLeft,
            child: Container(
              margin: EdgeInsets.only(left: 20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment:
                    dataMeasurement.productPatterns.isEmpty || dataHome.isFemale
                        ? CrossAxisAlignment.start
                        : CrossAxisAlignment.center,
                children: [
                  GestureDetector(
                      onTap: () {
                        setState(() {
                          isHide = !isHide;
                        });
                      },
                      child: Icon(
                        !isHide ? Icons.visibility : Icons.visibility_off,
                        size: 50,
                        color: Colors.black,
                      )),
                  SizedBox(
                    height: 10,
                  ),
                  dataMeasurement.productPatterns.isEmpty || dataHome.isFemale
                      ? Container()
                      : GestureDetector(
                          onTap: () {
                            ShowDialog().bottomSheetStyleOption(context);
                          },
                          child: Container(
                            padding: EdgeInsets.symmetric(vertical: 10),
                            decoration: BoxDecoration(
                                border: Border.all(color: Colors.grey),
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(30)),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Image.asset(
                                  'assets/images/fit/scissors.png',
                                  scale: 4,
                                ),
                                Container(
                                    padding: EdgeInsets.only(bottom: 10),
                                    child: Text(
                                      'Style',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 14),
                                    ))
                              ],
                            ),
                          ),
                        ),
                ],
              ),
            ),
          ),

          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              margin: EdgeInsets.only(
                  bottom: isKeyboard
                      ? MediaQuery.of(context).viewInsets.bottom
                      : 0),
              padding: EdgeInsets.all(15),
              height: 80,
              color: Colors.white.withOpacity(0.0),
              child: Center(
                child: TextField(
                  focusNode: focusNode,
                  textInputAction: TextInputAction.next,
                  controller: remarkController,
                  textAlign: TextAlign.left,
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                    hintText: 'Remarks',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide: BorderSide(
                        width: 0,
                        style: BorderStyle.none,
                      ),
                    ),
                    suffixIcon: GestureDetector(
                      onTap: () {
                        focusNode.unfocus();
                        focusNode.canRequestFocus = false;
                        dataMeasurement.bodyMeasurement = measureList;
                        dataMeasurement.remarks = remarkController.text;

                        if (widget.isStandardSizing == true) {
                          print('A');
                          Navigator.pop(context, true);
                          Navigator.pop(context, true);
                        } else if (widget.isCart) {
                          print('B');
                          Navigator.pop(context);
                        } else {
                          print('C');
                          if (widget.isDressingMeasurement) {
                            print('isDressing');
                            dataMeasurement.isDressingMeasurement = true;
                          } else {
                            print('isBody');
                            dataMeasurement.isDressingMeasurement = false;
                          }
                          Navigator.pop(context, true);
                        }
                      },
                      child: Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                        margin: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: Colors.black),
                        child: Text(
                          '>>',
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    filled: true,
                    contentPadding:
                        EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                    fillColor: Colors.grey[300],
                  ),
                ),
              ),
            ),
          ),
          // Align(
          //   alignment: Alignment.bottomCenter,
          //   child: SafeArea(
          //     child: Container(
          //       height: 60,
          //       color: Colors.white,
          //       child: Row(
          //         children: [
          //           Expanded(
          //             flex: 3,
          //             child: Container(
          //               child: TextField(
          //                 controller: remarkController,
          //                 style: TextStyle(),
          //                 textAlign: TextAlign.center,
          //                 maxLines: 3,
          //                 decoration: InputDecoration(
          //                     border: OutlineInputBorder(
          //                       borderSide:
          //                           BorderSide(color: Colors.grey, width: 2.0),
          //                     ),
          //                     hintText: 'Enter Your Remarks'),
          //               ),
          //             ),
          //           ),
          //           Expanded(
          //             child: GestureDetector(
          //               onTap: () {
          //                 dataMeasurement.bodyMeasurement = measureList;
          //                 dataMeasurement.remarks = remarkController.text;

          //                 if (widget.isStandardSizing == true) {
          //                   Navigator.pop(context, true);
          //                   Navigator.pop(context, true);
          //                 } else {
          //                   Navigator.pop(context, true);
          //                 }
          //               },
          //               child: Container(
          //                 color: Colors.blue,
          //                 child: Center(
          //                   child: Text(
          //                     'Summary >>',
          //                     textAlign: TextAlign.center,
          //                     style: TextStyle(
          //                       color: Colors.white,
          //                       fontWeight: FontWeight.bold,
          //                     ),
          //                   ),
          //                 ),
          //               ),
          //             ),
          //           ),
          //         ],
          //       ),
          //     ),
          //   ),
          // )
        ],
      ),
    );
  }

  String hintText;
  showModelSizeBody(int index) {
    final dataMeasure = Provider.of<Measurement>(context, listen: false);
    final dataHome = Provider.of<ShoppingPageProvider>(context, listen: false);
    int initialIndex = index;
    enterSize.text = measureList[initialIndex]['body'].toString();
    // finalSize = measureList[initialIndex]['final'].toString();
    showModalBottomSheet(
        isScrollControlled: true,
        elevation: 0,
        backgroundColor: Colors.transparent,
        barrierColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(40.0),
        ),
        context: context,
        builder: (context) {
          return StatefulBuilder(
              builder: (BuildContext context, StateSetter modalState) {
            return Container(
              color: Colors.transparent,
              child: Container(
                padding: MediaQuery.of(context).viewInsets,
                margin: EdgeInsets.all(20),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20)),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      children: [
                        Expanded(child: Container()),
                        Expanded(
                          child: Container(
                            child: CarouselSlider(
                              options: CarouselOptions(
                                  height: 100,
                                  initialPage: initialIndex,
                                  onPageChanged: (index, reason) {
                                    modalState(() {
                                      setState(() {
                                        initialIndex = index;
                                        enterSize.clear();
                                      });
                                    });
                                  },
                                  viewportFraction: 1.0,
                                  enlargeCenterPage: true),
                              items: List.generate(measureList.length, (index) {
                                return Image.asset(
                                  measureList[index]['image'],
                                  height: 100,
                                  width: 100,
                                );
                              }),
                            ),
                          ),
                        ),
                        // Image.asset(
                        //   measureList[initialIndex]['image'],
                        //   height: 100,
                        //   width: 100,
                        // ),
                        Expanded(
                          child: Container(
                            margin: EdgeInsets.only(bottom: 50),
                            alignment: Alignment.topRight,
                            child: GestureDetector(
                                onTap: () {
                                  Navigator.pop(context);
                                },
                                child: Container(
                                    padding: EdgeInsets.all(10),
                                    child: Icon(Icons.cancel))),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(
                        measureList.length,
                        (index) => Container(
                          width: 12.0,
                          height: 12.0,
                          margin: EdgeInsets.symmetric(
                              vertical: 8.0, horizontal: 4.0),
                          decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: (Theme.of(context).brightness ==
                                          Brightness.dark
                                      ? Colors.white
                                      : Colors.black)
                                  .withOpacity(
                                      initialIndex == index ? 0.9 : 0.4)),
                        ),
                      ),
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Container(
                            padding: EdgeInsets.all(10),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text(
                                    'Please enter your ${measureList[initialIndex]['name']} Size (inch)'),
                                SizedBox(
                                  height: 10,
                                ),
                                Container(
                                  child: TextField(
                                    onChanged: (String value) {
                                      setState(() {
                                        modalState(() {
                                          measureList[initialIndex]['body'] =
                                              double.parse(value);
                                          measureList[initialIndex]['final'] =
                                              measureList[initialIndex]
                                                      ['body'] +
                                                  measureList[initialIndex]
                                                      ['conversion'];
                                        });
                                      });
                                    },
                                    controller: enterSize,
                                    onTap: () {
                                      setState(() {
                                        enterSize.text = '';
                                      });
                                    },
                                    keyboardType: TextInputType.number,
                                    decoration: InputDecoration(
                                        contentPadding: EdgeInsets.all(10),
                                        border: OutlineInputBorder(
                                          borderSide: BorderSide(
                                              color: Colors.grey, width: 2.0),
                                        ),
                                        hintText:
                                            '${measureList[initialIndex]['body']}'),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        // Column(
                        //   crossAxisAlignment: CrossAxisAlignment.start,
                        //   children: [
                        //     Container(
                        //       child: Icon(
                        //         Icons.arrow_right_alt_outlined,
                        //         size: 40,
                        //       ),
                        //     ),
                        //   ],
                        // ),
                        // Expanded(
                        //   child: Container(
                        //     padding: EdgeInsets.all(10),
                        //     child: Column(
                        //       mainAxisAlignment: MainAxisAlignment.start,
                        //       crossAxisAlignment: CrossAxisAlignment.start,
                        //       children: [
                        //         SizedBox(
                        //           height: 10,
                        //         ),
                        //         Text(
                        //           'Final Product Size',
                        //         ),
                        //         SizedBox(
                        //           height: 15,
                        //         ),
                        //         SizedBox(
                        //           width: double.infinity,
                        //           child: Container(
                        //               padding: EdgeInsets.only(left: 10),
                        //               alignment: Alignment.centerLeft,
                        //               height: 50,
                        //               decoration: BoxDecoration(
                        //                   borderRadius:
                        //                       BorderRadius.circular(5),
                        //                   border: Border.all(
                        //                       color: Colors.grey[400])),
                        //               child: Text(
                        //                 measureList[initialIndex]['final']
                        //                     .toString(),
                        //               )),
                        //         ),
                        //       ],
                        //     ),
                        //   ),
                        // ),
                      ],
                    ),
                    Align(
                      alignment: Alignment.topRight,
                      child: GestureDetector(
                        onTap: () => ShowDialog().showDontKnowYourSize(context),
                        child: Container(
                          margin: EdgeInsets.symmetric(horizontal: 10),
                          padding:
                              EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                          decoration: BoxDecoration(
                              color: Color(0xFFf9e5d7),
                              border: Border.all(color: Colors.black)),
                          child: Text(
                            "DON'T KNOW YOUR SIZE?",
                            style: TextStyle(fontWeight: FontWeight.w400),
                          ),
                        ),
                      ),
                    ),
                    // Align(
                    //   alignment: Alignment.topRight,
                    //   child: GestureDetector(
                    //     onTap: () {
                    //       // dataMeasure.alertConversion(context);
                    //       // showDialog(
                    //       //     context: context,
                    //       //     builder: (context) {
                    //       //       return Consumer<ShoppingPageProvider>(
                    //       //           builder: (_, data, __) {
                    //       //         return AlertDialog(
                    //       //           content: Image.network(
                    //       //             data.isFemale
                    //       //                 ? data.differentList[1]
                    //       //                     ['measurement_pic']
                    //       //                 : data.differentList[0]
                    //       //                     ['measurement_pic'],
                    //       //             height: 200,
                    //       //           ),
                    //       //         );
                    //       //       });
                    //       //     });
                    //     },
                    //     child: Container(
                    //       margin:
                    //           EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    //       child: Text(
                    //         "What's the difference?",
                    //         textAlign: TextAlign.right,
                    //         style: TextStyle(
                    //             color: Colors.blue,
                    //             fontWeight: FontWeight.bold),
                    //       ),
                    //     ),
                    //   ),
                    // ),
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        // GestureDetector(
                        //   onTap: () {
                        //     setState(() {
                        //       modalState(() {
                        //         // Change text and image when click next button
                        //         if (initialIndex == 6 && dataHome.isFemale) {
                        //           modalState(() {
                        //             initialIndex = 0;
                        //             print('SDSDSDS');
                        //           });
                        //         } else if (initialIndex == 5 &&
                        //             !dataHome.isFemale) {
                        //           modalState(() {
                        //             initialIndex = 0;
                        //             print('SDSDSDS');
                        //           });
                        //         } else {
                        //           initialIndex = initialIndex + 1;
                        //         }
                        //         enterSize.clear();

                        //         log('$measureList');
                        //       });
                        //     });
                        //   },
                        //   child: Container(
                        //     decoration: BoxDecoration(
                        //         color: Colors.blue,
                        //         borderRadius: BorderRadius.circular(20)),
                        //     padding: EdgeInsets.symmetric(
                        //         horizontal: 60, vertical: 10),
                        //     child: Text(
                        //       'Next >',
                        //       style: TextStyle(
                        //           color: Colors.white,
                        //           fontWeight: FontWeight.bold),
                        //     ),
                        //   ),
                        // ),
                        GestureDetector(
                          onTap: () {
                            setState(() {});

                            Navigator.pop(context);
                          },
                          child: Container(
                            decoration: BoxDecoration(
                                color: Colors.green,
                                borderRadius: BorderRadius.circular(20)),
                            padding: EdgeInsets.symmetric(
                                horizontal: 60, vertical: 10),
                            child: Text(
                              'Done',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        )
                      ],
                    ),
                    SizedBox(
                      height: 20,
                    ),
                  ],
                ),
              ),
            );
          });
        });
  }

  showDontKnowYourSize() {
    showDialog(
        context: context,
        builder: (context) {
          return Consumer<ShoppingPageProvider>(
            builder: (_, data, child) {
              List sizeList;
              if (data.isFemale) {
                sizeList = data.sizeMap.values.toList()[1];
              } else {
                sizeList = data.sizeMap.values.toList()[0];
              }
              return StatefulBuilder(builder: (context, stateful) {
                return AlertDialog(
                  content: sizeList.length == 1
                      ? Container(
                          height: 200,
                          child: Image.network(sizeList[0]['banner_url']),
                        )
                      : Container(
                          height: 200,
                          child: Stack(
                            children: [
                              Container(
                                height: 200,
                                child: CarouselSlider(
                                  options: CarouselOptions(
                                      onPageChanged: (index, reason) {
                                        stateful(() {
                                          _current = index;
                                        });
                                      },
                                      viewportFraction: 1.0,
                                      autoPlay: true,
                                      enlargeCenterPage: true),
                                  items:
                                      List.generate(sizeList.length, (index) {
                                    return CachedNetworkImage(
                                      imageUrl: sizeList[index]['banner_url'],
                                      placeholder: (context, url) => Image.asset(
                                          'assets/images/placeholder-image.png'),
                                      errorWidget: (context, url, error) =>
                                          Image.asset(
                                              'assets/images/placeholder-image.png'),
                                      fit: BoxFit.cover,
                                      height: 200,
                                      alignment: Alignment.topCenter,
                                    );
                                  }),
                                ),
                              ),
                              sizeList.length == 1
                                  ? Container()
                                  : Align(
                                      alignment: Alignment.bottomCenter,
                                      child: Container(
                                        margin: EdgeInsets.only(bottom: 20),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: sizeList
                                              .asMap()
                                              .entries
                                              .map((entry) {
                                            return GestureDetector(
                                              // onTap: () => _controller.animateToPage(entry.key),
                                              child: Container(
                                                width: 12.0,
                                                height: 12.0,
                                                margin: EdgeInsets.symmetric(
                                                    vertical: 8.0,
                                                    horizontal: 4.0),
                                                decoration: BoxDecoration(
                                                    shape: BoxShape.circle,
                                                    color: (Theme.of(context)
                                                                    .brightness ==
                                                                Brightness.dark
                                                            ? Colors.white
                                                            : Colors.black)
                                                        .withOpacity(_current ==
                                                                entry.key
                                                            ? 0.9
                                                            : 0.4)),
                                              ),
                                            );
                                          }).toList(),
                                        ),
                                      ),
                                    ),
                            ],
                          )),
                );
              });
            },
          );
        });
  }

  final ItemScrollController itemScrollController = ItemScrollController();
  final ItemPositionsListener itemPositionsListener =
      ItemPositionsListener.create();
// Styling Option Model Bottom Sheet
  void bottomSheetStyleOption(Map bodyPattern) {
    List<bool> isSelect = [];

    showModalBottomSheet(
        context: context,
        builder: (context) {
          final dataMeasurement = Provider.of<Measurement>(context);
          dynamic patternList = dataMeasurement.productPatterns;
          return StatefulBuilder(
              builder: (BuildContext context, StateSetter modalState) {
            return Column(
              children: [
                Container(
                  padding: EdgeInsets.all(20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Styling Options',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 20),
                      ),
                      GestureDetector(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: Icon(Icons.cancel)),
                    ],
                  ),
                ),
                Expanded(
                    child: ScrollablePositionedList.builder(
                        itemScrollController: itemScrollController,
                        itemPositionsListener: itemPositionsListener,
                        itemCount: patternList.length + 1,
                        itemBuilder: (context, index) {
                          if (patternList.length == index) {
                            return Container(
                              height: 300,
                            );
                          }
                          isSelect.add(false);
                          String name = patternList[index]['name'][0]
                                  .toUpperCase()
                                  .toString() +
                              patternList[index]['name'].substring(1);
                          return Column(
                            children: [
                              GestureDetector(
                                onTap: () {
                                  modalState(() {
                                    setState(() {
                                      if (patternList[index]['data'].isEmpty) {
                                        Fluttertoast.showToast(
                                            msg: 'Comming Soon');
                                      } else if (isSelect[index] == false) {
                                        itemScrollController.scrollTo(
                                            index: index,
                                            duration: Duration(seconds: 1),
                                            curve: Curves.ease);
                                        isSelect[index] = !isSelect[index];
                                        print('AA' + index.toString());
                                      } else if (isSelect[index] == true) {
                                        itemScrollController.scrollTo(
                                            index: 0,
                                            duration: Duration(seconds: 2),
                                            curve: Curves.ease);
                                        isSelect[index] = !isSelect[index];
                                        print('BB' + index.toString());
                                      }
                                    });
                                  });
                                },
                                child: ListTile(
                                  leading: Text(name),
                                  trailing: Icon(Icons.keyboard_arrow_down),
                                ),
                              ),
                              Visibility(
                                visible: isSelect[index],
                                child: patternList[index]['data'].isEmpty
                                    ? Container(
                                        padding: EdgeInsets.all(20),
                                        child: Text('Coming Soon'),
                                      )
                                    : Container(
                                        child: ListView.separated(
                                            shrinkWrap: true,
                                            physics:
                                                NeverScrollableScrollPhysics(),
                                            itemBuilder: (context, i) {
                                              return GestureDetector(
                                                onTap: () {
                                                  dataMeasurement.selectPattern(
                                                      patternList[index]['data']
                                                          [i],
                                                      patternList[index]
                                                          ['name']);

                                                  print(dataMeasurement
                                                      .bodyPattern);
                                                },
                                                child: ListTile(
                                                  leading: Image.network(
                                                      patternList[index]['data']
                                                              [i]['image']
                                                          .toString()),
                                                  title: Text(patternList[index]
                                                      ['data'][i]['name']),
                                                  trailing: Text(
                                                      patternList[index]['data']
                                                                  [i]['name'] ==
                                                              bodyPattern.values
                                                                      .toList()[
                                                                  index]['name']
                                                          ? '(Default)'
                                                          : ''),
                                                ),
                                              );
                                            },
                                            separatorBuilder: (context, index) {
                                              return Divider(
                                                thickness: 2,
                                              );
                                            },
                                            itemCount: patternList[index]
                                                    ['data']
                                                .length),
                                      ),
                              )
                            ],
                          );
                        })),
              ],
            );
          });
        });
  }
}


/*
import 'dart:developer';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:custlr/api/measurementAPI.dart';
import 'package:custlr/widget/showDialog.dart';
import 'package:custlr/model/measurementModel.dart';
import 'package:custlr/utils/constants.dart';
import 'package:custlr/provider/Measurement.dart';
import 'package:custlr/provider/ShoppingPageProvider.dart';
import 'package:custlr/screen/profile_screen/my_measurement.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

class BodyMeasurement extends StatefulWidget {
  BodyMeasurement(
      {this.data,
      this.isStandardSizing = false,
      this.isCart = false,
      this.isDressingMeasurement = false});
  final MeasurementModel data;
  final bool isStandardSizing;
  final bool isCart;
  final bool isDressingMeasurement;

  @override
  _BodyMeasurementState createState() => _BodyMeasurementState();
}

class _BodyMeasurementState extends State<BodyMeasurement> {
  int _current = 0;
  final remarkController = TextEditingController();

  final enterSize = TextEditingController();

// Measure List
  List measureList = [];

  void getMeasure(double height, double width) {
    bool isFemale;
    if (widget.isCart) {
      if (widget.data.gender == "Woman") {
        isFemale = true;
      } else {
        isFemale = false;
      }
      remarkController.text = widget.data.review;
    } else {
      // remarkController.text = Provider.of<Measurement>(context, listen: false)
      //     .data['review']
      //     .toString();
      print('Data == >${widget.data}');
      isFemale =
          Provider.of<ShoppingPageProvider>(context, listen: false).isFemale;
    }

    dynamic convertionList;
    if (widget.isDressingMeasurement) {
      convertionList = {
        "chest_conversion": "0.00",
        "shoulder_conversion": "0.00",
        "arm_length_conversion": "0.00",
        "bicep_conversion": "0.00",
        "waist_conversion": "0.00"
      };
    } else {
      convertionList =
          Provider.of<Measurement>(context, listen: false).productConversion;
    }

    if (isFemale) {
      measureList = [
        {
          'name': 'Height',
          'parameter': 'height',
          'image': 'assets/images/bodyMeasurement/Height.png',
          'top': height / 20,
          'left': width / 30,
          'conversion':
              double.parse(convertionList['height_conversion'] ?? '0.00'),
          'body': double.parse(widget.data.height.toString()),
          'final': double.parse(widget.data.height.toString()) +
              double.parse(convertionList['height_conversion'] ?? '0.00'),
        },
        {
          'name': 'Chest',
          'parameter': 'chest',
          'image': 'assets/images/bodyMeasurement/chest.png',
          'top': height / 5,
          'left': width / 2.6,
          'conversion':
              double.parse(convertionList['chest_conversion'] ?? '0.00'),
          'body': double.parse(widget.data.chest.toString()),
          'final': double.parse(widget.data.chest.toString()) +
              double.parse(convertionList['chest_conversion'] ?? '0.00'),
        },
        {
          'name': 'Shoulder',
          'parameter': 'shoulder',
          'image': 'assets/images/bodyMeasurement/shoulder.png',
          'top': height / 9,
          'left': width / 30,
          'conversion':
              double.parse(convertionList['shoulder_conversion'] ?? '0.00'),
          'body': double.parse(widget.data.shoulder.toString()),
          'final': double.parse(widget.data.shoulder.toString()) +
              double.parse(convertionList['shoulder_conversion'] ?? '0.00'),
        },
        // {
        //   'name': 'Bicep',
        //   'parameter': 'bicep',
        //   'image': 'assets/images/bodyMeasurement/arm.png',
        //   'top': height / 5,
        //   'left': width / 1.4,
        //   'conversion':
        //       double.parse(convertionList['bicep_conversion'] ?? '0.00'),
        //   'body': double.parse(widget.data.bicep.toString()),
        //   'final': double.parse(widget.data.bicep.toString()) +
        //       double.parse(convertionList['bicep_conversion'] ?? '0.00'),
        // },
        {
          'name': 'Arm Length',
          'parameter': 'arm_length',
          'image': 'assets/images/bodyMeasurement/arm_length.png',
          'top': height / 9,
          'left': width / 1.7,
          'conversion':
              double.parse(convertionList['arm_length_conversion'] ?? '0.00'),
          'body': double.parse(widget.data.armLength.toString()),
          'final': double.parse(widget.data.armLength.toString()) +
              double.parse(convertionList['arm_length_conversion'] ?? '0.00'),
        },
        {
          'name': 'Waist',
          'parameter': 'waist',
          'image': 'assets/images/bodyMeasurement/waist.png',
          'top': height / 3.5,
          'left': width / 2.6,
          'conversion':
              double.parse(convertionList['waist_conversion'] ?? '0.00'),
          'body': double.parse(widget.data.waist.toString()),
          'final': double.parse(widget.data.waist.toString()) +
              double.parse(convertionList['waist_conversion'] ?? '0.00'),
        },
        {
          'name': 'Hip',
          'parameter': 'hip',
          'image': 'assets/images/bodyMeasurement/Hip.png',
          'top': height / 2.5,
          'left': width / 2.6,
          'conversion':
              double.parse(convertionList['hip_conversion'] ?? '0.00'),
          'body': double.parse(widget.data.hip.toString()),
          'final': double.parse(widget.data.hip.toString()) +
              double.parse(convertionList['hip_conversion'] ?? '0.00'),
        },
        {
          'name': 'Dress Length',
          'parameter': 'dress_length',
          'image': 'assets/images/bodyMeasurement/Dress Length.png',
          'top': height / 2,
          'left': width / 3,
          'conversion':
              double.parse(convertionList['dress_length_conversion'] ?? '0.00'),
          'body': double.parse(widget.data.dressLength.toString()),
          'final': double.parse(widget.data.dressLength.toString()) +
              double.parse(convertionList['dress_length_conversion'] ?? '0.00'),
        },
      ];
    } else {
      measureList = [
        {
          'name': 'Height',
          'parameter': 'height',
          'image': 'assets/images/bodyMeasurement/Height.png',
          'top': height / 35,
          'left': width / 30,
          'conversion':
              double.parse(convertionList['height_conversion'] ?? '0.00'),
          'body': double.parse(widget.data.height.toString()),
          'final': double.parse(widget.data.height.toString()) +
              double.parse(convertionList['height_conversion'] ?? '0.00'),
        },
        {
          'name': 'Chest',
          'parameter': 'chest',
          'image': 'assets/images/bodyMeasurement/chest.png',
          'top': height / 3.5,
          'left': width / 2.6,
          'conversion':
              double.parse(convertionList['chest_conversion'] ?? '0.00'),
          'body': double.parse(widget.data.chest.toString()),
          'final': double.parse(widget.data.chest.toString()) +
              double.parse(convertionList['chest_conversion'] ?? '0.00'),
        },
        {
          'name': 'Shoulder',
          'parameter': 'shoulder',
          'image': 'assets/images/bodyMeasurement/shoulder.png',
          'top': height / 5,
          'left': width / 1.9,
          'conversion':
              double.parse(convertionList['shoulder_conversion'] ?? '0.00'),
          'body': double.parse(widget.data.shoulder.toString()),
          'final': double.parse(widget.data.shoulder.toString()) +
              double.parse(convertionList['shoulder_conversion'] ?? '0.00'),
        },
        {
          'name': 'Arm Length',
          'parameter': 'arm_length',
          'image': 'assets/images/bodyMeasurement/arm_length.png',
          'top': height / 1.7,
          'left': width / 2.2,
          'conversion':
              double.parse(convertionList['arm_length_conversion'] ?? '0.00'),
          'body': double.parse(widget.data.armLength.toString()),
          'final': double.parse(widget.data.armLength.toString()) +
              double.parse(convertionList['arm_length_conversion'] ?? '0.00'),
        },
        {
          'name': 'Waist',
          'parameter': 'waist',
          'image': 'assets/images/bodyMeasurement/waist.png',
          'top': height / 2,
          'left': width / 3,
          'conversion':
              double.parse(convertionList['waist_conversion'] ?? '0.00'),
          'body': double.parse(widget.data.waist.toString()),
          'final': double.parse(widget.data.waist.toString()) +
              double.parse(convertionList['waist_conversion'] ?? '0.00'),
        },
        {
          'name': 'Bicep',
          'parameter': 'bicep',
          'image': 'assets/images/bodyMeasurement/arm.png',
          'top': height / 2.5,
          'left': width / 1.65,
          'conversion':
              double.parse(convertionList['bicep_conversion'] ?? '0.00'),
          'body': double.parse(widget.data.bicep.toString()),
          'final': double.parse(widget.data.bicep.toString()) +
              double.parse(convertionList['bicep_conversion'] ?? '0.00'),
        },
      ];
    }
  }

// Profile Measurement
  String _chosenValue = '';

  List profileList = [];

  void getProfileAPI() {
    MeasurementAPI.measurementListAPI().then((value) {
      profileList = value['user_measurement'];
      setState(() {
        if (profileList.isEmpty) {
          _chosenValue = "Add Profile";
        } else {
          _chosenValue = "Select Profile";
        }
      });
    });
  }

  bool isHide = false;
  @override
  void initState() {
    super.initState();
    getProfileAPI();
    getMeasure(Custlr.height, Custlr.width);
  }

  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  final focusNode = FocusNode();
  @override
  Widget build(BuildContext context) {
    //getMeasure(Custlr.height, Custlr.width);
    final isKeyboard = MediaQuery.of(context).viewInsets.bottom != 0;
    final dataMeasurement = Provider.of<Measurement>(context);
    final dataHome = Provider.of<ShoppingPageProvider>(context);
    final data = dataMeasurement.data;
    Map bodyPattern = dataMeasurement.bodyPattern;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: GestureDetector(
          onTap: () {
            log('$measureList');
          },
          child: GestureDetector(
            onTap: () {
              print(widget.data);
            },
            child: Text(
              widget.isDressingMeasurement
                  ? "Dress Measurement"
                  : 'Body Measurement',
              style: TextStyle(color: Colors.black),
            ),
          ),
        ),
        actions: [
          GestureDetector(
              onTap: () => ShowDialog().theDifference(context),
              child: Icon(Icons.info)),
          SizedBox(
            width: 10,
          ),
        ],
      ),
      body: Stack(
        children: [
          Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              Expanded(
                child: Image.network(
                  data['banner'] ?? 'https://${data['product_image']}',
                  fit: BoxFit.cover,
                ),
              ),
            ],
          ),
          if (!widget.isCart)
            Align(
              alignment: Alignment.topRight,
              child: GestureDetector(
                onTap: () async {
                  if (profileList.isEmpty) {
                    bool value = await Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => MyMeasurement(false)));
                    setState(() {
                      if (value == true) {
                        getProfileAPI();
                      }
                    });
                  }
                },
                child: Container(
                  height: 40,
                  margin: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Colors.white,
                    border: Border.all(
                      color: Colors.black,
                    ),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton(
                      hint: Text(_chosenValue.toString()),
                      onChanged: (final value) {
                        setState(() {
                          print(value);
                          _chosenValue = value['name'];
                          Fluttertoast.showToast(
                              msg: 'Selected successfully',
                              gravity: ToastGravity.CENTER);

                          measureList.forEach((data) {
                            data['body'] = value[data['parameter']];
                            print(data['conversion']);
                            data['final'] = double.parse(
                                    value[data['parameter']]) +
                                double.parse(
                                    measureList[0]['conversion'].toString());
                          });
                        });
                      },
                      items: profileList.map(
                        (e) {
                          return DropdownMenuItem<dynamic>(
                            value: e,
                            child: Row(
                              children: [
                                Text(
                                  e['name'],
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ).toList(),
                    ),
                  ),
                ),
              ),
            ),
          Stack(
            children: List.generate(measureList.length, (index) {
              return Positioned(
                  top: measureList[index]['top'],
                  left: measureList[index]['left'],
                  child: InkWell(
                    highlightColor: Colors.transparent,
                    splashColor: Colors.transparent,
                    onTap: () {
                      FocusScope.of(context).unfocus();
                      if (!widget.isCart) showModelSizeBody(index);
                    },
                    child: PhysicalModel(
                      color: Colors.white,
                      shadowColor: Colors.grey,
                      elevation: 10,
                      borderRadius: BorderRadius.circular(20),
                      child: Container(
                        padding:
                            EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                        child: Text(
                          '${measureList[index]['name']}: ${measureList[index]['body']} "',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 14),
                        ),
                      ),
                    ),
                  ));
            }),
          ),
          Align(
            alignment: Alignment.centerLeft,
            child: Container(
              margin: EdgeInsets.only(left: 20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // GestureDetector(
                  //     onTap: () {
                  //       setState(() {
                  //         isHide = !isHide;
                  //       });
                  //     },
                  //     child: Icon(
                  //         !isHide ? Icons.visibility : Icons.visibility_off)),
                  SizedBox(
                    height: 20,
                  ),
                  dataMeasurement.productPatterns.isEmpty || dataHome.isFemale
                      ? Container()
                      : GestureDetector(
                          onTap: () {
                            ShowDialog().bottomSheetStyleOption(context);
                          },
                          child: Container(
                            padding: EdgeInsets.symmetric(vertical: 10),
                            decoration: BoxDecoration(
                                border: Border.all(color: Colors.grey),
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(30)),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Image.asset(
                                  'assets/images/fit/scissors.png',
                                  scale: 4,
                                ),
                                Container(
                                    padding: EdgeInsets.only(bottom: 10),
                                    child: Text(
                                      'Style',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 14),
                                    ))
                              ],
                            ),
                          ),
                        ),
                ],
              ),
            ),
          ),

          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              margin: EdgeInsets.only(
                  bottom: isKeyboard
                      ? MediaQuery.of(context).viewInsets.bottom
                      : 0),
              padding: EdgeInsets.all(15),
              height: 80,
              color: Colors.white.withOpacity(0.0),
              child: Center(
                child: TextField(
                  focusNode: focusNode,
                  textInputAction: TextInputAction.next,
                  controller: remarkController,
                  textAlign: TextAlign.left,
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                    hintText: 'Remarks',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide: BorderSide(
                        width: 0,
                        style: BorderStyle.none,
                      ),
                    ),
                    suffixIcon: GestureDetector(
                      onTap: () {
                        focusNode.unfocus();
                        focusNode.canRequestFocus = false;
                        dataMeasurement.bodyMeasurement = measureList;
                        dataMeasurement.remarks = remarkController.text;

                        if (widget.isStandardSizing == true) {
                          print('A');
                          Navigator.pop(context, true);
                          Navigator.pop(context, true);
                        } else if (widget.isCart) {
                          print('B');
                          Navigator.pop(context);
                        } else {
                          print('C');
                          if (widget.isDressingMeasurement) {
                            print('isDressing');
                            dataMeasurement.isDressingMeasurement = true;
                          } else {
                            print('isBody');
                            dataMeasurement.isDressingMeasurement = false;
                          }
                          Navigator.pop(context, true);
                        }
                      },
                      child: Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                        margin: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: Colors.black),
                        child: Text(
                          '>>',
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    filled: true,
                    contentPadding:
                        EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                    fillColor: Colors.grey[300],
                  ),
                ),
              ),
            ),
          ),
          // Align(
          //   alignment: Alignment.bottomCenter,
          //   child: SafeArea(
          //     child: Container(
          //       height: 60,
          //       color: Colors.white,
          //       child: Row(
          //         children: [
          //           Expanded(
          //             flex: 3,
          //             child: Container(
          //               child: TextField(
          //                 controller: remarkController,
          //                 style: TextStyle(),
          //                 textAlign: TextAlign.center,
          //                 maxLines: 3,
          //                 decoration: InputDecoration(
          //                     border: OutlineInputBorder(
          //                       borderSide:
          //                           BorderSide(color: Colors.grey, width: 2.0),
          //                     ),
          //                     hintText: 'Enter Your Remarks'),
          //               ),
          //             ),
          //           ),
          //           Expanded(
          //             child: GestureDetector(
          //               onTap: () {
          //                 dataMeasurement.bodyMeasurement = measureList;
          //                 dataMeasurement.remarks = remarkController.text;

          //                 if (widget.isStandardSizing == true) {
          //                   Navigator.pop(context, true);
          //                   Navigator.pop(context, true);
          //                 } else {
          //                   Navigator.pop(context, true);
          //                 }
          //               },
          //               child: Container(
          //                 color: Colors.blue,
          //                 child: Center(
          //                   child: Text(
          //                     'Summary >>',
          //                     textAlign: TextAlign.center,
          //                     style: TextStyle(
          //                       color: Colors.white,
          //                       fontWeight: FontWeight.bold,
          //                     ),
          //                   ),
          //                 ),
          //               ),
          //             ),
          //           ),
          //         ],
          //       ),
          //     ),
          //   ),
          // )
        ],
      ),
    );
  }

  String hintText;
  showModelSizeBody(int index) {
    final dataMeasure = Provider.of<Measurement>(context, listen: false);
    final dataHome = Provider.of<ShoppingPageProvider>(context, listen: false);
    int initialIndex = index;
    enterSize.text = measureList[initialIndex]['body'].toString();
    // finalSize = measureList[initialIndex]['final'].toString();
    showModalBottomSheet(
        isScrollControlled: true,
        elevation: 0,
        backgroundColor: Colors.transparent,
        barrierColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(40.0),
        ),
        context: context,
        builder: (context) {
          return StatefulBuilder(
              builder: (BuildContext context, StateSetter modalState) {
            return Container(
              color: Colors.transparent,
              child: Container(
                padding: MediaQuery.of(context).viewInsets,
                margin: EdgeInsets.all(20),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20)),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      children: [
                        Expanded(child: Container()),
                        Expanded(
                          child: Container(
                            child: CarouselSlider(
                              options: CarouselOptions(
                                  height: 100,
                                  initialPage: initialIndex,
                                  onPageChanged: (index, reason) {
                                    modalState(() {
                                      setState(() {
                                        initialIndex = index;
                                        enterSize.clear();
                                      });
                                    });
                                  },
                                  viewportFraction: 1.0,
                                  enlargeCenterPage: true),
                              items: List.generate(measureList.length, (index) {
                                return Image.asset(
                                  measureList[index]['image'],
                                  height: 100,
                                  width: 100,
                                );
                              }),
                            ),
                          ),
                        ),
                        // Image.asset(
                        //   measureList[initialIndex]['image'],
                        //   height: 100,
                        //   width: 100,
                        // ),
                        Expanded(
                          child: Container(
                            margin: EdgeInsets.only(bottom: 50),
                            alignment: Alignment.topRight,
                            child: GestureDetector(
                                onTap: () {
                                  Navigator.pop(context);
                                },
                                child: Container(
                                    padding: EdgeInsets.all(10),
                                    child: Icon(Icons.cancel))),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(
                        measureList.length,
                        (index) => Container(
                          width: 12.0,
                          height: 12.0,
                          margin: EdgeInsets.symmetric(
                              vertical: 8.0, horizontal: 4.0),
                          decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: (Theme.of(context).brightness ==
                                          Brightness.dark
                                      ? Colors.white
                                      : Colors.black)
                                  .withOpacity(
                                      initialIndex == index ? 0.9 : 0.4)),
                        ),
                      ),
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Container(
                            padding: EdgeInsets.all(10),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text(
                                    'Please enter your ${measureList[initialIndex]['name']} Size (inch)'),
                                SizedBox(
                                  height: 10,
                                ),
                                Container(
                                  child: TextField(
                                    onChanged: (String value) {
                                      setState(() {
                                        modalState(() {
                                          measureList[initialIndex]['body'] =
                                              double.parse(value);
                                          measureList[initialIndex]['final'] =
                                              measureList[initialIndex]
                                                      ['body'] +
                                                  measureList[initialIndex]
                                                      ['conversion'];
                                        });
                                      });
                                    },
                                    controller: enterSize,
                                    onTap: () {
                                      setState(() {
                                        enterSize.text = '';
                                      });
                                    },
                                    keyboardType: TextInputType.number,
                                    decoration: InputDecoration(
                                        contentPadding: EdgeInsets.all(10),
                                        border: OutlineInputBorder(
                                          borderSide: BorderSide(
                                              color: Colors.grey, width: 2.0),
                                        ),
                                        hintText:
                                            '${measureList[initialIndex]['body']}'),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        // Column(
                        //   crossAxisAlignment: CrossAxisAlignment.start,
                        //   children: [
                        //     Container(
                        //       child: Icon(
                        //         Icons.arrow_right_alt_outlined,
                        //         size: 40,
                        //       ),
                        //     ),
                        //   ],
                        // ),
                        // Expanded(
                        //   child: Container(
                        //     padding: EdgeInsets.all(10),
                        //     child: Column(
                        //       mainAxisAlignment: MainAxisAlignment.start,
                        //       crossAxisAlignment: CrossAxisAlignment.start,
                        //       children: [
                        //         SizedBox(
                        //           height: 10,
                        //         ),
                        //         Text(
                        //           'Final Product Size',
                        //         ),
                        //         SizedBox(
                        //           height: 15,
                        //         ),
                        //         SizedBox(
                        //           width: double.infinity,
                        //           child: Container(
                        //               padding: EdgeInsets.only(left: 10),
                        //               alignment: Alignment.centerLeft,
                        //               height: 50,
                        //               decoration: BoxDecoration(
                        //                   borderRadius:
                        //                       BorderRadius.circular(5),
                        //                   border: Border.all(
                        //                       color: Colors.grey[400])),
                        //               child: Text(
                        //                 measureList[initialIndex]['final']
                        //                     .toString(),
                        //               )),
                        //         ),
                        //       ],
                        //     ),
                        //   ),
                        // ),
                      ],
                    ),
                    Align(
                      alignment: Alignment.topRight,
                      child: GestureDetector(
                        onTap: () => ShowDialog().showDontKnowYourSize(context),
                        child: Container(
                          margin: EdgeInsets.symmetric(horizontal: 10),
                          padding:
                              EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                          decoration: BoxDecoration(
                              color: Color(0xFFf9e5d7),
                              border: Border.all(color: Colors.black)),
                          child: Text(
                            "DON'T KNOW YOUR SIZE?",
                            style: TextStyle(fontWeight: FontWeight.w400),
                          ),
                        ),
                      ),
                    ),
                    // Align(
                    //   alignment: Alignment.topRight,
                    //   child: GestureDetector(
                    //     onTap: () {
                    //       // dataMeasure.alertConversion(context);
                    //       // showDialog(
                    //       //     context: context,
                    //       //     builder: (context) {
                    //       //       return Consumer<ShoppingPageProvider>(
                    //       //           builder: (_, data, __) {
                    //       //         return AlertDialog(
                    //       //           content: Image.network(
                    //       //             data.isFemale
                    //       //                 ? data.differentList[1]
                    //       //                     ['measurement_pic']
                    //       //                 : data.differentList[0]
                    //       //                     ['measurement_pic'],
                    //       //             height: 200,
                    //       //           ),
                    //       //         );
                    //       //       });
                    //       //     });
                    //     },
                    //     child: Container(
                    //       margin:
                    //           EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    //       child: Text(
                    //         "What's the difference?",
                    //         textAlign: TextAlign.right,
                    //         style: TextStyle(
                    //             color: Colors.blue,
                    //             fontWeight: FontWeight.bold),
                    //       ),
                    //     ),
                    //   ),
                    // ),
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        // GestureDetector(
                        //   onTap: () {
                        //     setState(() {
                        //       modalState(() {
                        //         // Change text and image when click next button
                        //         if (initialIndex == 6 && dataHome.isFemale) {
                        //           modalState(() {
                        //             initialIndex = 0;
                        //             print('SDSDSDS');
                        //           });
                        //         } else if (initialIndex == 5 &&
                        //             !dataHome.isFemale) {
                        //           modalState(() {
                        //             initialIndex = 0;
                        //             print('SDSDSDS');
                        //           });
                        //         } else {
                        //           initialIndex = initialIndex + 1;
                        //         }
                        //         enterSize.clear();

                        //         log('$measureList');
                        //       });
                        //     });
                        //   },
                        //   child: Container(
                        //     decoration: BoxDecoration(
                        //         color: Colors.blue,
                        //         borderRadius: BorderRadius.circular(20)),
                        //     padding: EdgeInsets.symmetric(
                        //         horizontal: 60, vertical: 10),
                        //     child: Text(
                        //       'Next >',
                        //       style: TextStyle(
                        //           color: Colors.white,
                        //           fontWeight: FontWeight.bold),
                        //     ),
                        //   ),
                        // ),
                        GestureDetector(
                          onTap: () {
                            setState(() {});

                            Navigator.pop(context);
                          },
                          child: Container(
                            decoration: BoxDecoration(
                                color: Colors.green,
                                borderRadius: BorderRadius.circular(20)),
                            padding: EdgeInsets.symmetric(
                                horizontal: 60, vertical: 10),
                            child: Text(
                              'Done',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        )
                      ],
                    ),
                    SizedBox(
                      height: 20,
                    ),
                  ],
                ),
              ),
            );
          });
        });
  }

  showDontKnowYourSize() {
    showDialog(
        context: context,
        builder: (context) {
          return Consumer<ShoppingPageProvider>(
            builder: (_, data, child) {
              List sizeList;
              if (data.isFemale) {
                sizeList = data.sizeMap.values.toList()[1];
              } else {
                sizeList = data.sizeMap.values.toList()[0];
              }
              return StatefulBuilder(builder: (context, stateful) {
                return AlertDialog(
                  content: sizeList.length == 1
                      ? Container(
                          height: 200,
                          child: Image.network(sizeList[0]['banner_url']),
                        )
                      : Container(
                          height: 200,
                          child: Stack(
                            children: [
                              Container(
                                height: 200,
                                child: CarouselSlider(
                                  options: CarouselOptions(
                                      onPageChanged: (index, reason) {
                                        stateful(() {
                                          _current = index;
                                        });
                                      },
                                      viewportFraction: 1.0,
                                      autoPlay: true,
                                      enlargeCenterPage: true),
                                  items:
                                      List.generate(sizeList.length, (index) {
                                    return CachedNetworkImage(
                                      imageUrl: sizeList[index]['banner_url'],
                                      placeholder: (context, url) => Image.asset(
                                          'assets/images/placeholder-image.png'),
                                      errorWidget: (context, url, error) =>
                                          Image.asset(
                                              'assets/images/placeholder-image.png'),
                                      fit: BoxFit.cover,
                                      height: 200,
                                      alignment: Alignment.topCenter,
                                    );
                                  }),
                                ),
                              ),
                              sizeList.length == 1
                                  ? Container()
                                  : Align(
                                      alignment: Alignment.bottomCenter,
                                      child: Container(
                                        margin: EdgeInsets.only(bottom: 20),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: sizeList
                                              .asMap()
                                              .entries
                                              .map((entry) {
                                            return GestureDetector(
                                              // onTap: () => _controller.animateToPage(entry.key),
                                              child: Container(
                                                width: 12.0,
                                                height: 12.0,
                                                margin: EdgeInsets.symmetric(
                                                    vertical: 8.0,
                                                    horizontal: 4.0),
                                                decoration: BoxDecoration(
                                                    shape: BoxShape.circle,
                                                    color: (Theme.of(context)
                                                                    .brightness ==
                                                                Brightness.dark
                                                            ? Colors.white
                                                            : Colors.black)
                                                        .withOpacity(_current ==
                                                                entry.key
                                                            ? 0.9
                                                            : 0.4)),
                                              ),
                                            );
                                          }).toList(),
                                        ),
                                      ),
                                    ),
                            ],
                          )),
                );
              });
            },
          );
        });
  }

  final ItemScrollController itemScrollController = ItemScrollController();
  final ItemPositionsListener itemPositionsListener =
      ItemPositionsListener.create();
// Styling Option Model Bottom Sheet
  void bottomSheetStyleOption(Map bodyPattern) {
    List<bool> isSelect = [];

    showModalBottomSheet(
        context: context,
        builder: (context) {
          final dataMeasurement = Provider.of<Measurement>(context);
          dynamic patternList = dataMeasurement.productPatterns;
          return StatefulBuilder(
              builder: (BuildContext context, StateSetter modalState) {
            return Column(
              children: [
                Container(
                  padding: EdgeInsets.all(20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Styling Options',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 20),
                      ),
                      GestureDetector(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: Icon(Icons.cancel)),
                    ],
                  ),
                ),
                Expanded(
                    child: ScrollablePositionedList.builder(
                        itemScrollController: itemScrollController,
                        itemPositionsListener: itemPositionsListener,
                        itemCount: patternList.length + 1,
                        itemBuilder: (context, index) {
                          if (patternList.length == index) {
                            return Container(
                              height: 300,
                            );
                          }
                          isSelect.add(false);
                          String name = patternList[index]['name'][0]
                                  .toUpperCase()
                                  .toString() +
                              patternList[index]['name'].substring(1);
                          return Column(
                            children: [
                              GestureDetector(
                                onTap: () {
                                  modalState(() {
                                    setState(() {
                                      if (patternList[index]['data'].isEmpty) {
                                        Fluttertoast.showToast(
                                            msg: 'Comming Soon');
                                      } else if (isSelect[index] == false) {
                                        itemScrollController.scrollTo(
                                            index: index,
                                            duration: Duration(seconds: 1),
                                            curve: Curves.ease);
                                        isSelect[index] = !isSelect[index];
                                        print('AA' + index.toString());
                                      } else if (isSelect[index] == true) {
                                        itemScrollController.scrollTo(
                                            index: 0,
                                            duration: Duration(seconds: 2),
                                            curve: Curves.ease);
                                        isSelect[index] = !isSelect[index];
                                        print('BB' + index.toString());
                                      }
                                    });
                                  });
                                },
                                child: ListTile(
                                  leading: Text(name),
                                  trailing: Icon(Icons.keyboard_arrow_down),
                                ),
                              ),
                              Visibility(
                                visible: isSelect[index],
                                child: patternList[index]['data'].isEmpty
                                    ? Container(
                                        padding: EdgeInsets.all(20),
                                        child: Text('Coming Soon'),
                                      )
                                    : Container(
                                        child: ListView.separated(
                                            shrinkWrap: true,
                                            physics:
                                                NeverScrollableScrollPhysics(),
                                            itemBuilder: (context, i) {
                                              return GestureDetector(
                                                onTap: () {
                                                  dataMeasurement.selectPattern(
                                                      patternList[index]['data']
                                                          [i],
                                                      patternList[index]
                                                          ['name']);

                                                  print(dataMeasurement
                                                      .bodyPattern);
                                                },
                                                child: ListTile(
                                                  leading: Image.network(
                                                      patternList[index]['data']
                                                              [i]['image']
                                                          .toString()),
                                                  title: Text(patternList[index]
                                                      ['data'][i]['name']),
                                                  trailing: Text(
                                                      patternList[index]['data']
                                                                  [i]['name'] ==
                                                              bodyPattern.values
                                                                      .toList()[
                                                                  index]['name']
                                                          ? '(Default)'
                                                          : ''),
                                                ),
                                              );
                                            },
                                            separatorBuilder: (context, index) {
                                              return Divider(
                                                thickness: 2,
                                              );
                                            },
                                            itemCount: patternList[index]
                                                    ['data']
                                                .length),
                                      ),
                              )
                            ],
                          );
                        })),
              ],
            );
          });
        });
  }
}
*/