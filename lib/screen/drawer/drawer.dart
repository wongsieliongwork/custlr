import 'package:custlr/provider/ShoppingPageProvider.dart';
import 'package:custlr/utils/shared_preference_utils.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CustlrDrawer extends StatefulWidget {
  @override
  _CustlrDrawerState createState() => _CustlrDrawerState();
}

class _CustlrDrawerState extends State<CustlrDrawer> {
  List drawerList = [
    {
      'name': 'My Addresses',
      'icon': Icon(Icons.home),
    },
    {
      'name': 'My Measurement',
      'icon': Icon(Icons.accessibility),
    },
    {
      'name': 'Edit Profile',
      'icon': Icon(Icons.person),
    },
    {
      'name': 'Log In',
      'icon': Icon(Icons.login),
    },
  ];

  void sharedPreferences() async {
    setState(() {
      if (SharedPreferencesUtil.isLogIn) {
        drawerList.removeWhere((element) => element['name'] == 'Log In');
      } else {
        drawerList.removeWhere((element) => element['name'] == 'My Address');
        drawerList.removeWhere((element) => element['name'] == 'Edit Profile');
      }
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    sharedPreferences();
  }

  @override
  Widget build(BuildContext context) {
    final dataHome = Provider.of<ShoppingPageProvider>(context);
    return Drawer(
      child: ListView(
        children: [
          // DrawerHeader(child: Image.asset('assets/images/black-logo.png')),

          DrawerHeader(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Image.asset(
                  'assets/images/logo.jpg',
                  scale: !SharedPreferencesUtil.isLogIn ? 8 : 13,
                ),
                SizedBox(
                  height: 10,
                ),
                !SharedPreferencesUtil.isLogIn
                    ? Container()
                    : Text(
                        '${SharedPreferencesUtil.firstName} ${SharedPreferencesUtil.lastName}'),
                !SharedPreferencesUtil.isLogIn
                    ? Container()
                    : Text(SharedPreferencesUtil.email),
              ],
            ),
          ),
          GestureDetector(
            onTap: () {
              Navigator.pop(context);
              dataHome.isLoading = false;
              dataHome.getAPI();
              dataHome.isFemale = false;
            },
            child: ListTile(
              leading: Image.asset(
                'assets/images/product/male.png',
                scale: 7,
              ),
              title: Text('Male'),
              trailing: dataHome.isFemale
                  ? null
                  : Icon(
                      Icons.check,
                      color: Colors.green,
                    ),
            ),
          ),
          GestureDetector(
            onTap: () {
              Navigator.pop(context);
              dataHome.isLoading = false;
              dataHome.getAPI();
              dataHome.isFemale = true;
            },
            child: ListTile(
              leading: Image.asset(
                'assets/images/product/female.png',
                scale: 7,
              ),
              title: Text('Female'),
              trailing: !dataHome.isFemale
                  ? null
                  : Icon(
                      Icons.check,
                      color: Colors.green,
                    ),
            ),
          ),
          Column(
            children: List.generate(drawerList.length, (index) {
              return GestureDetector(
                onTap: () async {
                  if (drawerList[index]['name'] == 'Edit Profile') {
                    bool value = await Navigator.pushNamed(
                        context, drawerList[index]['name']) as bool;

                    if (value == true) {
                      sharedPreferences();
                    }
                  } else {
                    Navigator.pushNamed(context, drawerList[index]['name']);
                  }
                },
                child: ListTile(
                  leading: drawerList[index]['icon'],
                  title: Text(drawerList[index]['name']),
                ),
              );
            }),
          ),
        ],
      ),
    );
  }
}
