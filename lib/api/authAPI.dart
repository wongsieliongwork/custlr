import 'dart:convert';
import 'dart:math';
import 'package:crypto/crypto.dart';
import 'package:custlr/utils/constants.dart';
import 'package:custlr/utils/shared_preference_utils.dart';
import 'package:custlr/widget/loading.dart';
import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

class AuthAPI {
  // User Login

  static Future userLogin(final params) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    try {
      Dio dio = Dio();
      String url = Custlr.url + "api/login";
      print(url);
      var formData = FormData.fromMap(params);

      var response = await dio.post(url,
          options: Options(headers: {
            // 'Authorization': 'Bearer ${SharedPreferencesUtil.token}',
          }),
          data: formData);
      var data = response.data;

      print('DONE LOGIN__________$data');
      SharedPreferencesUtil.token = data['token'];
      pref.setString('token', data['token']);

      return data;
    } catch (e) {
      return Custlr.databaseError('$e');
    }
  }

  // User Register
  static Future userRegister(final params) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    try {
      Dio dio = Dio();
      String url = Custlr.url + "api/register";
      print(url);
      var formData = FormData.fromMap(params);

      var response = await dio.post(url,
          options: Options(headers: {
            // 'Authorization': 'Bearer ${SharedPreferencesUtil.token}',
          }),
          data: formData);
      var data = response.data;

      print('DONE Register__________$data');

      SharedPreferencesUtil.token = data['token'];
      pref.setString('token', data['token']);
      return data;
    } catch (e) {
      return Custlr.databaseError('$e');
    }
  }

  // User LogOut
  static Future logOut() async {
    try {
      Dio dio = Dio();
      String url = Custlr.url + "api/logout";
      print(url);
      var formData = FormData.fromMap({});

      var response = await dio.post(url,
          options: Options(headers: {
            'Authorization': 'Bearer ${SharedPreferencesUtil.token}',
          }),
          data: formData);
      var data = response.data;

      print('DONE LogOut__________$data');

      return data;
    } catch (e) {
      return Custlr.databaseError('$e');
    }
  }

// Facebook Login Function
  Future<UserCredential> signInWithFacebook(BuildContext context) async {
    // Trigger the sign-in flow

    final LoginResult result = await FacebookAuth.instance.login();
    CustlrLoading.showLoaderDialog(context);
    // Create a credential from the access token
    final facebookAuthCredential =
        FacebookAuthProvider.credential(result.accessToken.token);

    // Once signed in, return the UserCredential

    try {
      return await FirebaseAuth.instance
          .signInWithCredential(facebookAuthCredential);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'account-exists-with-different-credential') {
        Fluttertoast.showToast(
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 5,
            msg: 'You signed in google before, Please use Google Sign In');
      }
    }
  }

  // Google Login Functon
  Future<UserCredential> signInWithGoogle(BuildContext context) async {
    // Trigger the authentication flow
    final GoogleSignInAccount googleUser = await GoogleSignIn().signIn();

    // Obtain the auth details from the request
    final GoogleSignInAuthentication googleAuth =
        await googleUser.authentication;

    // Create a new credential
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );
    CustlrLoading.showLoaderDialog(context);
    // Once signed in, return the UserCredential
    return await FirebaseAuth.instance.signInWithCredential(credential);
  }

  // Social APPLE

  String generateNonce([int length = 32]) {
    final charset =
        '0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._';
    final random = Random.secure();
    return List.generate(length, (_) => charset[random.nextInt(charset.length)])
        .join();
  }

  /// Returns the sha256 hash of [input] in hex notation.
  String sha256ofString(String input) {
    final bytes = utf8.encode(input);
    final digest = sha256.convert(bytes);
    return digest.toString();
  }

  Future<UserCredential> signInWithApple() async {
    // To prevent replay attacks with the credential returned from Apple, we
    // include a nonce in the credential request. When signing in with
    // Firebase, the nonce in the id token returned by Apple, is expected to
    // match the sha256 hash of `rawNonce`.
    final rawNonce = generateNonce();
    final nonce = sha256ofString(rawNonce);

    // Request credential for the currently signed in Apple account.
    final appleCredential = await SignInWithApple.getAppleIDCredential(
      scopes: [
        AppleIDAuthorizationScopes.email,
        AppleIDAuthorizationScopes.fullName,
      ],
      nonce: nonce,
    );

    // Create an `OAuthCredential` from the credential returned by Apple.
    final oauthCredential = OAuthProvider("apple.com").credential(
      idToken: appleCredential.identityToken,
      rawNonce: rawNonce,
    );

    // Sign in the user with Firebase. If the nonce we generated earlier does
    // not match the nonce in `appleCredential.identityToken`, sign in will fail.
    return await FirebaseAuth.instance.signInWithCredential(oauthCredential);
  }

