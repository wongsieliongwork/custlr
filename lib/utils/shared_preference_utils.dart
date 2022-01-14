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
    print('SharedPreference>>>>>>>>>>>>>>');
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
    print(pref.getString('token'));
  }

  void getShared({
    bool isLogIn,
    bool firstUser,
    String UserID,
    String token,
    String gender,
    String first_name,
    String last_name,
    String contact_no,
    String email,
    String birthdate,
    String profile_pic,
    int default_address_id,
    String active,
    String created_at,
    String updated_at,
  }) async {
    // isLogIn = pref.getBool('isLogIn') ?? false;
    // firstUser = pref.getBool('firstUser') ?? false;
    // userId = pref.getString('UserID');
    // token = pref.getString('token');
    // gender = pref.getString('gender');
    // firstName = pref.getString('first_name');
    // lastName = pref.getString('last_name');
    // contactNo = pref.getString('contact_no');
    // email = pref.getString('email');
    // birthdate = pref.getString('birthdate');
    // profilePic = pref.getString('profile_pic');
    // defaultAddressId = pref.getInt('default_address_id');
    // active = pref.getString('active');
    // createdAt = pref.getString('created_at');
    // updatedAt = pref.getString('updated_at');
    SharedPreferences pref = await SharedPreferences.getInstance();
    if (isLogIn != null) pref.setBool('isLogIn', isLogIn);
    if (firstUser != null) pref.setBool('firstUser', firstUser);
    if (UserID != null) pref.setString('UserID', UserID);
    if (token != null) pref.setString('token', token);
    if (email != null) pref.setString('email', email);
    getInitialSharedPreferences();
  }
}
