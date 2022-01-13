import 'dart:convert';
import 'package:custlr/provider/ShoppingPageProvider.dart';
import 'package:custlr/screen/MainTabBar/main_tab_bar.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DynamicLinkService {
  String linkMessage;
  bool isCreatingLink = false;
  // String _testString =
  //     'To test: long press link and then copy and click from a non-browser '
  //     "app. Make sure this isn't being tested on iOS simulator and iOS xcode "
  //     'is properly setup. Look at firebase_dynamic_links/README.md for more '
  //     'details.';

  Future<void> initDynamicLinks(BuildContext context) async {
    FirebaseDynamicLinks.instance.onLink(
        onSuccess: (PendingDynamicLinkData dynamicLink) async {
      final Uri deepLink = dynamicLink?.link;

      if (deepLink != null) {
        //ignore: unawaited_futures
        dynamic data = jsonDecode(deepLink.queryParameters['data']);
        print("Dynamic Data===>$data");
        Provider.of<ShoppingPageProvider>(context, listen: false).isFemale =
            false;
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => MainTabBar()));

        print('Go to Dynamic Link');
      }
    }, onError: (OnLinkErrorException e) async {
      print('onLinkError');
      print(e.message);
    });
  }

  Future createDynamicLink(bool short, dynamic data) async {
    print("create dynamic==>$data");
    final DynamicLinkParameters parameters = DynamicLinkParameters(
      uriPrefix: 'https://custlrapp.page.link',
      link: Uri.parse(
          'https://custlrapp.page.link/helloworld/?data=$data&name=me'),
      androidParameters: AndroidParameters(
        packageName: 'com.custlr.app',
        minimumVersion: 0,
      ),
      dynamicLinkParametersOptions: DynamicLinkParametersOptions(
        shortDynamicLinkPathLength: ShortDynamicLinkPathLength.short,
      ),
      iosParameters: IosParameters(
        bundleId: 'com.google.FirebaseCppDynamicLinksTestApp.dev',
        minimumVersion: '0',
      ),
    );

    Uri url;
    if (short) {
      final ShortDynamicLink shortLink = await parameters.buildShortLink();
      url = shortLink.shortUrl;
    } else {
      url = await parameters.buildUrl();
    }

    return url.toString();
  }
}
