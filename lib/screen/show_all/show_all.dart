import 'package:custlr/screen/show_all/show_product.dart';
import 'package:flutter/material.dart';

class ShowAll extends StatefulWidget {
  ShowAll(this.name, this.data);
  final String name;
  final data;

  @override
  _ShowAllState createState() => _ShowAllState();
}

class _ShowAllState extends State<ShowAll> with TickerProviderStateMixin {
  // Tab Variable
  final List categoryList = [
    'New arrivals',
    'Top Selling',
    'Featured',
  ];

  String name = '';
  TabController controller;

  @override
  void initState() {
    tabListener();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            name,
            style: TextStyle(color: Colors.black),
          ),
          bottom: TabBar(
            controller: controller,
            labelColor: Colors.black,
            indicatorColor: Color(0xFF77b9bc),
            tabs: List.generate(
                categoryList.length,
                (index) => Tab(
                      text: categoryList[index],
                    )),
          ),
        ),
        body: TabBarView(
          controller: controller,
          children: [
            ShowProduct(widget.data),
            ShowProduct(widget.data),
            ShowProduct(widget.data),
          ],
        ),
      ),
    );
  }

  // Change name for tab
  void changeName() {
    setState(() {
      name = categoryList[controller.index];
    });
  }

  // Tab Listener
  void tabListener() {
    int index;
    if (widget.name == 'New arrivals') {
      index = 0;
    } else if (widget.name == 'Top Selling') {
      index = 1;
    } else if (widget.name == 'Featured') {
      index = 2;
    }
    name = categoryList[0];
    controller = TabController(length: 3, vsync: this, initialIndex: index);
    controller.addListener(changeName);
  }
}
