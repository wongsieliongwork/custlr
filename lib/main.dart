import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:custlr/api/api.dart';
import 'package:custlr/api/authAPI.dart';
import 'package:custlr/common/dynamic_link_service.dart';
import 'package:custlr/utils/constants.dart';
import 'package:custlr/provider/ShoppingPageProvider.dart';
import 'package:custlr/provider/Measurement.dart';
import 'package:custlr/provider/viewcartProvider.dart';
import 'package:custlr/screen/auth/login_register.dart';
import 'package:custlr/screen/drawer/my_addresses.dart';
import 'package:custlr/screen/onboarding/onboarding.dart';
import 'package:custlr/screen/profile_screen/about_us.dart';
import 'package:custlr/screen/profile_screen/change_password.dart';
import 'package:custlr/screen/profile_screen/my_measurement.dart';
import 'package:custlr/screen/profile_screen/order_screen.dart';
import 'package:custlr/screen/profile_screen/privacy_policy.dart';
import 'package:custlr/screen/shopping_screen/chooseGender.dart';
import 'package:custlr/screen/drawer/edit_profile.dart';
import 'package:custlr/testing.dart';
import 'package:custlr/utils/shared_preference_utils.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();

  print('Handling a background message ${message.messageId}');
  print(message.data);
  flutterLocalNotificationsPlugin.show(
      message.data.hashCode,
      message.data['title'],
      message.data['body'],
      NotificationDetails(
        android: AndroidNotificationDetails(
          channel.id,
          channel.name,
          channel.description,
        ),
      ));
}

const AndroidNotificationChannel channel = AndroidNotificationChannel(
  'high_importance_channel', // id
  'High Importance Notifications', // title
  'This channel is used for important notifications.', // description
  importance: Importance.high,
);

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  SharedPreferencesUtil().getInitialSharedPreferences();

  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(channel);

  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String token;
  @override
  void initState() {
    super.initState();

    localPushNotification();
    DynamicLinkService().initDynamicLinks(context);
    // getSharedPreference();
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider(
            create: (context) => Measurement(),
          ),
          ChangeNotifierProvider(
            create: (context) => ShoppingPageProvider(),
          ),
          ChangeNotifierProvider(
            create: (context) => ViewCartProvider(),
          ),
        ],
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          color: Colors.white,
          title: 'Custlr App',
          theme: ThemeData(
              textTheme: GoogleFonts.montserratTextTheme(
                Theme.of(context).textTheme,
              ),
              appBarTheme: AppBarTheme(
                elevation: 0,
                color: Colors.transparent,
                titleTextStyle: TextStyle(backgroundColor: Colors.black),
                iconTheme: IconThemeData(
                  color: Colors.black,
                ),
              )),
          initialRoute: '/',
          routes: {
            'Choose Gender': (context) => ChooseGender(),
            'Edit Profile': (context) => EditProfile(),
            'Log In': (context) => LoginRegister(false),
            'Change Password': (context) => ChangePassword(),
            'My Measurement': (context) => MyMeasurement(false),
            'Select Measurement': (context) => MyMeasurement(true),
            'My Addresses': (context) => MyAddresses(),
            'Orders': (context) => OrderScreen(),
            'About Us': (context) => AboutUs(),
            'Data & Privacy': (context) => PrivacyPolicy()
          },
          home: SharedPreferencesUtil.isLogIn
              ? ChooseGender()
              : SharedPreferencesUtil.firstUser
                  ? LoginRegister(false)
                  : Onboarding(),
          // home: Testing(),
        ));
  }

// Generate Token from push notification
  getToken() async {
    token = await FirebaseMessaging.instance.getToken();
    setState(() {
      token = token;
    });
    print(token);
  }

  void localPushNotification() {
    // var initialzationSettingsAndroid
    //     AndroidInitializationSettings('@mipmap/launcher_icon');
    // var initializationSettings =
    //     InitializationSettings(android: initialzationSettingsAndroid);

    // flutterLocalNotificationsPlugin.initialize(initializationSettings);
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      RemoteNotification notification = message.notification;
      AndroidNotification android = message.notification?.android;
      if (notification != null && android != null) {
        flutterLocalNotificationsPlugin.show(
            notification.hashCode,
            notification.title,
            notification.body,
            NotificationDetails(
              android: AndroidNotificationDetails(
                channel.id,
                channel.name,
                channel.description,
                // icon: android?.smallIcon,
                icon: '@mipmap/launcher_icon',
              ),
            ));
      }
    });
  }
}
