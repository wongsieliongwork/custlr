import 'package:custlr/utils/constants.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:custlr/utils/shared_preference_utils.dart';

class ReviewAPI {
  // View review
  static Future review(final id) async {
    try {
      Dio dio = Dio();
      String url = Custlr.url + "api/product/review";
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

      print('ALL REVIEW__________$data');

      return data;
    } catch (e) {
      return Custlr.databaseError('$e');
    }
  }

// Add review
  static Future addReview(final params) async {
    try {
      Dio dio = Dio();
      String url = Custlr.url + "api/product/review/add";
      print(url);
      var formData = FormData.fromMap(params);

      var response = await dio.post(url,
          options: Options(headers: {
            'Authorization': 'Bearer ${SharedPreferencesUtil.token}',
          }),
          data: formData);
      var data = response.data;

      print('ALL REVIEW__________$data');

      return data;
    } catch (e) {
      return Custlr.databaseError('$e');
    }
  }

  // Delete review
  static Future deleteReview(final id) async {
    try {
      Dio dio = Dio();
      String url = Custlr.url + "api/product/review/delete";
      print(url);
      var formData = FormData.fromMap({'id': id});

      var response = await dio.post(url,
          options: Options(headers: {
            'Authorization': 'Bearer ${SharedPreferencesUtil.token}',
          }),
          data: formData);
      var data = response.data;

      print('Delete REVIEW__________$data');

      return data;
    } catch (e) {
      return Custlr.databaseError('$e');
    }
  }
}
