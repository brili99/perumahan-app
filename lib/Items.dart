import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:get_storage/get_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:get_storage/get_storage.dart';

Future<http.Response> fetchItems(http.Client client) async {
  final box = GetStorage();
  String token = box.read('token').toString();
  return client.post(Uri.parse('https://iot.tigamas.com/api/app/action'),
      headers: {"Content-Type": "application/json"},
      body:
          jsonEncode(<String, String>{"action": "getStatus", "token": token}));
}

class Items {
  final int r1;
  final int r2;
  final int r3;
  final int r4;
  final int r5;
  final int r6;
  final int r7;
  final int r8;

  const Items({
    required this.r1,
    required this.r2,
    required this.r3,
    required this.r4,
    required this.r5,
    required this.r6,
    required this.r7,
    required this.r8,
  });

  factory Items.fromJson(Map<String, dynamic> json) {
    return Items(
      r1: json['statusData']['r1'] as int,
      r2: json['statusData']['r2'] as int,
      r3: json['statusData']['r3'] as int,
      r4: json['statusData']['r4'] as int,
      r5: json['statusData']['r5'] as int,
      r6: json['statusData']['r6'] as int,
      r7: json['statusData']['r7'] as int,
      r8: json['statusData']['r8'] as int,
    );
  }
}
