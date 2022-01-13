import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesUtil {
  static bool isLogIn;
  static bool firstUser;
  static String userId;
  static String token;
  static String gender;
  static String firstName;
  static String lastName;
  static String contactNo;
  static String email;
  static String birthdate;
  static String profilePic;
  static int defaultAddressId;
  static String active;
  static String createdAt;
  static String updatedAt;

  void getInitialSharedPreferences() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    isLogIn = pref.getBool('isLogIn') ?? false;
    firstUser = pref.getBool('firstUser') ?? false;
    userId = pref.getString('UserID');
    token = pref.getString('token');
    gender = pref.getString('gender');
    firstName = pref.getString('first_name');
    lastName = pref.getString('last_name');
    contactNo = pref.getString('contact_no');
    email = pref.getString('email');
    birthdate = pref.getString('birthdate');
    profilePic = pref.getString('profile_pic');
    defaultAddressId = pref.getInt('default_address_id');
    active = pref.getString('active');
    createdAt = pref.getString('created_at');
    updatedAt = pref.getString('updated_at');
  }
}
