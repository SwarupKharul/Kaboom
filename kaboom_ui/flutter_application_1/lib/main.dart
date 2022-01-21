// ignore_for_file: camel_case_types, unnecessary_new, prefer_const_constructors
/*
import 'package:flutter/material.dart';

void main() {
  runApp(const MaterialApp(
    home: landing()
  ));
}

class landing extends StatefulWidget {
  const landing({ Key? key }) : super(key: key);

  @override
  _landingState createState() => _landingState();
}

class _landingState extends State<landing> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: new Stack(
        children: <Widget> [
          new Container(
            decoration: new BoxDecoration(
              image: new DecorationImage(
                image: new AssetImage("assets/back.jpg"),
                fit: BoxFit.cover,
              ),
            ),
          ),
          new Container(
            decoration: new BoxDecoration(
              color: Colors.black.withOpacity(0.7),
            ),
          ),
          //button at bottom with full width
          new Container(
            margin: const EdgeInsets.only(top: 600.0),
            child: new Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                new RaisedButton(
                  padding: const EdgeInsets.fromLTRB(100.0, 20.0, 100.0, 20.0),
                  onPressed: () {
                    // dummy text
                  },
                  child: new Text(
                    "Sign in with Google",
                    style: new TextStyle(
                      color: Colors.white,
                      fontSize: 20.0,
                    ),
                  ),
                  color: Color(0xFFFBCD2F),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                ),
              ],
            ),
          ),
          // insert an image inside container
          new Container(
            margin: const EdgeInsets.only(top: 80.0, left: 90.0),
            child: new Image(
              image: new AssetImage("assets/kab.png"),
              width: 250.0,
              height: 300.0,
            ),
          ),
        ]
      ),
    );
  }
}
*/