import 'package:custlr/utils/constants.dart';
import 'package:dio/dio.dart';

class API {
  // Banner List
  static Future bannerAPI(final page) async {
    String url = Custlr.url + "api/banner";
    var formData = FormData.fromMap({
      'page': page,
    });
    var response = await Dio().post(
      url,
      options: Options(headers: {
        // 'Authorization': 'Bearer ${SharedPreferencesUtil.token}',
      }),
      data: formData,
    );
    var data = response.data;
    print("GET BANNER LIST_________ $data");
    return data;
  }

  // Treding List
  static Future tredingAPI(final page) async {
    String url = Custlr.url + "api/trending/banner";
    var formData = FormData.fromMap({
      'page': page,
    });
    var response = await Dio().post(
      url,
      options: Options(headers: {
        // 'Authorization': 'Bearer ${SharedPreferencesUtil.token}',
      }),
      data: formData,
    );
    var data = response.data;
    print("GET Treding LIST_________ $data");
    return data;
  }

  // Product List
  static Future productAPI() async {
    String url = Custlr.url + "api/product/";
    var response = await Dio().get(
      url,
      options: Options(
        headers: {
          // 'Authorization': 'Bearer ${SharedPreferencesUtil.token}',
        },
      ),
    );
    var data = response.data;
    print("GET Product LIST_________ $data");
    return data;
  }

// Product Element
  static Future productElement(final id) async {
    try {
      Dio dio = Dio();
      String url = Custlr.url + "api/product/element";
      print(url);
      var formData = FormData.fromMap({
        'id': '$id',
      });

      var response = await dio.post(
        url,
        options: Options(
          headers: {},
        ),
        data: formData,
      );
      var data = response.data;

      print('DONE PRODUCT ELEMENT__________$data');

      return data;
    } catch (e) {
      return Custlr.databaseError('$e');
    }
  }

  // Search Name
  static Future searchProduct(final name) async {
    try {
      Dio dio = Dio();
      String url = Custlr.url + "api/product/search";
      print(url);
      var formData = FormData.fromMap({
        'name': '$name',
      });

      var response =
          await dio.post(url, options: Options(headers: {}), data: formData);
      var data = response.data;

      print('DONE SEARCH NAME__________$data');

      return data;
    } catch (e) {
      return Custlr.databaseError('$e');
    }
  }

  // TIMER
  static Future timerProduct(final id) async {
    try {
      Dio dio = Dio();
      String url = Custlr.url + "api/product/promotion_timer";
      print(url);
      var formData = FormData.fromMap({
        'id': '$id',
      });

      var response =
          await dio.post(url, options: Options(headers: {}), data: formData);
      var data = response.data;

      print('DONE TIMER__________$data');

      return data;
    } catch (e) {
      return Custlr.databaseError('$e');
    }
  }

// Banner For gender
  static Future bannerGender() async {
    try {
      Dio dio = Dio();
      String url = Custlr.url + "api/app/banner";
      print(url);

      var response = await dio.get(
        url,
        options: Options(headers: {}),
      );
      var data = response.data;

      print('GENDER BANER__________$data');

      return data;
    } catch (e) {
      return Custlr.databaseError('$e');
    }
  }

  // Dont know size API
  static Future dontKnowSize() async {
    try {
      Dio dio = Dio();
      String url = Custlr.url + "api/banner";
      print(url);
      var formData = FormData.fromMap({
        'page': 'size',
      });

      var response =
          await dio.post(url, options: Options(headers: {}), data: formData);
      var data = response.data;

      print('Dont know size__________$data');

      return data;
    } catch (e) {
      return Custlr.databaseError('$e');
    }
  }

  // The Different
  static Future theDifferent() async {
    try {
      Dio dio = Dio();
      String url = Custlr.url + "api/standard_measurement";
      print(url);

      var response = await dio.get(
        url,
        options: Options(headers: {}),
      );
      var data = response.data;

      print('The Different__________$data');

      return data;
    } catch (e) {
      return Custlr.databaseError('$e');
    }
  }
}
