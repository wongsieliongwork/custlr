import 'package:custlr/utils/constants.dart';
import 'package:dio/dio.dart';
import 'package:custlr/utils/shared_preference_utils.dart';

class MeasurementAPI {
  // Measurement List
  static Future measurementListAPI() async {
    String url = Custlr.url + "api/account/user_measurement";
    var response = await Dio().get(
      url,
      options: Options(headers: {
        'Authorization': 'Bearer ${SharedPreferencesUtil.token}',
      }),
    );
    var data = response.data;
    print("GET View Measurement_________ $data");

    return data;
  }

  // Add Or Edit Measurement
  static Future addEditMeasurement(final params) async {
    try {
      Dio dio = Dio();
      String url = Custlr.url + "api/account/user_measurement/edit";
      print(url);
      var formData = FormData.fromMap(params);

      var response = await dio.post(url,
          options: Options(headers: {
            'Authorization': 'Bearer ${SharedPreferencesUtil.token}',
          }),
          data: formData);
      var data = response.data;

      print('ADD OR EDIT Address__________$data');

      return data;
    } catch (e) {
      return Custlr.databaseError('$e');
    }
  }

  // DELETE Measurement
  static Future deleteMeasurement(final id) async {
    try {
      Dio dio = Dio();
      String url = Custlr.url + "api/account/user_measurement/delete";
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

      print('delete Address__________$data');

      return data;
    } catch (e) {
      return Custlr.databaseError('$e');
    }
  }

  // Default Measurement
  static Future defaultMeasurement(final id) async {
    try {
      Dio dio = Dio();
      String url = Custlr.url + "api/account/user_measurement/default";
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
