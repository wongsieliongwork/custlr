import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:custlr/provider/Measurement.dart';
import 'package:custlr/provider/ShoppingPageProvider.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

class ShowDialog {
  // Show bottomSheet for Style Option

  void bottomSheetStyleOption(BuildContext context) {
    final ItemScrollController itemScrollController = ItemScrollController();
    final ItemPositionsListener itemPositionsListener =
        ItemPositionsListener.create();
    List<bool> isSelect = [];

    showModalBottomSheet(
        context: context,
        builder: (context) {
          final dataMeasurement = Provider.of<Measurement>(context);
          final bodyPattern = dataMeasurement.bodyPattern;
          dynamic patternList = dataMeasurement.productPatterns;
          return StatefulBuilder(
              builder: (BuildContext context, StateSetter modalState) {
            return Column(
              children: [
                Container(
                  padding: EdgeInsets.all(20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Styling Options',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 20),
                      ),
                      GestureDetector(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: Icon(Icons.cancel)),
                    ],
                  ),
                ),
                Expanded(
                    child: ScrollablePositionedList.builder(
                        itemScrollController: itemScrollController,
                        itemPositionsListener: itemPositionsListener,
                        itemCount: patternList.length + 1,
                        itemBuilder: (context, index) {
                          if (patternList.length == index) {
                            return Container(
                              height: 300,
                            );
                          }
                          isSelect.add(false);
                          String name = patternList[index]['name'][0]
                                  .toUpperCase()
                                  .toString() +
                              patternList[index]['name'].substring(1);
                          return Column(
                            children: [
                              GestureDetector(
                                onTap: () {
                                  modalState(() {
                                    if (patternList[index]['data'].isEmpty) {
                                      Fluttertoast.showToast(
                                          msg: 'Comming Soon');
                                    } else if (isSelect[index] == false) {
                                      itemScrollController.scrollTo(
                                          index: index,
                                          duration: Duration(seconds: 1),
                                          curve: Curves.ease);
                                      isSelect[index] = !isSelect[index];
                                      print('AA' + index.toString());
                                    } else if (isSelect[index] == true) {
                                      itemScrollController.scrollTo(
                                          index: 0,
                                          duration: Duration(seconds: 2),
                                          curve: Curves.ease);
                                      isSelect[index] = !isSelect[index];
                                      print('BB' + index.toString());
                                    }
                                  });
                                },
                                child: ListTile(
                                  leading: Text(name),
                                  trailing: Icon(Icons.keyboard_arrow_down),
                                ),
                              ),
                              Visibility(
                                visible: isSelect[index],
                                child: patternList[index]['data'].isEmpty
                                    ? Container(
                                        padding: EdgeInsets.all(20),
                                        child: Text('Coming Soon'),
                                      )
                                    : Container(
                                        child: ListView.separated(
                                            shrinkWrap: true,
                                            physics:
                                                NeverScrollableScrollPhysics(),
                                            itemBuilder: (context, i) {
                                              return GestureDetector(
                                                onTap: () {
                                                  dataMeasurement.selectPattern(
                                                      patternList[index]['data']
                                                          [i],
                                                      patternList[index]
                                                          ['name']);

                                                  print(dataMeasurement
                                                      .bodyPattern);
                                                },
                                                child: ListTile(
                                                  leading: Image.network(
                                                      patternList[index]['data']
                                                              [i]['image']
                                                          .toString()),
                                                  title: Text(patternList[index]
                                                      ['data'][i]['name']),
                                                  trailing: Text(
                                                      patternList[index]['data']
                                                                  [i]['name'] ==
                                                              bodyPattern.values
                                                                      .toList()[
                                                                  index]['name']
                                                          ? '(Default)'
                                                          : ''),
                                                ),
                                              );
                                            },
                                            separatorBuilder: (context, index) {
                                              return Divider(
                                                thickness: 2,
                                              );
                                            },
                                            itemCount: patternList[index]
                                                    ['data']
                                                .length),
                                      ),
                              )
                            ],
                          );
                        })),
              ],
            );
          });
        });
  }

  // Don't know your size
  showDontKnowYourSize(BuildContext context) {
    int _current = 0;
    showDialog(
        context: context,
        builder: (context) {
          return Consumer<ShoppingPageProvider>(
            builder: (_, data, child) {
              List sizeList;
              if (data.isFemale) {
                sizeList = data.sizeMap.values.toList()[1];
              } else {
                sizeList = data.sizeMap.values.toList()[0];
              }
              return StatefulBuilder(builder: (context, stateful) {
                return AlertDialog(
                  content: sizeList.length == 1
                      ? Container(
                          height: 200,
                          child: Image.network(sizeList[0]['banner_url']),
                        )
                      : Container(
                          height: 200,
                          child: Stack(
                            children: [
                              Container(
                                height: 200,
                                child: CarouselSlider(
                                  options: CarouselOptions(
                                      onPageChanged: (index, reason) {
                                        stateful(() {
                                          _current = index;
                                        });
                                      },
                                      viewportFraction: 1.0,
                                      autoPlay: true,
                                      enlargeCenterPage: true),
                                  items:
                                      List.generate(sizeList.length, (index) {
                                    return CachedNetworkImage(
                                      imageUrl: sizeList[index]['banner_url'],
                                      placeholder: (context, url) => Image.asset(
                                          'assets/images/placeholder-image.png'),
                                      errorWidget: (context, url, error) =>
                                          Image.asset(
                                              'assets/images/placeholder-image.png'),
                                      fit: BoxFit.cover,
                                      height: 200,
                                      alignment: Alignment.topCenter,
                                    );
                                  }),
                                ),
                              ),
                              sizeList.length == 1
                                  ? Container()
                                  : Align(
                                      alignment: Alignment.bottomCenter,
                                      child: Container(
                                        margin: EdgeInsets.only(bottom: 20),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: sizeList
                                              .asMap()
                                              .entries
                                              .map((entry) {
                                            return GestureDetector(
                                              // onTap: () => _controller.animateToPage(entry.key),
                                              child: Container(
                                                width: 12.0,
                                                height: 12.0,
                                                margin: EdgeInsets.symmetric(
                                                    vertical: 8.0,
                                                    horizontal: 4.0),
                                                decoration: BoxDecoration(
                                                    shape: BoxShape.circle,
                                                    color: (Theme.of(context)
                                                                    .brightness ==
                                                                Brightness.dark
                                                            ? Colors.white
                                                            : Colors.black)
                                                        .withOpacity(_current ==
                                                                entry.key
                                                            ? 0.9
                                                            : 0.4)),
                                              ),
                                            );
                                          }).toList(),
                                        ),
                                      ),
                                    ),
                            ],
                          )),
                );
              });
            },
          );
        });
  }

  // What's the difference

  void theDifference(BuildContext context) {
    showDialog(
        context: context,
        builder: (context) {
          return Consumer<ShoppingPageProvider>(builder: (_, data, __) {
            return AlertDialog(
              content: Image.network(
                data.isFemale
                    ? data.differentList[1]['measurement_pic']
                    : data.differentList[0]['measurement_pic'],
                height: 200,
              ),
            );
          });
        });
  }
}
