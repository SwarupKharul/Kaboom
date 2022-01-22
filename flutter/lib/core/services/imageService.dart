import 'dart:io';
import 'dart:convert';

import 'package:http/http.dart';

class ImageService {
  String API_KEY = '2f4c0e9e-2aa3-4f05-a9d7-241660913d4a';

  Future<void> cartoonify(String url_con) async {
    var url = Uri.parse('https://api.deepai.org/api/fast-style-transfer');
    var response = await post(url, headers: {
      'api-key': API_KEY
    }, body: {
      'content': url_con,
      'style':
          'https://fiverr-res.cloudinary.com/images/q_auto,f_auto/gigs/170475371/original/0a4d3f38badf052a3d89ff8f141b12ce4f2434c2/do-a-cartoon-vector-or-comic-style-portrait.jpg',
    });
    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');
  }

  Future<String> cartoonify_image(File image) async {
    var url = Uri.parse('https://api.deepai.org/api/fast-style-transfer');
    var request = MultipartRequest(
      'POST',
      url,
    );

    Map<String, String> headers = {'api-key': API_KEY};

    request.files.add(await MultipartFile.fromPath(
      'content',
      image.path,
    ));

    request.headers.addAll(headers);

    request.fields.addAll({
      'style':
          'https://fiverr-res.cloudinary.com/images/q_auto,f_auto/gigs/170475371/original/0a4d3f38badf052a3d89ff8f141b12ce4f2434c2/do-a-cartoon-vector-or-comic-style-portrait.jpg',
    });
    print("request: " + request.toString());
    var res = await request.send();

    print('Response status: ${res.statusCode}');
    String image_url = await res.stream.bytesToString();
    Map data = jsonDecode(image_url);
    return data["output_url"];
  }
}
