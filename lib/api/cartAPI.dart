import 'package:custlr/utils/constants.dart';
import 'package:custlr/widget/dioError.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:custlr/utils/shared_preference_utils.dart';

class CartAPI {
  // ADD TO CART
  static Future addToCart(final params) async {
    try {
      Dio dio = Dio();
      String url = Custlr.url + "api/cart/add";
      print(url);
      var formData = FormData.fromMap(params);

      var response = await dio.post(url,
          options: Options(headers: {
            'Authorization': 'Bearer ${SharedPreferencesUtil.token}',
          }),
          data: formData);
      var data = response.data;

      print('ADD TO CART__________$data');

      return data;
    } catch (e) {
      return Custlr.databaseError('$e');
    }
  }

  // View Cart
  static Future viewCart() async {
    try {
      Dio dio = Dio();
      String url = Custlr.url + "api/cart/view";
      print(url);

      var response = await dio.get(
        url,
        options: Options(headers: {
          'Authorization': 'Bearer ${SharedPreferencesUtil.token}',
        }),
      );
      var data = response.data;

      print('ADD TO CART__________$data');

      return data;
    } catch (e) {
      return Custlr.databaseError('$e');
    }
  }

  // Senang Pay
  static Future senangPay() async {
    try {
      Dio dio = Dio();
      String url = 'https://sandbox.senangpay.my/payment/161159785825248';
      print(url);

      var formData = FormData.fromMap({
        'detail': 'ORD-20210507083310449089549811_detail',
        'amount': '100',
        'order_id': 'ORD-20210507083310449089549811',
        'name': 'Wong',
        'email': 'aboywsl@gmail.com',
        'phone': '123',
        'hash': '0deafa7a45e420237221853f31b94ce4'
      });
      var response = await dio.post(url,
          options: Options(
            headers: {
              'Authorization': 'Bearer ${SharedPreferencesUtil.token}',
            },
          ),
          data: formData);
      var data = response.data;

      print('SENANG PAY__________$data');

      return data;
    } catch (e) {
      return Custlr.databaseError('$e');
    }
  }

  // Gateway
  static Future gateway(final amount) async {
    try {
      Dio dio = Dio();
      String url = Custlr.url + 'api/payment/gateway';
      print(url);

      var formData = FormData.fromMap({
        'amount': '$amount',
      });
      var response = await dio.post(url,
          options: Options(
            headers: {
              'Authorization': 'Bearer ${SharedPreferencesUtil.token}',
            },
          ),
          data: formData);
      var data = response.data;

      print('GATEWAY__________$data');

      return data;
    } on DioError catch (e) {
      errorMessage(e.response.realUri.toString(), e.response.data);
    }
  }

  // Edit Cart
  static Future editCart(final params) async {
    Dio dio = Dio();
    String url = Custlr.url + 'api/cart/edit';
    print(url);

    var formData = FormData.fromMap(params);
    var response = await dio.post(url,
        options: Options(
          headers: {
            'Authorization': 'Bearer ${SharedPreferencesUtil.token}',
          },
        ),
        data: formData);
    var data = response.data;

    print('EDIT CART__________$data');

    return data;
  }

  // Remove Cart
  static Future removeCart(final id) async {
    try {
      Dio dio = Dio();
      String url = Custlr.url + 'api/cart/delete';
      print(url);

      var formData = FormData.fromMap({
        'id': id,
      });
      var response = await dio.post(url,
          options: Options(
            headers: {
              'Authorization': 'Bearer ${SharedPreferencesUtil.token}',
            },
          ),
          data: formData);
      var data = response.data;

      print('REMOVE CART__________$data');

      return data;
    } catch (e) {
      return Custlr.databaseError('$e');
    }
  }

  // View Order
  static Future viewOrder() async {
    try {
      Dio dio = Dio();
      String url = Custlr.url + "api/account/order/view";
      print(url);

      var response = await dio.get(
        url,
        options: Options(headers: {
          'Authorization': 'Bearer ${SharedPreferencesUtil.token}',
        }),
      );
      var data = response.data;

      print('View Order__________$data');

      return data;
    } catch (e) {
      return Custlr.databaseError('$e');
    }
  }

// View Order
  static Future continuePayment(final orderId) async {
    try {
      Dio dio = Dio();
      String url = Custlr.url + "api/payment/con_pay";
      print(url);
      var formData = FormData.fromMap({
        'id': orderId,
      });
      var response = await dio.post(url,
          options: Options(
            headers: {
              'Authorization': 'Bearer ${SharedPreferencesUtil.token}',
            },
          ),
          data: formData);
      var data = response.data;

      print('Continue Payment__________$data');

      return data;
    } catch (e) {
      return Custlr.databaseError('$e');
    }
  }

  // Edit Cart
  static Future registerCoupon(final params) async {
    Dio dio = Dio();
    String url = Custlr.url + 'api/coupon/register';
    print(url);

    var formData = FormData.fromMap(params);
    var response = await dio.post(url,
        options: Options(
          headers: {
            'Authorization': 'Bearer ${SharedPreferencesUtil.token}',
          },
        ),
        data: formData);
    var data = response.data;

    print('Register Coupon__________$data');

    return data;
  }
}
