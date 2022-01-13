import 'dart:io';

import 'package:custlr/api/authAPI.dart';
import 'package:custlr/common/dynamic_link_service.dart';
import 'package:custlr/utils/constants.dart';
import 'package:custlr/screen/auth/forgot_password.dart';
import 'package:custlr/widget/loading.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:custlr/utils/shared_preference_utils.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginRegister extends StatefulWidget {
  LoginRegister(this.isCheckout);
  final bool isCheckout;
  @override
  _LoginRegisterState createState() => _LoginRegisterState();
}

class _LoginRegisterState extends State<LoginRegister> {
  // Controller
  final firstController = TextEditingController();
  final lastController = TextEditingController();
  final contactController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  // Database
  bool isRegister = false;
  bool secure1 = true;
  String gender = 'Male';

  List textFieldList = [];
  void textField() {
    textFieldList = [
      {
        'name': 'First Name',
        'controller': firstController,
        'icon': Icons.person,
        'isLogin': false,
      },
      {
        'name': 'Last Name',
        'controller': lastController,
        'icon': Icons.person,
        'isLogin': false,
      },
      {
        'name': 'Contact Number',
        'controller': contactController,
        'icon': Icons.phone,
        'isLogin': false,
      },
      {
        'name': 'Email Address Or Username',
        'controller': emailController,
        'icon': Icons.email,
        'isLogin': true,
      },
    ];
  }

  List socialLogin = [
    {
      'image': 'assets/images/facebook-icon.png',
      'name': 'Facebook',
    },
    if (Platform.isIOS)
      {
        'image': 'assets/images/apple_logo.png',
        'name': 'Sign in with Apple',
      },
    {
      'image': 'assets/images/google-icon.png',
      'name': 'Google+',
    },
  ];

  @override
  void initState() {
    super.initState();
    textField();
    DynamicLinkService().initDynamicLinks(context);
  }

