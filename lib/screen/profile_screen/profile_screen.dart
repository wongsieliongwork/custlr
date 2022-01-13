import 'package:custlr/api/authAPI.dart';
import 'package:custlr/screen/auth/login_register.dart';
import 'package:custlr/screen/view_cart/view_cart.dart';
import 'package:custlr/utils/shared_preference_utils.dart';
import 'package:custlr/widget/loading.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  // String gender = '';
  // String name = '';
  // String email = '';
  // String phone = '';
  // String profile = '';
  // String birthdate = '';
  bool isLogIn = false;
  bool isLoading = true;
  void sharedPreference() {
    // gender = pref.getString('gender');
    // name = pref.getString('first_name').toString() +
    //     " " +
    //     pref.getString('last_name').toString();
    // email = pref.getString('email');
    // phone = pref.getString('contact_no');
    // profile = pref.getString('profile_pic');
    // birthdate = pref.getString('birthdate') ?? "No Birthdate";
    setState(() {
      if (SharedPreferencesUtil.isLogIn) {
        profileList.removeWhere((element) => element['name'] == "Log In");
      } else {
        profileList.removeWhere((element) => element['name'] == "Log out");
        profileList.removeWhere((element) => element['name'] == "Orders");
        profileList
            .removeWhere((element) => element['name'] == "Change Password");
        profileList.removeWhere((element) => element['name'] == "My Addresses");
        profileList
            .removeWhere((element) => element['name'] == "My Measurement");
      }
      // isLoading = false;
    });
  }

  List profileList = [
    {
      'name': 'Log In',
      'icon': Icons.login,
    },
    {
      'name': 'Orders',
      'icon': Icons.article,
    },
    {
      'name': 'My Measurement',
      'icon': Icons.person,
    },
    {
      'name': 'Push Notification',
      'icon': Icons.notifications,
    },
    {
      'name': 'Change Password',
      'icon': Icons.security,
    },
    {
      'name': 'About Us',
      'icon': Icons.person,
    },
    {
      'name': 'My Addresses',
      'icon': Icons.home,
    },
    {
      'name': 'Log out',
      'icon': Icons.logout,
    },
    {
      'name': 'Data & Privacy',
      'icon': Icons.policy,
    },
  ];

  bool isPush = false;
  @override
  void initState() {
    super.initState();
    sharedPreference();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Text(
            'My Profile',
            style: TextStyle(color: Colors.black),
          ),
        ),
        actions: [
          GestureDetector(
              onTap: () async {
                if (SharedPreferencesUtil.isLogIn) {
                  bool value = await Navigator.push(context,
                      MaterialPageRoute(builder: (context) => ViewCart()));

                  if (value == true) {
                    setState(() {});
                  }
                } else {
                  Alert(
                      context: context,
                      title: 'You are the guest\nPlease log in first.',
                      buttons: [
                        DialogButton(
                          child: Text(
                            "LOG IN",
                            style: TextStyle(color: Colors.white, fontSize: 20),
                          ),
                          onPressed: () =>
                              Navigator.pushNamed(context, 'Log In'),
                          width: 100,
                        ),
                      ]).show();
                }
              },
              child: Icon(Icons.shopping_cart_outlined)),
          SizedBox(
            width: 10,
          ),
        ],
      ),
      body: Column(
        children: [
          !SharedPreferencesUtil.isLogIn
              ? Container(
                  height: 300,
                  child: Center(
                    child: Text(
                      'Welcome To Custlr',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
                    ),
                  ),
                )
              : Column(
                  children: [
                    Center(
                      child: Container(
                        height: 100,
                        width: 150,
                        child: Stack(
                          children: [
                            Center(
                              child: Container(
                                height: 100,
                                width: 100,
                                child: CircleAvatar(
                                  radius: 40,
                                  backgroundImage: (SharedPreferencesUtil
                                                  .profilePic ==
                                              'null' ||
                                          SharedPreferencesUtil.profilePic ==
                                              null)
                                      ? AssetImage(
                                          SharedPreferencesUtil.gender ==
                                                  'female'
                                              ? 'assets/images/female_icon.png'
                                              : 'assets/images/male_icon.jpeg')
                                      : NetworkImage(
                                          SharedPreferencesUtil.profilePic),
                                ),
                              ),
                            ),
                            // Align(
                            //   alignment: Alignment.bottomRight,
                            //   child: Image.asset(
                            //     'assets/images/profile/Edit.png',
                            //     scale: 1.5,
                            //   ),
                            // )
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      '${SharedPreferencesUtil.firstName}',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                        '${SharedPreferencesUtil.birthdate ?? "Not birthday yet"}  |  +60-${SharedPreferencesUtil.contactNo == 'null' ? "" : SharedPreferencesUtil.contactNo}  |  ${SharedPreferencesUtil.email}',
                        style: TextStyle(fontSize: 13)),
                    SizedBox(
                      height: 20,
                    ),
                    GestureDetector(
                      onTap: () async {
                        bool value =
                            await Navigator.pushNamed(context, 'Edit Profile')
                                as bool;
                        if (value == true) {
                          setState(() {
                            sharedPreference();
                          });
                        }
                      },
                      child: Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: 50, vertical: 10),
                        decoration: BoxDecoration(
                            color: Colors.blue,
                            borderRadius: BorderRadius.circular(20)),
                        child: Text(
                          'Edit Profile',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),

          Spacer(),
          Column(
            children: List.generate(profileList.length, (index) {
              return GestureDetector(
                onTap: () => onTapProfile(index),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Divider(
                      height: 2,
                      thickness: 3,
                    ),
                    Container(
                      height: 50,
                      child: ListTile(
                        leading: Icon(profileList[index]['icon']),
                        title: Text(profileList[index]['name']),
                        trailing:
                            profileList[index]['name'] == 'Push Notification'
                                ? Switch(
                                    value: isPush,
                                    onChanged: (value) {
                                      setState(() {
                                        isPush = !isPush;
                                      });
                                    })
                                : Icon(Icons.keyboard_arrow_right),
                      ),
                    ),
                  ],
                ),
              );
            }),
          ),
          // Expanded(
          //   flex: 4,
          //   child: !isLogIn
          //       ? Center(
          //           child: Text(
          //           'Welcome To Custlr',
          //           style: TextStyle(fontSize: 25),
          //           textAlign: TextAlign.left,
          //         ))
          //       : Container(
          //           padding: EdgeInsets.all(20),
          //           child: Column(
          //             mainAxisAlignment: MainAxisAlignment.spaceAround,
          //             children: [
          //               SizedBox(
          //                 height: 5,
          //               ),
          //               CircleAvatar(
          //                 radius: 40,
          //                 backgroundImage:
          //                     (profile == 'null' || profile == null)
          //                         ? AssetImage(gender == 'female'
          //                             ? 'assets/images/female_icon.png'
          //                             : 'assets/images/male_icon.jpeg')
          //                         : NetworkImage(profile),
          //               ),
          //               Column(
          //                 crossAxisAlignment: CrossAxisAlignment.center,
          //                 mainAxisAlignment:
          //                     MainAxisAlignment.spaceBetween,
          //                 children: [
          //                   Text(
          //                     '$name',
          //                     style: TextStyle(
          //                       fontWeight: FontWeight.bold,
          //                       fontSize: 18,
          //                     ),
          //                   ),
          //                   SizedBox(
          //                     height: 5,
          //                   ),
          //                   Text(
          //                     '$email',
          //                     style: TextStyle(
          //                       color: Colors.grey,
          //                     ),
          //                   ),
          //                   SizedBox(
          //                     height: 5,
          //                   ),
          //                   Text(
          //                     '+60 - $phone',
          //                     style: TextStyle(color: Colors.grey),
          //                   ),
          //                 ],
          //               )
          //             ],
          //           ),
          //         ),
          // ),
          // Expanded(
          //   flex: 7,
          //   child: Container(
          //     child: PhysicalModel(
          //       shadowColor: Colors.grey,
          //       elevation: 10,
          //       color: Colors.white,
          //       borderRadius: BorderRadius.only(
          //         topRight: Radius.circular(30),
          //         topLeft: Radius.circular(30),
          //       ),
          //       child: Container(
          //         padding: EdgeInsets.symmetric(horizontal: 20),
          //         child: ListView.separated(
          //             shrinkWrap: true,
          //             physics: NeverScrollableScrollPhysics(),
          //             itemBuilder: (context, index) {
          //               return GestureDetector(
          //                 onTap: () async {
          //                   onTapProfile(index);
          //                 },
          //                 child: ListTile(
          //                   leading: Icon(profileList[index]['icon']),
          //                   title: Text(profileList[index]['name']),
          //                 ),
          //               );
          //             },
          //             separatorBuilder: (context, index) {
          //               return Divider();
          //             },
          //             itemCount: profileList.length),
          //       ),
          //     ),
          //   ),
          // )
        ],
      ),
    );
  }

  void onTapProfile(int index) async {
    if (profileList[index]['name'] == 'Edit Profile') {
      bool value =
          await Navigator.pushNamed(context, profileList[index]['name'])
              as bool;
      if (value == true) {
        setState(() {
          sharedPreference();
        });
      }
    } else if (profileList[index]['name'] == "Log out") {
      Alert(
        context: context,
        type: AlertType.warning,
        title: "WARNING",
        desc: "Do you want log out?",
        buttons: [
          DialogButton(
            child: Text(
              "CONFIRM",
              style: TextStyle(
                color: Colors.white,
              ),
            ),
            onPressed: () async {
              SharedPreferencesUtil.isLogIn = false;
              SharedPreferencesUtil.profilePic = 'null';

              CustlrLoading.showLoaderDialog(context);
              AuthAPI.logOut().then((value) {
                CustlrLoading.hideLoaderDialog(context);
                Fluttertoast.showToast(msg: value['msg']);
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => LoginRegister(false)));
              });
            },
            width: 100,
          ),
          DialogButton(
            child: Text(
              "CANCEL",
              style: TextStyle(
                color: Colors.white,
              ),
            ),
            onPressed: () => Navigator.pop(context),
            width: 100,
          )
        ],
      ).show();
    } else if (profileList[index]['name'] == "Log In") {
      Navigator.pushNamed(context, profileList[index]['name']);
    } else {
      Navigator.pushNamed(context, profileList[index]['name']);
    }
  }
}

