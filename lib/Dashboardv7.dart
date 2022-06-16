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
import 'package:tigamas_app/Setting.dart';
import 'Chat.dart';
import 'main.dart';
import 'Session.dart';
import 'package:external_app_launcher/external_app_launcher.dart';

class init_Dashboardv7 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // String token = box.read('token');
    return MaterialApp(
      title: "Dashboard",
      theme: ThemeData(
        primaryColor: Colors.white,
      ),
      home: const Scaffold(
        body: Dashboardv7(),
      ),
    );
  }
}

class Dashboardv7 extends StatefulWidget {
  const Dashboardv7({Key? key}) : super(key: key);
  // const Dashboardv7();
  @override
  State<Dashboardv7> createState() => _Dashboardv7();
}

class _Dashboardv7 extends State<Dashboardv7> {
  final box = GetStorage();
  Session session = Session();
  int mode = 0;
  List<int> rVal = [99, 99, 99, 99, 99, 99, 99, 99];
  List<String> rIconPath = [
    'lamp',
    'lamp',
    'lamp',
    'lamp',
    'lamp',
    'lamp',
    'lamp',
    'lamp'
  ];
  List<String> rNama = [
    'Relay',
    'Relay',
    'Relay',
    'Relay',
    'Relay',
    'Relay',
    'Relay',
    'Relay',
  ];

  List<int> shortcutSiang = List.generate(8, (i) => 0);
  List<int> shortcutMalam = List.generate(8, (i) => 0);
  List<int> shortcutPergi = List.generate(8, (i) => 0);

  Color getColorByIcon(String icon) {
    switch (icon) {
      case "ac":
        return const Color.fromRGBO(76, 133, 186, 1);
      case "lamp":
        return Colors.amber;
      case "tv":
        return const Color.fromRGBO(184, 26, 183, 1);
      case "lock":
        return Color.fromARGB(255, 187, 16, 16);
      default:
        return Colors.amber;
    }
  }

