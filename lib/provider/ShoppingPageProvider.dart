import 'package:custlr/api/api.dart';
import 'package:flutter/material.dart';

class ShoppingPageProvider extends ChangeNotifier {
  // List for shopping page
  List bannerList = [];
  List productList = [];
  List newList = [];
  List topList = [];
  List featuredList = [];
  Map sizeMap = {};
  List differentList = [];
  // Loading
  bool isLoading = true;
  // First time is Female
  bool isFemale = true;
  // From API
  Future getAPI() async {
    this.isFemale = isFemale;

// Banner Image
    API.bannerAPI('shop').then((value) {
      if (isFemale) {
        bannerList = value['woman'];
      } else if (!isFemale) {
        bannerList = value['man'];
      }

      notifyListeners();
    });

// All product
    API.productAPI().then((value) {
      productList = value['product'];

      //If else for female and male
      if (isFemale) {
        productList = productList
            .where((element) => element['gender'] == 'Woman')
            .toList();
      } else if (!isFemale) {
        productList =
            productList.where((element) => element['gender'] == 'Man').toList();
      }

      notifyListeners();
      isLoading = false;

// Find top_seller,new_arrival,featured_product
      newList =
          productList.where((element) => element['new_arrival'] == 1).toList();
      topList =
          productList.where((element) => element['top_seller'] == 1).toList();
      featuredList = productList
          .where((element) => element['featured_product'] == 1)
          .toList();
    });

    API.dontKnowSize().then((value) {
      sizeMap = value;
    });

    API.theDifferent().then((value) {
      differentList = value;
    });
  }
}
