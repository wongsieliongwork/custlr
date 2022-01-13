import 'package:custlr/api/authAPI.dart';
import 'package:custlr/utils/shared_preference_utils.dart';
import 'package:custlr/widget/loading.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gender_picker/source/enums.dart';
import 'package:gender_picker/source/gender_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EditProfile extends StatefulWidget {
  @override
  _EditProfileState createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  final firstController = TextEditingController();
  final lastController = TextEditingController();
  final contactController = TextEditingController();
  final emailController = TextEditingController();

  List textFieldList = [];
  // String gender;
  void textField() async {
    textFieldList = [
      {
        'name': 'First Name',
        'controller': firstController,
        'icon': Icon(Icons.person),
        'data': SharedPreferencesUtil.firstName,
      },
      {
        'name': 'Last Name',
        'controller': lastController,
        'icon': Icon(Icons.person),
        'data': SharedPreferencesUtil.lastName,
      },
      {
        'name': 'Contact Number',
        'controller': contactController,
        'icon': Icon(Icons.phone),
        'data': SharedPreferencesUtil.contactNo,
      },
      {
        'name': 'Email',
        'controller': emailController,
        'icon': Icon(Icons.email),
        'data': SharedPreferencesUtil.email,
      },
    ];

    setState(() {});
  }

  String birthdate = SharedPreferencesUtil.birthdate;
  DateTime now = new DateTime.now();
  @override
  void initState() {
    super.initState();
    textField();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            'Edit Profile',
            style: TextStyle(color: Colors.black),
          ),
        ),
        body: Stack(
          children: [
            ListView.builder(
                itemCount: textFieldList.length + 2,
                itemBuilder: (context, index) {
                  if (index == textFieldList.length) {
                    return GestureDetector(
                      onTap: () {
                        DatePicker.showDatePicker(context,
                            showTitleActions: true,
                            minTime: DateTime(1900, 1, 1),
                            maxTime: DateTime(now.year, now.month, now.day),
                            onChanged: (date) {
                          print('change $date');
                        }, onConfirm: (date) {
                          setState(() {
                            birthdate =
                                "${date.year}-${date.month}-${date.day}";
                          });
                        }, currentTime: DateTime.now(), locale: LocaleType.en);
                      },
                      child: Container(
                        padding: EdgeInsets.all(20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Birth Date',
                              style: TextStyle(color: Colors.grey),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Column(
                              children: [
                                Container(
                                  padding: EdgeInsets.symmetric(horizontal: 12),
                                  child: Row(
                                    children: [
                                      Icon(Icons.date_range),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      Text(birthdate ?? "Select Birthday"),
                                    ],
                                  ),
                                ),
                                Divider(
                                  thickness: 1,
                                  color: Colors.grey,
                                )
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  }
                  if (index == textFieldList.length + 1) {
                    return Container(
                      padding: EdgeInsets.only(left: 40),
                      child: GenderPickerWithImage(
                        verticalAlignedText: false,
                        // to show what's selected on app opens, but by default it's Male
                        selectedGender: SharedPreferencesUtil.gender == 'male'
                            ? Gender.Male
                            : Gender.Female,
                        selectedGenderTextStyle: TextStyle(
                            color: Color(0xFF8b32a8),
                            fontWeight: FontWeight.bold),
                        unSelectedGenderTextStyle: TextStyle(
                            color: Colors.black, fontWeight: FontWeight.normal),
                        onChanged: (Gender gender) {
                          if (gender == Gender.Male) {
                            SharedPreferencesUtil.gender = 'male';
                          } else {
                            SharedPreferencesUtil.gender = 'female';
                          }
                        },
                        //Alignment between icons
                        equallyAligned: true,

                        animationDuration: Duration(milliseconds: 300),
                        isCircular: true,
                        // default : true,
                        opacityOfGradient: 0.4,

                        size: 70, //default : 40
                      ),
                    );
                  }
                  textFieldList[index]['controller'].text =
                      textFieldList[index]['data'];
                  return Container(
                    padding: EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          textFieldList[index]['name'],
                          style: TextStyle(color: Colors.grey),
                        ),
                        TextField(
                          controller: textFieldList[index]['controller'],
                          decoration: new InputDecoration(
                            prefixText: index == 2 ? '+60 -' : '',
                            prefixIcon: textFieldList[index]['icon'],
                            hintText: textFieldList[index]['name'],
                          ),
                        ),
                      ],
                    ),
                  );
                }),
            SafeArea(
              child: Align(
                alignment: Alignment.bottomCenter,
                child: GestureDetector(
                  onTap: () async {
                    SharedPreferences pref =
                        await SharedPreferences.getInstance();
                    CustlrLoading.showLoaderDialog(context);
                    final data = {
                      'first_name': firstController.text,
                      'last_name': lastController.text,
                      'contact_no': contactController.text,
                      'gender': SharedPreferencesUtil.gender,
                      'email': emailController.text,
                    };
                    AuthAPI.editProfile(data).then((value) {
                      if (value['status'] == 1) {
                        SharedPreferencesUtil.birthdate = birthdate;
                        Fluttertoast.showToast(msg: 'Successful');
                        CustlrLoading.hideLoaderDialog(context);
                        Navigator.pop(context, true);
                      }
                    });
                  },
                  child: Container(
                    margin: EdgeInsets.symmetric(vertical: 20),
                    padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Colors.black),
                    child: Text(
                      'Confirm',
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 18),
                    ),
                  ),
                ),
              ),
            )
          ],
        ));
  }
}
