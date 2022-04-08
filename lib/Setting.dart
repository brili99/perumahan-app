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

import 'Session.dart';
import 'column_builder.dart';
import 'package:flutter_iconpicker/flutter_iconpicker.dart';
import 'icon_cust_icons.dart';
import 'package:restart_app/restart_app.dart';

import 'main.dart';

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
  Session session = Session();
  ModeOtomatisLampu? _character;

  List<TextEditingController> ctrlTxtInput =
      List.generate(8, (i) => TextEditingController());

  // List<String> mode_relay = ['lampu', 'tv', 'ac', 'lain-lain'];
  // List<String> jenis_relay = [
  //   'lampu',
  //   'lampu',
  //   'lampu',
  //   'lampu',
  //   'lampu',
  //   'lampu',
  //   'lampu',
  //   'lampu',
  // ];
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
  List<String> icon_str_relay = [
    'lamp', //icon lampu
    'lamp',
    'lamp',
    'lamp',
    'lamp',
    'lamp',
    'lamp',
    'lamp'
  ];
  List<IconData> icon_relay = [
    //untuk tampilan di
    IconCust.lamp,
    IconCust.lamp,
    IconCust.lamp,
    IconCust.lamp,
    IconCust.lamp,
    IconCust.lamp,
    IconCust.lamp,
    IconCust.lamp
  ];

  strToIconCust(String waticon) {
    switch (waticon) {
      case "ac":
        return IconCust.air_conditioner;
      case "setting":
        return IconCust.cog;
      case "lamp":
        return IconCust.lamp;
      case "chat":
        return IconCust.message;
      case "tv":
        return IconCust.tv;
      case "lock":
        return IconCust.lock;
      default:
        return IconCust.lamp;
    }
  }

  // List<SvgPicture> icons_svg_relay = [
  //   SvgPicture.asset('assets/images/air-conditioner.svg'),
  //   SvgPicture.asset('assets/images/lamp.svg'),
  //   SvgPicture.asset('assets/images/tv.svg'),
  //   SvgPicture.asset('assets/images/logout.svg'),
  //   SvgPicture.asset('assets/images/cog.svg'),
  //   SvgPicture.asset('assets/images/message.svg'),
  //   SvgPicture.asset('assets/images/lightning.svg'),
  //   SvgPicture.asset('assets/images/lock.svg'),
  // ];

  Map<String, IconData> myCustomIcons = {
    'air_conditioner': IconCust.air_conditioner,
    'lamp': IconCust.lamp,
    'tv': IconCust.tv,
    'cog': IconCust.cog,
    'message': IconCust.message,
    'lock': IconCust.lock,
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
        // icon_str_relay[index] = icon.toString();
        if (icon.toString() == "IconData(U+0E800)") {
          icon_str_relay[index] = "ac";
        } else if (icon.toString() == "IconData(U+0E801)") {
          icon_str_relay[index] = "setting";
        } else if (icon.toString() == "IconData(U+0E802)") {
          icon_str_relay[index] = "lamp";
        } else if (icon.toString() == "IconData(U+0E803)") {
          icon_str_relay[index] = "chat";
        } else if (icon.toString() == "IconData(U+0E804)") {
          icon_str_relay[index] = "tv";
        } else if (icon.toString() == "IconData(U+0E805)") {
          icon_str_relay[index] = "lock";
        }
      });
      // debugPrint('Picked Icon:  $icon ');
      // debugPrint(icon_relay.toString());
    }
  }

  void uploadSetting(String token) async {
    // var response = await http.post(
    //   Uri.parse("https://iot.tigamas.com/api/app/action"),
    //   headers: {"Content-Type": "application/json"},
    //   body: jsonEncode(<String, dynamic>{
    //     "action": "uploadSetting",
    //     "token": token,
    //     "nama_relay": nama_relay,
    //     "icon_relay": icon_str_relay,
    //     "shortcutSiang": shortcutSiang,
    //     "shortcutMalam": shortcutMalam,
    //     "shortcutPergi": shortcutPergi,
    //   }),
    // );
    // var status = json.decode(response.body)['msg'];
    // if (status == "success") {
    //   debugPrint("Berhasil upload setting");
    //   Restart.restartApp();
    // } else {
    //   debugPrint(response.body);
    // }

    var res = await session.post(
        'https://iot.tigamas.com/api/app/action',
        jsonEncode(<String, dynamic>{
          "action": "uploadSetting",
          "token": token,
          "nama_relay": nama_relay,
          "icon_relay": icon_str_relay,
          "shortcutSiang": shortcutSiang,
          "shortcutMalam": shortcutMalam,
          "shortcutPergi": shortcutPergi,
        }));
    if (!res['session']) {
      goBackLogin();
    } else if (res["msg"] == "success") {
      setState(() {
        debugPrint("Berhasil upload setting");
        Restart.restartApp();
      });
    } else {
      debugPrint(jsonEncode(res));
    }
  }

  List<int> shortcutSiang = List.generate(8, (i) => 0);
  List<int> shortcutMalam = List.generate(8, (i) => 0);
  List<int> shortcutPergi = List.generate(8, (i) => 0);
  void goBackLogin() async {
    var res = await session.post("https://iot.tigamas.com/api/app/action",
        jsonEncode(<String, String>{"action": "logout"}));
    box.remove('token');
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => MyApp()),
    );
  }

  void getSetting(String token) async {
    // var response = await http.post(
    //   Uri.parse("https://iot.tigamas.com/api/app/action"),
    //   headers: {"Content-Type": "application/json"},
    //   body:
    //       jsonEncode(<String, String>{"action": "getSetting", "token": token}),
    // );
    // var data = json.decode(response.body);
    // // debugPrint(data);
    // var status = data['msg'];
    // if (status == "success") {
    //   // print(data['icon_relay']);
    //   data['icon_relay'] = data['icon_relay'].cast<String>();
    //   // List<String> iconRelay = data['icon_relay'];
    //   for (var i = 0; i < 8; i++) {
    //     icon_relay[i] = strToIconCust(data['icon_relay'][i].toString());
    //   }
    //   setState(() {
    //     nama_relay = data['nama_relay'].cast<String>();
    //     icon_str_relay = data['icon_relay'];
    //     shortcutSiang = data['shortcutSiang'].cast<int>();
    //     shortcutMalam = data['shortcutMalam'].cast<int>();
    //     shortcutPergi = data['shortcutPergi'].cast<int>();
    //   });
    // } else {
    //   debugPrint("ada yang salah");
    // }

    var res = await session.post('https://iot.tigamas.com/api/app/action',
        jsonEncode(<String, String>{"action": "getSetting", "token": token}));
    // debugPrint(jsonEncode(res));
    if (!res['session']) {
      goBackLogin();
    } else if (res["msg"] == "success") {
      res['icon_relay'] = res['icon_relay'].cast<String>();
      for (var i = 0; i < 8; i++) {
        icon_relay[i] = strToIconCust(res['icon_relay'][i].toString());
      }
      setState(() {
        nama_relay = res['nama_relay'].cast<String>();
        icon_str_relay = res['icon_relay'];
        shortcutSiang = res['shortcutSiang'].cast<int>();
        shortcutMalam = res['shortcutMalam'].cast<int>();
        shortcutPergi = res['shortcutPergi'].cast<int>();
      });
    } else {
      debugPrint("ada yang salah");
    }
  }

  @override
  void initState() {
    super.initState();
    getSetting(box.read('token').toString());
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
                      setState(() {
                        uploadSetting(token);
                      });
                      // print(icon_str_relay);
                      // print(nama_relay);
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
            // const Padding(
            //   padding: EdgeInsets.only(
            //     left: 20,
            //     top: 0,
            //     right: 0,
            //     bottom: 0,
            //   ),
            //   child: Text(
            //     "Lampu mati saat malam hari:",
            //     style: TextStyle(fontSize: 20),
            //   ),
            // ),
            // Column(
            //   children: <Widget>[
            // ListTile(
            //   title: const Text('Nyala', textAlign: TextAlign.left),
            //   leading: Radio<ModeOtomatisLampu>(
            //     value: ModeOtomatisLampu.nyala,
            //     groupValue: _character,
            //     onChanged: (ModeOtomatisLampu? value) {
            //       setState(() {
            //         _character = value;
            //         print(value);
            //       });
            //     },
            //   ),
            // ),
            // ListTile(
            //   title: const Text('Mati'),
            //   leading: Radio<ModeOtomatisLampu>(
            //     value: ModeOtomatisLampu.mati,
            //     groupValue: _character,
            //     onChanged: (ModeOtomatisLampu? value) {
            //       setState(() {
            //         _character = value;
            //         print(value);
            //       });
            //     },
            //   ),
            // ),
            //   ],
            // ),
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
            const Padding(
              padding: EdgeInsets.only(
                left: 20,
                top: 0,
                right: 0,
                bottom: 0,
              ),
              child: Text(
                "Setting Shortcut Siang:",
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
                          Expanded(
                              child: ListTile(
                            title:
                                const Text('Nyala', textAlign: TextAlign.left),
                            leading: Radio<int>(
                              value: 1,
                              groupValue: shortcutSiang[index],
                              onChanged: (value) {
                                setState(() {
                                  shortcutSiang[index] = value!;
                                  // print(value);
                                });
                              },
                            ),
                          )),
                          Expanded(
                              child: ListTile(
                            title: const Text('Mati'),
                            leading: Radio<int>(
                              value: 0,
                              groupValue: shortcutSiang[index],
                              onChanged: (value) {
                                setState(() {
                                  shortcutSiang[index] = value!;
                                  // print(value);
                                });
                              },
                            ),
                          )),
                        ],
                      );
                    })),
            const SizedBox(
              height: 20,
            ),
            const Padding(
              padding: EdgeInsets.only(
                left: 20,
                top: 0,
                right: 0,
                bottom: 0,
              ),
              child: Text(
                "Setting Shortcut Malam:",
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
                          Expanded(
                              child: ListTile(
                            title:
                                const Text('Nyala', textAlign: TextAlign.left),
                            leading: Radio<int>(
                              value: 1,
                              groupValue: shortcutMalam[index],
                              onChanged: (value) {
                                setState(() {
                                  shortcutMalam[index] = value!;
                                  // print(value);
                                });
                              },
                            ),
                          )),
                          Expanded(
                              child: ListTile(
                            title: const Text('Mati'),
                            leading: Radio<int>(
                              value: 0,
                              groupValue: shortcutMalam[index],
                              onChanged: (value) {
                                setState(() {
                                  shortcutMalam[index] = value!;
                                  // print(value);
                                });
                              },
                            ),
                          )),
                        ],
                      );
                    })),
            const SizedBox(
              height: 20,
            ),
            const Padding(
              padding: EdgeInsets.only(
                left: 20,
                top: 0,
                right: 0,
                bottom: 0,
              ),
              child: Text(
                "Setting Shortcut Pergi:",
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
                          Expanded(
                              child: ListTile(
                            title:
                                const Text('Nyala', textAlign: TextAlign.left),
                            leading: Radio<int>(
                              value: 1,
                              groupValue: shortcutPergi[index],
                              onChanged: (value) {
                                setState(() {
                                  shortcutPergi[index] = value!;
                                  // print(value);
                                });
                              },
                            ),
                          )),
                          Expanded(
                              child: ListTile(
                            title: const Text('Mati'),
                            leading: Radio<int>(
                              value: 0,
                              groupValue: shortcutPergi[index],
                              onChanged: (value) {
                                setState(() {
                                  shortcutPergi[index] = value!;
                                  // print(value);
                                });
                              },
                            ),
                          )),
                        ],
                      );
                    })),
          ],
        ));
  }
}
