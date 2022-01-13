import 'package:custlr/api/measurementAPI.dart';
import 'package:custlr/utils/constants.dart';
import 'package:flutter/material.dart';

class AddEditMeasurement extends StatefulWidget {
  final dynamic data;
  final bool isAdd;
  AddEditMeasurement(this.data, this.isAdd);
  @override
  _AddEditMeasurementState createState() => _AddEditMeasurementState();
}

class _AddEditMeasurementState extends State<AddEditMeasurement> {
  final nameController = TextEditingController();
  final heightController = TextEditingController();
  final chestController = TextEditingController();
  final shoulderController = TextEditingController();
  final armLengthController = TextEditingController();
  final bicepController = TextEditingController();
  final waistController = TextEditingController();
  final hipController = TextEditingController();
  final dressLengthController = TextEditingController();

  List measurementList = [];

  void getAddressIntoList() {
    if (!widget.isAdd) {
      nameController.text = '${widget.data['name']}';
      heightController.text = '${widget.data['height']}';
      chestController.text = '${widget.data['chest']}';
      shoulderController.text = '${widget.data['shoulder']}';
      armLengthController.text = '${widget.data['arm_length']}';
      bicepController.text = '${widget.data['bicep']}';
      waistController.text = '${widget.data['waist']}';
      hipController.text = "${widget.data['hip']}";
      dressLengthController.text = "${widget.data['dress_length']}";
    }
    print(isMale);
  }

  bool isLoading = false;

  bool isMale;
  void isGender() {
    if (widget.isAdd) {
      isMale = true;
    } else {
      if (widget.data['gender'] == "m") {
        isMale = true;
      } else {
        isMale = false;
      }
    }
  }

  @override
  void initState() {
    super.initState();
    isGender();
    getAddressIntoList();
  }

  @override
  Widget build(BuildContext context) {
    final isKeyboard = MediaQuery.of(context).viewInsets.bottom != 0;
    measurementList = [
      {
        'name': 'Name',
        'top': Custlr.height / 50,
        'left': Custlr.width / 1.9,
        'controller': nameController,
      },
      {
        'name': 'Height',
        'top': Custlr.height / 50,
        'left': Custlr.width / 20,
        'controller': heightController,
      },
      {
        'name': 'Chest',
        'top': Custlr.height / 5.5,
        'left': Custlr.width / 3,
        'controller': chestController,
      },
      {
        'name': 'Shoulder',
        'top': Custlr.height / 8,
        'left': Custlr.width / 30,
        'controller': shoulderController,
      },
      {
        'name': 'Arm Length',
        'top': Custlr.height / 3.4,
        'left': Custlr.width / 30,
        'controller': armLengthController,
      },
      {
        'name': 'Waist',
        'top': Custlr.height / 2.8,
        'left': Custlr.width / 3,
        'controller': waistController,
      },
      if (isMale)
        {
          'name': 'Bicep',
          'top': Custlr.height / 4.2,
          'left': Custlr.width / 1.7,
          'controller': bicepController,
        },
      if (!isMale)
        {
          'name': 'Hip',
          'top': Custlr.height / 2.4,
          'left': Custlr.width / 3,
          'controller': hipController,
        },
      if (!isMale)
        {
          'name': 'Dress Length',
          'top': Custlr.height / 2.1,
          'left': Custlr.width / 2.0,
          'controller': dressLengthController,
        },
    ];

    return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          title: Text(
            widget.isAdd ? "Add Measurement" : 'Edit Measurement',
            style: TextStyle(color: Colors.black),
          ),
          actions: [
            GestureDetector(
              onTap: () {
                setState(() {
                  if (!isMale) isMale = !isMale;
                });
              },
              child: Image.asset(
                'assets/images/product/male.png',
                scale: 5,
                color: isMale ? Colors.blue : Colors.black,
              ),
            ),
            GestureDetector(
              onTap: () {
                setState(() {
                  if (isMale) isMale = !isMale;
                });
              },
              child: Image.asset(
                'assets/images/product/female.png',
                scale: 5,
                color: !isMale ? Colors.blue : Colors.black,
              ),
            ),
          ],
        ),
        body: Stack(
          fit: StackFit.expand,
          alignment: Alignment.center,
          children: [
            Image.asset(
              isMale
                  ? 'assets/images/bodyMeasurement/male_body.jpeg'
                  : 'assets/images/bodyMeasurement/female_body.jpg',
              fit: BoxFit.cover,
            ),
            Stack(
                children: List.generate(measurementList.length, (index) {
              return Positioned(
                top: measurementList[index]['top'],
                left: measurementList[index]['left'],
                child: PhysicalModel(
                  color: Colors.white,
                  elevation: 5,
                  borderRadius: BorderRadius.circular(20),
                  shadowColor: Colors.grey,
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    height: 35,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          measurementList[index]['name'] + " : ",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Container(
                          width: measurementList[index]['name'] == 'Name'
                              ? 120
                              : 80,
                          padding:
                              EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          child: TextField(
                            textInputAction:
                                measurementList[index]['name'] == "Dress Length"
                                    ? TextInputAction.done
                                    : TextInputAction.next,
                            keyboardType:
                                measurementList[index]['name'] == 'Name'
                                    ? TextInputType.text
                                    : TextInputType.number,
                            controller: measurementList[index]['controller'],
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              );
            })),
            Align(
              alignment: Alignment.bottomCenter,
              child: SafeArea(
                child: Container(
                  padding: EdgeInsets.only(bottom: 20),
                  child: InkWell(
                    highlightColor: Colors.transparent,
                    splashColor: Colors.transparent,
                    onTap: () async {
                      setState(() {
                        isLoading = true;
                      });
                      dynamic data = {
                        'name': nameController.text,
                        'gender': isMale ? "m" : "f",
                        'size': 'custom',
                        'height': heightController.text,
                        'chest': chestController.text,
                        'shoulder': shoulderController.text,
                        'arm_length': armLengthController.text,
                        'bicep': bicepController.text,
                        'waist': waistController.text,
                        'hip': isMale ? "0" : hipController.text,
                        'dress_length':
                            isMale ? "0" : dressLengthController.text,
                        'unit': 'inch',
                        'id':
                            widget.isAdd ? '' : widget.data['UserMeasurementID']
                      };
                      print(data);
                      MeasurementAPI.addEditMeasurement(data).then((value) {
                        if (value['status'] == 1 || value['status'] == 2) {
                          Navigator.pop(context, true);
                        }
                      });
                    },
                    child: PhysicalModel(
                      color: Colors.black,
                      elevation: 10,
                      shadowColor: Colors.grey,
                      borderRadius: BorderRadius.circular(30),
                      child: Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: 40, vertical: 15),
                          child: isLoading
                              ? Container(
                                  child: CircularProgressIndicator(
                                    color: Colors.white,
                                  ),
                                )
                              : Text(
                                  'Confirm',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold),
                                )),
                    ),
                  ),
                ),
              ),
            )
          ],
        ));
  }
}
