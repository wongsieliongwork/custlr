import 'package:carousel_slider/carousel_slider.dart';
import 'package:custlr/widget/showDialog.dart';
import 'package:custlr/provider/Measurement.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'dart:io';

import 'package:rflutter_alert/rflutter_alert.dart';

class A4Fit extends StatefulWidget {
  @override
  _A4FitState createState() => _A4FitState();
}

class _A4FitState extends State<A4Fit> {
  List imgList = [
    'assets/images/fit/A4_Fit_sample.jpg',
    'assets/images/fit/A4_Side.png'
  ];

  final heightController = TextEditingController();
  final weightController = TextEditingController();

  List data = [];

  void heightAndHeight() {
    data = [
      {
        'name': 'HEIGHT ',
        'controller': heightController,
        'format': 'CM',
        'value': 100.00,
        'min': 100.00,
        'max': 200.00
      },
      {
        'name': 'WEIGHT',
        'controller': weightController,
        'format': 'KG',
        'value': 30.00,
        'min': 30.00,
        'max': 200.00
      }
    ];
  }

// Image Picker
  File img;
  File img2;
  final picker = ImagePicker();
  final picker2 = ImagePicker();

  Future getCamera(bool isFront) async {
    PickedFile pickedFile;
    pickedFile = await picker.getImage(source: ImageSource.camera);

    setState(() {
      if (isFront == true) {
        img = File(pickedFile.path);
      } else {
        img2 = File(pickedFile.path);
      }

      upload();
    });
  }

  Future getGallery(bool isFront) async {
    PickedFile pickedFile;

    pickedFile = await picker.getImage(source: ImageSource.gallery);

    setState(() {
      if (isFront == true) {
        img = File(pickedFile.path);
      } else {
        img2 = File(pickedFile.path);
      }
      upload();
    });
  }

  List uploadList = [];

  void upload() {
    uploadList = [
      {
        'name': 'ADD FRONT IMAGE',
        'file': img,
        'isFront': true,
      },
      {
        'name': 'ADD \nSIDE IMAGE',
        'file': img2,
        'isFront': false,
      },
    ];
  }

