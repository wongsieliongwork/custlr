import 'package:flutter/material.dart';

class AboutUs extends StatefulWidget {
  @override
  _AboutUsState createState() => _AboutUsState();
}

class _AboutUsState extends State<AboutUs> {
  List aboutList = [
    {
      'title': 'ABOUT US',
      'image': 'assets/images/AboutUs/pic1.jpg',
      'description':
          '''Start Wearing What Fits You. We all need a dress shirt or an outfit that makes us go around beaming with style and confidence.

At CUSTLR, we tailor-fit your shirt from the palm of your hand, using our app. Gone were the days of the traditional ready-size of S, M, L or XL size, where you have to spend countless hours in the fitting room, to search for something that doesn’t fit you.

Events? Weddings? Suiting? We bring the best of both worlds right to you with high quality material coupled with a highly affordable price. Any suit, any style, any location, any time. We make it as convenient as possible for you.

Our 100% Fit-Back guarantee ensures that the shirt will fit you perfectly so that you can wear what you love.

Our mission is to ensure that customised tailoring is brought to you technologically. Our goal is to ensure everyone in the 21st century dresses like a movie star. Dress to impress, gentlemen.''',
    },
    {
      'title': 'ALGORITHM',
      'image': 'assets/images/AboutUs/pic2.jpg',
      'description':
          '''CUSTLR brings you the coolness of measurement algorithms to ensure the perfect tailored-fit shirt measurement.

We offer 4 different measurement methods to ensure the perfect tailored-fit shirt measurement:

Body Measurement (inch/cm)
A4 Fit Algorithm – Take picture with an A4 paper in front of your body
Standard Sizing - S,M,L,XL
Shirt Size Estimator – Input your Height (cm) and Weight (kg)''',
    },
    {
      'title': '100% FIT BACK',
      'image': 'assets/images/AboutUs/pic3.jpg',
      'description':
          '''Our 100% Fit Back guarantee ensures that the shirt will fit you perfect. If it doesn’t fit you, we will remake your clothing till it fits you. No questions asked.''',
    },
    {
      'title': 'ECO FRIENDLY PRODUCT',
      'image': 'assets/images/AboutUs/pic4.jpg',
      'description':
          '''CUSTLR is not only personalised and stylish, we also do our part in environmental sustainability.

Our clothing material are eco-friendly with a soft, durable, and breathable touch. Our clothing material are also biodegradable, cutting down on landfill waste, and avoiding the need for use of harmful chemicals in the waste handling process.''',
    },
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: GestureDetector(
            onTap: () {
              Navigator.pop(context, true);
            },
            child: Icon(
              Icons.keyboard_arrow_left,
              size: 40,
            )),
        title: Text(
          'About Us',
          style: TextStyle(
              color: Colors.black, fontWeight: FontWeight.bold, fontSize: 16),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: List.generate(aboutList.length, (index) {
          return Expanded(
              child: GestureDetector(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => AboutDetail(aboutList[index])));
            },
            child: Stack(
              children: [
                SizedBox(
                  width: double.infinity,
                  child: Container(
                    padding: EdgeInsets.all(10),
                    child: ClipRRect(
                        borderRadius: BorderRadius.circular(30.0),
                        child: ColorFiltered(
                          colorFilter:
                              ColorFilter.mode(Colors.grey, BlendMode.modulate),
                          child: Hero(
                            tag: aboutList[index]['image'],
                            child: Image.asset(
                              aboutList[index]['image'],
                              fit: BoxFit.cover,
                            ),
                          ),
                        )),
                  ),
                ),
                Align(
                  alignment: Alignment.center,
                  child: Text(
                    aboutList[index]['title'],
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        fontSize: 20),
                  ),
                )
              ],
            ),
          ));
        }),
      ),
    );
  }
}

class AboutDetail extends StatefulWidget {
  final dynamic data;
  AboutDetail(this.data);
  @override
  _AboutDetailState createState() => _AboutDetailState();
}

class _AboutDetailState extends State<AboutDetail> {
  @override
  void initState() {
    super.initState();
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
                tag: widget.data['image'],
                child: Image.asset(
                  widget.data['image'],
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
                  Text(widget.data['description'])
                ],
              ),
            )
          ])),
        ],
      ),
    );
  }
}