  @override
  Widget build(BuildContext context) {
    final isKeyboard = MediaQuery.of(context).viewInsets.bottom != 0;
    final size = MediaQuery.of(context).size;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
        child: Stack(
          fit: StackFit.expand,
          children: [
            Image.asset(
              'assets/images/Login_Register.jpeg',
              fit: BoxFit.cover,
            ),
            SafeArea(
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: [
                    !isKeyboard
                        ? Expanded(
                            child: Container(
                              child: Image.asset(
                                'assets/images/white-logo.png',
                                scale: 10,
                              ),
                            ),
                          )
                        : Container(
                            height: size.height / 6,
                            child: Image.asset(
                              'assets/images/white-logo.png',
                              scale: 10,
                            ),
                          ),
                    Container(
                      child: Column(
                        children: [
                          Column(
                            children:
                                List.generate(textFieldList.length, (index) {
                              return Visibility(
                                visible: textFieldList[index]['isLogin']
                                    ? true
                                    : isRegister,
                                child: Container(
                                  padding: EdgeInsets.only(bottom: 10),
                                  child: TextField(
                                    textInputAction: TextInputAction.next,
                                    controller: textFieldList[index]
                                        ['controller'],
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 13),
                                    decoration: new InputDecoration(
                                        contentPadding:
                                            EdgeInsets.symmetric(vertical: 5),
                                        border: new OutlineInputBorder(
                                          borderRadius: const BorderRadius.all(
                                            Radius.circular(30.0),
                                          ),
                                          borderSide: BorderSide(
                                            color: Colors.white,
                                            width: 1,
                                          ),
                                        ),
                                        enabledBorder: OutlineInputBorder(
                                          borderRadius: const BorderRadius.all(
                                            Radius.circular(30.0),
                                          ),
                                          borderSide: BorderSide(
                                            color: Colors.white,
                                            width: 1,
                                          ),
                                        ),
                                        filled: true,
                                        prefixText: textFieldList[index]
                                                    ['name'] ==
                                                'Contact Number'
                                            ? '+60 - '
                                            : null,
                                        prefixStyle:
                                            TextStyle(color: Colors.white),
                                        prefixIcon: Icon(
                                          textFieldList[index]['icon'],
                                          color: Colors.white,
                                        ),
                                        hintStyle:
                                            new TextStyle(color: Colors.white),
                                        hintText: textFieldList[index]['name'],
                                        fillColor: Colors.black),
                                  ),
                                ),
                              );
                            }),
                          ),
                          Row(
                            children: [
                              Expanded(
                                child: TextField(
                                  controller: passwordController,
                                  obscureText: secure1,
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 13),
                                  decoration: new InputDecoration(
                                      contentPadding:
                                          EdgeInsets.symmetric(vertical: 5),
                                      suffixIcon: GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            secure1 = !secure1;
                                          });
                                        },
                                        child: Icon(
                                          secure1
                                              ? Icons.visibility_off
                                              : Icons.visibility,
                                          color: Colors.white,
                                        ),
                                      ),
                                      border: new OutlineInputBorder(
                                        borderRadius: const BorderRadius.all(
                                          Radius.circular(30.0),
                                        ),
                                        borderSide: BorderSide(
                                          color: Colors.white,
                                          width: 1,
                                        ),
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderRadius: const BorderRadius.all(
                                          Radius.circular(30.0),
                                        ),
                                        borderSide: BorderSide(
                                          color: Colors.white,
                                          width: 1,
                                        ),
                                      ),
                                      filled: true,
                                      prefixIcon: Icon(
                                        Icons.lock,
                                        color: Colors.white,
                                      ),
                                      hintStyle:
                                          new TextStyle(color: Colors.white),
                                      hintText: "Password",
                                      fillColor: Colors.black),
                                ),
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              ForgotPassword()));
                                },
                                child: Text(
                                  'Forgot Password?',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold),
                                ),
                              )
                            ],
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          InkWell(
                            splashColor: Colors.transparent,
                            highlightColor: Colors.transparent,
                            onTap: () => loginOrRegister(),
                            child: PhysicalModel(
                                borderRadius: BorderRadius.circular(30),
                                color: Colors.white,
                                child: Container(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 60, vertical: 15),
                                  child: Text(
                                    isRegister ? 'Register' : 'Log In',
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18),
                                  ),
                                )),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Visibility(
                            visible: !isRegister,
                            child: Column(
                              children: [
                                Text(
                                  '- Or Log in using -',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: List.generate(socialLogin.length,
                                        (index) {
                                      return Container(
                                          padding: EdgeInsets.all(20),
                                          child: Column(
                                            children: [
                                              GestureDetector(
                                                onTap: () {
                                                  if (socialLogin[index]
                                                          ['name'] ==
                                                      'Facebook') {
                                                    facebookLogin();
                                                  } else if (socialLogin[index]
                                                          ['name'] ==
                                                      'Google+') {
                                                    googleLogin();
                                                  } else {
                                                    print('AAA');
                                                    appleLogin();
                                                  }
                                                },
                                                child: Container(
                                                  child: Image.asset(
                                                    socialLogin[index]['image'],
                                                    height: size.height / 13,
                                                  ),
                                                ),
                                              ),
                                              SizedBox(
                                                height: 10,
                                              ),
                                              Text(
                                                socialLogin[index]['name'],
                                                style: TextStyle(
                                                    color: Colors.white),
                                              )
                                            ],
                                          ));
                                    })),
                              ],
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                isRegister = !isRegister;
                                firstController.text = '';
                                lastController.text = '';
                                contactController.text = '';
                                emailController.text = '';
                                passwordController.text = '';
                              });
                            },
                            child: Text(
                              isRegister
                                  ? "Login?"
                                  : "Don't have an account? Sign Up",
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          GestureDetector(
                            onTap: () => skipLogin(),
                            child: Center(
                              child: Html(style: {
                                'p': Style(
                                    color: Colors.white,
                                    textAlign: TextAlign.center),
                                'u': Style(textDecorationThickness: 2)
                              }, data: '<p><u>Skip</u> Login for now</p>'),
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
            ),
          ],
        ),
      ),
    );
  }

  skipLogin() async {
    SharedPreferencesUtil.isLogIn = false;
    // SharedPreferences pref = await SharedPreferences.getInstance();
    // pref.setBool('isLogIn', false);
    Navigator.pushNamed(context, 'Choose Gender');
  }

  appleLogin() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    AuthAPI().signInWithApple().then((value) {
      AuthAPI.getSocialToken().then((data) {
        AuthAPI.socialLogin(
                value.user.email, value.user.displayName, data['token'])
            .then((inf) {
          print(value);
          print(inf['status']);
          if (inf['status'] == '1') {
            SharedPreferencesUtil.userId = inf['user']['UserID'].toString();
            SharedPreferencesUtil.firstName = inf['user']['first_name'];
            SharedPreferencesUtil.lastName = '';

            SharedPreferencesUtil.email = value.user.email;
            SharedPreferencesUtil.profilePic = '';
            pref.setString('UserID', inf['user']['UserID'].toString());
            pref.setString('first_name', inf['user']['first_name']);
            pref.setString('last_name', '');
            pref.setString('email', value.user.email);
            pref.setString('profile_pic', '');

            AuthAPI.userAPI(inf['token']);
            CustlrLoading.hideLoaderDialog(context);
            if (widget.isCheckout) {
              Navigator.pop(context, true);
            } else {
              Navigator.of(context).pushNamedAndRemoveUntil(
                  'Choose Gender', (Route<dynamic> route) => false);
            }

            Fluttertoast.showToast(msg: inf['msg']);
            islogIn();
          } else {
            CustlrLoading.hideLoaderDialog(context);
            Fluttertoast.showToast(msg: inf['msg']);
          }
        });
      });
    });
  }

  facebookLogin() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    AuthAPI().signInWithFacebook(context).then((value) {
      print('${value.additionalUserInfo.profile['email']}');
      print('${value.user}');

      AuthAPI.getSocialToken().then((data) {
        AuthAPI.socialLogin(value.additionalUserInfo.profile['email'],
                value.additionalUserInfo.profile['name'], data['token'])
            .then((inf) {
          if (inf['status'] == '1') {
            print('AAAAA');
            SharedPreferencesUtil.userId = inf['user']['UserID'].toString();
            SharedPreferencesUtil.firstName = value.user.displayName;
            SharedPreferencesUtil.lastName = '';
            SharedPreferencesUtil.email = value.user.email;
            SharedPreferencesUtil.profilePic = value.user.photoURL;
            pref.setString('UserID', inf['user']['UserID'].toString());
            pref.setString('first_name', value.user.displayName);
            pref.setString('last_name', '');
            pref.setString('email', value.user.email);
            pref.setString('profile_pic', value.user.photoURL);

            AuthAPI.userAPI(inf['token']);

            if (widget.isCheckout) {
              CustlrLoading.hideLoaderDialog(context);
            } else {
              print('AAAAA');
              Navigator.of(context).pushNamedAndRemoveUntil(
                  'Choose Gender', (Route<dynamic> route) => false);
            }

            Fluttertoast.showToast(msg: inf['msg']);
            islogIn();
          } else {
            CustlrLoading.hideLoaderDialog(context);
            Fluttertoast.showToast(msg: inf['msg']);
          }
        });
      });
    });
  }

  googleLogin() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    AuthAPI().signInWithGoogle(context).then((value) {
      print(value.user.email);

      AuthAPI.getSocialToken().then((data) {
        AuthAPI.socialLogin(
                value.user.email, value.user.displayName, data['token'])
            .then((inf) {
          print(value.user.email);
          print('Status $inf');
          if (inf['status'] == '1') {
            SharedPreferencesUtil.userId = inf['user']['UserID'].toString();
            SharedPreferencesUtil.firstName = value.user.displayName;
            SharedPreferencesUtil.lastName = '';

            SharedPreferencesUtil.email = value.user.email;
            SharedPreferencesUtil.profilePic = value.user.photoURL;
            pref.setString('UserID', inf['user']['UserID'].toString());
            pref.setString('first_name', value.user.displayName);
            pref.setString('last_name', '');
            pref.setString('email', value.user.email);
            pref.setString('profile_pic', value.user.photoURL);

            AuthAPI.userAPI(inf['token']);
            CustlrLoading.hideLoaderDialog(context);
            print('Checkout ${widget.isCheckout}');
            if (widget.isCheckout) {
              print('a');
              Navigator.pop(context, true);
            } else {
              print('B');
              Navigator.of(context).pushNamedAndRemoveUntil(
                  'Choose Gender', (Route<dynamic> route) => false);
            }

            Fluttertoast.showToast(msg: inf['msg']);
            islogIn();
          } else {
            CustlrLoading.hideLoaderDialog(context);
            Fluttertoast.showToast(msg: inf['msg']);
          }
        });
      });
    });
  }

  loginOrRegister() {
    setState(() {});
    if (isRegister) {
      register();
    } else {
      login();
      print(emailController.text);
      print(passwordController.text);
    }
  }

