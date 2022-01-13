import 'package:custlr/utils/constants.dart';
import 'package:dio/dio.dart';
import 'package:custlr/utils/shared_preference_utils.dart';

class AddressAPI {
  // View Address
  static Future addressListAPI() async {
    String url = Custlr.url + "api/account/address/view";
    var response = await Dio().get(
      url,
      options: Options(headers: {
        'Authorization': 'Bearer ${SharedPreferencesUtil.token}',
      }),
    );
    var data = response.data;
    print("GET View Addresses_________ $data");

    return data;
  }

// Add Address
  static Future addAddress(final params) async {
    try {
      Dio dio = Dio();
      String url = Custlr.url + "api/account/address/add";
      print(url);
      var formData = FormData.fromMap(params);

      var response = await dio.post(url,
          options: Options(headers: {
            'Authorization': 'Bearer ${SharedPreferencesUtil.token}',
          }),
          data: formData);
      var data = response.data;

      print('ADD Address__________$data');

      return data;
    } catch (e) {
      return Custlr.databaseError('$e');
    }
  }

// Edit Address
  static Future editAddress(final params) async {
    try {
      Dio dio = Dio();
      String url = Custlr.url + "api/account/address/edit";
      print(url);
      var formData = FormData.fromMap(params);

      var response = await dio.post(url,
          options: Options(headers: {
            'Authorization': 'Bearer ${SharedPreferencesUtil.token}',
          }),
          data: formData);
      var data = response.data;

      print('EDIT Address__________$data');

      return data;
    } catch (e) {
      return Custlr.databaseError('$e');
    }
  }

  // Delete Address
  static Future deleteAddress(final id) async {
    try {
      Dio dio = Dio();
      String url = Custlr.url + "api/account/address/delete";
      print(url);
      var formData = FormData.fromMap({
        'id': id,
      });

      var response = await dio.post(url,
          options: Options(headers: {
            'Authorization': 'Bearer ${SharedPreferencesUtil.token}',
          }),
          data: formData);
      var data = response.data;

      print('Delete Address__________$data');

      return data;
    } catch (e) {
      return Custlr.databaseError('$e');
    }
  }

  // default Address
  static Future defaultAddress(final id) async {
    try {
      Dio dio = Dio();
      String url = Custlr.url + "api/account/address/default";
      print(url);
      var formData = FormData.fromMap({
        'id': id,
      });

      var response = await dio.post(url,
          options: Options(headers: {
            'Authorization': 'Bearer ${SharedPreferencesUtil.token}',
          }),
          data: formData);
      var data = response.data;

      print('Default Address__________$data');

      return data;
    } catch (e) {
      return Custlr.databaseError('$e');
    }
  }
}
