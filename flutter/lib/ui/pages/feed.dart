// ignore_for_file: unused_import, prefer_const_constructors, unnecessary_new, prefer_const_literals_to_create_immutables, avoid_unnecessary_containers, camel_case_types

import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:kaboom/core/models/post.dart';
import 'package:kaboom/services/web3.dart';
import 'package:web3dart/web3dart.dart';

var web3 = Web3Service();

class Feed extends StatefulWidget {
  const Feed({Key? key}) : super(key: key);

  @override
  _FeedState createState() => _FeedState();
}

class _FeedState extends State<Feed> {
  List<Post> _posts = [];

  Future<void> getFeed() async {
    _posts = await web3.getMarketItems();
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    getFeed();
  }

  // Future<> bytesToImage(Uint8List imgBytes) async {
  //   ui.Codec codec = await ui.instantiateImageCodec(imgBytes);
  //   ui.FrameInfo frame = await codec.getNextFrame();
  //   return frame.image.toByteData(format: Imag);
  // }

  Widget post({
    required String name,
    required String title,
    required String price,
    required String img,
    required BigInt itemId,
    required int index,
    // required bool like,
  }) {
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
                              title,
                              style: TextStyle(
                                fontSize: 17.0,
                                color: Color(0xFFFFFFFF),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          new Text(
                            name,
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
                    child: Image.network(
                      "https://dweb.link/ipfs/$img",
                      fit: BoxFit.fill,
                      loadingBuilder: (context, child, loadingProgress) {
                        if (loadingProgress?.cumulativeBytesLoaded ==
                            loadingProgress?.expectedTotalBytes) return child;
                        return CircularProgressIndicator();
                      },
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
                        new IconButton(
                          icon: Icon(Icons.favorite_border),
                          color: Color(0xFFFFFFFF),
                          onPressed: () {},
                        ),
                        ElevatedButton(
                          onPressed: () {
                            web3.buyNft(
                                itemId: itemId,
                                price: BigInt.from(int.parse(price)));
                            // Future.delayed(Duration(seconds: 3)).then((value) {
                            //   _posts.removeAt(index);
                            //   setState(() {});
                            // });
                          },
                          child: Text("Buy ${price}"),
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
      itemCount: _posts.length,
      itemBuilder: (context, index) => post(
        name: _posts[index].name,
        price: _posts[index].price,
        img: _posts[index].img,
        title: _posts[index].title,
        itemId: _posts[index].itemId,
        index: index,
      ),
    );
  }
}
