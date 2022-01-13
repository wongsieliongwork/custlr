import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

class Testing extends StatefulWidget {
  @override
  _TestingState createState() => _TestingState();
}

class _TestingState extends State<Testing> {
  List imageList = [
    {
      'image': 'arm_length.png',
      'name': 'Arm Length',
    },
    {
      'image': 'arm.png',
      'name': 'Arm',
    },
    {
      'image': 'chest.png',
      'name': 'Chest',
    },
    {
      'image': 'Dress Length.png',
      'name': 'Dress Length',
    },
  ];
  @override
  void initState() {
    super.initState();
  }

  int _current = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: CarouselSlider(
          options: CarouselOptions(
              onPageChanged: (index, reason) {
                setState(() {
                  print(index);
                });
              },
              viewportFraction: 1.0,
              enlargeCenterPage: true),
          items: List.generate(imageList.length, (index) {
            return Image.asset(
                'assets/images/bodyMeasurement/${imageList[index]['image']}');
          }),
        ),
      ),
    );
  }
}
