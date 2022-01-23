// ignore_for_file: unused_import, prefer_const_constructors, unnecessary_new, prefer_const_literals_to_create_immutables, avoid_unnecessary_containers, camel_case_types

import 'package:flutter/material.dart';
import 'package:kaboom/core/models/post.dart';
import 'package:kaboom/services/web3.dart';

class second extends StatefulWidget {
  const second({Key? key}) : super(key: key);

  @override
  _secondState createState() => _secondState();
}

class _secondState extends State<second> {
  int _index = 0;
  List<Post> _created = [];
  List<Post> _sold = [];
  List<Post> _bought = [];
  var web3 = Web3Service();

  @override
  void initState() {
    super.initState();
    init();
  }

  void init() async {
    print("before");
    //_bought = await web3.getUserOwnedItems();
    print("after");
    _created = await web3.getMarketItems();
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        Container(
          height: 300,
          // width: 300,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(10),
                child: Text(
                  "NFTs Created",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                  ),
                  textAlign: TextAlign.left,
                ),
              ),
              Expanded(
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: _created.length,
                  itemBuilder: (context, index) => Padding(
                    padding: EdgeInsets.all(10),
                    child: SmallCard(
                      height: 200,
                      title: _created[index].img,
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
        Container(
          height: 300,
          // width: 300,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(10),
                child: Text(
                  "NFTs Bought",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                  ),
                  textAlign: TextAlign.left,
                ),
              ),
              Expanded(
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: _bought.length,
                  itemBuilder: (context, index) => Padding(
                    padding: EdgeInsets.all(10),
                    child: SmallCard(
                      height: 200,
                      title: _bought[index].img,
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ],
    );
  }
}

class SmallCard extends StatelessWidget {
  const SmallCard({Key? key, required this.height, this.title = "Forest"})
      : super(key: key);
  final double height;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: height,
      child: Card(
          clipBehavior: Clip.hardEdge,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(20))),
          color: Colors.blue,
          child: Image.network(
            "https://dweb.link/ipfs/$title",
            fit: BoxFit.cover,
          )),
    );
  }
}
