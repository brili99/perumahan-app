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
import 'package:restart_app/restart_app.dart';
import 'package:tigamas_app/Setting.dart';
import 'Chat.dart';
import 'main.dart';
import 'Session.dart';
import 'package:external_app_launcher/external_app_launcher.dart';

class init_Dashboardv8 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // String token = box.read('token');
    return MaterialApp(
      title: "Dashboard",
      theme: ThemeData(
        primaryColor: Colors.white,
      ),
      home: const Scaffold(
        body: Dashboardv8(),
      ),
    );
  }
}

class Dashboardv8 extends StatefulWidget {
  const Dashboardv8({Key? key}) : super(key: key);
  // const Dashboardv8();
  @override
  State<Dashboardv8> createState() => _Dashboardv8();
}

class _Dashboardv8 extends State<Dashboardv8> {
  final box = GetStorage();
  Session session = Session();
  String token = "";
  String userName = "john";
  String lastSyncTime = "";
  int statusDeviceOnline = 1;
  int statusPesanMasuk = 1;
  List<int> btnValShortcut = [0, 0, 0];

  List<int> relayValue = [0, 0, 0, 0, 0, 0, 0, 0];
  List<String> relayIcon = [
    "tv",
    "tv",
    "tv",
    "tv",
    "tv",
    "tv",
    "tv",
    "tv",
  ];
  List<String> relayName = [
    "Relay 1",
    "Relay 2",
    "Relay 3",
    "Relay 4",
    "Relay 5",
    "Relay 6",
    "Relay 7",
    "Relay 8",
  ];

  List<int> shortcutSiang = List.generate(8, (i) => 0);
  List<int> shortcutMalam = List.generate(8, (i) => 0);
  List<int> shortcutPergi = List.generate(8, (i) => 0);

  void shortcutRelay(String whatshortcut) {
    String token = box.read('token').toString();
    switch (whatshortcut) {
      case "siang":
        setState(() {
          for (var i = 0; i < shortcutSiang.length; i++) {
            setStateRelay(
                token, (i + 1).toString(), shortcutSiang[i].toString());
          }
          relayValue = shortcutSiang;
        });
        break;
      case "malam":
        setState(() {
          for (var i = 0; i < shortcutMalam.length; i++) {
            setStateRelay(
                token, (i + 1).toString(), shortcutMalam[i].toString());
          }
          relayValue = shortcutMalam;
        });
        break;
      case "pergi":
        setState(() {
          for (var i = 0; i < shortcutPergi.length; i++) {
            setStateRelay(
                token, (i + 1).toString(), shortcutPergi[i].toString());
          }
          relayValue = shortcutPergi;
        });
        break;
      case "matikan":
        setState(() {
          for (var i = 0; i < 8; i++) {
            setStateRelay(token, (i + 1).toString(), "0");
          }
          relayValue = [0, 0, 0, 0, 0, 0, 0, 0];
        });
        break;
      default:
        debugPrint("Wrong shortcut");
    }
  }

  getStatus(String token) async {
    var res = await session.post("https://iot.tigamas.com/api/app/action",
        jsonEncode(<String, String>{"action": "getStatus", "token": token}));
    if (res['session']) {
      setState(() {
        lastSyncTime = res['lastDataChange'];
        relayValue = res['dataValue'].cast<int>();
        relayName = res['dataName'].cast<String>();
        // print(res['dataIcon'].cast<String>());
        relayIcon = res['dataIcon'].cast<String>();

        // statusDeviceOnline = int.parse(res['online']);
        statusPesanMasuk = int.parse(res['pesanTerakhirAdmin']);

        if (res['shortcutSiang'].length == 8) {
          shortcutSiang = res['shortcutSiang'].cast<int>();
        }
        if (res['shortcutMalam'].length == 8) {
          shortcutMalam = res['shortcutMalam'].cast<int>();
        }
        if (res['shortcutPergi'].length == 8) {
          shortcutPergi = res['shortcutPergi'].cast<int>();
        }
      });
    } else {
      // Re login
      goBackLogin();
    }
    // return response.body;
    return jsonEncode(res);
  }

