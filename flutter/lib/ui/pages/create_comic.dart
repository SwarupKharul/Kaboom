import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:image_picker/image_picker.dart';
import 'package:kaboom/core/services/imageService.dart';
import 'package:kaboom/services/web3.dart';
import 'package:kaboom/ipfs/ipfs.wrapper.dart';

class CreateComic extends StatefulWidget {
  const CreateComic({Key? key, required this.func}) : super(key: key);
  final func;

  @override
  State<CreateComic> createState() => _CreateComicState();
}

class _CreateComicState extends State<CreateComic> {
  List<String> _imagepaths = [" ", " ", " ", " "];
  List<String> _dialogues = [" ", " ", " ", " "];
  int _dialogueCounter = 0;
  TextEditingController _controller = TextEditingController();
  TextEditingController _namecontroller = TextEditingController();
  TextEditingController _titlecontroller = TextEditingController();
  TextEditingController _pricecontroller = TextEditingController();
  bool _busy = false;

  ImageService _image = ImageService();

  ImagePicker _picker = ImagePicker();

  GlobalKey _globalKey = new GlobalKey();

  var web3 = Web3Service();
  var ipfs = IPFS();

  Future<void> addImage(int index) async {
    setState(() {
      _busy = true;
    });
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      String path = await _image.cartoonify_image(File(image.path));
      _imagepaths[index] = path;
    }
    setState(() {
      _busy = false;
    });
  }

  Future<Uint8List> _capturePng() async {
    try {
      print('inside');
      RenderRepaintBoundary boundary = _globalKey.currentContext!
          .findRenderObject() as RenderRepaintBoundary;
      ui.Image image = await boundary.toImage(pixelRatio: 3.0);
      ByteData? byteData =
          await image.toByteData(format: ui.ImageByteFormat.png);
      var pngBytes = byteData!.buffer.asUint8List();
      var bs64 = base64Encode(pngBytes);
      // print(pngBytes);
      // print(bs64);
      setState(() {});
      return pngBytes;
    } catch (e) {
      print(e);
    }
    throw Exception("Error saving file");
  }

  BigInt? tokenId;
  BigInt? getTokenId() {
    return tokenId;
  }

  // fetch all items by fetchMyNFTs
  Future<String?> createMarketItem(
      {required double price, required String ipfsHash}) async {
        
    final nftToken = await web3.createToken(tokenURI: ipfsHash);
    web3.nft.transferEvents().toString();
    getTokenId();
    print("tokenId: $tokenId");
    final marketItem = await web3.createMarketItem(
        tokenId: tokenId!, price: BigInt.from(price));

    print('createMarketItem $marketItem');
    return marketItem;
  }

  @override
  void initState() {
    super.initState();
    web3.nft.transferEvents().listen((event) {
      setState(() {
        tokenId = event.tokenId;
      });
    });
  }

  void _publish() {
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return Container(
            height: MediaQuery.of(context).size.height,
            color: Color(0xFF2B2D32),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextField(
                        controller: _namecontroller,
                        decoration: InputDecoration(
                            labelText: "Creator's Name",
                            labelStyle: TextStyle(color: Colors.white)),
                        style: TextStyle(color: Colors.white),
                      )),
                  Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextField(
                        controller: _titlecontroller,
                        decoration: InputDecoration(
                            labelText: "Comic Title",
                            labelStyle: TextStyle(color: Colors.white)),
                        style: TextStyle(color: Colors.white),
                      )),
                  Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextField(
                        controller: _pricecontroller,
                        decoration: InputDecoration(
                            labelText: "Price",
                            labelStyle: TextStyle(color: Colors.white)),
                        style: TextStyle(color: Colors.white),
                      )),
                  ElevatedButton(
                      onPressed: () async {
                        var bytes = await _capturePng();
                        var res = await ipfs.addData(
                          bytes,
                          int.parse(_pricecontroller.text),
                          _titlecontroller.text,
                          _namecontroller.text,
                        );
                        // print(res);
                        createMarketItem(
                            price: double.parse(
                              _pricecontroller.text,
                            ),
                            ipfsHash: res['Hash']);

                        // ipfs.add(
                        //     bytes,
                        //     _namecontroller.text,
                        //     int.parse(_pricecontroller.text),
                        //     _titlecontroller.text);

                        Navigator.of(context).pop();
                      },
                      style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all(Colors.amber)),
                      child: Text(
                        "Done",
                        style: TextStyle(color: Colors.white),
                      ))
                ],
              ),
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: Padding(
            padding: EdgeInsets.all(20),
            child: RepaintBoundary(
              key: _globalKey,
              child: Card(
                clipBehavior: Clip.hardEdge,
                color: Color(0xFF2B2D32),
                child: SizedBox(
                    width: double.infinity,
                    // height: 600,
                    child: LayoutBuilder(builder: (context, constraints) {
                      return CustomPaint(
                        painter: myPainter(),
                        child: Stack(
                          children: [
                            Positioned(
                                top: 0,
                                left: 0,
                                child: ClipPath(
                                  clipper: firstImageClipper(
                                      height: constraints.maxHeight,
                                      width: constraints.maxWidth),
                                  child: (_imagepaths[0] == " ")
                                      ? Container()
                                      : Stack(
                                          children: [
                                            Image.network(
                                              _imagepaths[0],
                                              // color: Colors.amber,
                                              fit: BoxFit.cover,
                                              height:
                                                  constraints.maxHeight * 0.6,
                                              width: constraints.maxWidth * 0.6,
                                            ),
                                            if (_dialogues[0] != " ")
                                              Positioned(
                                                  top: 0,
                                                  child: Card(
                                                    shape:
                                                        RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .all(
                                                              Radius.circular(
                                                                  10),
                                                            ),
                                                            side: BorderSide(
                                                                width: 5)),
                                                    child: Container(
                                                      //height: 100,
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                    .symmetric(
                                                                vertical: 10,
                                                                horizontal: 15),
                                                        child:
                                                            Text(_dialogues[0]),
                                                      ),
                                                      width:
                                                          constraints.maxWidth *
                                                              0.4,
                                                    ),
                                                  ))
                                          ],
                                        ),
                                )),
                            Positioned(
                                top: 0,
                                left: 0.4 * constraints.maxWidth,
                                child: ClipPath(
                                  clipper: secondImageClipper(
                                      height: constraints.maxHeight,
                                      width: constraints.maxWidth),
                                  child: (_imagepaths[1] == " ")
                                      ? Container()
                                      : Stack(
                                          children: [
                                            Image.network(
                                              _imagepaths[1],
                                              fit: BoxFit.cover,
                                              height:
                                                  constraints.maxHeight * 0.48,
                                              width: constraints.maxWidth * 0.6,
                                            ),
                                            if (_dialogues[1] != " ")
                                              Positioned(
                                                  bottom: 50,
                                                  right: 0,
                                                  child: Card(
                                                    shape:
                                                        RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .all(
                                                              Radius.circular(
                                                                  10),
                                                            ),
                                                            side: BorderSide(
                                                                width: 5)),
                                                    child: Container(
                                                      //height: 100,
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                    .symmetric(
                                                                vertical: 10,
                                                                horizontal: 15),
                                                        child:
                                                            Text(_dialogues[1]),
                                                      ),
                                                      width:
                                                          constraints.maxWidth *
                                                              0.4,
                                                    ),
                                                  ))
                                          ],
                                        ),
                                )),
                            Positioned(
                                top: 0.51 * constraints.maxHeight,
                                left: 0,
                                child: ClipPath(
                                  clipper: thirdImageClipper(
                                      height: constraints.maxHeight,
                                      width: constraints.maxWidth),
                                  child: (_imagepaths[2] == " ")
                                      ? Container()
                                      : Stack(
                                          children: [
                                            Image.network(
                                              _imagepaths[2],
                                              fit: BoxFit.cover,
                                              height:
                                                  constraints.maxHeight * 0.49,
                                              width:
                                                  constraints.maxWidth * 0.45,
                                            ),
                                            if (_dialogues[2] != " ")
                                              Positioned(
                                                  top: 30,
                                                  right: 0,
                                                  child: Card(
                                                    shape:
                                                        RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .all(
                                                              Radius.circular(
                                                                  10),
                                                            ),
                                                            side: BorderSide(
                                                                width: 5)),
                                                    child: Container(
                                                      //height: 100,
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                    .symmetric(
                                                                vertical: 10,
                                                                horizontal: 15),
                                                        child:
                                                            Text(_dialogues[2]),
                                                      ),
                                                      width:
                                                          constraints.maxWidth *
                                                              0.3,
                                                    ),
                                                  ))
                                          ],
                                        ),
                                )),
                            Positioned(
                                top: 0.4 * constraints.maxHeight,
                                left: 0.35 * constraints.maxWidth,
                                child: ClipPath(
                                  clipper: fourthImageClipper(
                                      height: constraints.maxHeight,
                                      width: constraints.maxWidth),
                                  child: (_imagepaths[3] == " ")
                                      ? Container()
                                      : Stack(
                                          children: [
                                            Image.network(
                                              _imagepaths[3],
                                              fit: BoxFit.cover,
                                              height:
                                                  constraints.maxHeight * 0.6,
                                              width:
                                                  constraints.maxWidth * 0.65,
                                            ),
                                            if (_dialogues[3] != " ")
                                              Positioned(
                                                  bottom: 0,
                                                  child: Card(
                                                    shape:
                                                        RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .all(
                                                              Radius.circular(
                                                                  10),
                                                            ),
                                                            side: BorderSide(
                                                                width: 5)),
                                                    child: Container(
                                                      //height: 100,
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                    .symmetric(
                                                                vertical: 10,
                                                                horizontal: 15),
                                                        child:
                                                            Text(_dialogues[3]),
                                                      ),
                                                      width:
                                                          constraints.maxWidth *
                                                              0.65,
                                                    ),
                                                  ))
                                          ],
                                        ),
                                )),
                            if (_imagepaths[0] == " ")
                              Positioned(
                                  top: constraints.maxHeight * 0.25,
                                  left: constraints.maxWidth * 0.25,
                                  child: IconButton(
                                    icon: Icon(Icons.add_circle,
                                        color: Colors.amber),
                                    onPressed: () async {
                                      await addImage(0);
                                      setState(() {});
                                    },
                                  )),
                            if (_imagepaths[1] == " ")
                              Positioned(
                                  top: constraints.maxHeight * 0.20,
                                  left: constraints.maxWidth * 0.70,
                                  child: IconButton(
                                    icon: Icon(Icons.add_circle,
                                        color: Colors.amber),
                                    onPressed: () async {
                                      await addImage(1);
                                      setState(() {});
                                    },
                                  )),
                            if (_imagepaths[2] == " ")
                              Positioned(
                                  top: constraints.maxHeight * 0.75,
                                  left: constraints.maxWidth * 0.15,
                                  child: IconButton(
                                    icon: Icon(Icons.add_circle,
                                        color: Colors.amber),
                                    onPressed: () async {
                                      await addImage(2);
                                      setState(() {});
                                    },
                                  )),
                            if (_imagepaths[3] == " ")
                              Positioned(
                                  top: constraints.maxHeight * 0.70,
                                  left: constraints.maxWidth * 0.65,
                                  child: IconButton(
                                    icon: Icon(Icons.add_circle,
                                        color: Colors.amber),
                                    onPressed: () async {
                                      await addImage(3);
                                      setState(() {});
                                    },
                                  )),
                            if (_busy == true)
                              Positioned(
                                  top: constraints.maxHeight / 2,
                                  left: constraints.maxWidth / 2,
                                  child: CircularProgressIndicator(
                                    color: Colors.amber,
                                  ))
                          ],
                        ),
                      );
                    })),
              ),
            ),
          ),
        ),
        Padding(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
            child: Card(
              color: Color(0xFF2B2D32),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      children: [
                        IconButton(
                            onPressed: () {
                              widget.func();
                            },
                            icon: Icon(
                              Icons.layers,
                              color: Colors.white,
                            )),
                        Text(
                          "Layout",
                          style: TextStyle(color: Colors.white),
                        ),
                      ],
                    ),
                    Column(
                      children: [
                        IconButton(
                            onPressed: () {
                              showModalBottomSheet(
                                context: context,
                                builder: (context) {
                                  return Container(
                                    height: 500,
                                    color: Color(0xFF2B2D32),
                                    child: Padding(
                                      padding: const EdgeInsets.all(20),
                                      child: Column(
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Text("Enter Text",
                                                style: TextStyle(
                                                    color: Colors.white)),
                                          ),
                                          TextField(
                                            controller: _controller,
                                            style:
                                                TextStyle(color: Colors.white),
                                          ),
                                          Align(
                                            alignment: Alignment.centerRight,
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: ElevatedButton(
                                                  onPressed: () {
                                                    _dialogues[
                                                            _dialogueCounter] =
                                                        _controller.text;
                                                    _controller.text = "";
                                                    _dialogueCounter += 1;
                                                    _dialogueCounter %= 4;
                                                    setState(() {});
                                                    Navigator.of(context).pop();
                                                  },
                                                  style: ButtonStyle(
                                                      backgroundColor:
                                                          MaterialStateProperty
                                                              .all(Colors
                                                                  .amber)),
                                                  child: Text(
                                                    "Done",
                                                    style: TextStyle(
                                                        color: Colors.white),
                                                  )),
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              );
                            },
                            icon: Icon(
                              Icons.text_format,
                              color: Colors.white,
                            )),
                        Text(
                          "Text",
                          style: TextStyle(color: Colors.white),
                        ),
                      ],
                    ),
                    Column(
                      children: [
                        IconButton(
                            onPressed: () {
                              _publish();
                            },
                            icon: Icon(
                              Icons.arrow_forward_rounded,
                              color: Colors.amber,
                            )),
                        Text(
                          "Publish",
                          style: TextStyle(color: Colors.amber),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ))
      ],
    );
  }
}

class myPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint()
      ..color = Colors.white
      ..strokeWidth = 10.0;

    //middle line
    canvas.drawLine(Offset(-2, 0.6 * size.height),
        Offset(size.width + 2, 0.4 * size.height), paint);

    //top vertical line
    canvas.drawLine(Offset(0.4 * size.width, -2),
        Offset(0.6 * size.width, 0.48 * size.height), paint);

    //bottom line
    canvas.drawLine(Offset(0.35 * size.width, size.height + 2),
        Offset(0.45 * size.width, 0.51 * size.height), paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}

class firstImageClipper extends CustomClipper<Path> {
  firstImageClipper({required this.height, required this.width});
  final double height;
  final double width;
  @override
  Path getClip(Size size) {
    final path = Path();
    path.lineTo(width * 0.4 - 5, 0);
    path.lineTo(0.6 * width - 5, 0.48 * height - 5);
    path.lineTo(0, height * 0.6 - 5);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    return false;
  }
}

class secondImageClipper extends CustomClipper<Path> {
  secondImageClipper({required this.height, required this.width});
  final double height;
  final double width;
  @override
  Path getClip(Size size) {
    final path = Path();
    path.moveTo(5, 0);
    path.lineTo(size.width + 0, 0);
    path.lineTo(size.width, 0.4 * height - 5);
    path.lineTo(size.width - (0.4 * width - 5), height * 0.48 - 5);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    return false;
  }
}

class thirdImageClipper extends CustomClipper<Path> {
  thirdImageClipper({required this.height, required this.width});
  final double height;
  final double width;
  @override
  Path getClip(Size size) {
    final path = Path();
    path.moveTo(0, 5 + 0.6 * height - 0.51 * height);
    path.lineTo(size.width - 5, 5);
    path.lineTo(width * 0.35 - 5, size.height);
    path.lineTo(0, size.height);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    return false;
  }
}

class fourthImageClipper extends CustomClipper<Path> {
  fourthImageClipper({required this.height, required this.width});
  final double height;
  final double width;
  @override
  Path getClip(Size size) {
    final path = Path();
    path.moveTo(0.1 * width, 0.09 * height + 15);
    path.lineTo(size.width, 0 + 5);
    path.lineTo(size.width, size.height);
    path.lineTo(5, size.height);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    return false;
  }
}
