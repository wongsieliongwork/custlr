import 'package:fluttertoast/fluttertoast.dart';

void errorMessage(String url, String msg) {
  Fluttertoast.showToast(
    msg: '$url \n $msg',
    toastLength: Toast.LENGTH_LONG,
  );
}
