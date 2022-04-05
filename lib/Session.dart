import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:get_storage/get_storage.dart';

class Session {
  final box = GetStorage();
  Map<String, String> headers = {};

  Future<Map> get(String url) async {
    var head = box.read("header");
    if (head != null) {
      headers = jsonDecode(head).cast<String, String>();
    }
    http.Response response = await http.get(Uri.parse(url), headers: headers);
    updateCookie(response);
    return json.decode(response.body);
  }

  Future<Map> post(String url, String data) async {
    var head = box.read("header");
    if (head != null) {
      headers = jsonDecode(head).cast<String, String>();
    }
    http.Response response =
        await http.post(Uri.parse(url), body: data, headers: headers);
    updateCookie(response);
    // debugPrint(jsonEncode(response.headers));
    // debugPrint(jsonEncode(headers));
    return json.decode(response.body);
  }

  void updateCookie(http.Response response) {
    String? rawCookie = response.headers['set-cookie'];
    if (rawCookie != null) {
      int index = rawCookie.indexOf(';');
      headers['cookie'] =
          (index == -1) ? rawCookie : rawCookie.substring(0, index);
      box.write("header", jsonEncode(headers));
    }
  }
}
