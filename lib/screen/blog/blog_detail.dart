import 'package:custlr/api/blogAPI.dart';
import 'package:custlr/widget/loading.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';

class BlogDetail extends StatefulWidget {
  final dynamic data;
  BlogDetail(this.data);
  @override
  _BlogDetailState createState() => _BlogDetailState();
}

class _BlogDetailState extends State<BlogDetail> {
  dynamic blogDetail = {};
  bool isLoading = true;
  void getBlogDetail() {
    Blog.blogDetail(widget.data['BlogID']).then((value) {
      blogDetail = value;
      setState(() {
        isLoading = false;
      });
    });
  }

  @override
  void initState() {
    super.initState();
    getBlogDetail();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            leading: GestureDetector(
              onTap: () {
                Navigator.pop(context);
              },
              child: Icon(
                Icons.keyboard_arrow_left_outlined,
                color: Colors.grey,
                size: 40,
              ),
            ),
            shadowColor: Colors.white,
            floating: true,
            expandedHeight: 300,
            flexibleSpace: FlexibleSpaceBar(
              background: Hero(
                tag: widget.data['title'],
                child: Image.network(
                  'https://www.custlr.com/admin/images/blogs/${widget.data['BlogID']}/${widget.data['banner']}',
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          SliverList(
              delegate: SliverChildListDelegate([
            Container(
              padding: EdgeInsets.all(20),
              child: Column(
                children: [
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    widget.data['title'],
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  isLoading
                      ? CustlrLoading.circularLoading()
                      : Html(data: blogDetail['content']),
                ],
              ),
            )
          ])),
        ],
      ),
    );
  }
}
