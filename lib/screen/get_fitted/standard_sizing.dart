import 'dart:developer';
import 'package:custlr/model/measurementModel.dart';
import 'package:custlr/provider/Measurement.dart';
import 'package:custlr/screen/get_fitted/body_measurement.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class StandardSizing extends StatefulWidget {
  @override
  _StandardSizingState createState() => _StandardSizingState();
}

class _StandardSizingState extends State<StandardSizing> {
  List sizeList = [
    {
      'name': 'Small (S)',
      'data': [
        {
          'name': 'Chest',
          'cm': 1,
        },
        {
          'name': 'Shoulder',
          'cm': 2,
        },
        {
          'name': 'Arm',
          'cm': 4,
        },
        {
          'name': 'Arm Length',
          'cm': 9,
        },
        {
          'name': 'Waist',
          'cm': 11,
        },
      ],
    },
    {
      'name': 'Medium (M)',
      'data': [
        {
          'name': 'Chest',
          'cm': 1,
        },
        {
          'name': 'Shoulder',
          'cm': 2,
        },
        {
          'name': 'Arm',
          'cm': 4,
        },
        {
          'name': 'Arm Length',
          'cm': 9,
        },
        {
          'name': 'Waist',
          'cm': 11,
        },
      ],
    },
    {
      'name': 'Large (L)',
      'data': [
        {
          'name': 'Chest',
          'cm': 1,
        },
        {
          'name': 'Shoulder',
          'cm': 2,
        },
        {
          'name': 'Arm',
          'cm': 4,
        },
        {
          'name': 'Arm Length',
          'cm': 9,
        },
        {
          'name': 'Waist',
          'cm': 11,
        },
      ],
    },
    {
      'name': 'Extra Large (XL)',
      'data': [
        {
          'name': 'Chest',
          'cm': 1,
        },
        {
          'name': 'Shoulder',
          'cm': 2,
        },
        {
          'name': 'Arm',
          'cm': 22,
        },
        {
          'name': 'Arm Length',
          'cm': 11,
        },
        {
          'name': 'Waist',
          'cm': 11,
        },
      ],
    },
  ];
  List converter = [
    {
      'Name': 'Chest',
      'cm': 1.00,
    },
    {
      'Name': 'Shoulder',
      'cm': 2.00,
    },
    {
      'Name': 'Arm',
      'cm': 1.00,
    },
    {
      'Name': 'Arm Length',
      'cm': 2.00,
    },
    {
      'Name': 'Waist',
      'cm': 3.00,
    },
  ];
  int value = 0;
  @override
  Widget build(BuildContext context) {
    final dataMeasure = Provider.of<Measurement>(context);
    final measureList = dataMeasure.productMeasurement;

    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.white,
          leading: GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: Icon(
              Icons.keyboard_arrow_left,
              size: 40,
              color: Colors.black,
            ),
          ),
          title: GestureDetector(
            onTap: () {
              log('$measureList');
            },
            child: Text(
              'Standard Sizing',
              style: TextStyle(color: Colors.black),
            ),
          ),
        ),
        body: measureList.isEmpty
            ? Container(
                child: Center(
                  child: Text('Not Available'),
                ),
              )
            : Column(
                children: [
                  ListView.separated(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              value = index;
                            });
                          },
                          child: ListTile(
                            leading: Radio(
                                value: index,
                                groupValue: value,
                                onChanged: (int i) {
                                  setState(() {
                                    value = i;
                                  });
                                }),
                            title: Text(measureList[index]['size']),
                          ),
                        );
                      },
                      separatorBuilder: (context, index) {
                        return Divider(
                          thickness: 3,
                        );
                      },
                      itemCount: measureList.length),
                  Spacer(),
                  GestureDetector(
                    onTap: () {
                      dataMeasure.isDressingMeasurement = false;
                      MeasurementModel measurementModel = MeasurementModel(
                          chest: measureList[value]['chest'],
                          shoulder: measureList[value]['shoulder'],
                          armLength: measureList[value]['arm_length'],
                          bicep: measureList[value]['bicep'],
                          waist: measureList[value]['waist'],
                          hip: measureList[value]['hip'] ?? "0.00",
                          dressLength:
                              measureList[value]['dress_length'] ?? "0.00",
                          height: (measureList[value]['height'] ?? 0.00)
                              .toString());
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => BodyMeasurement(
                                    data: measurementModel,
                                    isStandardSizing: true,
                                  )));
                    },
                    child: SizedBox(
                      width: double.infinity,
                      child: Container(
                        height: 60,
                        color: Colors.blue,
                        child: Center(
                          child: Text(
                            'Next Step >>',
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ));
  }
}
