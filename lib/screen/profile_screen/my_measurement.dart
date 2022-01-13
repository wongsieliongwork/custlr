import 'package:custlr/api/measurementAPI.dart';
import 'package:custlr/screen/profile_screen/edit_add_measurement.dart';
import 'package:custlr/widget/loading.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class MyMeasurement extends StatefulWidget {
  final bool isSelectMeasurement;
  MyMeasurement(this.isSelectMeasurement);
  @override
  _MyMeasurementState createState() => _MyMeasurementState();
}

class _MyMeasurementState extends State<MyMeasurement> {
  int initialIndex = 0;
  List measurementList = [];
  bool isLoading = true;
  Future getMeasurementAPI() async {
    MeasurementAPI.measurementListAPI().then((value) {
      measurementList = value['user_measurement'];
      setState(() {
        isLoading = false;
      });
    });
  }

  bool isLoadingDefault = false;
  @override
  void initState() {
    super.initState();
    getMeasurementAPI();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          title: Text(
              widget.isSelectMeasurement
                  ? 'Please Select Your Measurement'
                  : 'My Measurement',
              style: TextStyle(color: Colors.black)),
          leading: GestureDetector(
            onTap: () {
              Navigator.pop(context, true);
            },
            child: Icon(
              Icons.keyboard_arrow_left,
              size: 40,
            ),
          ),
        ),
        body: Stack(
          children: [
            Container(
                color: Colors.grey[300],
                child: isLoading
                    ? CustlrLoading.circularLoading()
                    : measurementList.isEmpty
                        ? Container(
                            child: Center(child: Text('Empty')),
                          )
                        : ListView(
                            children: [
                              Container(
                                padding: EdgeInsets.all(20),
                                child: ListView.builder(
                                    shrinkWrap: true,
                                    physics: NeverScrollableScrollPhysics(),
                                    itemCount: measurementList.length,
                                    itemBuilder: (context, index) {
                                      final data = measurementList[index]
                                                  ['gender'] ==
                                              "f"
                                          ? """<div><p><b>Name: ${measurementList[index]['name']} ( ${measurementList[index]['gender']} )</b></p>
Height: ${measurementList[index]['height']}
Chest: ${measurementList[index]['chest']}
Shoulder: ${measurementList[index]['shoulder']}
Arm Length: ${measurementList[index]['arm_length']}
Waist: ${measurementList[index]['waist']}
Hip: ${measurementList[index]['hip']}
Dress Length: ${measurementList[index]['dress_length']}
unit: ${measurementList[index]['unit']}
</div>"""
                                          : """<div><p><b>Name: ${measurementList[index]['name']} ( ${measurementList[index]['gender']} )</b></p>
Height: ${measurementList[index]['height']}
Chest: ${measurementList[index]['chest']}
Shoulder: ${measurementList[index]['shoulder']}
Arm Length: ${measurementList[index]['arm_length']}
Bicep: ${measurementList[index]['bicep']}
Waist: ${measurementList[index]['waist']}
unit: ${measurementList[index]['unit']}
</div>""";
                                      return Container(
                                        padding: EdgeInsets.only(bottom: 20),
                                        child: Row(
                                          children: [
                                            // Radio(
                                            //     activeColor: Colors.green,
                                            //     value: index,
                                            //     groupValue: initialIndex,
                                            //     onChanged: (value) {
                                            //       setState(() {
                                            //         initialIndex = value;
                                            //         MeasurementAPI.defaultMeasurement(
                                            //             measurementList[value]
                                            //                 ['UserMeasurementID']);
                                            //       });
                                            //     }),
                                            Expanded(
                                              child: InkWell(
                                                splashColor: Colors.transparent,
                                                highlightColor:
                                                    Colors.transparent,
                                                onTap: () {
                                                  if (widget
                                                          .isSelectMeasurement ==
                                                      true) {
                                                    Navigator.pop(context,
                                                        measurementList[index]);
                                                  } else {}
                                                },
                                                child: PhysicalModel(
                                                  borderRadius:
                                                      BorderRadius.circular(20),
                                                  color: Colors.white,
                                                  shadowColor: Colors.black,
                                                  elevation: 5,
                                                  child: Container(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            15),
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        Expanded(
                                                          child: Column(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: [
                                                              Html(
                                                                data: data,
                                                                style: {
                                                                  "div": Style(
                                                                    whiteSpace:
                                                                        WhiteSpace
                                                                            .PRE,
                                                                  ),
                                                                },
                                                              ),
                                                              if (index == 0)
                                                                Container(
                                                                  margin: EdgeInsets
                                                                      .only(
                                                                          left:
                                                                              10),
                                                                  padding: EdgeInsets
                                                                      .symmetric(
                                                                          horizontal:
                                                                              10,
                                                                          vertical:
                                                                              5),
                                                                  decoration:
                                                                      BoxDecoration(
                                                                    border: Border.all(
                                                                        color: Colors
                                                                            .lightBlue),
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            20),
                                                                  ),
                                                                  child: Text(
                                                                    'Default Measurement',
                                                                    style: TextStyle(
                                                                        color: Colors
                                                                            .lightBlue),
                                                                  ),
                                                                ),
                                                            ],
                                                          ),
                                                        ),
                                                        Column(
                                                          children: [
                                                            if (index != 0)
                                                              GestureDetector(
                                                                onTap: () =>
                                                                    defaultMeasurement(
                                                                        index),
                                                                child: Container(
                                                                    padding: EdgeInsets.all(5),
                                                                    decoration: BoxDecoration(color: Colors.grey, borderRadius: BorderRadius.circular(10)),
                                                                    child: isLoadingDefault
                                                                        ? Container(
                                                                            child:
                                                                                SpinKitFadingCircle(
                                                                              color: Colors.white,
                                                                              size: 25.0,
                                                                            ),
                                                                          )
                                                                        : Icon(
                                                                            Icons.person,
                                                                            color:
                                                                                Colors.white,
                                                                          )),
                                                              ),
                                                            if (index != 0)
                                                              SizedBox(
                                                                height: 10,
                                                              ),
                                                            GestureDetector(
                                                              onTap: () async {
                                                                bool value = await Navigator.push(
                                                                    context,
                                                                    MaterialPageRoute(
                                                                        builder: (context) => AddEditMeasurement(
                                                                            measurementList[index],
                                                                            false)));

                                                                if (value ==
                                                                    true) {
                                                                  setState(() {
                                                                    getMeasurementAPI();
                                                                  });
                                                                }
                                                              },
                                                              child: Container(
                                                                  padding:
                                                                      EdgeInsets
                                                                          .all(
                                                                              5),
                                                                  decoration: BoxDecoration(
                                                                      color: Colors
                                                                          .orange,
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              10)),
                                                                  child: Icon(
                                                                    Icons.edit,
                                                                    color: Colors
                                                                        .white,
                                                                  )),
                                                            ),
                                                            SizedBox(
                                                              height: 10,
                                                            ),
                                                            GestureDetector(
                                                              onTap: () async {
                                                                Alert(
                                                                    context:
                                                                        context,
                                                                    title:
                                                                        'Do you want delete it?',
                                                                    buttons: [
                                                                      DialogButton(
                                                                          child:
                                                                              Text(
                                                                            'YES',
                                                                            style:
                                                                                TextStyle(color: Colors.white),
                                                                          ),
                                                                          onPressed:
                                                                              () {
                                                                            deleteMeasurement(index);
                                                                          }),
                                                                      DialogButton(
                                                                          child:
                                                                              Text(
                                                                            'CANCEL',
                                                                            style:
                                                                                TextStyle(color: Colors.white),
                                                                          ),
                                                                          onPressed: () =>
                                                                              Navigator.pop(context)),
                                                                    ]).show();
                                                              },
                                                              child: Container(
                                                                  padding:
                                                                      EdgeInsets
                                                                          .all(
                                                                              5),
                                                                  decoration: BoxDecoration(
                                                                      color: Colors
                                                                          .red,
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              10)),
                                                                  child: Icon(
                                                                    Icons
                                                                        .delete,
                                                                    color: Colors
                                                                        .white,
                                                                  )),
                                                            ),
                                                          ],
                                                        )
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            )
                                          ],
                                        ),
                                      );
                                    }),
                              ),
                            ],
                          )),
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                padding: EdgeInsets.only(bottom: 10),
                child: InkWell(
                  onTap: () async {
                    bool value = await Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                AddEditMeasurement([], true)));

                    if (value == true) {
                      setState(() {
                        getMeasurementAPI();
                      });
                    }
                  },
                  highlightColor: Colors.transparent,
                  splashColor: Colors.transparent,
                  child: PhysicalModel(
                    color: Colors.white,
                    shadowColor: Colors.grey,
                    elevation: 5,
                    borderRadius: BorderRadius.circular(30),
                    child: Container(
                      padding:
                          EdgeInsets.symmetric(vertical: 15, horizontal: 30),
                      child: Text(
                        'Add Measurement',
                        style: TextStyle(color: Colors.black),
                      ),
                    ),
                  ),
                ),
              ),
            )
          ],
        ));
  }

  void defaultMeasurement(int index) {
    setState(() {
      isLoadingDefault = true;
    });
    MeasurementAPI.defaultMeasurement(
            measurementList[index]['UserMeasurementID'])
        .then((value) {
      setState(() {
        getMeasurementAPI().then((value) {
          Fluttertoast.showToast(msg: 'Default already');
          isLoadingDefault = false;
        });
      });
    });
  }

  void deleteMeasurement(int index) {
    MeasurementAPI.deleteMeasurement(
            measurementList[index]['UserMeasurementID'])
        .then((value) {
      if (value['status'] == 1) {
        setState(() {
          getMeasurementAPI();
          Navigator.pop(context);
        });
      }
    });
  }
}