// Login
  login() async {
    await FirebaseMessaging.instance.getToken().then((token) {
      print('TOKEN $token');
      CustlrLoading.showLoaderDialog(context);
      final data = {
        'email': emailController.text,
        'password': passwordController.text,
        'device_name': 'mobile',
        'token': token
      };
      print('$data');
      AuthAPI.userLogin(data).then((value) {
        if (value['status'] == '1') {
          AuthAPI.userAPI(value['token']);
          CustlrLoading.hideLoaderDialog(context);
          if (widget.isCheckout) {
            Navigator.pop(context, true);
          } else {
            Navigator.of(context).pushNamedAndRemoveUntil(
                'Choose Gender', (Route<dynamic> route) => false);
          }

          Fluttertoast.showToast(msg: value['msg']);
          islogIn();
        } else {
          CustlrLoading.hideLoaderDialog(context);
          Fluttertoast.showToast(msg: value['msg']);
        }
      });
    });
  }

// Register
  register() {
    CustlrLoading.showLoaderDialog(context);
    final data = {
      'first_name': firstController.text,
      'last_name': lastController.text,
      'contact_no': contactController.text,
      'email': emailController.text,
      'password': passwordController.text,
      'gender': gender,
      'device_name': 'mobile',
    };
    AuthAPI.userRegister(data).then((value) {
      if (value['status'] == '1') {
        AuthAPI.userAPI(value['token']);
        CustlrLoading.hideLoaderDialog(context);
        if (widget.isCheckout) {
          Navigator.pop(context, true);
        } else {
          Navigator.of(context).pushNamedAndRemoveUntil(
              'Choose Gender', (Route<dynamic> route) => false);
        }

        Fluttertoast.showToast(msg: value['msg']);
        islogIn();
      } else {
        CustlrLoading.hideLoaderDialog(context);
        Fluttertoast.showToast(msg: value['msg']);
      }
    });
  }

  void islogIn() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    pref.setBool('isLogIn', true);
    SharedPreferencesUtil.isLogIn = true;
  }
}

