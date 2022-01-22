// ignore_for_file: unused_import, prefer_const_constructors, unnecessary_new, prefer_const_literals_to_create_immutables, avoid_unnecessary_containers, camel_case_types

import 'package:flutter/material.dart';
import 'package:kaboom/services/web3.dart';

var web3 = Web3Service();

class Feed extends StatefulWidget {
  const Feed({Key? key}) : super(key: key);

  @override
  _FeedState createState() => _FeedState();
}

class _FeedState extends State<Feed> {
  Future<List> getFeed() async {
    List items = await web3.getMarketItems();
    print(items);
    return items;
  }

  Widget post({required String name , required String ) {
    return Container(
      margin: EdgeInsets.only(top: 10.0, left: 20.0, right: 20.0),
      child: Column(
        children: <Widget>[
          new Card(
            color: Color(0xFF2B2D32),
            child: new Container(
              padding: EdgeInsets.only(
                  top: 20.0, bottom: 0.0, left: 20.0, right: 20.0),
              child: new Column(
                children: <Widget>[
                  new Row(
                    children: <Widget>[
                      new Container(
                        margin: EdgeInsets.only(right: 10.0),
                        child: new CircleAvatar(
                          backgroundImage: AssetImage('assets/profile.jpg'),
                          radius: 30.0,
                        ),
                      ),
                      new Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.only(bottom: 5.0),
                            child: new Text(
                              "Suryakant is a student ",
                              style: TextStyle(
                                fontSize: 17.0,
                                color: Color(0xFFFFFFFF),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          new Text(
                            "Suryakant",
                            style: TextStyle(
                              fontSize: 14.0,
                              color: Colors.white70,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  Card(
                    semanticContainer: true,
                    clipBehavior: Clip.antiAliasWithSaveLayer,
                    child: Image.asset(
                      'assets/profile.jpg',
                      fit: BoxFit.fill,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    elevation: 5,
                    margin: EdgeInsets.only(top: 10.0),
                  ),
                  // add heart , comment and cart icon button
                  Padding(
                    padding: const EdgeInsets.all(5),
                    child: new Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Row(
                          children: [
                            new IconButton(
                              icon: Icon(Icons.favorite_border),
                              color: Color(0xFFFFFFFF),
                              onPressed: () {},
                            ),
                            new IconButton(
                              icon: Icon(Icons.comment),
                              color: Color(0xFFFFFFFF),
                              onPressed: () {},
                            ),
                          ],
                        ),
                        ElevatedButton(
                          onPressed: () {
                            getFeed();
                          },
                          child: Text("Buy"),
                          style: ButtonStyle(
                              backgroundColor:
                                  MaterialStateProperty.all(Colors.amber)),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemBuilder: (context, index) => post(),
    );
  }
}
