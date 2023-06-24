import 'package:http/http.dart' as http;
import 'dart:convert';

class NetworkHelper {
  final String url;
  NetworkHelper({required this.url});

  Future getData() async {
    var uri = Uri.parse(url);
    http.Response response = await http.get(uri);
    if (response.statusCode == 200) {
      // success
      var json = jsonDecode(response.body);
      return json;
    } else {
      print(response.statusCode);
    }
  }
}
