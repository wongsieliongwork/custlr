import 'package:custlr/screen/blog/blog_screen.dart';
import 'package:custlr/screen/home_screen/home_screen.dart';
import 'package:custlr/screen/shopping_screen/shopping_screen.dart';
import 'package:custlr/screen/profile_screen/profile_screen.dart';
import 'package:custlr/screen/search_screen/search_screen.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:whatsapp_unilink/whatsapp_unilink.dart';

class MainTabBar extends StatefulWidget {
  @override
  _MainTabBarState createState() => _MainTabBarState();
}

class _MainTabBarState extends State<MainTabBar> {
  int _selectedIndex = 2;

  List<Widget> _widgetOptions;
  void list() {
    _widgetOptions = <Widget>[
      HomeScreen((int index) {
        setState(() {
          _onItemTapped(index);
        });
      }),
      SearchScreen(),
      ShoppingScreen(),
      BlogScreen(),
      ProfileScreen()
    ];
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    list();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final link = WhatsAppUnilink(
            phoneNumber: '+6016-3024878',
            // text: "Hey! I'm messaging you",
          );

          await launch('$link');
        },
        child: Image.asset('assets/images/WhatsApp.png'),
      ),
      body: Center(child: _widgetOptions.elementAt(_selectedIndex)),
      bottomNavigationBar: BottomNavigationBar(
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: 'Search',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_bag),
            label: 'Shop',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.notes),
            label: 'Exciting',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.black,
        unselectedItemColor: Colors.grey,
        onTap: _onItemTapped,
      ),
    );
  }
}