  getSyncDataWithServer(String token) async {
    var res = await session.post(
        "https://iot.tigamas.com/api/app/action",
        jsonEncode(<String, String>{
          "action": "getSyncDataWithServer",
          "token": token
        }));
    if (res['session']) {
      if (res['msg'] == "success") {
        setState(() {
          statusDeviceOnline = int.parse(res['online']);
        });
        if (lastSyncTime != res['data']) {
          getStatus(token);
          // lastSyncTime = res['data'];
          debugPrint("Data changed, sync with server");
        }
      }
    } else {
      // Re login
      goBackLogin();
    }
  }

  setStateRelay(String token, String relay, String state) async {
    var res = await session.post(
        "https://iot.tigamas.com/api/app/action",
        jsonEncode(<String, String>{
          "action": "setStatusRelay",
          "relay": relay,
          "token": token,
          "state": state
        }));
    // debugPrint(jsonEncode(res));
    if (!res['session']) {
      goBackLogin();
    }
    // return response.body;
    return jsonEncode(res);
  }

  void goBackLogin() async {
    String token = box.read('token').toString();
    var res = await session.post("https://iot.tigamas.com/api/app/action",
        jsonEncode(<String, String>{"action": "logout", "token": token}));
    await box.remove('token');
    Restart.restartApp();
    // Navigator.push(
    //   context,
    //   MaterialPageRoute(builder: (context) => MyApp()),
    // );
  }

  @override
  void initState() {
    super.initState();
    setState(() {
      token = box.read('token').toString();
      userName = box.read('nama').toString();
    });
    getStatus(token);

    Timer.periodic(new Duration(seconds: 1), (timer) {
      getSyncDataWithServer(token);
    });
  }

