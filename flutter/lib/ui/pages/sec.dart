// ignore_for_file: unused_import, prefer_const_constructors, unnecessary_new, prefer_const_literals_to_create_immutables, avoid_unnecessary_containers, camel_case_types

import 'package:flutter/material.dart';

void main() {
  runApp(const MaterialApp(home: second()));
}

class second extends StatefulWidget {
  const second({Key? key}) : super(key: key);

  @override
  _secondState createState() => _secondState();
}

class _secondState extends State<second> {
  int _index = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color(0xFF1D1E22),
        body: new Stack(
          children: <Widget>[
            // insert row with textbox and power icon
            new Row(
              children: <Widget>[
                new Container(
                  margin: EdgeInsets.only(left: 20.0, top: 50.0),
                  child: new Text(
                    'Profile',
                    style: TextStyle(
                      fontSize: 24.0,
                      color: Color(0xFFFBCD2F),
                    ),
                  ),
                ),
                new Container(
                  margin: EdgeInsets.only(left: 240.0, top: 50.0),
                  child: new IconButton(
                    icon: Icon(Icons.power_settings_new),
                    color: Color(0xFFFBCD2F),
                    iconSize: 29.0,
                    onPressed: () {
                      // dummy text
                    },
                  ),
                ),
              ],
            ),

            new Column(
              children: <Widget>[
                new Container(
                  margin: EdgeInsets.only(left: 170.0, top: 60.0),
                  child: new CircleAvatar(
                    backgroundImage: AssetImage('assets/profile.jpg'),
                    radius: 50.0,
                  ),
                ),
                new Container(
                  margin: EdgeInsets.only(left: 170.0, top: 10.0),
                  child: new Text(
                    'Suryakant',
                    style: TextStyle(
                      fontSize: 17.0,
                      color: Color(0xFFFFFFFF),
                    ),
                  ),
                ),
              ],
            ),

            Container(
              margin: EdgeInsets.only(left: 5.0, top: 220.0),
              child: Column(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: Text(
                      "Comics",
                      style:
                          TextStyle(fontSize: 20.0, color: Color(0xFFFBCD2F)),
                    ),
                  ),
                  SizedBox(
                    height: 150, // card height
                    child: PageView.builder(
                      itemCount: 10,
                      controller: PageController(viewportFraction: 0.7),
                      onPageChanged: (int index) =>
                          setState(() => _index = index),
                      itemBuilder: (_, i) {
                        return Transform.scale(
                          scale: i == _index ? 1 : 0.9,
                          child: Card(
                            elevation: 6,
                            color: Color(0xFF2B2D32),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20)),
                            child: Center(
                              child: Text(
                                "Card ${i + 1}",
                                style: TextStyle(fontSize: 32),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.only(left: 5.0, top: 400.0),
              child: Column(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: Text(
                      "NFT's",
                      style:
                          TextStyle(fontSize: 20.0, color: Color(0xFFFBCD2F)),
                    ),
                  ),
                  SizedBox(
                    height: 150, // card height
                    child: PageView.builder(
                      itemCount: 10,
                      controller: PageController(viewportFraction: 0.7),
                      onPageChanged: (int index) =>
                          setState(() => _index = index),
                      itemBuilder: (_, i) {
                        return Transform.scale(
                          scale: i == _index ? 1 : 0.9,
                          child: Card(
                            elevation: 6,
                            color: Color(0xFF2B2D32),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20)),
                            child: Center(
                              child: Text(
                                "Card ${i + 1}",
                                style: TextStyle(fontSize: 32),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ));
  }
}
