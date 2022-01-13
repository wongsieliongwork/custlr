import 'package:cached_network_image/cached_network_image.dart';
import 'package:custlr/api/blogAPI.dart';
import 'package:custlr/screen/blog/blog_detail.dart';
import 'package:custlr/screen/blog/blog_see_all.dart';
import 'package:custlr/widget/loading.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class BlogScreen extends StatefulWidget {
  @override
  _BlogScreenState createState() => _BlogScreenState();
}

class _BlogScreenState extends State<BlogScreen> {
  List entertainmentList = [];
  List healthList = [];
  bool isLoading = true;
  void getBlog() {
    Blog.blog(1).then((value) {
      entertainmentList = value['Blogs'];
      Blog.blog(2).then((value) {
        healthList = value['Blogs'];
        // setState(() {
        //   isLoading = false;
        // });

        if (mounted)
          setState(() {
            isLoading = false;
          });
      });
    });
  }

  @override
  void initState() {
    super.initState();
    getBlog();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
        body: isLoading
            ? Container(
                padding: EdgeInsets.all(20),
                child: ListView(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Shimmer.fromColors(
                          baseColor: Colors.grey[300],
                          highlightColor: Colors.grey[100],
                          child: Container(
                            height: 20,
                            width: 100,
                            color: Colors.grey,
                          ),
                        ),
                        Shimmer.fromColors(
                          baseColor: Colors.grey[300],
                          highlightColor: Colors.grey[100],
                          child: Container(
                            height: 20,
                            width: 100,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Shimmer.fromColors(
                      baseColor: Colors.grey[300],
                      highlightColor: Colors.grey[100],
                      child: Container(
                        height: size.height / 2.5,
                        color: Colors.grey,
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Shimmer.fromColors(
                          baseColor: Colors.grey[300],
                          highlightColor: Colors.grey[100],
                          child: Container(
                            height: 20,
                            width: 100,
                            color: Colors.grey,
                          ),
                        ),
                        Shimmer.fromColors(
                          baseColor: Colors.grey[300],
                          highlightColor: Colors.grey[100],
                          child: Container(
                            height: 20,
                            width: 100,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Column(
                        children: List.generate(
                      10,
                      (index) => Container(
                        padding: EdgeInsets.only(bottom: 10),
                        child: Shimmer.fromColors(
                          baseColor: Colors.grey[300],
                          highlightColor: Colors.grey[100],
                          child: Container(
                            height: 100,
                            width: size.width,
                            color: Colors.grey,
                          ),
                        ),
                      ),
                    ))
                  ],
                ),
              )
            : Container(
                padding: EdgeInsets.all(20),
                child: ListView(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Entertainment',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 20),
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        BlogSeeAll(entertainmentList)));
                          },
                          child: Text(
                            'See all',
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 14),
                          ),
                        ),
                      ],
                    ),
                    Container(
                      height: size.height / 2.5,
                      child: ListView.builder(
                          shrinkWrap: true,
                          scrollDirection: Axis.horizontal,
                          itemCount: entertainmentList.length,
                          itemBuilder: (context, index) {
                            return GestureDetector(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => BlogDetail(
                                              entertainmentList[index],
                                            )));
                              },
                              child: Stack(
                                children: [
                                  Container(
                                    height: size.height / 2.5,
                                    padding:
                                        EdgeInsets.only(top: 20, right: 20),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(20.0),
                                      child: ColorFiltered(
                                        colorFilter: ColorFilter.mode(
                                            Colors.grey.withOpacity(0.5),
                                            BlendMode.darken),
                                        child: Hero(
                                          tag: entertainmentList[index]
                                              ['title'],
                                          child: CachedNetworkImage(
                                            width: size.width / 2,
                                            fit: BoxFit.cover,
                                            placeholder: (context, url) =>
                                                Container(
                                              color: Colors.grey,
                                            ),
                                            imageUrl:
                                                'https://www.custlr.com/admin/images/blogs/${entertainmentList[index]['BlogID']}/${entertainmentList[index]['banner']}',
                                          ),
                                          // child: Image.network(
                                          //   'https://www.custlr.com/admin/images/blogs/${entertainmentList[index]['BlogID']}/${entertainmentList[index]['banner']}',
                                          //   width: size.width / 2,
                                          //   fit: BoxFit.cover,
                                          // ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Align(
                                    alignment: Alignment.bottomLeft,
                                    child: Container(
                                        padding: EdgeInsets.symmetric(
                                            vertical: 20, horizontal: 20),
                                        width: size.width / 2,
                                        child: Text(
                                          entertainmentList[index]['title'],
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold),
                                        )),
                                  ),
                                ],
                              ),
                            );
                          }),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Health',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 20),
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        BlogSeeAll(healthList)));
                          },
                          child: Text(
                            'See all',
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 14),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Column(
                      children: List.generate(healthList.length, (index) {
                        return GestureDetector(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        BlogDetail(healthList[index])));
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
                                      tag: healthList[index]['title'],
                                      child: CachedNetworkImage(
                                        height: size.height / 8,
                                        width: size.height / 8,
                                        fit: BoxFit.cover,
                                        placeholder: (context, url) =>
                                            Container(
                                          color: Colors.grey,
                                        ),
                                        imageUrl:
                                            'https://www.custlr.com/admin/images/blogs/${healthList[index]['BlogID']}/${healthList[index]['banner']}',
                                      ),
                                      // child: Image.network(
                                      //   'https://www.custlr.com/admin/images/blogs/${healthList[index]['BlogID']}/${healthList[index]['banner']}',
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
                                      blogList[index]['title'],
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                  )),
                                ],
                              ),
                            ),
                          ),
                        );
                      }),
                    )
                  ],
                ),
              ));
  }

  List blogList = [
    {
      'title': 'Enhance at a Glance! (How to Look Good)',
      'image': 'assets/images/blog/1.jpeg',
    },
    {
      'title': 'Protection by Prevention',
      'image': 'assets/images/blog/2.jpeg',
    },
    {
      'title': 'Inspiration for New Bloggers',
      'image': 'assets/images/blog/3.jpeg',
    },
    {
      'title': '10 Eating Habits That Rewire Your Brain for Success',
      'image': 'assets/images/blog/4.png',
    },
    {
      'title': "The Real Reason Money Can't Buy Happiness",
      'image': 'assets/images/blog/5.png',
    },
    {
      'title': "Few Facts About Streaming and Music Creation",
      'image': 'assets/images/blog/6.png',
    },
    {
      'title': "How I Became Strong After a Lifetime of Being Bullied",
      'image': 'assets/images/blog/7.png',
    }
  ];
}
