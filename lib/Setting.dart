import 'dart:async';
import 'dart:developer';

import 'package:flutter_launcher_icons/android.dart';
import 'package:flutter_launcher_icons/constants.dart';
import 'package:flutter_launcher_icons/custom_exceptions.dart';
import 'package:flutter_launcher_icons/ios.dart';
import 'package:flutter_launcher_icons/main.dart';
import 'package:flutter_launcher_icons/utils.dart';
import 'package:flutter_launcher_icons/xml_templates.dart';

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:get_storage/get_storage.dart';
import 'package:flutter/cupertino.dart';

class init_Setting extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // String token = box.read('token');
    return MaterialApp(
      title: "Dashboard",
      theme: ThemeData(
        primaryColor: Colors.white,
      ),
      home: const Scaffold(
        body: Setting(),
      ),
    );
  }
}

class Setting extends StatefulWidget {
  const Setting({Key? key}) : super(key: key);
  // const Setting();
  @override
  State<Setting> createState() => _Setting();
}

enum ModeOtomatisLampu { nyala, mati }

class _Setting extends State<Setting> {
  final box = GetStorage();
  ModeOtomatisLampu? _character = ModeOtomatisLampu.nyala;
  List<TextEditingController> ctrlTxtInput =
      List.generate(8, (i) => TextEditingController());
  // TextEditingController nameController = TextEditingController();

  List<String> mode_relay = ['lampu', 'tv', 'ac', 'lain-lain'];
  List<String> jenis_relay = [
    'lampu',
    'lampu',
    'lampu',
    'lampu',
    'lampu',
    'lampu',
    'lampu',
    'lampu',
  ];
  List<String> nama_relay = [
    'Relay 1',
    'Relay 2',
    'Relay 3',
    'Relay 4',
    'Relay 5',
    'Relay 6',
    'Relay 7',
    'Relay 8',
  ];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    String token = box.read('token').toString();
    for (var i = 0; i < ctrlTxtInput.length; i++) {
      ctrlTxtInput[i].text = nama_relay[i];
    }
    return Scaffold(
        appBar: AppBar(
          elevation: 0,
          automaticallyImplyLeading: false,
          backgroundColor: Colors.white,
          flexibleSpace: SafeArea(
            child: Container(
              padding: const EdgeInsets.only(right: 16),
              child: Row(
                children: <Widget>[
                  IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: const Icon(
                      Icons.arrow_back,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(
                    width: 2,
                  ),
                  const SizedBox(
                    width: 12,
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const <Widget>[
                        Text(
                          "Setting",
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                  ),
                  // Icon(
                  //   Icons.settings,
                  //   color: Colors.black54,
                  // ),
                ],
              ),
            ),
          ),
        ),
        body: ListView(
          children: <Widget>[
            // const Text("Lampu mati saat malam hari:"),
            const Padding(
              padding: EdgeInsets.only(
                left: 20,
                top: 0,
                right: 0,
                bottom: 0,
              ),
              child: Text(
                "Lampu mati saat malam hari:",
                style: TextStyle(fontSize: 20),
              ),
            ),
            Column(
              children: <Widget>[
                ListTile(
                  title: const Text('Nyala', textAlign: TextAlign.left),
                  leading: Radio<ModeOtomatisLampu>(
                    value: ModeOtomatisLampu.nyala,
                    groupValue: _character,
                    onChanged: (ModeOtomatisLampu? value) {
                      setState(() {
                        _character = value;
                        print(value);
                      });
                    },
                  ),
                ),
                ListTile(
                  title: const Text('Mati'),
                  leading: Radio<ModeOtomatisLampu>(
                    value: ModeOtomatisLampu.mati,
                    groupValue: _character,
                    onChanged: (ModeOtomatisLampu? value) {
                      setState(() {
                        _character = value;
                        print(value);
                      });
                    },
                  ),
                ),
              ],
            ),
            const Padding(
              padding: EdgeInsets.only(
                left: 20,
                top: 0,
                right: 0,
                bottom: 0,
              ),
              child: Text(
                "Ubah jenis relay:",
                style: TextStyle(fontSize: 20),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                left: 20,
                top: 0,
                right: 20,
                bottom: 0,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      const Padding(
                        padding: EdgeInsets.only(
                          left: 0,
                          top: 0,
                          right: 10,
                          bottom: 0,
                        ),
                        child: Text('R1', textAlign: TextAlign.left),
                      ),
                      Expanded(
                        child: DropdownButton<String>(
                          isExpanded: true,
                          value: jenis_relay[0],
                          items: mode_relay.map((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                          onChanged: (newVal) {
                            setState(() {
                              jenis_relay[0] = newVal!;
                            });
                          },
                        ),
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(
                            left: 20,
                            top: 0,
                            right: 0,
                            bottom: 20,
                          ),
                          child: TextFormField(
                            controller: ctrlTxtInput[0],
                            onChanged: (newVal) {
                              nama_relay[0] = newVal;
                            },
                            decoration: const InputDecoration(
                              border: UnderlineInputBorder(),
                              labelText: 'Nama Device',
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ));
  }
}
