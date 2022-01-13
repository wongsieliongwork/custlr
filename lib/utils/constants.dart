import 'package:flutter/cupertino.dart';

class Custlr {
  static const String url = 'https://app.custlr.com/';
  static const String imgUrl = 'https://www.custlr.com/';
  // static const String devUrl = 'https://dev.custlr.com';
  static const String lorem =
      'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Donec placerat purus augue. Praesent ac tortor non purus lobortis maximus. Nunc euismod id enim sit amet dignissim. Integer pulvinar euismod feugiat. Curabitur enim lorem, varius a facilisis eget, posuere eget nibh. Duis mollis dolor a blandit dapibus. Nulla facilisi. Fusce dolor tellus, tempor eu tortor et, pulvinar ultricies dui. Nam consectetur commodo sem id finibus. Suspendisse ac libero quam. Etiam egestas mattis condimentum. Etiam facilisis sodales lobortis. Etiam dapibus vitae urna vel sodales. Phasellus mollis volutpat condimentum.';
  static const String lorem2 =
      'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Donec placerat purus augue. Praesent ac tortor non purus lobortis maximus. Nunc euismod id enim sit amet dignissim. Integer pulvinar euismod feugiat. Curabitur enim lorem, varius a facilisis eget, posuere eget nibh. Duis mollis dolor a blandit dapibus. Nulla facilisi. Fusce dolor tellus, tempor eu tortor et, pulvinar ultricies dui. Nam consectetur commodo sem id finibus. Suspendisse ac libero quam. Etiam egestas mattis condimentum. Etiam facilisis sodales lobortis. Etiam dapibus vitae urna vel sodales. Phasellus mollis volutpat condimentum.\n\nLorem ipsum dolor sit amet, consectetur adipiscing elit. Donec placerat purus augue. Praesent ac tortor non purus lobortis maximus. Nunc euismod id enim sit amet dignissim. Integer pulvinar euismod feugiat. Curabitur enim lorem, varius a facilisis eget, posuere eget nibh. Duis mollis dolor a blandit dapibus. Nulla facilisi. Fusce dolor tellus, tempor eu tortor et, pulvinar ultricies dui. Nam consectetur commodo sem id finibus. Suspendisse ac libero quam. Etiam egestas mattis condimentum. Etiam facilisis sodales lobortis. Etiam dapibus vitae urna vel sodales. Phasellus mollis volutpat condimentum.\n\nLorem ipsum dolor sit amet, consectetur adipiscing elit. Donec placerat purus augue. Praesent ac tortor non purus lobortis maximus. Nunc euismod id enim sit amet dignissim. Integer pulvinar euismod feugiat. Curabitur enim lorem, varius a facilisis eget, posuere eget nibh. Duis mollis dolor a blandit dapibus. Nulla facilisi. Fusce dolor tellus, tempor eu tortor et, pulvinar ultricies dui. Nam consectetur commodo sem id finibus. Suspendisse ac libero quam. Etiam egestas mattis condimentum. Etiam facilisis sodales lobortis. Etiam dapibus vitae urna vel sodales. Phasellus mollis volutpat condimentum.\n\nLorem ipsum dolor sit amet, consectetur adipiscing elit. Donec placerat purus augue. Praesent ac tortor non purus lobortis maximus. Nunc euismod id enim sit amet dignissim. Integer pulvinar euismod feugiat. Curabitur enim lorem, varius a facilisis eget, posuere eget nibh. Duis mollis dolor a blandit dapibus. Nulla facilisi. Fusce dolor tellus, tempor eu tortor et, pulvinar ultricies dui. Nam consectetur commodo sem id finibus. Suspendisse ac libero quam. Etiam egestas mattis condimentum. Etiam facilisis sodales lobortis. Etiam dapibus vitae urna vel sodales. Phasellus mollis volutpat condimentum.\n\nLorem ipsum dolor sit amet, consectetur adipiscing elit. Donec placerat purus augue. Praesent ac tortor non purus lobortis maximus. Nunc euismod id enim sit amet dignissim. Integer pulvinar euismod feugiat. Curabitur enim lorem, varius a facilisis eget, posuere eget nibh. Duis mollis dolor a blandit dapibus. Nulla facilisi. Fusce dolor tellus, tempor eu tortor et, pulvinar ultricies dui. Nam consectetur commodo sem id finibus. Suspendisse ac libero quam. Etiam egestas mattis condimentum. Etiam facilisis sodales lobortis. Etiam dapibus vitae urna vel sodales. Phasellus mollis volutpat condimentum.';
  static dynamic databaseError(final error) {
    return {
      'status': '0',
      'msg': 'database error \n$error',
    };
  }

  static double width;
  static double height;

  void initializeConstants(BuildContext context) {
    width = MediaQuery.of(context).size.width;
    height = MediaQuery.of(context).size.height;
  }
}
