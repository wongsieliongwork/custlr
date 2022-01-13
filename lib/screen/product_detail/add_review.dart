import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:custlr/api/reviewAPI.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:image_picker/image_picker.dart';
import 'package:dio/dio.dart' as dio;
import 'package:path/path.dart';

class AddReview extends StatefulWidget {
  final data;
  AddReview(this.data);
  @override
  _AddReviewState createState() => _AddReviewState();
}

class _AddReviewState extends State<AddReview> {
  double rate = 3.00;

  // Image Picker
  File img;

  final picker = ImagePicker();

  Future getCamera() async {
    PickedFile pickedFile;
    pickedFile = await picker.getImage(source: ImageSource.camera);

    setState(() {
      img = File(pickedFile.path);
    });
  }

  Future getGallery() async {
    PickedFile pickedFile;
    pickedFile = await picker.getImage(source: ImageSource.gallery);

    setState(() {
      img = File(pickedFile.path);
    });
  }

  final reviewController = TextEditingController();

  bool isLoading = false;
  @override
  Widget build(BuildContext context) {
    final isKeyboard = MediaQuery.of(context).viewInsets.bottom != 0;
    return Scaffold(
        appBar: AppBar(
          title: Text(
            'Rate Product',
            style: TextStyle(color: Colors.black),
          ),
        ),
        body: Stack(
          children: [
            Column(
              children: [
                isKeyboard
                    ? Container()
                    : Column(
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              CachedNetworkImage(
                                imageUrl: widget.data['banner'],
                                placeholder: (context, url) => Image.asset(
                                    'assets/images/placeholder-image.png'),
                                errorWidget: (context, url, error) =>
                                    Image.asset(
                                        'assets/images/placeholder-image.png'),
                                height: 50,
                                width: 50,
                                alignment: Alignment.topCenter,
                              ),
                              Text(
                                widget.data['product_name'],
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Divider(
                            thickness: 2,
                          ),
                          RatingBar.builder(
                            initialRating: rate,
                            minRating: 1,
                            direction: Axis.horizontal,
                            // allowHalfRating: true,
                            itemCount: 5,
                            itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
                            itemBuilder: (context, _) => Icon(
                              Icons.star,
                              color: Colors.amber,
                            ),
                            onRatingUpdate: (rating) {
                              rate = rating;
                            },
                          ),
                          Row(
                            children: [
                              Expanded(
                                child: GestureDetector(
                                  onTap: () {
                                    getCamera();
                                  },
                                  child: Container(
                                    margin: EdgeInsets.all(10),
                                    height: 60,
                                    decoration: BoxDecoration(
                                        border: Border.all(color: Colors.grey)),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Icon(
                                          Icons.camera_alt,
                                          color: Colors.grey,
                                        ),
                                        Text(
                                          'Camera',
                                          style: TextStyle(color: Colors.grey),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              Expanded(
                                child: GestureDetector(
                                  onTap: () {
                                    getGallery();
                                  },
                                  child: Container(
                                    margin: EdgeInsets.all(10),
                                    height: 60,
                                    decoration: BoxDecoration(
                                        border: Border.all(color: Colors.grey)),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Icon(
                                          Icons.image,
                                          color: Colors.grey,
                                        ),
                                        Text(
                                          'Gallery',
                                          style: TextStyle(color: Colors.grey),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                          img != null
                              ? SizedBox(
                                  width: double.infinity,
                                  child: Image.file(
                                    img,
                                    fit: BoxFit.cover,
                                    height: 150,
                                  ),
                                )
                              : Container(),
                        ],
                      ),
                Container(
                  margin: EdgeInsets.all(10),
                  child: TextField(
                    controller: reviewController,
                    autofocus: false,
                    maxLines: 10,
                    decoration: new InputDecoration(
                      hintText:
                          'Share your experience and help others make better choice!',
                      filled: true,
                      fillColor: Colors.grey[300],
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white),
                      ),
                    ),
                  ),
                ),
                Spacer(),
                GestureDetector(
                  onTap: () async {
                    setState(() {
                      isLoading = true;
                    });
                    final data = {
                      'reviews': reviewController.text,
                      'star_rating': rate,
                      'user_pic': img != null
                          ? await dio.MultipartFile.fromFile(img.path,
                              filename: basename(img.path))
                          : '',
                      // : await dio.MultipartFile.fromFile(file.path,
                      //     filename: basename(file.path)),
                      'ProductID': widget.data['ProductID'],
                      'vertified': '1',
                    };
                    ReviewAPI.addReview(data).then((value) {
                      setState(() {
                        isLoading = false;
                      });
                      Navigator.pop(context, true);
                    });
                  },
                  child: SizedBox(
                      width: double.infinity,
                      height: 40,
                      child: Container(
                        color: Colors.black,
                        alignment: Alignment.center,
                        child: isLoading
                            ? Container(
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                ),
                              )
                            : Text(
                                'Submit',
                                style: TextStyle(
                                    color: Colors.white, fontSize: 20),
                              ),
                      )),
                )
              ],
            ),
            !isKeyboard
                ? Container()
                : Container(
                    child: Align(
                      alignment: Alignment.bottomCenter,
                      child: SizedBox(
                        width: double.infinity,
                        child: Container(
                          alignment: Alignment.centerRight,
                          color: Colors.black,
                          height: 30,
                          child: GestureDetector(
                            onTap: () {
                              FocusScope.of(context).unfocus();
                            },
                            child: Text(
                              'Done',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
          ],
        ));
  }
}

/*
  !isKeyboard
              ? Container()
              : Container(
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child: SizedBox(
                      width: double.infinity,
                      child: Container(
                        alignment: Alignment.centerRight,
                        color: Colors.black,
                        height: 30,
                        child: GestureDetector(
                          onTap: () {
                            FocusScope.of(context).unfocus();
                          },
                          child: Text(
                            'Done',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),

                */