import 'package:cached_network_image/cached_network_image.dart';
import 'package:custlr/screen/blog/blog_detail.dart';
import 'package:flutter/material.dart';

class BlogSeeAll extends StatefulWidget {
  final List seeAllList;
  BlogSeeAll(this.seeAllList);
  @override
  _BlogSeeAllState createState() => _BlogSeeAllState();
}

class _BlogSeeAllState extends State<BlogSeeAll> {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'See All',
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: Container(
        padding: EdgeInsets.all(20),
        child: ListView(
          children: List.generate(widget.seeAllList.length, (index) {
            return GestureDetector(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            BlogDetail(widget.seeAllList[index])));
              },
              child: Container(
                margin: EdgeInsets.only(bottom: 10),
                child: Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: Row(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(10),
                          bottomLeft: Radius.circular(10),
                        ),
                        child: Hero(
                          tag: widget.seeAllList[index]['title'],
                          child: CachedNetworkImage(
                            height: size.height / 8,
                            width: size.height / 8,
                            fit: BoxFit.cover,
                            placeholder: (context, url) => Container(
                              color: Colors.grey,
                            ),
                            imageUrl:
                                'https://www.custlr.com/admin/images/blogs/${widget.seeAllList[index]['BlogID']}/${widget.seeAllList[index]['banner']}',
                          ),
                          // child: Image.network(
                          //   'https://www.custlr.com/admin/images/blogs/${widget.seeAllList[index]['BlogID']}/${widget.seeAllList[index]['banner']}',
                          //   height: size.height / 8,
                          //   width: size.height / 8,
                          //   fit: BoxFit.cover,
                          // ),
                        ),
                      ),
                      Expanded(
                          child: Container(
                        padding: EdgeInsets.all(20),
                        child: Text(
                          widget.seeAllList[index]['title'],
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      )),
                    ],
                  ),
                ),
              ),
            );
          }),
        ),
      ),
    );
  }
}