// Generate Token
  static Future getSocialToken() async {
    try {
      String url = Custlr.url + "api/guest";

      print(url);
      var formData = FormData.fromMap({
        'device_name': 'mobile',
      });
      var response = await Dio().post(
        url,
        data: formData,
        options: Options(headers: {
          // 'Authorization': 'Bearer ${SharedPreferencesUtil.token}',
        }),
      );
      var data = response.data;
      print("GET TOKEN SOCIAL_________ $data");
      return data;
    } on DioError catch (e) {
      print('${e.response.data}');
    }
  }

  // Social Login
  static Future socialLogin(final email, final name, final token) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    try {
      Dio dio = Dio();
      String url = Custlr.url + "api/social_login";
      print(url);
      var formData = FormData.fromMap({
        'device_name': 'mobile',
        'email': '$email',
        'first_name': '$name',
      });

      var response = await dio.post(url,
          options: Options(headers: {
            'Authorization': 'Bearer $token',
          }),
          data: formData);
      var data = response.data;
      print(data);
      SharedPreferencesUtil.token = data['token'];
      SharedPreferencesUtil.contactNo = data['user']['contact_no'];
      SharedPreferencesUtil.gender = data['user']['gender'];
      pref.setString('token', data['token']);
      pref.setString('contact_no', data['user']['contact_no'] ?? "");
      pref.setString('gender', data['user']['gender'] ?? "");
      print('DONE Social Login __________$data');

      return data;
    } catch (e) {
      return Custlr.databaseError('$e');
    }
  }

  // User Detail
  static Future userAPI(final token) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    String url = Custlr.url + "api/user";
    var response = await Dio().get(
      url,
      options: Options(headers: {
        'Authorization': 'Bearer ${SharedPreferencesUtil.token}',
      }),
    );
    var data = response.data;
    print("GET User LIST_________ $data");
    SharedPreferencesUtil.userId = data['UserID'].toString();
    SharedPreferencesUtil.firstName = data['first_name'];
    SharedPreferencesUtil.userId = data['UserID'].toString();
    SharedPreferencesUtil.firstName = data['first_name'];
    SharedPreferencesUtil.lastName = data['last_name'];
    SharedPreferencesUtil.email = data['email'];
    SharedPreferencesUtil.gender = data['gender'];
    SharedPreferencesUtil.defaultAddressId = data['default_address_id'];
    SharedPreferencesUtil.active = data['active'];
    SharedPreferencesUtil.createdAt = data['created_at'];
    SharedPreferencesUtil.updatedAt = data['updated_at'];
    pref.setString('UserID', data['UserID'].toString());
    pref.setString('first_name', data['first_name']);
    pref.setString('last_name', data['last_name']);
    pref.setString('contact_no', data['contact_no']);
    pref.setString('email', data['email']);
    pref.setString('gender', data['gender']);
    pref.setInt('default_address_id', data['default_address_id']);
    pref.setString('active', data['active']);
    pref.setString('created_at', data['created_at']);
    pref.setString('updated_at', data['updated_at']);

    return data;
  }

  // Edit Profile
  static Future editProfile(final params) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    try {
      Dio dio = Dio();
      String url = Custlr.url + "api/user/edit";
      print(url);
      var formData = FormData.fromMap(params);

      var response = await dio.post(url,
          options: Options(headers: {
            'Authorization': 'Bearer ${SharedPreferencesUtil.token}',
          }),
          data: formData);
      var data = response.data;
      if (data['status'] == 1) {
        SharedPreferencesUtil.firstName = data['user']['first_name'];
        SharedPreferencesUtil.lastName = data['user']['last_namee'];
        SharedPreferencesUtil.contactNo = data['user']['contact_no'];
        SharedPreferencesUtil.gender = data['user']['gender'];
        SharedPreferencesUtil.email = data['user']['email'];
        pref.setString('first_name', data['user']['first_name']);
        pref.setString('last_name', data['user']['last_name']);
        pref.setString('contact_no', data['user']['contact_no']);
        pref.setString('gender', data['user']['gender']);
        pref.setString('email', data['user']['email']);
      }
      print('DONE EDIT PROFILE__________$data');

      return data;
    } catch (e) {
      return Custlr.databaseError('$e');
    }
  }

//  Reset Password
  static Future resetPassword(final params) async {
    try {
      Dio dio = Dio();
      String url = Custlr.url + "api/account/password/reset";
      print(url);
      var formData = FormData.fromMap(params);

      var response = await dio.post(url,
          options: Options(headers: {
            'Authorization': 'Bearer ${SharedPreferencesUtil.token}',
          }),
          data: formData);
      var data = response.data;

      print('DONE RESET PASWORD__________$data');

      return data;
    } catch (e) {
      return Custlr.databaseError('$e');
    }
  }

  //  Verify Phone
  static Future verifyPhone(final phone) async {
    try {
      Dio dio = Dio();
      String url = Custlr.url + "api/validate_contact_no";
      print(url);
      var formData = FormData.fromMap({'contact_no': phone});

      var response = await dio.post(url,
          options: Options(headers: {
            'Authorization': 'Bearer ${SharedPreferencesUtil.token}',
          }),
          data: formData);
      var data = response.data;

      print('DONE VERIFY PHONE__________$data');

      return data;
    } catch (e) {
      return Custlr.databaseError('$e');
    }
  }

  // Change Password
  static Future changePassword(final params) async {
    try {
      Dio dio = Dio();
      String url = Custlr.url + "api/account/password/change";
      print(url);
      var formData = FormData.fromMap(params);

      var response = await dio.post(url,
          options: Options(headers: {
            'Authorization': 'Bearer ${SharedPreferencesUtil.token}',
          }),
          data: formData);
      var data = response.data;

      print('DONE Change PASWORD__________$data');

      return data;
    } catch (e) {
      return Custlr.databaseError('$e');
    }
  }
}
