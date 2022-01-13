import 'package:custlr/provider/Measurement.dart';
import 'package:custlr/screen/product_detail/checkout.dart';
import 'package:custlr/screen/product_detail/get_fitted.dart';
import 'package:custlr/screen/product_detail/select_product.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:timelines/timelines.dart';
import 'dart:math';

class ProductDetail extends StatefulWidget {
  ProductDetail(this.data);
  final data;
  @override
  _ProductDetailState createState() => _ProductDetailState();
}

class _ProductDetailState extends State<ProductDetail> {
  // Process Stage
  int _processIndex = 0;
  List processList = ['Select Product', 'Get Fitted', 'Checkout'];

  void runProvider() {
    Provider.of<Measurement>(context, listen: false)
        .getProductElement(widget.data['ProductID']);
    Provider.of<Measurement>(context, listen: false).data = widget.data;
    Provider.of<Measurement>(context, listen: false).remarks = '';
    Provider.of<Measurement>(context, listen: false).bodyPattern.clear();
  }

  @override
  void initState() {
    super.initState();
    runProvider();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return WillPopScope(
      onWillPop: () async {
        if (_processIndex == 0) {
          Navigator.pop(context);
        } else if (_processIndex == 1) {
          setState(() {
            _processIndex = 0;
          });
        } else {
          setState(() {
            _processIndex = 1;
          });
        }
        return false;
      },
      child: Scaffold(
          body: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          SafeArea(
            bottom: false,
            child: Column(
              children: [
                Container(height: size.height / 12, child: processTimeLine()),
                SizedBox(
                  height: 10,
                ),
                Expanded(
                  child: body(),
                )
              ],
            ),
          ),
          // _processIndex != 0
          //     ? Container()
          //     : PhysicalModel(
          //         shadowColor: Colors.black,
          //         elevation: 20,
          //         color: Colors.white,
          //         child: Container(
          //           margin: EdgeInsets.all(10),
          //           height: 40,
          //           child: Row(
          //             children: [
          //               Expanded(
          //                 child: GestureDetector(
          //                   onTap: () {
          //                     setState(() {
          //                       _processIndex =
          //                           (_processIndex + 2) % _processes.length;
          //                     });
          //                   },
          //                   child: SizedBox(
          //                     height: double.infinity,
          //                     child: Container(
          //                       margin: EdgeInsets.symmetric(horizontal: 10),
          //                       decoration: BoxDecoration(
          //                         color: Colors.blue,
          //                         borderRadius: BorderRadius.circular(30),
          //                       ),
          //                       child: Center(
          //                           child: Text(
          //                         'One Click Checkout',
          //                         style: TextStyle(
          //                             color: Colors.white,
          //                             fontWeight: FontWeight.bold,
          //                             fontSize: 12),
          //                       )),
          //                     ),
          //                   ),
          //                 ),
          //               ),
          //               Expanded(
          //                 child: GestureDetector(
          //                   onTap: () {
          //                     setState(() {
          //                       _processIndex =
          //                           (_processIndex + 1) % _processes.length;
          //                     });
          //                   },
          //                   child: SizedBox(
          //                     height: double.infinity,
          //                     child: Container(
          //                       margin: EdgeInsets.symmetric(horizontal: 10),
          //                       decoration: BoxDecoration(
          //                         color: Colors.black,
          //                         borderRadius: BorderRadius.circular(30),
          //                       ),
          //                       child: Center(
          //                           child: Text(
          //                         'Get Fitted',
          //                         style: TextStyle(
          //                             color: Colors.white,
          //                             fontWeight: FontWeight.bold),
          //                       )),
          //                     ),
          //                   ),
          //                 ),
          //               )
          //             ],
          //           ),
          //         ),
          //       ),
        ],
      )
          // floatingActionButton: FloatingActionButton(
          //   child: Icon(Icons.next_plan),
          //   onPressed: () {
          //     setState(() {
          //       _processIndex = (_processIndex + 1) % _processes.length;
          //     });
          //   },
          //   backgroundColor: inProgressColor,
          // ),
          ),
    );
  }

  // Body
  Widget body() {
    if (_processIndex == 0) {
      return SelectProduct(widget.data, (int index) {
        setState(() {
          _processIndex = index;
        });
      });
    } else if (_processIndex == 1) {
      return GetFitted((int value) {
        setState(() {
          _processIndex = value;
        });
      });
    } else {
      return Checkout((value) {
        setState(() {
          _processIndex = value;
        });
      });
    }
  }

