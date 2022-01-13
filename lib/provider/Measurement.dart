import 'package:custlr/api/api.dart';
import 'package:flutter/material.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

// Body Measurement and Checkout
class Measurement extends ChangeNotifier {
  List bodyMeasurement = [];
  Map bodyPattern = {};
  dynamic data = {};
  String remarks = '';
  bool isDressingMeasurement;
  bool isA4Fit;
  List productPatterns = [];
  dynamic productConversion = {};
  List productMeasurement = [];
  void getProductElement(final id) async {
    print("ID $id");
    API.productElement(id).then((value) {
      productPatterns = value['product_patterns'];
      // first selection for pattern
      bodyPattern = {
        for (var v in productPatterns)
          v['name']: !v['data'].isEmpty
              ? v['data'][0]
              : {
                  "ProductPatternID": 7810,
                  "name": "As per image",
                  "image": "/admin/images/product/32/patterns/fitting1.jpg"
                },
      };
      print(value['product_conversions']);
      if (value['product_conversions'].isEmpty) {
        productConversion = {
          "chest_conversion": "0.00",
          "shoulder_conversion": "0.00",
          "arm_length_conversion": "0.00",
          "bicep_conversion": "0.00",
          "waist_conversion": "0.00"
        };
      } else {
        productConversion = value['product_conversions'][0];
      }
      print('PRODUCT CONVERSION $productConversion');
      productMeasurement = value['product_measurement'];
      notifyListeners();
    });

    print('Product Pattern Result $bodyPattern');

    //First Own Measurement
    bodyMeasurement = [
      {
        'name': 'Chest',
        'top': 140.00,
        'left': 165.00,
        'conversion':
            double.parse(productConversion['chest_conversion'] ?? "0.00"),
        'body': 0.00,
        'final': double.parse(productConversion['chest_conversion'] ?? "0.00"),
      },
      {
        'name': 'Shoulder',
        'top': 140.00,
        'left': 300.00,
        'conversion':
            double.parse(productConversion['shoulder_conversion'] ?? "0.00"),
        'body': 0.00,
        'final':
            double.parse(productConversion['shoulder_conversion'] ?? "0.00"),
      },
      {
        'name': 'Arm',
        'top': 250.00,
        'left': 350.00,
        'conversion':
            double.parse(productConversion['bicep_conversion'] ?? "0.00"),
        'body': 0.00,
        'final': double.parse(productConversion['bicep_conversion'] ?? "0.00"),
      },
      {
        'name': 'Arm Length',
        'top': 400.00,
        'left': 280.00,
        'conversion':
            double.parse(productConversion['arm_length_conversion'] ?? "0.00"),
        'body': 0.00,
        'final':
            double.parse(productConversion['arm_length_conversion'] ?? "0.00"),
      },
      {
        'name': 'Waist',
        'top': 500.00,
        'left': 165.00,
        'conversion':
            double.parse(productConversion['waist_conversion'] ?? "0.00"),
        'body': 0.00,
        'final': double.parse(productConversion['waist_conversion'] ?? "0.00"),
      },
    ];
  }

// Select Pattern
  void selectPattern(dynamic data, String name) {
    bodyPattern.update(name, (value) => data);
    notifyListeners();
  }

// Show AlertDialog For Conversion Each Product
  void alertConversion(BuildContext context) async {
    Alert(
        context: context,
        title: "Conversion",
        content: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: List.generate(
                bodyMeasurement.length,
                (index) => Container(
                      padding: EdgeInsets.symmetric(vertical: 5),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('${bodyMeasurement[index]["name"]}'),
                          Text('${bodyMeasurement[index]["conversion"]} cm'),
                        ],
                      ),
                    )))).show();
  }
}
