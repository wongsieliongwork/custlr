import 'package:custlr/api/authAPI.dart';
import 'package:custlr/widget/loading.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ChangePassword extends StatefulWidget {
  @override
  _ChangePasswordState createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {
  final oldController = TextEditingController();
  final newController = TextEditingController();

  List passwordList = [];

  // String contact = '';
  // void sharedPreference() async {
  //   SharedPreferences pref = await SharedPreferences.getInstance();
  //   contact = pref.getString('contact_no');
  //   setState(() {});
  // }

  void nameAndTextField() {
    passwordList = [
      {
        'name': 'Old Password',
        'icon': Icons.lock,
        'controller': oldController,
        'secure': true,
      },
      {
        'name': 'Confirm Password',
        'icon': Icons.lock,
        'controller': newController,
        'secure': true,
      }
    ];
  }

  @override
  void initState() {
    super.initState();
    nameAndTextField();
    // sharedPreference();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            'Change Password',
            style: TextStyle(color: Colors.black),
          ),
        ),
        body: Container(
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 40),
          child: Column(
            children: [
              Column(
                children: List.generate(passwordList.length, (index) {
                  return Container(
                    margin: EdgeInsets.only(bottom: 30),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          passwordList[index]['name'],
                          style: TextStyle(color: Colors.grey),
                        ),
                        TextField(
                          obscureText: passwordList[index]['secure'],
                          controller: passwordList[index]['controller'],
                          decoration: new InputDecoration(
                            prefixIcon: Icon(passwordList[index]['icon']),
                            hintText: passwordList[index]['name'],
                            suffixIcon: GestureDetector(
                              onTap: () {
                                setState(() {
                                  passwordList[index]['secure'] =
                                      !passwordList[index]['secure'];
                                });
                              },
                              child: Icon(passwordList[index]['secure']
                                  ? Icons.visibility_off
                                  : Icons.visibility),
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                }),
              ),
              Spacer(),
              InkWell(
                highlightColor: Colors.transparent,
                splashColor: Colors.transparent,
                onTap: () {
                  CustlrLoading.showLoaderDialog(context);
                  final data = {
                    'old_password': oldController.text,
                    'new_password': newController.text,
                  };
                  AuthAPI.changePassword(data).then((value) {
                    CustlrLoading.hideLoaderDialog(context);
                    Fluttertoast.showToast(msg: value['msg']);
                    Navigator.pop(context);
                  });
                },
                child: PhysicalModel(
                  shadowColor: Colors.grey,
                  elevation: 10,
                  borderRadius: BorderRadius.circular(30),
                  color: Colors.blue,
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 15, horizontal: 40),
                    child: Text(
                      'Confirm',
                      style: TextStyle(color: Colors.white, fontSize: 20),
                    ),
                  ),
                ),
              )
            ],
          ),
        ));
  }
}
