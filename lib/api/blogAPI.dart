import 'package:custlr/utils/constants.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:custlr/utils/shared_preference_utils.dart';

class Blog {
  // View Blog Category
  static Future blogCategory() async {
    try {
      Dio dio = Dio();
      String url = Custlr.url + "api/blog/category";
      print(url);

      var response = await dio.get(
        url,
        options: Options(headers: {
          'Authorization': 'Bearer ${SharedPreferencesUtil.token}',
        }),
      );
      var data = response.data;

      print('Blog Category__________$data');

      return data;
    } catch (e) {
      return Custlr.databaseError('$e');
    }
  }

  // View Blog
  static Future blog(final id) async {
    try {
      Dio dio = Dio();
      String url = Custlr.url + "api/blog";
      print(url);

      var formData = FormData.fromMap(
        {'id': id},
      );

      var response = await dio.post(url,
          options: Options(
            headers: {
              'Authorization': 'Bearer ${SharedPreferencesUtil.token}',
            },
          ),
          data: formData);
      var data = response.data;

      print('Blog __________$data');

      return data;
    } catch (e) {
      return Custlr.databaseError('$e');
    }
  }

  // View Blog Detail
  static Future blogDetail(final id) async {
    try {
      Dio dio = Dio();
      String url = Custlr.url + "api/blog/content";
      print(url);

      var formData = FormData.fromMap(
        {'id': id},
      );

      var response = await dio.post(url,
          options: Options(
            headers: {
              'Authorization': 'Bearer ${SharedPreferencesUtil.token}',
            },
          ),
          data: formData);
      var data = response.data;

      print('Blog Detail__________$data');

      return data;
    } catch (e) {
      return Custlr.databaseError('$e');
    }
  }
}
