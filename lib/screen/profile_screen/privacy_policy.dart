import 'package:custlr/utils/json_utils.dart';
import 'package:flutter/material.dart';

class PrivacyPolicy extends StatefulWidget {
  @override
  _PrivacyPolicyState createState() => _PrivacyPolicyState();
}

class _PrivacyPolicyState extends State<PrivacyPolicy>
    with SingleTickerProviderStateMixin {
  List toggled = [];
  List privaryList = CustlrJson.privacyList;

  @override
  void initState() {
    super.initState();
  }

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
          'Data & Privacy',
          style: TextStyle(
              color: Colors.black, fontWeight: FontWeight.bold, fontSize: 16),
        ),
      ),
      body: ListView.separated(
          separatorBuilder: (context, index) {
            return Divider(
              thickness: 2,
            );
          },
          itemCount: privaryList.length,
          itemBuilder: (context, index) {
            return Column(
              children: [
                GestureDetector(
                  onTap: () {
                    setState(() {
                      if (!toggled.contains(index)) {
                        toggled.add(index);
                      } else {
                        toggled.remove(index);
                      }
                    });
                  },
                  child: ListTile(
                    leading: Text('${index + 1}.'),
                    title: Text(
                      privaryList[index]['title'],
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    trailing: Icon(Icons.keyboard_arrow_down),
                  ),
                ),
                Visibility(
                  visible: toggled.contains(index),
                  child: Container(
                    padding: EdgeInsets.all(15),
                    child: Text(privaryList[index]['description']),
                  ),
                )
              ],
            );
          }),
    );
  }
}