/*
import 'package:custlr/api/authAPI.dart';
import 'package:custlr/provider/dynamic_link_service.dart';
import 'package:custlr/screen/auth/forgot_password.dart';
import 'package:custlr/widget/loading.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gender_picker/source/gender_picker.dart';
import 'package:gender_picker/source/enums.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginRegister extends StatefulWidget {
  @override
  _LoginRegisterState createState() => _LoginRegisterState();
}

class _LoginRegisterState extends State<LoginRegister> {
  // Controller
  final firstController = TextEditingController();
  final lastController = TextEditingController();
  final contactController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  bool isRegister = false;
  bool secure1 = true;
  String gender = 'Male';

  bool validatePassword = false;
  int validateEmail = 0;
  String errorEmailText = '';

  @override
  void dispose() {
    // passwordController.dispose();
    super.dispose();
  }

  @override
  void initState() {
   
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          padding: EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Image.asset('assets/images/black-logo.png'),
              Column(
                children: [
                  // For Register Only TextField
                  Visibility(
                    visible: isRegister,
                    child: Column(
                      children: [
                        // First Name
                        TextField(
                          controller: firstController,
                          decoration: InputDecoration(
                            prefixIcon: Icon(Icons.person),
                            hintText: 'First Name',
                          ),
                        ),
                        // Last Name
                        TextField(
                          controller: lastController,
                          decoration: InputDecoration(
                            prefixIcon: Icon(Icons.person),
                            hintText: 'Last Name',
                          ),
                        ),
                        // Last Name
                        TextField(
                          controller: contactController,
                          decoration: InputDecoration(
                            prefixIcon: Icon(Icons.phone),
                            prefixText: '+60 - ',
                            hintText: 'Phone Number',
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Email
                  TextField(
                    controller: emailController,
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.email),
                      hintText: 'Email',
                      helperText: 'ABC@example.com',
                    ),
                  ),
                  //Password
                  TextField(
                    controller: passwordController,
                    obscureText: secure1,
                    decoration: InputDecoration(
                        suffixIcon: GestureDetector(
                          onTap: () {
                            setState(() {
                              secure1 = !secure1;
                            });
                          },
                          child: Icon(secure1
                              ? Icons.visibility_off
                              : Icons.visibility),
                        ),
                        prefixIcon: Icon(Icons.lock),
                        hintText: 'Password',
                        errorText: validatePassword
                            ? 'Please enter your password'
                            : null),
                  ),
                  SizedBox(
                    height: 10,
                  ),

                  // Gender Picker
                  Visibility(
                    visible: isRegister,
                    child: Container(
                      padding: EdgeInsets.only(left: 40),
                      child: GenderPickerWithImage(
                        verticalAlignedText: false,
                        // to show what's selected on app opens, but by default it's Male
                        selectedGender: Gender.Male,
                        selectedGenderTextStyle: TextStyle(
                            color: Color(0xFF8b32a8),
                            fontWeight: FontWeight.bold),
                        unSelectedGenderTextStyle: TextStyle(
                            color: Colors.black, fontWeight: FontWeight.normal),
                        onChanged: (Gender gender) {
                          if (gender == Gender.Male) {
                            this.gender = 'male';
                          } else {
                            this.gender = 'female';
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
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  SizedBox(),
                  GestureDetector(
                    onTap: () {
                      loginOrRegister();
                    },
                    child: SizedBox(
                      width: double.infinity,
                      child: Container(
                        height: 40,
                        decoration: BoxDecoration(
                            color: Colors.blue,
                            borderRadius: BorderRadius.circular(5)),
                        child: Center(
                          child: Text(
                            isRegister ? 'REGISTER' : 'LOGIN',
                            style: TextStyle(fontSize: 20, color: Colors.white),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Divider(),
                  Visibility(
                    visible: !isRegister,
                    child: GestureDetector(
                      onTap: () {
                        facebookLogin();
                      },
                      child: SizedBox(
                        width: double.infinity,
                        child: Container(
                          height: 40,
                          decoration: BoxDecoration(
                              color: Colors.blueAccent,
                              borderRadius: BorderRadius.circular(5)),
                          child: Center(
                              child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.asset(
                                'assets/images/facebook-logo.png',
                                scale: 16,
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Text(
                                isRegister
                                    ? 'FACEBOOK REGISTER'
                                    : 'FACEBOOK LOGIN',
                                style: TextStyle(
                                    fontSize: 20, color: Colors.white),
                              ),
                            ],
                          )),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  GestureDetector(
                      onTap: () {
                        setState(() {
                          isRegister = !isRegister;
                          firstController.text = '';
                          lastController.text = '';
                          contactController.text = '';
                          emailController.text = '';
                          passwordController.text = '';
                        });
                      },
                      child: Text(isRegister
                          ? "Already register, Log In ?"
                          : "Don't have an account? Sign Up")),
                  SizedBox(
                    height: 10,
                  ),
                  GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ForgotPassword()));
                      },
                      child: Text('forgot password?')),
                ],
              ),
              GestureDetector(
                onTap: () async {
                  SharedPreferences pref =
                      await SharedPreferences.getInstance();
                  pref.setBool('isLogIn', false);
                  Navigator.pushNamed(context, 'Choose Gender');
                },
                child: SizedBox(
                  width: double.infinity,
                  child: Container(
                    height: 40,
                    decoration: BoxDecoration(
                        color: Colors.blueAccent,
                        borderRadius: BorderRadius.circular(5)),
                    child: Center(
                      child: Text(
                        'Skip Login for now',
                        style: TextStyle(fontSize: 20, color: Colors.white),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  facebookLogin() {
    AuthAPI().signInWithFacebook().then((value) {
      print(value.user.email);
      CustlrLoading.showLoaderDialog(context);
      AuthAPI.getSocialToken().then((data) {
        AuthAPI.socialLogin(value.user.email, data['token']).then((inf) {
          print(value.user.email);
          if (inf['status'] == '1') {
            AuthAPI.userAPI(inf['token']);
            CustlrLoading.hideLoaderDialog(context);
            Navigator.of(context).pushNamedAndRemoveUntil(
                'Choose Gender', (Route<dynamic> route) => false);
            Fluttertoast.showToast(msg: inf['msg']);
            islogIn();
          } else {
            CustlrLoading.hideLoaderDialog(context);
            Fluttertoast.showToast(msg: inf['msg']);
          }
        });
      });
    });
  }

  loginOrRegister() {
    setState(() {});

    if (isRegister == true) {
      register();
    } else {
      login();
    }
  }

// Login
  login() {
    CustlrLoading.showLoaderDialog(context);
    final data = {
      'email': emailController.text,
      'password': passwordController.text,
      'device_name': 'mobile'
    };
    AuthAPI.userLogin(data).then((value) {
      if (value['status'] == '1') {
        AuthAPI.userAPI(value['token']);
        CustlrLoading.hideLoaderDialog(context);
        Navigator.of(context).pushNamedAndRemoveUntil(
            'Choose Gender', (Route<dynamic> route) => false);

        Fluttertoast.showToast(msg: value['msg']);
        islogIn();
      } else {
        CustlrLoading.hideLoaderDialog(context);
        Fluttertoast.showToast(msg: value['msg']);
      }
    });
  }

// Register
  register() {
    CustlrLoading.showLoaderDialog(context);
    final data = {
      'first_name': firstController.text,
      'last_name': lastController.text,
      'contact_no': contactController.text,
      'email': emailController.text,
      'password': passwordController.text,
      'gender': gender,
      'device_name': 'mobile',
    };
    AuthAPI.userRegister(data).then((value) {
      if (value['status'] == '1') {
        AuthAPI.userAPI(value['token']);
        CustlrLoading.hideLoaderDialog(context);
        Navigator.of(context).pushNamedAndRemoveUntil(
            'Choose Gender', (Route<dynamic> route) => false);
        Fluttertoast.showToast(msg: value['msg']);
        islogIn();
      } else {
        CustlrLoading.hideLoaderDialog(context);
        Fluttertoast.showToast(msg: value['msg']);
      }
    });
  }

  void islogIn() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    pref.setBool('isLogIn', true);
  }
}
*/