// Change Color
  Color getColor(int index) {
    if (index == _processIndex) {
      return inProgressColor;
    } else if (index < _processIndex) {
      return completeColor;
    } else {
      return todoColor;
    }
  }

// Process TimeLine
  Widget processTimeLine() {
    return Timeline.tileBuilder(
      theme: TimelineThemeData(
        direction: Axis.horizontal,
        connectorTheme: ConnectorThemeData(
          space: 30.0,
          thickness: 5.0,
        ),
      ),
      builder: TimelineTileBuilder.connected(
        connectionDirection: ConnectionDirection.before,
        itemExtentBuilder: (_, __) =>
            MediaQuery.of(context).size.width / _processes.length,
        // oppositeContentsBuilder: (context, index) {
        //   // return Padding(
        //   //   padding: const EdgeInsets.only(bottom: 5.0),
        //   //   child: Image.asset(
        //   //     'assets/images/process_timeline/status${index + 1}.png',
        //   //     width: 50.0,
        //   //     color: getColor(index),
        //   //   ),
        //   // );
        // },
        contentsBuilder: (context, index) {
          return Text(
            _processes[index],
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: getColor(index),
              fontSize: 12,
            ),
          );
        },
        indicatorBuilder: (_, index) {
          var color;
          var child;
          if (index == _processIndex) {
            color = inProgressColor;
            child = Padding(
              padding: const EdgeInsets.all(8.0),
              // child: CircularProgressIndicator(
              //   strokeWidth: 3.0,
              //   valueColor: AlwaysStoppedAnimation(Colors.white),
              // ),
              child: Icon(
                Icons.check,
                color: Colors.white,
                size: 15,
              ),
            );
          } else if (index < _processIndex) {
            color = completeColor;
            child = Icon(
              Icons.check,
              color: Colors.white,
              size: 15.0,
            );
          } else {
            color = todoColor;
          }

          if (index <= _processIndex) {
            return Stack(
              children: [
                CustomPaint(
                  size: Size(30.0, 30.0),
                  painter: _BezierPainter(
                    color: color,
                    drawStart: index > 0,
                    drawEnd: index < _processIndex,
                  ),
                ),
                DotIndicator(
                  size: 30.0,
                  color: color,
                  child: child,
                ),
              ],
            );
          } else {
            return Stack(
              children: [
                CustomPaint(
                  size: Size(15.0, 15.0),
                  painter: _BezierPainter(
                    color: color,
                    drawEnd: index < _processes.length - 1,
                  ),
                ),
                OutlinedDotIndicator(
                  borderWidth: 4.0,
                  color: color,
                ),
              ],
            );
          }
        },
        connectorBuilder: (_, index, type) {
          if (index > 0) {
            if (index == _processIndex) {
              final prevColor = getColor(index - 1);
              final color = getColor(index);
              List<Color> gradientColors;
              if (type == ConnectorType.start) {
                gradientColors = [Color.lerp(prevColor, color, 0.5), color];
              } else {
                gradientColors = [prevColor, Color.lerp(prevColor, color, 0.5)];
              }
              return DecoratedLineConnector(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: gradientColors,
                  ),
                ),
              );
            } else {
              return SolidLineConnector(
                color: getColor(index),
              );
            }
          } else {
            return null;
          }
        },
        itemCount: _processes.length,
      ),
    );
  }
}

// Process Time Line Templete
const kTileHeight = 50.0;
const completeColor = Color(0xff5e6172);
const inProgressColor = Color(0xff5ec792);
const todoColor = Color(0xffd1d2d7);

class _BezierPainter extends CustomPainter {
  const _BezierPainter({
    this.color,
    this.drawStart = true,
    this.drawEnd = true,
  });

  final Color color;
  final bool drawStart;
  final bool drawEnd;

  Offset _offset(double radius, double angle) {
    return Offset(
      radius * cos(angle) + radius,
      radius * sin(angle) + radius,
    );
  }

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..style = PaintingStyle.fill
      ..color = color;

    final radius = size.width / 2;

    var angle;
    var offset1;
    var offset2;

    var path;

