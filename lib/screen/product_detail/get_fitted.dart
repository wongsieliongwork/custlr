import 'package:custlr/model/measurementModel.dart';
import 'package:custlr/provider/Measurement.dart';
import 'package:custlr/provider/ShoppingPageProvider.dart';
import 'package:custlr/screen/get_fitted/A4_fit.dart';
import 'package:custlr/screen/get_fitted/body_measurement.dart';
import 'package:custlr/screen/get_fitted/standard_sizing.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';

class GetFitted extends StatefulWidget {
  GetFitted(this.onChanged);
  final Function(int) onChanged;
  @override
  _GetFittedState createState() => _GetFittedState();
}

class _GetFittedState extends State<GetFitted> {
  List fitList;

  void getFemale() {
    if (Provider.of<ShoppingPageProvider>(context, listen: false).isFemale) {
      fitList = [
        {
          'name': 'Body Measurement',
          'description': 'Lets do with a measuring tape',
          'image': 'assets/images/fit/Body_mesaurement_female.png',
        },
        {
          'name': 'Dress Measurement',
          'description': "Let's measure your dress for your fitting",
          'image': 'assets/images/fit/dressing_measuremet.png',
        },
        {
          'name': 'Standard Sizing',
          'description': 'Sizings you are familier with',
          'image': 'assets/images/fit/Standard Sizing.png',
        },
      ];
    } else {
      fitList = [
        {
          'name': 'Body Measurement',
          'description': 'Lets do with a measuring tape',
          'image': 'assets/images/fit/Body Measurement.jpg',
        },
        {
          'name': 'Standard Sizing',
          'description': 'Sizings you are familier with',
          'image': 'assets/images/fit/Standard Sizing.png',
        },
        {
          'name': 'A4 Fit',
          'description': 'Fitting using a A4 Sheet',
          'image': 'assets/images/fit/A4 Fit.jpg',
        },
      ];
    }
  }

// For Women
  MeasurementModel ownbodyMeasurement = MeasurementModel(
    height: '0.00',
    chest: '0.00',
    bicep: '0.00',
    shoulder: '0.00',
    waist: '0.00',
    armLength: '0.00',
    hip: '0.00',
    dressLength: '0.00',
  );

  @override
  void initState() {
    super.initState();
    getFemale();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final dataHome = Provider.of<ShoppingPageProvider>(context);
    return Container(
      child: Column(
        children: [
          Stack(
            children: [
              Container(
                padding: EdgeInsets.only(top: 7),
                child: SizedBox(
                  width: double.infinity,
                  child: Text(
                    'Lets Fit You',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {
                  widget.onChanged(0);
                },
                child: Icon(
                  Icons.keyboard_arrow_left,
                  size: 40,
                ),
              )
            ],
          ),
          // Divider(),
          Expanded(
            child: Column(
              children: List.generate(fitList.length, (index) {
                return Expanded(
                  child: GestureDetector(
                    onTap: () async {
                      Provider.of<Measurement>(context, listen: false).isA4Fit =
                          false;
                      if (fitList[index]['name'] == "Body Measurement") {
                        bool value = await Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    BodyMeasurement(data: ownbodyMeasurement)));

                        if (value == true) {
                          setState(() {
                            widget.onChanged(2);
                          });
                        }
                      } else if (fitList[index]['name'] == "Standard Sizing") {
                        bool value = await Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => StandardSizing()));

                        if (value == true) {
                          setState(() {
                            widget.onChanged(2);
                          });
                        }
                      } else if (fitList[index]['name'] == "A4 Fit") {
                        if (dataHome.isFemale) {
                          Fluttertoast.showToast(
                              msg: 'Not Available for Women');
                        } else {
                          bool value = await Navigator.push(context,
                              MaterialPageRoute(builder: (context) => A4Fit()));
                          if (value == true) {
                            setState(() {
                              widget.onChanged(2);
                            });
                          }
                        }
                      } else if (fitList[index]['name'] ==
                          "Dress Measurement") {
                        bool value = await Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => BodyMeasurement(
                                      data: ownbodyMeasurement,
                                      isDressingMeasurement: true,
                                    )));

                        if (value == true) {
                          setState(() {
                            widget.onChanged(2);
                          });
                        }
                      }
                    },
                    child: Container(
                      child: Stack(
                        fit: StackFit.expand,
                        children: [
                          Container(
                            padding: EdgeInsets.only(bottom: 10),
                            width: size.width,
                            color: Colors.white,
                            child: ColorFiltered(
                              colorFilter: ColorFilter.mode(
                                  Colors.black54, BlendMode.darken),
                              child: Image.asset(
                                fitList[index]['image'],
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          Align(
                            alignment: Alignment.bottomRight,
                            child: Container(
                              padding: EdgeInsets.only(top: 30, right: 30),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Text(
                                    fitList[index]['name'],
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20,
                                        color: Colors.white),
                                  ),
                                  Text(
                                    fitList[index]['description'],
                                    style: TextStyle(
                                        fontSize: 16, color: Colors.white),
                                  )
                                ],
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                );
              }),
            ),
          ),
        ],
      ),
    );
  }
}
