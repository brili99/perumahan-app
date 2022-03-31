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

import 'column_builder.dart';
import 'package:flutter_iconpicker/flutter_iconpicker.dart';
import 'icon_cust_icons.dart';

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

  String getIcon(String whaticon) {
    switch (whaticon) {
      case "ac":
        return 'assets/images/air-conditioner.svg';
      case "lamp":
        return 'assets/images/lamp.svg';
      case "tv":
        return 'assets/images/tv.svg';
      case "logout":
        return 'assets/images/logout.svg';
      case "setting":
        return 'assets/images/cog.svg';
      case "chat":
        return 'assets/images/message.svg';
      default:
        return 'assets/images/lightning.svg';
    }
  }

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
  List<IconData> icon_relay = [
    IconCust.lamp,
    IconCust.lamp,
    IconCust.lamp,
    IconCust.lamp,
    IconCust.lamp,
    IconCust.lamp,
    IconCust.lamp,
    IconCust.lamp
  ];

  List<SvgPicture> icons_svg_relay = [
    SvgPicture.asset('assets/images/air-conditioner.svg'),
    SvgPicture.asset('assets/images/lamp.svg'),
    SvgPicture.asset('assets/images/tv.svg'),
    SvgPicture.asset('assets/images/logout.svg'),
    SvgPicture.asset('assets/images/cog.svg'),
    SvgPicture.asset('assets/images/message.svg'),
    SvgPicture.asset('assets/images/lightning.svg'),
  ];

  Map<String, IconData> myCustomIcons = {
    'air_conditioner': IconCust.air_conditioner,
    'lamp': IconCust.lamp,
    'tv': IconCust.tv,
    'cog': IconCust.cog,
    'message': IconCust.message,
  };

  _pickIcon(int index) async {
    IconData? icon = await FlutterIconPicker.showIconPicker(context,
        adaptiveDialog: false,
        showTooltips: false,
        showSearchBar: true,
        iconPickerShape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        iconPackModes: [IconPack.custom],
        customIconPack: myCustomIcons);

    if (icon != null) {
      // notifier.iconData = icon;
      setState(() {
        icon_relay[index] = icon;
      });
      // debugPrint('Picked Icon:  $icon ');
      // debugPrint(icon_relay.toString());
      if (icon.toString() == "IconData(U+0E802)") {
        debugPrint("lampu");
      }
    }
  }

  uploadSetting(String token) async {
    var response = await http.post(
      Uri.parse("https://iot.tigamas.com/api/app/action"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(<String, String>{
        "action": "uploadSetting",
        "token": token,
      }),
    );
    // var rVal = json.decode(response.body)['dataValue'].cast<int>();
    setState(() {});
    // print(rVal);
    return response.body;
  }

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
                  ElevatedButton(
                    child: const Text("Simpan"),
                    onPressed: () {
                      setState(() {});
                      print(jenis_relay);
                      print(nama_relay);
                    },
                  )
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
                child: ColumnBuilder(
                    itemCount: 8,
                    itemBuilder: (BuildContext context, int index) {
                      String textRelay = "R" + (index + 1).toString();
                      return Row(
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.only(
                              left: 0,
                              top: 0,
                              right: 10,
                              bottom: 0,
                            ),
                            child: Text(textRelay, textAlign: TextAlign.left),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                              left: 0,
                              top: 0,
                              right: 10,
                              bottom: 0,
                            ),
                            child: OutlinedButton.icon(
                              style: OutlinedButton.styleFrom(
                                padding: const EdgeInsets.all(8),
                              ),
                              onPressed: () {
                                _pickIcon(index);
                              },
                              icon: Icon(
                                icon_relay[index],
                                size: 24.0,
                              ),
                              label: const Text(''),
                            ),
                          ),
                          // Expanded(
                          //   child: DropdownButton<String>(
                          //     isExpanded: true,
                          //     value: jenis_relay[index],
                          //     items: mode_relay.map((String value) {
                          //       return DropdownMenuItem<String>(
                          //         value: value,
                          //         child: Text(value),
                          //       );
                          //     }).toList(),
                          //     onChanged: (newVal) {
                          //       setState(() {
                          //         jenis_relay[index] = newVal!;
                          //       });
                          //     },
                          //   ),
                          // ),
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.only(
                                left: 20,
                                top: 0,
                                right: 0,
                                bottom: 20,
                              ),
                              child: TextFormField(
                                controller: ctrlTxtInput[index],
                                onChanged: (newVal) {
                                  nama_relay[index] = newVal;
                                },
                                decoration: const InputDecoration(
                                  border: UnderlineInputBorder(),
                                  labelText: 'Nama Device',
                                ),
                              ),
                            ),
                          ),
                        ],
                      );
                    })),
          ],
        ));
  }
}
