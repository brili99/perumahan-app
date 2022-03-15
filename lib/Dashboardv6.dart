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
import 'main.dart';

class init_Dashboardv6 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // String token = box.read('token');
    return MaterialApp(
      title: "Dashboard",
      theme: ThemeData(
        primaryColor: Colors.white,
      ),
      home: const Scaffold(
        body: Dashboardv6(),
      ),
    );
  }
}

class Dashboardv6 extends StatefulWidget {
  // const Dashboardv2({Key? key}) : super(key: key);
  const Dashboardv6();
  @override
  State<Dashboardv6> createState() => _Dashboardv6();
}

class _Dashboardv6 extends State<Dashboardv6> {
  final box = GetStorage();

  List<int> rVal = [99, 99, 99, 99, 99, 99, 99, 99];

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
    rVal = json.decode(response.body)['data'].cast<int>();
    setState(() {});
    // print(rVal);
    return response.body;
  }

  getIcon(String whaticon) {
    switch (whaticon) {
      case "ac":
        return 'assets/images/air-conditioner.svg';
      case "lamp":
        return 'assets/images/lamp.svg';
      case "tv":
        return 'assets/images/tv.svg';
      case "logout":
        return 'assets/images/logout.svg';
      default:
        return 'assets/images/lightning.svg';
    }
  }

  getIconbyOrder(int index) {
    switch (index) {
      case 0:
        return getIcon("lamp");
      case 1:
        return getIcon("ac");
      case 2:
        return getIcon("tv");
      case 3:
        return getIcon("lamp");
      case 4:
        return getIcon("lamp");
      case 5:
        return getIcon("lamp");
      case 6:
        return getIcon("ac");
      case 7:
        return getIcon("tv");
      default:
        return 'assets/images/lightning.svg';
    }
  }

  getTextbyOrder(int index) {
    switch (index) {
      case 0:
        return "Lampu 1";
      case 1:
        return "AC 1";
      case 2:
        return "TV 1";
      case 3:
        return "Lampu 2";
      case 4:
        return "Lampu 3";
      case 5:
        return "Lampu 4";
      case 6:
        return "AC 2";
      case 7:
        return "TV 2";
      default:
        return "Relay";
    }
  }

  Future<List<dynamic>> fetchPost(token) async {
    final response = await http.post(
      Uri.parse("https://iot.tigamas.com/api/app/action"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(<String, String>{
        "action": "getStatus",
        "token": token,
      }),
    );

    if (response.statusCode == 200) {
      rVal = json.decode(response.body)['data'].cast<int>();
      return rVal;
    } else {
      // If that call was not successful, throw an error.
      throw Exception('Failed to load post');
    }
  }

  @override
  void initState() {
    super.initState();
    String token = box.read('token').toString();

    getStatus(token);
    // debugPrint(getStatus(token));
    // rVal = json.decode(getStatus(token))['data'].cast<int>();
    // fetchPost(box.read('token').toString());
    // box.write('data', getStatus(token));
  }

  @override
  Widget build(BuildContext context) {
    String token = box.read('token').toString();

    return ListView(children: [
      Container(
        height: 180,
        decoration: const BoxDecoration(
          // color: Color.fromARGB(255, 255, 255, 255),
          image: DecorationImage(
              alignment: Alignment.topCenter,
              image: AssetImage("assets/images/bg_dashboard2.jpg"),
              fit: BoxFit.contain),
        ),
        child: Center(
            child: Padding(
                padding: const EdgeInsets.only(
                  left: 300,
                  top: 0,
                  right: 0,
                  bottom: 0,
                ),
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
                ))),
      ),
      const Padding(
        padding: EdgeInsets.fromLTRB(25, 25, 0, 0),
        child: Text(
          "Ruang Tamu",
          style: TextStyle(fontSize: 30),
        ),
      ),
      Center(
          child: GridView.count(
        physics: const NeverScrollableScrollPhysics(),
        crossAxisCount: 2,
        shrinkWrap: true,
        children: [
          InkWell(
            customBorder: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(40),
            ),
            onTap: () {
              rVal[0] = rVal[0] == 1 ? 0 : 1;
              setState(() {
                setStateRelay(token, "1", rVal[0].toString());
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
                          getIcon("lamp"),
                          color: rVal[0] == 1 ? Colors.amber : Colors.black,
                        ),
                      ),
                      const SizedBox(height: 5.0),
                      Center(
                        child: Text("Lampu 1",
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
                    color: rVal[0] == 1 ? Colors.red : Colors.black,
                  )
                ],
              ),
            ),
          ),
          InkWell(
            customBorder: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(40),
            ),
            onTap: () {
              rVal[1] = rVal[1] == 1 ? 0 : 1;
              setState(() {
                setStateRelay(token, "2", rVal[1].toString());
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
                          getIcon("ac"),
                          color: rVal[1] == 1
                              ? Color.fromRGBO(76, 133, 186, 1)
                              : Colors.black,
                        ),
                      ),
                      const SizedBox(height: 5.0),
                      Center(
                        child: Text("AC 1",
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
                    color: rVal[1] == 1 ? Colors.red : Colors.black,
                  )
                ],
              ),
            ),
          ),
          InkWell(
            customBorder: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(40),
            ),
            onTap: () {
              rVal[2] = rVal[2] == 1 ? 0 : 1;
              setState(() {
                setStateRelay(token, "3", rVal[2].toString());
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
                          getIcon("tv"),
                          color: rVal[2] == 1
                              ? Color.fromRGBO(184, 26, 183, 1)
                              : Colors.black,
                        ),
                      ),
                      const SizedBox(height: 5.0),
                      Center(
                        child: Text("TV 1",
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
                    color: rVal[2] == 1 ? Colors.red : Colors.black,
                  )
                ],
              ),
            ),
          ),
          InkWell(
            customBorder: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(40),
            ),
            onTap: () {
              rVal[3] = rVal[3] == 1 ? 0 : 1;
              setState(() {
                setStateRelay(token, "4", rVal[3].toString());
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
                          getIcon("lamp"),
                          color: rVal[3] == 1 ? Colors.amber : Colors.black,
                        ),
                      ),
                      const SizedBox(height: 5.0),
                      Center(
                        child: Text("Lampu 2",
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
                    color: rVal[3] == 1 ? Colors.red : Colors.black,
                  )
                ],
              ),
            ),
          ),
        ],
      )),
      const Padding(
        padding: EdgeInsets.fromLTRB(25, 25, 0, 0),
        child: Text(
          "Ruang Keluarga",
          style: TextStyle(fontSize: 30),
        ),
      ),
      Center(
          child: GridView.count(
        physics: const NeverScrollableScrollPhysics(),
        crossAxisCount: 2,
        shrinkWrap: true,
        children: [
          InkWell(
            customBorder: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(40),
            ),
            onTap: () {
              rVal[4] = rVal[4] == 1 ? 0 : 1;
              setState(() {
                setStateRelay(token, "5", rVal[4].toString());
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
                          getIcon("lamp"),
                          color: rVal[4] == 1 ? Colors.amber : Colors.black,
                        ),
                      ),
                      const SizedBox(height: 5.0),
                      Center(
                        child: Text("Lampu 3",
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
                    color: rVal[4] == 1 ? Colors.red : Colors.black,
                  )
                ],
              ),
            ),
          ),
          InkWell(
            customBorder: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(40),
            ),
            onTap: () {
              rVal[5] = rVal[5] == 1 ? 0 : 1;
              setState(() {
                setStateRelay(token, "6", rVal[5].toString());
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
                          getIcon("lamp"),
                          color: rVal[5] == 1 ? Colors.amber : Colors.black,
                        ),
                      ),
                      const SizedBox(height: 5.0),
                      Center(
                        child: Text("Lampu 4",
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
                    color: rVal[5] == 1 ? Colors.red : Colors.black,
                  )
                ],
              ),
            ),
          ),
          InkWell(
            customBorder: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(40),
            ),
            onTap: () {
              rVal[6] = rVal[6] == 1 ? 0 : 1;
              setState(() {
                setStateRelay(token, "7", rVal[6].toString());
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
                          getIcon("tv"),
                          color: rVal[6] == 1
                              ? const Color.fromRGBO(184, 26, 183, 1)
                              : Colors.black,
                        ),
                      ),
                      const SizedBox(height: 5.0),
                      Center(
                        child: Text("TV 2",
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
                    color: rVal[6] == 1 ? Colors.red : Colors.black,
                  )
                ],
              ),
            ),
          ),
          InkWell(
            customBorder: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(40),
            ),
            onTap: () {
              rVal[7] = rVal[7] == 1 ? 0 : 1;
              setState(() {
                setStateRelay(token, "8", rVal[7].toString());
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
                          getIcon("ac"),
                          color: rVal[7] == 1
                              ? Color.fromRGBO(76, 133, 186, 1)
                              : Colors.black,
                        ),
                      ),
                      const SizedBox(height: 5.0),
                      Center(
                        child: Text("AC 2",
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
                    color: rVal[7] == 1 ? Colors.red : Colors.black,
                  )
                ],
              ),
            ),
          ),
        ],
      )),
    ]);
  }
}
