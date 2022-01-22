import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';

class IPFS {
  late String url;
  late HttpClient httpClient = new HttpClient();

  IPFS._() {
    url = "http://127.0.0.1:5001";
  }
  static IPFS instance = IPFS._();

  Future<dynamic> add(
      String path, String fileName, int price, String title) async {
    Map<String, String> headers = <String, String>{
      "Content-Disposition": 'form-data; name="file"; filename="$fileName"',
      "Content-Type": "application/octet-stream"
    };

    var uri = Uri.parse('$url/api/v0/add');
    var request = http.MultipartRequest('POST', uri);
    request.headers.addAll(headers);
    request.fields['price'] = price as String;
    request.fields['title'] = title;
    request.files.add(await http.MultipartFile.fromPath(
      'path',
      '$path',
    ));
    var response = await request.send();
    final respStr = await response.stream.bytesToString();
    return (jsonDecode(respStr));
  }

  Future<File> download(String hash, String fileName) async {
    final queryParameters = {
      'arg': hash,
    };
    final uri = Uri.http("127.0.0.1:5001", '/api/v0/get/', queryParameters);

    http.Client client = new http.Client();
    final req = await client.get(uri);
    final bytes = req.bodyBytes;
    print(bytes);
    // extract data from response
    String dir = (await getApplicationDocumentsDirectory()).path;
    File file = File('$dir/$fileName');
    await file.writeAsBytes(bytes);
    print(file);
    print("downloaded");
    return file;
  }
}