  @override
  Widget build(BuildContext context) {
    token = box.read('token').toString();
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/imagesv2/backgorund.png"),
            fit: BoxFit.cover,
          ),
        ),
        child: ListView(
          children: [
            Padding(
              padding: const EdgeInsets.only(
                left: 15,
                top: 10,
                right: 15,
                bottom: 10,
              ),
              child: Row(
                children: [
                  Expanded(
                      child: Text(
                    "Halo " + userName,
                    style: const TextStyle(color: Colors.white),
                  )),
                  IconButton(
                    icon: Image.asset('assets/imagesv2/wifi ' +
                        (statusDeviceOnline == 1 ? 'kuning' : 'putih') +
                        '.png'),
                    onPressed: null,
                  ),
                  IconButton(
                    icon: Image.asset('assets/imagesv2/mail ' +
                        (statusPesanMasuk == 1 ? 'kuning' : 'putih') +
                        '.png'),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const Chat()),
                      );
                    },
                  ),
                  IconButton(
                    icon: Image.asset('assets/imagesv2/setting.png'),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const Setting()),
                      );
                    },
                  ),
                  IconButton(
                    icon: Image.asset('assets/imagesv2/keluar.png'),
                    onPressed: () {
                      // Log Out
                      goBackLogin();
                    },
                  ),
                ],
              ),
            ),
            Image.asset('assets/imagesv2/banner.png'),
            Padding(
                padding: const EdgeInsets.only(
                  left: 20,
                  top: 10,
                  right: 20,
                  bottom: 10,
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: TextButton(
                          onPressed: () {
                            setState(() {
                              box.write('mode', 3);
                              if (btnValShortcut[0] == 0) {
                                btnValShortcut[0] = 1;
                                btnValShortcut[1] = 0;
                                btnValShortcut[2] = 0;
                                shortcutRelay("pergi");
                              } else {
                                btnValShortcut[0] = 0;
                                btnValShortcut[1] = 0;
                                btnValShortcut[2] = 0;
                                shortcutRelay("matikan");
                              }
                            });
                          },
                          child: Column(
                            children: [
                              Text(
                                "Pergi",
                                style: TextStyle(
                                    color: btnValShortcut[0] == 0
                                        ? Colors.white
                                        : Colors.yellow),
                              ),
                              Image.asset(btnValShortcut[0] == 0
                                  ? 'assets/imagesv2/pergi putih.png'
                                  : 'assets/imagesv2/pergi kuning.png'),
                            ],
                          )),
                    ),
                    Expanded(
                      child: TextButton(
                          onPressed: () {
                            setState(() {
                              box.write('mode', 1);
                              if (btnValShortcut[1] == 0) {
                                btnValShortcut[0] = 0;
                                btnValShortcut[1] = 1;
                                btnValShortcut[2] = 0;
                                shortcutRelay("siang");
                              } else {
                                btnValShortcut[0] = 0;
                                btnValShortcut[1] = 0;
                                btnValShortcut[2] = 0;
                                shortcutRelay("matikan");
                              }
                            });
                          },
                          child: Column(
                            children: [
                              Text(
                                "Siang",
                                style: TextStyle(
                                    color: btnValShortcut[1] == 0
                                        ? Colors.white
                                        : Colors.yellow),
                              ),
                              Image.asset(btnValShortcut[1] == 0
                                  ? 'assets/imagesv2/siang putih.png'
                                  : 'assets/imagesv2/siang kuning.png'),
                            ],
                          )),
                    ),
                    Expanded(
                      child: TextButton(
                          onPressed: () {
                            setState(() {
                              box.write('mode', 2);
                              if (btnValShortcut[2] == 0) {
                                btnValShortcut[0] = 0;
                                btnValShortcut[1] = 0;
                                btnValShortcut[2] = 1;
                                shortcutRelay("malam");
                              } else {
                                box.write('mode', 0);
                                btnValShortcut[0] = 0;
                                btnValShortcut[1] = 0;
                                btnValShortcut[2] = 0;
                                shortcutRelay("matikan");
                              }
                            });
                          },
                          child: Column(
                            children: [
                              Text(
                                "Malam",
                                style: TextStyle(
                                    color: btnValShortcut[2] == 0
                                        ? Colors.white
                                        : Colors.yellow),
                              ),
                              Image.asset(btnValShortcut[2] == 0
                                  ? 'assets/imagesv2/malam putih.png'
                                  : 'assets/imagesv2/malam kuning.png'),
                            ],
                          )),
                    ),
                  ],
                )),

            // Relay button
            Padding(
                padding: const EdgeInsets.only(
                  left: 20,
                  top: 10,
                  right: 20,
                  bottom: 10,
                ),
                child: Column(
                  children: [
                    Row(children: [
                      Expanded(
                          child: TextButton(
                              onPressed: () {
                                setState(() {
                                  relayValue[0] = relayValue[0] == 1 ? 0 : 1;
                                  btnValShortcut[0] = 0;
                                  btnValShortcut[1] = 0;
                                  btnValShortcut[2] = 0;
                                  setStateRelay(
                                      token, "1", relayValue[0].toString());
                                });
                              },
                              child: Stack(
                                  alignment: Alignment.bottomCenter,
                                  children: <Widget>[
                                    Image.asset('assets/imagesv2/' +
                                        relayIcon[0] +
                                        ' ' +
                                        (relayValue[0] == 1
                                            ? 'kuning'
                                            : 'putih') +
                                        '.png'),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                        left: 0,
                                        top: 0,
                                        right: 0,
                                        bottom: 10,
                                      ),
                                      child: Text(
                                        relayName[0],
                                        style: TextStyle(
                                            color: relayValue[0] == 0
                                                ? Colors.white
                                                : Colors.yellow),
                                      ),
                                    )
                                  ]))),
                      Expanded(
                          child: TextButton(
                              onPressed: () {
                                setState(() {
                                  relayValue[1] = relayValue[1] == 1 ? 0 : 1;
                                  btnValShortcut[0] = 0;
                                  btnValShortcut[1] = 0;
                                  btnValShortcut[2] = 0;
                                  setStateRelay(
                                      token, "2", relayValue[1].toString());
                                });
                              },
                              child: Stack(
                                  alignment: Alignment.bottomCenter,
                                  children: <Widget>[
                                    Image.asset('assets/imagesv2/' +
                                        relayIcon[1] +
                                        ' ' +
                                        (relayValue[1] == 1
                                            ? 'kuning'
                                            : 'putih') +
                                        '.png'),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                        left: 0,
                                        top: 0,
                                        right: 0,
                                        bottom: 10,
                                      ),
                                      child: Text(
                                        relayName[1],
                                        style: TextStyle(
                                            color: relayValue[1] == 0
                                                ? Colors.white
                                                : Colors.yellow),
                                      ),
                                    )
                                  ]))),
                      Expanded(
                          child: TextButton(
                              onPressed: () {
                                setState(() {
                                  relayValue[2] = relayValue[2] == 1 ? 0 : 1;
                                  btnValShortcut[0] = 0;
                                  btnValShortcut[1] = 0;
                                  btnValShortcut[2] = 0;
                                  setStateRelay(
                                      token, "3", relayValue[2].toString());
                                });
                              },
                              child: Stack(
                                  alignment: Alignment.bottomCenter,
                                  children: <Widget>[
                                    Image.asset('assets/imagesv2/' +
                                        relayIcon[2] +
                                        ' ' +
                                        (relayValue[2] == 1
                                            ? 'kuning'
                                            : 'putih') +
                                        '.png'),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                        left: 0,
                                        top: 0,
                                        right: 0,
                                        bottom: 10,
                                      ),
                                      child: Text(
                                        relayName[2],
                                        style: TextStyle(
                                            color: relayValue[2] == 0
                                                ? Colors.white
                                                : Colors.yellow),
                                      ),
                                    )
                                  ]))),
                    ]),
                    const SizedBox(
                      height: 10,
                    ),
                    Row(children: [
                      Expanded(
                          child: TextButton(
                              onPressed: () {
                                setState(() {
                                  relayValue[3] = relayValue[3] == 1 ? 0 : 1;
                                  btnValShortcut[0] = 0;
                                  btnValShortcut[1] = 0;
                                  btnValShortcut[2] = 0;
                                  setStateRelay(
                                      token, "4", relayValue[3].toString());
                                });
                              },
                              child: Stack(
                                  alignment: Alignment.bottomCenter,
                                  children: <Widget>[
                                    Image.asset('assets/imagesv2/' +
                                        relayIcon[3] +
                                        ' ' +
                                        (relayValue[3] == 1
                                            ? 'kuning'
                                            : 'putih') +
                                        '.png'),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                        left: 0,
                                        top: 0,
                                        right: 0,
                                        bottom: 10,
                                      ),
                                      child: Text(
                                        relayName[3],
                                        style: TextStyle(
                                            color: relayValue[3] == 0
                                                ? Colors.white
                                                : Colors.yellow),
                                      ),
                                    )
                                  ]))),
                      Expanded(
                          child: TextButton(
                              onPressed: () async {
                                await LaunchApp.openApp(
                                    androidPackageName: 'com.mobile.myeye',
                                    iosUrlScheme: 'xmeye://',
                                    appStoreLink:
                                        'itms-apps://itunes.apple.com/us/app/xmeye/id884006786',
                                    openStore: false);
                              },
                              child: Stack(
                                  alignment: Alignment.bottomCenter,
                                  children: <Widget>[
                                    Image.asset(
                                        'assets/imagesv2/cctv putih.png'),
                                    const Padding(
                                      padding: EdgeInsets.only(
                                        left: 0,
                                        top: 0,
                                        right: 0,
                                        bottom: 10,
                                      ),
                                      child: Text(
                                        'CCTV',
                                        style: TextStyle(color: Colors.white),
                                      ),
                                    )
                                  ]))),
                      Expanded(
                          child: TextButton(
                              onPressed: () {
                                setState(() {
                                  relayValue[4] = relayValue[4] == 1 ? 0 : 1;
                                  btnValShortcut[0] = 0;
                                  btnValShortcut[1] = 0;
                                  btnValShortcut[2] = 0;
                                  setStateRelay(
                                      token, "5", relayValue[4].toString());
                                });
                              },
                              child: Stack(
                                  alignment: Alignment.bottomCenter,
                                  children: <Widget>[
                                    Image.asset('assets/imagesv2/' +
                                        relayIcon[4] +
                                        ' ' +
                                        (relayValue[4] == 1
                                            ? 'kuning'
                                            : 'putih') +
                                        '.png'),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                        left: 0,
                                        top: 0,
                                        right: 0,
                                        bottom: 10,
                                      ),
                                      child: Text(
                                        relayName[4],
                                        style: TextStyle(
                                            color: relayValue[4] == 0
                                                ? Colors.white
                                                : Colors.yellow),
                                      ),
                                    )
                                  ]))),
                    ]),
                    const SizedBox(
                      height: 10,
                    ),
                    Row(children: [
                      Expanded(
                          child: TextButton(
                              onPressed: () {
                                setState(() {
                                  relayValue[5] = relayValue[5] == 1 ? 0 : 1;
                                  btnValShortcut[0] = 0;
                                  btnValShortcut[1] = 0;
                                  btnValShortcut[2] = 0;
                                  setStateRelay(
                                      token, "6", relayValue[5].toString());
                                });
                              },
                              child: Stack(
                                  alignment: Alignment.bottomCenter,
                                  children: <Widget>[
                                    Image.asset('assets/imagesv2/' +
                                        relayIcon[5] +
                                        ' ' +
                                        (relayValue[5] == 1
                                            ? 'kuning'
                                            : 'putih') +
                                        '.png'),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                        left: 0,
                                        top: 0,
                                        right: 0,
                                        bottom: 10,
                                      ),
                                      child: Text(
                                        relayName[5],
                                        style: TextStyle(
                                            color: relayValue[5] == 0
                                                ? Colors.white
                                                : Colors.yellow),
                                      ),
                                    )
                                  ]))),
                      Expanded(
                          child: TextButton(
                              onPressed: () {
                                setState(() {
                                  relayValue[6] = relayValue[6] == 1 ? 0 : 1;
                                  btnValShortcut[0] = 0;
                                  btnValShortcut[1] = 0;
                                  btnValShortcut[2] = 0;
                                  setStateRelay(
                                      token, "7", relayValue[6].toString());
                                });
                              },
                              child: Stack(
                                  alignment: Alignment.bottomCenter,
                                  children: <Widget>[
                                    Image.asset('assets/imagesv2/' +
                                        relayIcon[6] +
                                        ' ' +
                                        (relayValue[6] == 1
                                            ? 'kuning'
                                            : 'putih') +
                                        '.png'),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                        left: 0,
                                        top: 0,
                                        right: 0,
                                        bottom: 10,
                                      ),
                                      child: Text(
                                        relayName[6],
                                        style: TextStyle(
                                            color: relayValue[6] == 0
                                                ? Colors.white
                                                : Colors.yellow),
                                      ),
                                    )
                                  ]))),
                      Expanded(
                          child: TextButton(
                              onPressed: () {
                                setState(() {
                                  relayValue[7] = relayValue[7] == 1 ? 0 : 1;
                                  btnValShortcut[0] = 0;
                                  btnValShortcut[1] = 0;
                                  btnValShortcut[2] = 0;
                                  setStateRelay(
                                      token, "8", relayValue[7].toString());
                                });
                              },
                              child: Stack(
                                  alignment: Alignment.bottomCenter,
                                  children: <Widget>[
                                    Image.asset('assets/imagesv2/' +
                                        relayIcon[7] +
                                        ' ' +
                                        (relayValue[7] == 1
                                            ? 'kuning'
                                            : 'putih') +
                                        '.png'),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                        left: 0,
                                        top: 0,
                                        right: 0,
                                        bottom: 10,
                                      ),
                                      child: Text(
                                        relayName[7],
                                        style: TextStyle(
                                            color: relayValue[7] == 0
                                                ? Colors.white
                                                : Colors.yellow),
                                      ),
                                    )
                                  ]))),
                    ])
                  ],
                )),
          ],
        ),
      ),
    );
  }
}
