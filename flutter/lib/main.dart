import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:image_picker/image_picker.dart';

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
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<String> _imagepaths = [" ", " ", " ", " "];
  ImagePicker _picker = ImagePicker();

  GlobalKey _globalKey = new GlobalKey();

  Future<void> addImage(int index) async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      _imagepaths[index] = image.path;
    }
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
    return Scaffold(
      backgroundColor: Color(0xFF1D1E22),
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: RepaintBoundary(
          key: _globalKey,
          child: Card(
            clipBehavior: Clip.hardEdge,
            color: Color(0xFF2B2D32),
            child: SizedBox(
                width: double.infinity,
                height: 600,
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
                                  : Image.file(
                                      File(_imagepaths[0]),
                                      // color: Colors.amber,
                                      fit: BoxFit.fill,
                                      height: constraints.maxHeight * 0.6,
                                      width: constraints.maxWidth * 0.6,
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
                                  : Image.file(
                                      File(_imagepaths[1]),
                                      fit: BoxFit.fill,
                                      height: constraints.maxHeight * 0.48,
                                      width: constraints.maxWidth * 0.6,
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
                                  : Image.file(
                                      File(_imagepaths[2]),
                                      fit: BoxFit.fill,
                                      height: constraints.maxHeight * 0.49,
                                      width: constraints.maxWidth * 0.45,
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
                                  : Image.file(
                                      File(_imagepaths[3]),
                                      fit: BoxFit.fill,
                                      height: constraints.maxHeight * 0.6,
                                      width: constraints.maxWidth * 0.65,
                                    ),
                            )),
                        Positioned(
                            top: constraints.maxHeight * 0.25,
                            left: constraints.maxWidth * 0.25,
                            child: IconButton(
                              icon: Icon(Icons.add_circle, color: Colors.amber),
                              onPressed: () async {
                                await addImage(0);
                                setState(() {});
                              },
                            )),
                        Positioned(
                            top: constraints.maxHeight * 0.20,
                            left: constraints.maxWidth * 0.70,
                            child: IconButton(
                              icon: Icon(Icons.add_circle, color: Colors.amber),
                              onPressed: () async {
                                await addImage(1);
                                setState(() {});
                              },
                            )),
                        Positioned(
                            top: constraints.maxHeight * 0.75,
                            left: constraints.maxWidth * 0.15,
                            child: IconButton(
                              icon: Icon(Icons.add_circle, color: Colors.amber),
                              onPressed: () async {
                                await addImage(2);
                                setState(() {});
                              },
                            )),
                        Positioned(
                            top: constraints.maxHeight * 0.70,
                            left: constraints.maxWidth * 0.65,
                            child: IconButton(
                              icon: Icon(Icons.add_circle, color: Colors.amber),
                              onPressed: () async {
                                await addImage(3);
                                setState(() {});
                              },
                            )),
                      ],
                    ),
                  );
                })),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _capturePng,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
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
    path.lineTo(size.width - 5, 0);
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