  void imagePicker(bool isFront) {
    Alert(
        context: context,
        title: "Upload Image",
        content: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            GestureDetector(
              onTap: () {
                getCamera(isFront);
                Navigator.pop(context);
              },
              child: Column(
                children: [
                  Icon(
                    Icons.camera,
                    size: 50,
                  ),
                  Text('Camera'),
                ],
              ),
            ),
            SizedBox(
              width: 30,
            ),
            GestureDetector(
              onTap: () {
                getGallery(isFront);
                Navigator.pop(context);
              },
              child: Column(
                children: [
                  Icon(
                    Icons.image,
                    size: 50,
                  ),
                  Text('Gallery'),
                ],
              ),
            ),
          ],
        )).show();
  }

  @override
  void initState() {
    super.initState();
    heightAndHeight();
    upload();
  }

  bool isLoading = false;
  final focusNode = FocusNode();
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isKeyboard = MediaQuery.of(context).viewInsets.bottom != 0;
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        leading: GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: Icon(
            Icons.keyboard_arrow_left,
            size: 40,
            color: Colors.black,
          ),
        ),
        title: Text(
          'A4 Fit',
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: Stack(
        children: [
          Column(
            children: [
              if (!isKeyboard)
                Container(
                  color: Colors.grey[200],
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Expanded(
                        flex: 14,
                        child: Container(
                          child: Builder(
                            builder: (context) {
                              // final double height = MediaQuery.of(context).size.height;
                              return CarouselSlider(
                                options: CarouselOptions(
                                    viewportFraction: 1.0,
                                    enlargeCenterPage: true,
                                    autoPlay: true,
                                    height: size.height / 1.6),
                                items: imgList
                                    .map((item) => Image.asset(
                                          item,
                                          fit: BoxFit.cover,
                                        ))
                                    .toList(),
                              );
                            },
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 4,
                        child: Container(
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: List.generate(3, (index) {
                                if (index == 2) {
                                  return GestureDetector(
                                    onTap: () {
                                      ShowDialog()
                                          .bottomSheetStyleOption(context);
                                    },
                                    child: Container(
                                      padding:
                                          EdgeInsets.symmetric(vertical: 15),
                                      decoration: BoxDecoration(
                                          color: Colors.white,
                                          border:
                                              Border.all(color: Colors.grey),
                                          borderRadius:
                                              BorderRadius.circular(20)),
                                      child: Column(
                                        children: [
                                          Image.asset(
                                            'assets/images/fit/scissors.png',
                                            scale: 6,
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                }
                                return GestureDetector(
                                  onTap: () async {
                                    imagePicker(uploadList[index]['isFront']);
                                  },
                                  child: uploadList[index]['file'] != null
                                      ? Container(
                                          margin: EdgeInsets.all(10),
                                          child: Image.file(
                                            uploadList[index]['file'],
                                            fit: BoxFit.cover,
                                          ),
                                        )
                                      : Container(
                                          margin: EdgeInsets.all(10),
                                          padding: EdgeInsets.symmetric(
                                              vertical: 20, horizontal: 5),
                                          decoration: BoxDecoration(
                                              color: Colors.white,
                                              border: Border.all(
                                                  color: Colors.black,
                                                  width: 2)),
                                          child: Column(
                                            children: [
                                              Text(
                                                uploadList[index]['name'],
                                                textAlign: TextAlign.center,
                                                style: TextStyle(fontSize: 12),
                                              ),
                                              SizedBox(
                                                height: 10,
                                              ),
                                              Icon(Icons.upload_sharp),
                                            ],
                                          ),
                                        ),
                                );
                              })),
                        ),
                      )
                    ],
                  ),
                ),
              SizedBox(
                height: 10,
              ),
              Text(
                'YOUR WEIGHT AND HEIGHT',
              ),
              Column(
                  children: List.generate(data.length, (index) {
                return Container(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  child: Row(
                    children: [
                      Text(data[index]['name']),
                      Expanded(
                        child: Container(
                          child: Slider(
                            value: data[index]['value'],
                            onChanged: (double newValue) {
                              setState(() {
                                data[index]['value'] = newValue;
                                data[index]['controller'].text =
                                    newValue.toStringAsFixed(0);
                              });
                            },
                            label:
                                '${data[index]['value'].toStringAsFixed(0)} CM',
                            // divisions: 200,
                            divisions: (data[index]['max'] - data[index]['min'])
                                .toInt(),
                            min: data[index]['min'],
                            max: data[index]['max'],
                          ),
                        ),
                      ),
                      Row(
                        children: [
                          Container(
                            width: 80,
                            height: 40,
                            child: TextField(
                              textAlign: TextAlign.center,
                              keyboardType: TextInputType.number,
                              controller: data[index]['controller'],
                              decoration: InputDecoration(
                                hintText: '',
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                                filled: true,
                              ),
                              onChanged: (value) {
                                if ((data[index]['min'] > double.parse(value) ||
                                    data[index]['max'] < double.parse(value))) {
                                } else {
                                  setState(() {
                                    data[index]['value'] = double.parse(value);
                                  });
                                }
                              },
                            ),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Text(data[index]['format']),
                        ],
                      ),
                    ],
                  ),
                );
              })),
              // Container(
              //   padding: EdgeInsets.symmetric(horizontal: 10),
              //   child: Row(
              //     children: [
              //       Text('WEIGHT'),
              //       Expanded(
              //         child: Slider(
              //           value: kg,
              //           onChanged: (newValue) {
              //             setState(() {
              //               kg = newValue;
              //             });
              //           },
              //           label: '${kg.toStringAsFixed(2)} KG',
              //           divisions: 200,
              //           min: 0,
              //           max: 200,
              //         ),
              //       ),
              //       Text(
              //         kg.toStringAsFixed(2),
              //       ),
              //       SizedBox(
              //         width: 5,
              //       ),
              //       Text('KG'),
              //     ],
              //   ),
              // ),
              Container(
                height: 20,
              ),
            ],
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              padding: EdgeInsets.all(15),
              height: 80,
              color: Colors.white,
              child: Center(
                child: TextField(
                  focusNode: focusNode,
                  textInputAction: TextInputAction.next,
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
                      onTap: () => confirm(),
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
          //   child: Container(
          //     height: 60,
          //     color: Colors.white,
          //     child: Row(
          //       children: [
          //         Expanded(
          //           flex: 3,
          //           child: Container(
          //             child: TextField(
          //               style: TextStyle(),
          //               textAlign: TextAlign.center,
          //               maxLines: 3,
          //               decoration: InputDecoration(
          //                   border: OutlineInputBorder(
          //                     borderSide:
          //                         BorderSide(color: Colors.grey, width: 2.0),
          //                   ),
          //                   hintText: 'Enter Your Remarks'),
          //             ),
          //           ),
          //         ),
          //         Expanded(
          //           child: Container(
          //             color: Colors.blue,
          //             child: Center(
          //               child: Text(
          //                 'Summary >>',
          //                 textAlign: TextAlign.center,
          //                 style: TextStyle(
          //                   color: Colors.white,
          //                   fontWeight: FontWeight.bold,
          //                 ),
          //               ),
          //             ),
          //           ),
          //         ),
          //       ],
          //     ),
          //   ),
          // ),
        ],
      ),
    );
  }

  void confirm() {
    final dataMeasurement = Provider.of<Measurement>(context, listen: false);
    focusNode.unfocus();
    focusNode.canRequestFocus = false;
    if (img == null) {
      Fluttertoast.showToast(msg: 'Front Image is not add yet');
    } else if (img2 == null) {
      Fluttertoast.showToast(msg: 'Side Image is not add yet');
    } else if (heightController.text.isEmpty) {
      Fluttertoast.showToast(msg: 'Height is not set yet');
    } else if (weightController.text.isEmpty) {
      Fluttertoast.showToast(msg: 'Weight is not set yet');
    } else {
      dataMeasurement.isA4Fit = true;
      // final data = {
      //   'frontImage': img,
      //   'sideImage': img2,
      //   'height': heightController.text,
      //   'weight': weightController.text,
      // };

      List data = [
        {
          'name': 'Height',
          'parameter': 'height',
          'final': heightController.text,
        },
        {
          'name': 'Weight',
          'parameter': 'weight',
          'final': weightController.text,
        },
        {
          'name': 'Front Image',
          'parameter': 'front_img',
          'final': img,
        },
        {
          'name': 'Side Image',
          'parameter': 'side_img',
          'final': img2,
        },
      ];
      dataMeasurement.bodyMeasurement = data;
      Navigator.pop(context, true);
    }
    // setState(() {
    //   isLoading = true;
    //   MeasurementAPI.measurementListAPI().then((value) {
    //     print(value);
    //     if (value['user_measurement'].isEmpty) {
    //       setState(() {
    //         isLoading = false;
    //         Fluttertoast.showToast(
    //           toastLength: Toast.LENGTH_LONG,
    //           msg: "Please set profile measurement first",
    //         );
    //       });
    //     } else {
    //       setState(() {
    //         isLoading = false;
    //         // Go page 3
    //         final convertionList =
    //             Provider.of<Measurement>(context, listen: false)
    //                 .productConversion;
    //         List measureList = [
    //           {
    //             'name': 'Height',
    //             'conversion':
    //                 double.parse(convertionList['height_conversion'] ?? '0.00'),
    //             'body': double.parse(
    //                 value['user_measurement'][0]['height'].toString()),
    //             'final': double.parse(
    //                     value['user_measurement'][0]['height'].toString()) +
    //                 double.parse(convertionList['height_conversion'] ?? '0.00'),
    //           },
    //           {
    //             'name': 'Chest',
    //             'conversion':
    //                 double.parse(convertionList['chest_conversion'] ?? '0.00'),
    //             'body': double.parse(
    //                 value['user_measurement'][0]['chest'].toString()),
    //             'final': double.parse(
    //                     value['user_measurement'][0]['chest'].toString()) +
    //                 double.parse(convertionList['chest_conversion'] ?? '0.00'),
    //           },
    //           {
    //             'name': 'Shoulder',
    //             'conversion': double.parse(
    //                 convertionList['shoulder_conversion'] ?? '0.00'),
    //             'body': double.parse(
    //                 value['user_measurement'][0]['shoulder'].toString()),
    //             'final': double.parse(
    //                     value['user_measurement'][0]['shoulder'].toString()) +
    //                 double.parse(
    //                     convertionList['shoulder_conversion'] ?? '0.00'),
    //           },
    //           {
    //             'name': 'Bicep',
    //             'conversion':
    //                 double.parse(convertionList['bicep_conversion'] ?? '0.00'),
    //             'body': double.parse(
    //                 value['user_measurement'][0]['bicep'].toString()),
    //             'final': double.parse(
    //                     value['user_measurement'][0]['bicep'].toString()) +
    //                 double.parse(convertionList['bicep_conversion'] ?? '0.00'),
    //           },
    //           {
    //             'name': 'Arm Length',
    //             'conversion': double.parse(
    //                 convertionList['arm_length_conversion'] ?? '0.00'),
    //             'body': double.parse(
    //                 value['user_measurement'][0]['arm_length'].toString()),
    //             'final': double.parse(
    //                     value['user_measurement'][0]['arm_length'].toString()) +
    //                 double.parse(
    //                     convertionList['arm_length_conversion'] ?? '0.00'),
    //           },
    //           {
    //             'name': 'Waist',
    //             'conversion':
    //                 double.parse(convertionList['waist_conversion'] ?? '0.00'),
    //             'body': double.parse(
    //                 value['user_measurement'][0]['waist'].toString()),
    //             'final': double.parse(
    //                     value['user_measurement'][0]['waist'].toString()) +
    //                 double.parse(convertionList['waist_conversion'] ?? '0.00'),
    //           },
    //           {
    //             'name': 'Hip',
    //             'conversion':
    //                 double.parse(convertionList['hip_conversion'] ?? '0.00'),
    //             'body': double.parse(
    //                 value['user_measurement'][0]['hip'].toString()),
    //             'final': double.parse(
    //                     value['user_measurement'][0]['hip'].toString()) +
    //                 double.parse(convertionList['hip_conversion'] ?? '0.00'),
    //           },
    //           {
    //             'name': 'Dress Length',
    //             'conversion': double.parse(
    //                 convertionList['dress_length_conversion'] ?? '0.00'),
    //             'body': double.parse(
    //                 value['user_measurement'][0]['dress_length'].toString()),
    //             'final': double.parse(value['user_measurement'][0]
    //                         ['dress_length']
    //                     .toString()) +
    //                 double.parse(
    //                     convertionList['dress_length_conversion'] ?? '0.00'),
    //           },
    //         ];
    //         print(measureList);
    //         final dataMeasurement =
    //             Provider.of<Measurement>(context, listen: false);
    //         dataMeasurement.bodyMeasurement = measureList;
    //       });
    //     }
    // });
    // });
  }
}
