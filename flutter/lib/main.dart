import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:image_picker/image_picker.dart';
import 'package:kaboom/ui/pages/create_comic.dart';
import 'package:kaboom/ui/pages/feed.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  PageController _controller = PageController(initialPage: 0);
  int _index = 0;

  @override
  void initState() {
    super.initState();
    _controller.addListener(() {
      if (_index != _controller.page!.round()) {
        setState(() {
          _index = _controller.page!.round();
        });
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  AppBar _appbar(int index) {
    List<String> _pagetitles = ['Kaboom', 'New Comic', 'Profile'];
    return AppBar(
      title: Text(
        _pagetitles[index],
        style: TextStyle(color: Colors.amber),
      ),
      backgroundColor: Color(0xFF1D1E22),
      elevation: 0,
    );
  }

  Widget _bottomNavBar(int index) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Material(
        elevation: 5.0,
        borderRadius: BorderRadius.circular(10.0),
        color: Color(0xFF2B2D32),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              new Container(
                child: new IconButton(
                  icon: Icon(Icons.home),
                  color: Color(0xFFFBCD2F),
                  iconSize: (index == 0) ? 35 : 29.0,
                  onPressed: () {
                    _controller.animateToPage(0,
                        duration: Duration(milliseconds: 500),
                        curve: Curves.easeInOut);
                  },
                ),
              ),
              new Container(
                child: new IconButton(
                  icon: Icon(Icons.library_add),
                  color: Color(0xFFFBCD2F),
                  iconSize: (index == 1) ? 35 : 29.0,
                  onPressed: () {
                    _controller.animateToPage(1,
                        duration: Duration(milliseconds: 500),
                        curve: Curves.easeInOut);
                  },
                ),
              ),
              new Container(
                child: new IconButton(
                  icon: Icon(Icons.account_circle_rounded),
                  color: Color(0xFFFBCD2F),
                  iconSize: (index == 2) ? 35 : 29.0,
                  onPressed: () {
                    _controller.animateToPage(2,
                        duration: Duration(milliseconds: 500),
                        curve: Curves.easeInOut);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF1D1E22),
      appBar: _appbar(_index),
      body: PageView(
        controller: _controller,
        children: [
          Feed(),
          CreateComic(),
          Center(child: Text("prof")),
        ],
      ),
      bottomNavigationBar: _bottomNavBar(_index),
    );
  }
}