    if (drawStart) {
      angle = 3 * pi / 4;
      offset1 = _offset(radius, angle);
      offset2 = _offset(radius, -angle);
      path = Path()
        ..moveTo(offset1.dx, offset1.dy)
        ..quadraticBezierTo(0.0, size.height / 2, -radius,
            radius) // TODO connector start & gradient
        ..quadraticBezierTo(0.0, size.height / 2, offset2.dx, offset2.dy)
        ..close();

      canvas.drawPath(path, paint);
    }
    if (drawEnd) {
      angle = -pi / 4;
      offset1 = _offset(radius, angle);
      offset2 = _offset(radius, -angle);

      path = Path()
        ..moveTo(offset1.dx, offset1.dy)
        ..quadraticBezierTo(size.width, size.height / 2, size.width + radius,
            radius) // TODO connector end & gradient
        ..quadraticBezierTo(size.width, size.height / 2, offset2.dx, offset2.dy)
        ..close();

      canvas.drawPath(path, paint);
    }
  }

  @override
  bool shouldRepaint(_BezierPainter oldDelegate) {
    return oldDelegate.color != color ||
        oldDelegate.drawStart != drawStart ||
        oldDelegate.drawEnd != drawEnd;
  }
}

final _processes = [
  'Select Product',
  'Get Fitted',
  'Checkout',
];

