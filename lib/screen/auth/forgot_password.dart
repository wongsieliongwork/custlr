import 'package:custlr/api/authAPI.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

class ForgotPassword extends StatefulWidget {
  @override
  _ForgotPasswordState createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  final phoneController = TextEditingController();
  final pinController = TextEditingController();
  String verificationCode;
  bool isLoading = false;

  void verifyPhone(String phoneNumber) {
    setState(() {
      isLoading = true;
    });
    AuthAPI.verifyPhone(phoneNumber).then((value) async {
      if (value['status'] == '1') {
        Fluttertoast.showToast(msg: value['msg']);

        FirebaseAuth auth = FirebaseAuth.instance;
        await auth.verifyPhoneNumber(
          phoneNumber: '+60' + phoneNumber,
          verificationCompleted: (PhoneAuthCredential credential) async {
            await auth.signInWithCredential(credential);
          },
          verificationFailed: (FirebaseAuthException e) {
            if (e.code == 'invalid-phone-number') {
              setState(() {
                isLoading = false;
              });
              Fluttertoast.showToast(
                  msg: 'The provided phone number is not valid');
              print('The provided phone number is not valid');
            }
          },
          codeSent: (String verificationId, int resendToken) async {
            setState(() {
              isLoading = false;
              verificationCode = verificationId;
              isSubmit = true;
            });
          },
          codeAutoRetrievalTimeout: (String verificationId) async {
            setState(() {
              verificationCode = verificationId;
            });
          },
          timeout: Duration(seconds: 120),
        );
      } else {
        Fluttertoast.showToast(msg: value['msg']);
      }
    });
  }

  bool isSubmit = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Forgot Password',
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: Container(
        padding: EdgeInsets.all(20),
        color: Colors.orangeAccent,
        child: Column(
          children: [
            // Send Phone Verify
            Visibility(
              visible: !isSubmit,
              child: Column(
                children: [
                  SizedBox(
                    height: 20,
                  ),
                  TextField(
                    textInputAction: TextInputAction.next,
                    textAlign: TextAlign.left,
                    controller: phoneController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      prefixText: "+60 - ",
                      hintText: 'Phone Number',
                      hintStyle: TextStyle(fontSize: 16),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: BorderSide(
                          width: 0,
                          style: BorderStyle.none,
                        ),
                      ),
                      filled: true,
                      contentPadding: EdgeInsets.all(16),
                      fillColor: Colors.white,
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  InkWell(
                    highlightColor: Colors.transparent,
                    splashColor: Colors.transparent,
                    onTap: () {
                      verifyPhone(phoneController.text);
                    },
                    child: PhysicalModel(
                      color: Colors.blueAccent,
                      shadowColor: Colors.grey,
                      elevation: 5,
                      borderRadius: BorderRadius.circular(30),
                      child: Container(
                        padding:
                            EdgeInsets.symmetric(vertical: 15, horizontal: 30),
                        child: isLoading
                            ? CircularProgressIndicator(
                                color: Colors.white,
                              )
                            : Text('Submit',
                                style: TextStyle(color: Colors.white)),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // OTP
            Visibility(
              visible: isSubmit,
              child: Column(
                children: [
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                    'We have sent the verification code to',
                    style: TextStyle(fontSize: 20),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                    '+60' + phoneController.text,
                    style: TextStyle(fontSize: 20),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Form(
                    child: PinCodeTextField(
                      keyboardType: TextInputType.number,
                      appContext: context,
                      pastedTextStyle: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                      length: 6,
                      // d obsecureText: false,
                      animationType: AnimationType.fade,
                      // validator: (v) {
                      //   if (v.length < 3) {
                      //     return "I'm from validator";
                      //   } else {
                      //     return null;
                      //   }
                      // },
                      pinTheme: PinTheme(
                        shape: PinCodeFieldShape.box,
                        activeColor: Colors.white,
                        inactiveColor: Colors.white,
                        borderRadius: BorderRadius.circular(5),
                        selectedColor: null,
                        fieldHeight: 50,
                        fieldWidth: 40,
                        selectedFillColor: Colors.white,
                        inactiveFillColor: Colors.white,
                        activeFillColor: Colors.white,
                      ),
                      animationDuration: Duration(milliseconds: 300),
                      enableActiveFill: true,
                      onCompleted: (v) async {
                        try {
                          await FirebaseAuth.instance
                              .signInWithCredential(
                                  PhoneAuthProvider.credential(
                                      verificationId: verificationCode,
                                      smsCode: v))
                              .then((value) async {
                            if (value.user != null) {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          ForgotChangePassword(
                                              phoneController.text)));
                            } else {
                              print('False');
                            }
                          });
                        } catch (e) {
                          Fluttertoast.showToast(msg: e);
                        }
                      },
                      onChanged: (value) {
                        print(value);
                      },
                      beforeTextPaste: (text) {
                        return true;
                      },
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

class ForgotChangePassword extends StatefulWidget {
  ForgotChangePassword(this.phone);
  final String phone;
  @override
  _ForgotChangePasswordState createState() => _ForgotChangePasswordState();
}

class _ForgotChangePasswordState extends State<ForgotChangePassword> {
  final passwordController = TextEditingController();
  bool secure1 = true;
  bool isLoading = false;
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
        padding: EdgeInsets.all(20),
        color: Colors.orangeAccent,
        child: Column(
          children: [
            TextField(
              textInputAction: TextInputAction.next,
              textAlign: TextAlign.left,
              controller: passwordController,
              keyboardType: TextInputType.text,
              obscureText: secure1,
              decoration: InputDecoration(
                suffixIcon: GestureDetector(
                  onTap: () {
                    setState(() {
                      secure1 = !secure1;
                    });
                  },
                  child:
                      Icon(secure1 ? Icons.visibility_off : Icons.visibility),
                ),
                prefixIcon: Icon(Icons.lock),
                hintText: 'Password',
                hintStyle: TextStyle(fontSize: 16),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: BorderSide(
                    width: 0,
                    style: BorderStyle.none,
                  ),
                ),
                filled: true,
                contentPadding: EdgeInsets.all(16),
                fillColor: Colors.white,
              ),
            ),
            Spacer(),
            InkWell(
              splashColor: Colors.transparent,
              highlightColor: Colors.transparent,
              onTap: () {
                setState(() {
                  isLoading = true;
                });

                final data = {
                  'contact_no': widget.phone,
                  'password': passwordController.text,
                  'device_name': 'mobile',
                };
                AuthAPI.resetPassword(data).then((value) {
                  if (value['status'] == 1) {
                    setState(() {
                      isLoading = false;
                    });

                    Fluttertoast.showToast(msg: value['msg']);
                    Navigator.pop(context);
                    Navigator.pop(context);
                  } else {
                    setState(() {
                      isLoading = false;
                    });
                    Fluttertoast.showToast(msg: value['msg']);
                  }
                });
              },
              child: PhysicalModel(
                color: Colors.black,
                elevation: 5,
                shadowColor: Colors.grey,
                borderRadius: BorderRadius.circular(20),
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                  child: isLoading
                      ? CircularProgressIndicator(
                          color: Colors.white,
                        )
                      : Text(
                          'Confirm',
                          style: TextStyle(color: Colors.white),
                        ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
