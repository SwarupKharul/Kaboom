import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:image_picker/image_picker.dart';
import 'package:kaboom/core/services/imageService.dart';

class CreateComic2 extends StatefulWidget {
  const CreateComic2({Key? key}) : super(key: key);

  @override
  State<CreateComic2> createState() => _CreateComic2State();
}

class _CreateComic2State extends State<CreateComic2> {
  List<String> _imagepaths = [" ", " ", " ", " "];
  List<String> _dialogues = [" ", " ", " ", " "];
  int _dialogueCounter = 0;
  TextEditingController _controller = TextEditingController();
  bool _busy = false;

  ImageService _image = ImageService();

  ImagePicker _picker = ImagePicker();

  GlobalKey _globalKey = new GlobalKey();

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
                                              width: constraints.maxWidth,
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
                                                              0.6,
                                                    ),
                                                  ))
                                          ],
                                        ),
                                )),
                            Positioned(
                                top: 0.4 * constraints.maxHeight,
                                left: 0,
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
                                                  constraints.maxHeight * 0.6,
                                              width: constraints.maxWidth,
                                            ),
                                            if (_dialogues[1] != " ")
                                              Positioned(
                                                  bottom: 0,
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
                                                              0.6,
                                                    ),
                                                  ))
                                          ],
                                        ),
                                )),
                            if (_imagepaths[0] == " ")
                              Positioned(
                                  top: constraints.maxHeight * 0.25,
                                  left: constraints.maxWidth * 0.50,
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
                                  top: constraints.maxHeight * 0.70,
                                  left: constraints.maxWidth * 0.50,
                                  child: IconButton(
                                    icon: Icon(Icons.add_circle,
                                        color: Colors.amber),
                                    onPressed: () async {
                                      await addImage(1);
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
                            onPressed: () {},
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
                                                    _dialogueCounter %= 2;
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
                            onPressed: () {},
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
    canvas.drawLine(Offset(-2, 0.4 * size.height),
        Offset(size.width + 2, 0.6 * size.height), paint);
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
    path.lineTo(width, 0);
    path.lineTo(width, 0.6 * height - 5);
    path.lineTo(0, height * 0.4 - 5);
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
    path.moveTo(0, 5);
    path.lineTo(0, size.height);
    path.lineTo(size.width, size.height);
    path.lineTo(size.width, height * 0.2 + 5);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    return false;
  }
}
