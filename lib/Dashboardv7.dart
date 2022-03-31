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
  State<Dashboardv7> createState() => _Dashboardv6();
}

class _Dashboardv6 extends State<Dashboardv7> {
  final box = GetStorage();
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

  Color getColorByIcon(String icon) {
    switch (icon) {
      case "ac":
        return const Color.fromRGBO(76, 133, 186, 1);
      case "lamp":
        return Colors.amber;
      case "tv":
        return const Color.fromRGBO(184, 26, 183, 1);
      default:
        return Colors.amber;
    }
  }

  setStateRelay(String token, String relay, String state) async {
    var response = await http.post(
      Uri.parse("https://iot.tigamas.com/api/app/action"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(<String, String>{
        "action": "setStatusRelay",
        "relay": relay,
        "token": token,
        "state": state
      }),
    );
    return response.body;
  }

  getStatus(String token) async {
    var response = await http.post(
      Uri.parse("https://iot.tigamas.com/api/app/action"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(<String, String>{
        "action": "getStatus",
        "token": token,
      }),
    );
    rVal = json.decode(response.body)['dataValue'].cast<int>();
    rNama = json.decode(response.body)['dataName'].cast<String>();
    rIconPath = json.decode(response.body)['dataIcon'].cast<String>();
    setState(() {});
    // print(rVal);
    return response.body;
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
      default:
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
            // color: Color.fromARGB(255, 255, 255, 255),
            // image: DecorationImage(
            //     alignment: Alignment.topCenter,
            //     image: AssetImage("assets/images/bg_dashboard2.jpg"),
            //     fit: BoxFit.contain),
            gradient: LinearGradient(
          begin: Alignment.bottomCenter,
          end: Alignment.topCenter,
          colors: [
            Color.fromRGBO(250, 250, 250, 1),
            Colors.amber,
          ],
        )),
        child: Padding(
            padding: const EdgeInsets.only(
              left: 300,
              top: 0,
              right: 0,
              bottom: 0,
            ),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const Chat()),
                      );
                    },
                    child: SizedBox(
                        height: 40,
                        width: 40,
                        child: SvgPicture.asset(getIcon("chat"))),
                  ),
                ),
                Expanded(
                  child: InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const Setting()),
                      );
                    },
                    child: SizedBox(
                        height: 40,
                        width: 40,
                        child: SvgPicture.asset(getIcon("setting"))),
                  ),
                ),
                Expanded(
                  child: InkWell(
                    onTap: () {
                      // Log Out
                      box.remove('token');
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => MyApp()),
                      );
                    },
                    child: SizedBox(
                        height: 40,
                        width: 40,
                        child: SvgPicture.asset(getIcon("logout"))),
                  ),
                ),
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
              },
            ),
            TextButton(
              child: Container(
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color: mode == 4 ? Colors.grey : Colors.white,
                      blurRadius: 15.0,
                    ),
                  ],
                ),
                child: Card(
                  color: mode == 4
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
                          FontAwesomeIcons.cog,
                          size: 30.0,
                          color: Colors.amber,
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Center(
                          child: Text("Custom"),
                        )
                      ],
                    ),
                  ),
                ),
              ),
              onPressed: () {
                setState(() {
                  mode = 4;
                  box.write('mode', 4);
                });
              },
            ),
          ],
        ),
      ),
      GridView.builder(
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