/*
import 'package:carousel_slider/carousel_slider.dart';
import 'package:custlr/api/api.dart';
import 'package:custlr/constants.dart';
import 'package:custlr/provider/Measurement.dart';
import 'package:custlr/screen/product_detail/checkout.dart';
import 'package:custlr/screen/product_detail/get_fitted.dart';
import 'package:custlr/screen/product_detail/select_product.dart';
import 'package:flutter/material.dart';
import 'package:flutter_countdown_timer/index.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:provider/provider.dart';
import 'package:timelines/timelines.dart';
import 'dart:developer';
import 'dart:math';

class ProductDetail extends StatefulWidget {
  ProductDetail(this.data);
  final data;
  @override
  _ProductDetailState createState() => _ProductDetailState();
}

class _ProductDetailState extends State<ProductDetail> {
  // Process Stage
  int _processIndex = 0;
  List processList = ['Select Product', 'Get Fitted', 'Checkout'];

  @override
  void initState() {
    super.initState();

    Provider.of<Measurement>(context, listen: false).data = widget.data;
    Provider.of<Measurement>(context, listen: false).remarks = '';
    Provider.of<Measurement>(context, listen: false).bodyPattern.clear();
    Provider.of<Measurement>(context, listen: false)
        .getProductElement(widget.data['ProductID']);
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
        body: Stack(
      alignment: Alignment.bottomCenter,
      children: [
        SafeArea(
          bottom: false,
          child: Column(
            children: [
              Container(height: size.height / 8, child: processTimeLine()),
              Expanded(
                child: body(),
              )
            ],
          ),
        ),
        _processIndex != 0
            ? Container()
            : Container(
                height: 70,
                child: Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            _processIndex =
                                (_processIndex + 2) % _processes.length;
                          });
                        },
                        child: SizedBox(
                          height: double.infinity,
                          child: Container(
                            color: Colors.blue,
                            child: Center(
                              child: Text(
                                  'One Click Checkout >> \n (User saved body measurements and default styling)',
                                  style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold),
                                  textAlign: TextAlign.center),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            _processIndex =
                                (_processIndex + 1) % _processes.length;
                          });
                        },
                        child: SizedBox(
                          height: double.infinity,
                          child: Container(
                            color: Colors.black,
                            child: Center(
                              child: Text('Get Fitted >',
                                  style: TextStyle(
                                      fontSize: 18,
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold),
                                  textAlign: TextAlign.center),
                            ),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
      ],
    )
        // floatingActionButton: FloatingActionButton(
        //   child: Icon(Icons.next_plan),
        //   onPressed: () {
        //     setState(() {
        //       _processIndex = (_processIndex + 1) % _processes.length;
        //     });
        //   },
        //   backgroundColor: inProgressColor,
        // ),
        );
  }

  // Body
  Widget body() {
    if (_processIndex == 0) {
      return SelectProduct(widget.data);
    } else if (_processIndex == 1) {
      return GetFitted((int value) {
        setState(() {
          _processIndex = value;
        });
      });
    } else {
      return Checkout((value) {
        setState(() {
          _processIndex = value;
        });
      });
    }
  }

// Change Color
  Color getColor(int index) {
    if (index == _processIndex) {
      return inProgressColor;
    } else if (index < _processIndex) {
      return completeColor;
    } else {
      return todoColor;
    }
  }

// Process TimeLine
  Widget processTimeLine() {
    return Timeline.tileBuilder(
      theme: TimelineThemeData(
        direction: Axis.horizontal,
        connectorTheme: ConnectorThemeData(
          space: 30.0,
          thickness: 5.0,
        ),
      ),
      builder: TimelineTileBuilder.connected(
        connectionDirection: ConnectionDirection.before,
        itemExtentBuilder: (_, __) =>
            MediaQuery.of(context).size.width / _processes.length,
        oppositeContentsBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 5.0),
            child: Image.asset(
              'assets/images/process_timeline/status${index + 1}.png',
              width: 50.0,
              color: getColor(index),
            ),
          );
        },
        contentsBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.only(top: 5.0),
            child: Text(
              _processes[index],
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: getColor(index),
              ),
            ),
          );
        },
        indicatorBuilder: (_, index) {
          var color;
          var child;
          if (index == _processIndex) {
            color = inProgressColor;
            child = Padding(
              padding: const EdgeInsets.all(8.0),
              child: CircularProgressIndicator(
                strokeWidth: 3.0,
                valueColor: AlwaysStoppedAnimation(Colors.white),
              ),
            );
          } else if (index < _processIndex) {
            color = completeColor;
            child = Icon(
              Icons.check,
              color: Colors.white,
              size: 15.0,
            );
          } else {
            color = todoColor;
          }

          if (index <= _processIndex) {
            return Stack(
              children: [
                CustomPaint(
                  size: Size(30.0, 30.0),
                  painter: _BezierPainter(
                    color: color,
                    drawStart: index > 0,
                    drawEnd: index < _processIndex,
                  ),
                ),
                DotIndicator(
                  size: 30.0,
                  color: color,
                  child: child,
                ),
              ],
            );
          } else {
            return Stack(
              children: [
                CustomPaint(
                  size: Size(15.0, 15.0),
                  painter: _BezierPainter(
                    color: color,
                    drawEnd: index < _processes.length - 1,
                  ),
                ),
                OutlinedDotIndicator(
                  borderWidth: 4.0,
                  color: color,
                ),
              ],
            );
          }
        },
        connectorBuilder: (_, index, type) {
          if (index > 0) {
            if (index == _processIndex) {
              final prevColor = getColor(index - 1);
              final color = getColor(index);
              List<Color> gradientColors;
              if (type == ConnectorType.start) {
                gradientColors = [Color.lerp(prevColor, color, 0.5), color];
              } else {
                gradientColors = [prevColor, Color.lerp(prevColor, color, 0.5)];
              }
              return DecoratedLineConnector(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: gradientColors,
                  ),
                ),
              );
            } else {
              return SolidLineConnector(
                color: getColor(index),
              );
            }
          } else {
            return null;
          }
        },
        itemCount: _processes.length,
      ),
    );
  }
}

// Process Time Line Templete
const kTileHeight = 50.0;
const completeColor = Color(0xff5e6172);
const inProgressColor = Color(0xff5ec792);
const todoColor = Color(0xffd1d2d7);

class _BezierPainter extends CustomPainter {
  const _BezierPainter({
    this.color,
    this.drawStart = true,
    this.drawEnd = true,
  });

  final Color color;
  final bool drawStart;
  final bool drawEnd;

  Offset _offset(double radius, double angle) {
    return Offset(
      radius * cos(angle) + radius,
      radius * sin(angle) + radius,
    );
  }

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..style = PaintingStyle.fill
      ..color = color;

    final radius = size.width / 2;

    var angle;
    var offset1;
    var offset2;

    var path;

    if (drawStart) {
      angle = 3 * pi / 4;
      offset1 = _offset(radius, angle);
      offset2 = _offset(radius, -angle);
      path = Path()
        ..moveTo(offset1.dx, offset1.dy)
        ..quadraticBezierTo(0.0, size.height / 2, -radius,
            radius) // TODO connector start & gradient
        ..quadraticBezierTo(0.0, size.height / 2, offset2.dx, offset2.dy)
        ..close();

      canvas.drawPath(path, paint);
    }
    if (drawEnd) {
      angle = -pi / 4;
      offset1 = _offset(radius, angle);
      offset2 = _offset(radius, -angle);

      path = Path()
        ..moveTo(offset1.dx, offset1.dy)
        ..quadraticBezierTo(size.width, size.height / 2, size.width + radius,
            radius) // TODO connector end & gradient
        ..quadraticBezierTo(size.width, size.height / 2, offset2.dx, offset2.dy)
        ..close();

      canvas.drawPath(path, paint);
    }
  }

  @override
  bool shouldRepaint(_BezierPainter oldDelegate) {
    return oldDelegate.color != color ||
        oldDelegate.drawStart != drawStart ||
        oldDelegate.drawEnd != drawEnd;
  }
}

final _processes = [
  'Select Product',
  'Get Fitted',
  'Checkout',
];
*/