  setStateRelay(String token, String relay, String state) async {
    // var response = await http.post(
    //   Uri.parse("https://iot.tigamas.com/api/app/action"),
    //   headers: {"Content-Type": "application/json"},
    //   body: jsonEncode(<String, String>{
    //     "action": "setStatusRelay",
    //     "relay": relay,
    //     "token": token,
    //     "state": state
    //   }),
    // );

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

  getStatus(String token) async {
    // var response = await http.post(
    //   Uri.parse("https://iot.tigamas.com/api/app/action"),
    //   headers: {"Content-Type": "application/json"},
    //   body: jsonEncode(<String, String>{
    //     "action": "getStatus",
    //     "token": token,
    //   }),
    // );

    // setState(() {
    //   rVal = json.decode(response.body)['dataValue'].cast<int>();
    //   rNama = json.decode(response.body)['dataName'].cast<String>();
    //   rIconPath = json.decode(response.body)['dataIcon'].cast<String>();
    //   shortcutSiang = json.decode(response.body)['shortcutSiang'].cast<int>();
    //   shortcutMalam = json.decode(response.body)['shortcutMalam'].cast<int>();
    //   shortcutPergi = json.decode(response.body)['shortcutPergi'].cast<int>();
    // });

    var res = await session.post("https://iot.tigamas.com/api/app/action",
        jsonEncode(<String, String>{"action": "getStatus", "token": token}));
    // debugPrint(jsonEncode(res));
    if (res['session']) {
      setState(() {
        rVal = res['dataValue'].cast<int>();
        rNama = res['dataName'].cast<String>();
        rIconPath = res['dataIcon'].cast<String>();
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

  void goBackLogin() async {
    String token = box.read('token').toString();
    var res = await session.post("https://iot.tigamas.com/api/app/action",
        jsonEncode(<String, String>{"action": "logout", "token": token}));
    box.remove('token');
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => MyApp()),
    );
  }

  void shortcutRelay(String whatshortcut) {
    String token = box.read('token').toString();
    switch (whatshortcut) {
      case "siang":
        setState(() {
          for (var i = 0; i < shortcutSiang.length; i++) {
            setStateRelay(
                token, (i + 1).toString(), shortcutSiang[i].toString());
          }
          rVal = shortcutSiang;
        });
        break;
      case "malam":
        setState(() {
          for (var i = 0; i < shortcutMalam.length; i++) {
            setStateRelay(
                token, (i + 1).toString(), shortcutMalam[i].toString());
          }
          rVal = shortcutMalam;
        });
        break;
      case "pergi":
        setState(() {
          for (var i = 0; i < shortcutPergi.length; i++) {
            setStateRelay(
                token, (i + 1).toString(), shortcutPergi[i].toString());
          }
          rVal = shortcutPergi;
        });
        break;
      default:
        debugPrint("Wrong shortcut");
    }
  }

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
      case "cctv":
        return 'assets/images/cctv.svg';
      case "lock":
        return 'assets/images/lock.svg';
      default:
        debugPrint(whaticon);
        return 'assets/images/lightning.svg';
    }
  }

  @override
  void initState() {
    super.initState();
    String token = box.read('token').toString();
    // print(box.read('mode'));
    mode = box.read('mode') ?? 0;
    getStatus(token);
  }

  @override
  Widget build(BuildContext context) {
    String token = box.read('token').toString();

    return ListView(children: [
      Container(
        height: 180,
        decoration: const BoxDecoration(
          color: Color.fromARGB(255, 250, 250, 250),
          image: DecorationImage(
              alignment: Alignment.topLeft,
              // image: AssetImage("assets/images/bg_menu.png"),
              image: AssetImage("assets/images/logo_IG.png"),
              fit: BoxFit.fitHeight),
          //     gradient: LinearGradient(
          //   begin: Alignment.bottomCenter,
          //   end: Alignment.topCenter,
          //   colors: [
          //     Color.fromRGBO(250, 250, 250, 1),
          //     Colors.amber,
          //   ],
          // )
        ),
        child: Padding(
            padding: const EdgeInsets.only(
              left: 0,
              top: 10,
              right: 0,
              bottom: 0,
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                // Expanded(
                //   child: Image.asset("assets/images/logo_tigamas2.png"),
                // ),
                const Expanded(
                  child: Text(""),
                ),
                InkWell(
                  onTap: () async {
                    await LaunchApp.openApp(
                        androidPackageName: 'com.mobile.myeye',
                        iosUrlScheme: 'xmeye://',
                        appStoreLink:
                            'itms-apps://itunes.apple.com/us/app/xmeye/id884006786',
                        openStore: false);
                  },
                  child: SizedBox(
                      height: 40,
                      width: 40,
                      child: SvgPicture.asset(getIcon("cctv"),
                          color: Colors.amber)),
                ),
                const SizedBox(
                  width: 10,
                ),
                InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const Chat()),
                    );
                  },
                  child: SizedBox(
                      height: 40,
                      width: 40,
                      child: SvgPicture.asset(getIcon("chat"),
                          color: Colors.amber)),
                ),
                const SizedBox(
                  width: 5,
                ),
                InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const Setting()),
                    );
                  },
                  child: SizedBox(
                      height: 40,
                      width: 40,
                      child: SvgPicture.asset(
                        getIcon("setting"),
                        color: Colors.amber,
                      )),
                ),
                // const SizedBox(
                //   width: 5,
                // ),
                InkWell(
                  onTap: () {
                    // Log Out
                    goBackLogin();
                  },
                  child: SizedBox(
                      height: 40,
                      width: 40,
                      child: SvgPicture.asset(getIcon("logout"),
                          color: Colors.amber)),
                ),
                // const SizedBox(
                //   width: 10,
                // )
              ],
            )),
      ),
      // Row(
      //   mainAxisAlignment: MainAxisAlignment.center,
      //   crossAxisAlignment: CrossAxisAlignment.center,
      //   children: <Widget>[
      //     Expanded(
      //         child: InkWell(
      //       onTap: () {},
      //       child: Container(
      //         height: 100,
      //         alignment: Alignment.center,
      //         child: Card(
      //           shape: RoundedRectangleBorder(
      //             borderRadius: BorderRadius.circular(40.0),
      //           ),
      //           child: Text("data"),
      //         ),
      //       ),
      //     )),
      //   ],
      // ),
      Center(
        child: ButtonBar(
          mainAxisSize: MainAxisSize
              .min, // this will take space as minimum as posible(to center)
          children: <Widget>[
            TextButton(
              child: Container(
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color: mode == 1 ? Colors.grey : Colors.white,
                      blurRadius: 15.0,
                    ),
                  ],
                ),
                child: Card(
                  color: mode == 1
                      ? Color.fromRGBO(228, 229, 231, 1)
                      : Colors.white,
                  child: Padding(
                    padding: const EdgeInsets.only(
                      left: 15,
                      top: 10,
                      right: 15,
                      bottom: 10,
                    ),
                    child: Column(
                      children: const <Widget>[
                        Icon(
                          FontAwesomeIcons.cloudSun,
                          size: 30.0,
                          color: Colors.amber,
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Center(
                          child: Text("Siang"),
                        )
                      ],
                    ),
                  ),
                ),
              ),
              onPressed: () {
                setState(() {
                  mode = 1;
                  box.write('mode', 1);
                });
                shortcutRelay("siang");
              },
            ),
            TextButton(
              child: Container(
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color: mode == 2 ? Colors.grey : Colors.white,
                      blurRadius: 15.0,
                    ),
                  ],
                ),
                child: Card(
                  color: mode == 2
                      ? Color.fromRGBO(228, 229, 231, 1)
                      : Colors.white,
                  child: Padding(
                    padding: const EdgeInsets.only(
                      left: 15,
                      top: 10,
                      right: 15,
                      bottom: 10,
                    ),
                    child: Column(
                      children: const <Widget>[
                        Icon(
                          FontAwesomeIcons.cloudMoon,
                          size: 30.0,
                          color: Colors.amber,
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Center(
                          child: Text("Malam"),
                        )
                      ],
                    ),
                  ),
                ),
              ),
              onPressed: () {
                setState(() {
                  mode = 2;
                  box.write('mode', 2);
                });
                shortcutRelay("malam");
              },
            ),
            TextButton(
              child: Container(
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color: mode == 3 ? Colors.grey : Colors.white,
                      blurRadius: 15.0,
                    ),
                  ],
                ),
                child: Card(
                  color: mode == 3
                      ? Color.fromRGBO(228, 229, 231, 1)
                      : Colors.white,
                  child: Padding(
                    padding: const EdgeInsets.only(
                      left: 15,
                      top: 10,
                      right: 15,
                      bottom: 10,
                    ),
                    child: Column(
                      children: const <Widget>[
                        Icon(
                          FontAwesomeIcons.planeDeparture,
                          size: 30.0,
                          color: Colors.amber,
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Center(
                          child: Text("Pergi"),
                        )
                      ],
                    ),
                  ),
                ),
              ),
              onPressed: () {
                setState(() {
                  mode = 3;
                  box.write('mode', 3);
                });
                shortcutRelay("pergi");
              },
            ),
            // TextButton(
            //   child: Container(
            //     decoration: BoxDecoration(
            //       boxShadow: [
            //         BoxShadow(
            //           color: mode == 4 ? Colors.grey : Colors.white,
            //           blurRadius: 15.0,
            //         ),
            //       ],
            //     ),
            //     child: Card(
            //       color: mode == 4
            //           ? Color.fromRGBO(228, 229, 231, 1)
            //           : Colors.white,
            //       child: Padding(
            //         padding: const EdgeInsets.only(
            //           left: 15,
            //           top: 10,
            //           right: 15,
            //           bottom: 10,
            //         ),
            //         child: Column(
            //           children: const <Widget>[
            //             Icon(
            //               FontAwesomeIcons.cog,
            //               size: 30.0,
            //               color: Colors.amber,
            //             ),
            //             SizedBox(
            //               height: 10,
            //             ),
            //             Center(
            //               child: Text("Custom"),
            //             )
            //           ],
            //         ),
            //       ),
            //     ),
            //   ),
            //   onPressed: () {
            //     setState(() {
            //       mode = 4;
            //       box.write('mode', 4);
            //     });
            //   },
            // ),
          ],
        ),
      ),
      GridView.builder(
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
          ),
          shrinkWrap: true,
          itemCount: 8,
          itemBuilder: (BuildContext ctx, int index) {
            return InkWell(
              customBorder: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(40),
              ),
              onTap: () {
                rVal[index] = rVal[index] == 1 ? 0 : 1;
                setState(() {
                  mode = 0;
                  box.write('mode', 0);
                  setStateRelay(
                      token, (index + 1).toString(), rVal[index].toString());
                });
              },
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(40.0),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(
                          height: 59,
                          width: 59,
                          child: SvgPicture.asset(
                            // "assets/images/" + rIconPath[index] + ".svg",
                            getIcon(rIconPath[index]),
                            color: rVal[index] == 1
                                ? getColorByIcon(rIconPath[index])
                                : Colors.black,
                          ),
                        ),
                        const SizedBox(height: 5.0),
                        Center(
                          child: Text(rNama[index],
                              style: const TextStyle(
                                  fontSize: 20.0, color: Colors.black)),
                        )
                      ],
                    ),
                    const SizedBox(
                      width: 20,
                    ),
                    Icon(
                      FontAwesomeIcons.powerOff,
                      size: 30.0,
                      color: rVal[index] == 1 ? Colors.red : Colors.black,
                    )
                  ],
                ),
              ),
            );
          }),
    ]);
  }
}
