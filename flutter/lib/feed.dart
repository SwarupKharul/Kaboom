// ignore_for_file: unused_import, prefer_const_constructors, unnecessary_new, prefer_const_literals_to_create_immutables, avoid_unnecessary_containers, camel_case_types

import 'package:flutter/material.dart';

void main() {
  runApp(const MaterialApp(
    home: Feed()
  ));
}

class Feed extends StatefulWidget {
  const Feed({ Key? key }) : super(key: key);

  @override
  _FeedState createState() => _FeedState();
}

class _FeedState extends State<Feed> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
       backgroundColor: Color(0xFF1D1E22),
      body: new Stack(
        children: <Widget> [
          new Container(
            margin: EdgeInsets.only(top: 50.0, left: 20.0, right: 20.0),
            child: new Text(
              "Kaboom",
              style: TextStyle(
                fontSize: 24.0,
                color: Color(0xFFFBCD2F),
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          
          new Container(
          //card with profile picture,name and bio
            margin: EdgeInsets.only(top: 100.0, left: 20.0, right: 20.0),
            child: new Card(
              color: Color(0xFF1D1E22),
              child: new Container(
                padding: EdgeInsets.all(20.0),
                child: new Column(
                  children: <Widget>[
                    new Row(
                      children: <Widget>[
                        new Container(
                          margin: EdgeInsets.only(right: 20.0),
                          child: new CircleAvatar(
                            backgroundImage: AssetImage('assets/profile.jpg'),
                            radius: 30.0,
                          ),
                        ),
                        new Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            new Text(
                              "Suryakant",
                              style: TextStyle(
                                fontSize: 18.0,
                                color: Color(0xFFFBCD2F),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            new Text(
                              "KAboom",
                              style: TextStyle(
                                fontSize: 14.0,
                                color: Color(0xFFFBCD2F),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ), 
            ),      
          ), 
        ],
      )
    );
  }
}