/*
import 'package:custlr/api/authAPI.dart';
import 'package:custlr/screen/auth/login_register.dart';
import 'package:custlr/widget/loading.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String gender = '';
  String name = '';
  String email = '';
  String phone = '';
  String profile = '';
  bool isLogIn = false;
  bool isLoading = true;
  void sharedPreference() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    isLogIn = pref.getBool('isLogIn');
    gender = pref.getString('gender');
    name = pref.getString('first_name').toString() +
        " " +
        pref.getString('last_name').toString();
    email = pref.getString('email');
    phone = pref.getString('contact_no');
    profile = pref.getString('profile_pic');
    setState(() {
      if (isLogIn == true) {
        profileList.removeWhere((element) => element['name'] == "Log In");
      } else {
        profileList.removeWhere((element) => element['name'] == "Log Out");
        profileList.removeWhere((element) => element['name'] == "Edit Profile");
        profileList
            .removeWhere((element) => element['name'] == "Change Password");
        profileList.removeWhere((element) => element['name'] == "My Addresses");
        profileList
            .removeWhere((element) => element['name'] == "My Measurement");
      }
      isLoading = false;
    });
  }

  List profileList = [
    {
      'name': 'Log In',
      'icon': Icons.login,
    },
    {
      'name': 'Edit Profile',
      'icon': Icons.person,
    },
    {
      'name': 'Change Password',
      'icon': Icons.password,
    },
    {
      'name': 'My Addresses',
      'icon': Icons.home,
    },
    {
      'name': 'My Measurement',
      'icon': Icons.accessibility,
    },
    {
      'name': 'Log Out',
      'icon': Icons.logout,
    }
  ];

  @override
  void initState() {
    super.initState();
    sharedPreference();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.grey[200],
      body: isLoading
          ? Container()
          : Column(
              children: [
                Expanded(
                  flex: 4,
                  child: !isLogIn
                      ? Center(
                          child: Text(
                          'Welcome To Custlr',
                          style: TextStyle(fontSize: 25),
                          textAlign: TextAlign.left,
                        ))
                      : Container(
                          padding: EdgeInsets.all(20),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              SizedBox(
                                height: 5,
                              ),
                              CircleAvatar(
                                radius: 40,
                                backgroundImage:
                                    (profile == 'null' || profile == null)
                                        ? AssetImage(gender == 'female'
                                            ? 'assets/images/female_icon.png'
                                            : 'assets/images/male_icon.jpeg')
                                        : NetworkImage(profile),
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    '$name',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18,
                                    ),
                                  ),
                                  SizedBox(
                                    height: 5,
                                  ),
                                  Text(
                                    '$email',
                                    style: TextStyle(
                                      color: Colors.grey,
                                    ),
                                  ),
                                  SizedBox(
                                    height: 5,
                                  ),
                                  Text(
                                    '+60 - $phone',
                                    style: TextStyle(color: Colors.grey),
                                  ),
                                ],
                              )
                            ],
                          ),
                        ),
                ),
                Expanded(
                  flex: 7,
                  child: Container(
                    child: PhysicalModel(
                      shadowColor: Colors.grey,
                      elevation: 10,
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topRight: Radius.circular(30),
                        topLeft: Radius.circular(30),
                      ),
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 20),
                        child: ListView.separated(
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            itemBuilder: (context, index) {
                              return GestureDetector(
                                onTap: () async {
                                  onTapProfile(index);
                                },
                                child: ListTile(
                                  leading: Icon(profileList[index]['icon']),
                                  title: Text(profileList[index]['name']),
                                ),
                              );
                            },
                            separatorBuilder: (context, index) {
                              return Divider();
                            },
                            itemCount: profileList.length),
                      ),
                    ),
                  ),
                )
              ],
            ),
    );
  }

  void onTapProfile(int index) async {
    if (profileList[index]['name'] == 'Edit Profile') {
      bool value =
          await Navigator.pushNamed(context, profileList[index]['name'])
              as bool;
      if (value == true) {
        setState(() {
          sharedPreference();
        });
      }
    } else if (profileList[index]['name'] == "Log Out") {
      Alert(
        context: context,
        type: AlertType.warning,
        title: "WARNING",
        desc: "Do you want log out?",
        buttons: [
          DialogButton(
            child: Text(
              "CONFIRM",
              style: TextStyle(color: Colors.white, fontSize: 20),
            ),
            onPressed: () async {
              SharedPreferences pref = await SharedPreferences.getInstance();

              pref.setBool('isLogIn', false);
              pref.setString('profile_pic', 'null');
              CustlrLoading.showLoaderDialog(context);
              AuthAPI.logOut().then((value) {
                CustlrLoading.hideLoaderDialog(context);
                Fluttertoast.showToast(msg: value['msg']);
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => LoginRegister()));
              });
            },
            width: 100,
          ),
          DialogButton(
            child: Text(
              "CANCEL",
              style: TextStyle(color: Colors.white, fontSize: 20),
            ),
            onPressed: () => Navigator.pop(context),
            width: 100,
          )
        ],
      ).show();
    } else if (profileList[index]['name'] == "Log In") {
      Navigator.pushNamed(context, profileList[index]['name']);
    } else {
      Navigator.pushNamed(context, profileList[index]['name']);
    }
  }
}
*/
