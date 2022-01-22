import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';

class IPFS {
  late String url;
  late HttpClient httpClient = new HttpClient();

  // IPFS._() {
  //   url = "https://ipfs.infura.io:5001";
  // }
  // static IPFS instance = IPFS._();

  Future<dynamic> addImage(List<int> path) async {
    Map<String, String> headers = <String, String>{
      "Content-Disposition": 'form-data; name="file"; filename="File"',
      "Content-Type": "application/octet-stream"
    };

    var uri = Uri.parse('https://ipfs.infura.io:5001/api/v0/add');
    var request = http.MultipartRequest('POST', uri);
    request.headers.addAll(headers);
    request.files.add(http.MultipartFile.fromBytes('path', path));
    var response = await request.send();
    final respStr = await response.stream.bytesToString();
    return (jsonDecode(respStr));
  }

  // Function to add Json data to ipfs
  Future<dynamic> addData(
      List<int> path, int price, String title, String creatorName) async {
    Map<String, String> headers = <String, String>{
      "Content-Disposition": 'form-data; name="file"; title="$title"',
      "Content-Type": "application/octet-stream"
    };
    print("Before img link");
    var imgHash = await addImage(path);
    print("After img link");
    var uri = Uri.parse('https://ipfs.infura.io:5001/api/v0/add');
    var body = jsonEncode({
      "price": price.toString(),
      "title": title,
      "creatorName": creatorName,
      "imgHash": imgHash['Hash'],
    });
    print("Before request");
    var request = http.MultipartRequest('POST', uri);
    request.headers.addAll(headers);
    request.files.add(http.MultipartFile.fromString('path', body));
    var response = await request.send();
    final respStr = await response.stream.bytesToString();
    print(respStr);
    return jsonDecode(respStr);
  }

  Future<void> download(String hash, String fileName) async {
    final queryParameters = {
      'arg': hash,
    };
    final uri =
        Uri.https("ipfs.infura.io:5001", '/api/v0/get', queryParameters);
    print(uri);

    http.Client client = new http.Client();
    final req = await client.get(uri);
    final bytes = req.bodyBytes;
    // extract data from response
    // String dir = (await getApplicationDocumentsDirectory()).path;
    //File file = File('$dir/$fileName');
    // await file.writeAsBytes(bytes);
    // print(file);
    print("downloaded");
    //return file;
  }
}
