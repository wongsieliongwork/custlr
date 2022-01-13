import 'package:custlr/api/api.dart';
import 'package:custlr/screen/product_detail/product_detail.dart';
import 'package:flutter/material.dart';
import 'package:material_floating_search_bar/material_floating_search_bar.dart';

class SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  List searchList = [];
  void getSearchAPI(final name) async {
    API.searchProduct(name).then((value) {
      searchList = value['product'];
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget buildFloatingSearchBar() {
      final isPortrait =
          MediaQuery.of(context).orientation == Orientation.portrait;
      return FloatingSearchBar(
        hint: 'Search...',
        scrollPadding: const EdgeInsets.only(top: 16, bottom: 56),
        transitionDuration: const Duration(milliseconds: 800),
        transitionCurve: Curves.easeInOut,
        physics: const BouncingScrollPhysics(),
        axisAlignment: isPortrait ? 0.0 : -1.0,
        openAxisAlignment: 0.0,
        width: isPortrait ? 600 : 500,
        debounceDelay: const Duration(milliseconds: 500),
        onQueryChanged: (query) {
          setState(() {
            if (query == '') {
              searchList = [];
            } else {
              getSearchAPI(query);
            }
          });
        },
        transition: CircularFloatingSearchBarTransition(),
        actions: [
          FloatingSearchBarAction.searchToClear(
            showIfClosed: true,
          ),
        ],
        builder: (context, transition) {
          return ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Material(
              color: Colors.white,
              elevation: 4.0,
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: List.generate(searchList.length, (index) {
                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    ProductDetail(searchList[index])));
                      },
                      child: SizedBox(
                        width: double.infinity,
                        child: Container(
                            decoration: BoxDecoration(
                                border: Border(
                              bottom: BorderSide(
                                  color: Colors.grey.withOpacity(0.5)),
                            )),
                            padding: EdgeInsets.all(20),
                            child: Text(searchList[index]['product_name'])),
                      ),
                    );
                  })),
            ),
          );
        },
      );
    }

    return Scaffold(
      body: Container(
        color: Colors.black,
        child: Column(
          children: [
            Expanded(child: buildFloatingSearchBar()),
          ],
        ),
      ),
    );
  }
}
