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

class init_Dashboardv5 extends StatelessWidget {
  // final box = GetStorage();
  // String token = "";

  @override
  Widget build(BuildContext context) {
    // String token = box.read('token');
    return MaterialApp(
      title: "Dashboard",
      theme: ThemeData(
        primaryColor: Colors.white,
      ),
      home: const Scaffold(
        body: Dashboardv5(),
      ),
    );
  }
}

class Dashboardv5 extends StatefulWidget {
  // const Dashboardv2({Key? key}) : super(key: key);
  const Dashboardv5();
  @override
  State<Dashboardv5> createState() => _Dashboardv5();
}

class _Dashboardv5 extends State<Dashboardv5> {
  final box = GetStorage();
  // String token = "";

  // var vr1 = 99;
  // var vr2 = 99;
  // var vr3 = 99;
  // var vr4 = 99;
  // var vr5 = 99;
  // var vr6 = 99;
  // var vr7 = 99;
  // var vr8 = 99;

  var rVal = [99, 99, 99, 99, 99, 99, 99, 99];
  getTampilanVar(int rel, String pathIcon, Color colorIcon, String labelBtn) {
    // log(rVal[0].toString() +
    //     " " +
    //     rVal[1].toString() +
    //     " " +
    //     rVal[2].toString() +
    //     " " +
    //     rVal[3].toString() +
    //     " " +
    //     rVal[4].toString() +
    //     " " +
    //     rVal[5].toString() +
    //     " " +
    //     rVal[6].toString() +
    //     " " +
    //     rVal[7].toString());
    if (rVal[rel - 1] != 99) {
      return InkWell(
        customBorder: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(40),
        ),
        onTap: () {},
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
                      pathIcon,
                      color: rVal[rel - 1] == 1 ? colorIcon : Colors.black,
                    ),
                  ),
                  const SizedBox(height: 5.0),
                  Center(
                    child: Text(labelBtn,
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
                color: rVal[rel - 1] == 1 ? Colors.red : Colors.black,
              )
            ],
          ),
        ),
      );
    } else {
      return const Center(child: CircularProgressIndicator());
    }
  }

  getStateRelay(String token, String relay) async {
    var response = await http.post(
      Uri.parse("https://iot.tigamas.com/api/app/action"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(<String, String>{
        "action": "getStatusRelay",
        "relay": relay,
        "token": token
      }),
    );
    // print(token);
    // print(response.body);
    return response.body;
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
    // print(response.body);
    return response.body;
  }

  // final Widget svg_ac = SvgPicture.asset(
  //   "images/air-conditioner.svg",
  //   color: Colors.amber,
  // );

  // final Icon icon_ac = SvgPicture.asset(
  //   "images/air-conditioner.svg",
  //   color: Colors.amber,
  // ) as Icon;

  SizedBox icon_ac2 = SizedBox(
    height: 59,
    width: 59,
    child: SvgPicture.asset(
      'images/air-conditioner.svg',
      color: Colors.amber,
    ),
  );

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

  // var timestamp = true;
  // @override
  // void initState() {
  //   Timer mytimer = Timer.periodic(Duration(seconds: 10), (timer) {
  //     setState(() {
  //       timestamp = !timestamp;
  //     });
  //   });
  //   super.initState();
  // }

  @override
  Widget build(BuildContext context) {
    // var timestamp = true;
    // Timer mytimer = Timer.periodic(Duration(seconds: 10), (timer) {
    //   setState(() {
    //     timestamp = !timestamp;
    //   });
    // });
    String token = box.read('token').toString();
    // print("token: " + token);

    // debugPrint(rVal[0].toString() +
    //     " " +
    //     rVal[1].toString() +
    //     " " +
    //     rVal[2].toString() +
    //     " " +
    //     rVal[3].toString() +
    //     " " +
    //     rVal[4].toString() +
    //     " " +
    //     rVal[5].toString() +
    //     " " +
    //     rVal[6].toString() +
    //     " " +
    //     rVal[7].toString());

    return Container(
      child: ListView(
        children: [
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
                FutureBuilder(
                  future: getStateRelay(token, "1"),
                  builder: (BuildContext context, AsyncSnapshot snapshot) {
                    if (snapshot.connectionState == ConnectionState.done) {
                      if (snapshot.data == null) {
                        return Text("Ada yang salah, cek internet anda");
                      }
                      var hasil = jsonDecode(snapshot.data);
                      if (hasil.toString() == "[]") {
                        return Text("Invalid token");
                      }
                      rVal[int.parse(hasil['relay']) - 1] =
                          int.parse(hasil['state']);
                      return InkWell(
                        customBorder: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(40),
                        ),
                        onTap: () {
                          setState(() {
                            setStateRelay(token, "1",
                                int.parse(hasil['state']) == 1 ? "0" : "1");
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
                                      color: int.parse(hasil['state']) == 1
                                          ? Colors.amber
                                          : Colors.black,
                                    ),
                                  ),
                                  const SizedBox(height: 5.0),
                                  Center(
                                    child: Text("Lampu 1",
                                        style: const TextStyle(
                                            fontSize: 20.0,
                                            color: Colors.black)),
                                  )
                                ],
                              ),
                              const SizedBox(
                                width: 20,
                              ),
                              Icon(
                                FontAwesomeIcons.powerOff,
                                size: 30.0,
                                color: int.parse(hasil['state']) == 1
                                    ? Colors.red
                                    : Colors.black,
                              )
                            ],
                          ),
                        ),
                      );
                    } else {
                      return getTampilanVar(
                          1, getIcon("lamp"), Colors.amber, "Lampu 1");
                    }
                  },
                ),
                FutureBuilder(
                  future: getStateRelay(token, "2"),
                  builder: (BuildContext context, AsyncSnapshot snapshot) {
                    if (snapshot.connectionState == ConnectionState.done) {
                      var hasil = jsonDecode(snapshot.data);
                      if (hasil.toString() == "[]") {
                        return Text("Invalid token");
                      }
                      rVal[int.parse(hasil['relay']) - 1] =
                          int.parse(hasil['state']);
                      return InkWell(
                        customBorder: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(40),
                        ),
                        onTap: () {
                          setState(() {
                            setStateRelay(token, "2",
                                int.parse(hasil['state']) == 1 ? "0" : "1");
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
                                      color: int.parse(hasil['state']) == 1
                                          ? Color.fromRGBO(76, 133, 186, 1)
                                          : Colors.black,
                                    ),
                                  ),
                                  const SizedBox(height: 5.0),
                                  Center(
                                    child: Text("AC 1",
                                        style: const TextStyle(
                                            fontSize: 20.0,
                                            color: Colors.black)),
                                  )
                                ],
                              ),
                              const SizedBox(
                                width: 20,
                              ),
                              Icon(
                                FontAwesomeIcons.powerOff,
                                size: 30.0,
                                color: int.parse(hasil['state']) == 1
                                    ? Colors.red
                                    : Colors.black,
                              )
                            ],
                          ),
                        ),
                      );
                    } else {
                      return getTampilanVar(2, getIcon("ac"),
                          Color.fromRGBO(76, 133, 186, 1), "AC 1");
                    }
                  },
                ),
                FutureBuilder(
                  future: getStateRelay(token, "3"),
                  builder: (BuildContext context, AsyncSnapshot snapshot) {
                    if (snapshot.connectionState == ConnectionState.done) {
                      var hasil = jsonDecode(snapshot.data);
                      if (hasil.toString() == "[]") {
                        return Text("Invalid token");
                      }
                      rVal[int.parse(hasil['relay']) - 1] =
                          int.parse(hasil['state']);
                      return InkWell(
                        customBorder: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(40),
                        ),
                        onTap: () {
                          setState(() {
                            setStateRelay(token, "3",
                                int.parse(hasil['state']) == 1 ? "0" : "1");
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
                                      color: int.parse(hasil['state']) == 1
                                          ? Color.fromRGBO(184, 26, 183, 1)
                                          : Colors.black,
                                    ),
                                  ),
                                  const SizedBox(height: 5.0),
                                  const Center(
                                    child: Text("TV 1",
                                        style: TextStyle(
                                            fontSize: 20.0,
                                            color: Colors.black)),
                                  )
                                ],
                              ),
                              const SizedBox(
                                width: 20,
                              ),
                              Icon(
                                FontAwesomeIcons.powerOff,
                                size: 30.0,
                                color: int.parse(hasil['state']) == 1
                                    ? Colors.red
                                    : Colors.black,
                              )
                            ],
                          ),
                        ),
                      );
                    } else {
                      return getTampilanVar(3, getIcon("tv"),
                          Color.fromRGBO(184, 26, 183, 1), "TV 1");
                    }
                  },
                ),
                FutureBuilder(
                  future: getStateRelay(token, "4"),
                  builder: (BuildContext context, AsyncSnapshot snapshot) {
                    if (snapshot.connectionState == ConnectionState.done) {
                      var hasil = jsonDecode(snapshot.data);
                      if (hasil.toString() == "[]") {
                        return Text("Invalid token");
                      }
                      rVal[int.parse(hasil['relay']) - 1] =
                          int.parse(hasil['state']);
                      return InkWell(
                        customBorder: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(40),
                        ),
                        onTap: () {
                          setState(() {
                            setStateRelay(token, "4",
                                int.parse(hasil['state']) == 1 ? "0" : "1");
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
                                      color: int.parse(hasil['state']) == 1
                                          ? Colors.amber
                                          : Colors.black,
                                    ),
                                  ),
                                  const SizedBox(height: 5.0),
                                  Center(
                                    child: Text("Lampu 2",
                                        style: const TextStyle(
                                            fontSize: 20.0,
                                            color: Colors.black)),
                                  )
                                ],
                              ),
                              const SizedBox(
                                width: 20,
                              ),
                              Icon(
                                FontAwesomeIcons.powerOff,
                                size: 30.0,
                                color: int.parse(hasil['state']) == 1
                                    ? Colors.red
                                    : Colors.black,
                              )
                            ],
                          ),
                        ),
                      );
                    } else {
                      return getTampilanVar(
                          4, getIcon("lamp"), Colors.amber, "Lampu 2");
                    }
                  },
                ),
              ],
            ),
          ),
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
                FutureBuilder(
                  future: getStateRelay(token, "5"),
                  builder: (BuildContext context, AsyncSnapshot snapshot) {
                    if (snapshot.connectionState == ConnectionState.done) {
                      var hasil = jsonDecode(snapshot.data);
                      if (hasil.toString() == "[]") {
                        return Text("Invalid token");
                      }
                      rVal[int.parse(hasil['relay']) - 1] =
                          int.parse(hasil['state']);
                      return InkWell(
                        customBorder: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(40),
                        ),
                        onTap: () {
                          setState(() {
                            setStateRelay(token, "5",
                                int.parse(hasil['state']) == 1 ? "0" : "1");
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
                                      color: int.parse(hasil['state']) == 1
                                          ? Colors.amber
                                          : Colors.black,
                                    ),
                                  ),
                                  const SizedBox(height: 5.0),
                                  Center(
                                    child: Text("Lampu 3",
                                        style: const TextStyle(
                                            fontSize: 20.0,
                                            color: Colors.black)),
                                  )
                                ],
                              ),
                              const SizedBox(
                                width: 20,
                              ),
                              Icon(
                                FontAwesomeIcons.powerOff,
                                size: 30.0,
                                color: int.parse(hasil['state']) == 1
                                    ? Colors.red
                                    : Colors.black,
                              )
                            ],
                          ),
                        ),
                      );
                    } else {
                      return getTampilanVar(
                          5, getIcon("lamp"), Colors.amber, "Lampu 3");
                    }
                  },
                ),
                FutureBuilder(
                  future: getStateRelay(token, "6"),
                  builder: (BuildContext context, AsyncSnapshot snapshot) {
                    if (snapshot.connectionState == ConnectionState.done) {
                      var hasil = jsonDecode(snapshot.data);
                      if (hasil.toString() == "[]") {
                        return Text("Invalid token");
                      }
                      rVal[int.parse(hasil['relay']) - 1] =
                          int.parse(hasil['state']);
                      return InkWell(
                        customBorder: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(40),
                        ),
                        onTap: () {
                          setState(() {
                            setStateRelay(token, "6",
                                int.parse(hasil['state']) == 1 ? "0" : "1");
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
                                      color: int.parse(hasil['state']) == 1
                                          ? Colors.amber
                                          : Colors.black,
                                    ),
                                  ),
                                  const SizedBox(height: 5.0),
                                  Center(
                                    child: Text("Lampu 4",
                                        style: const TextStyle(
                                            fontSize: 20.0,
                                            color: Colors.black)),
                                  )
                                ],
                              ),
                              const SizedBox(
                                width: 20,
                              ),
                              Icon(
                                FontAwesomeIcons.powerOff,
                                size: 30.0,
                                color: int.parse(hasil['state']) == 1
                                    ? Colors.red
                                    : Colors.black,
                              )
                            ],
                          ),
                        ),
                      );
                    } else {
                      return getTampilanVar(
                          6, getIcon("lamp"), Colors.amber, "Lampu 4");
                    }
                  },
                ),
                FutureBuilder(
                  future: getStateRelay(token, "7"),
                  builder: (BuildContext context, AsyncSnapshot snapshot) {
                    if (snapshot.connectionState == ConnectionState.done) {
                      var hasil = jsonDecode(snapshot.data);
                      if (hasil.toString() == "[]") {
                        return Text("Invalid token");
                      }
                      rVal[int.parse(hasil['relay']) - 1] =
                          int.parse(hasil['state']);
                      return InkWell(
                        customBorder: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(40),
                        ),
                        onTap: () {
                          setState(() {
                            setStateRelay(token, "7",
                                int.parse(hasil['state']) == 1 ? "0" : "1");
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
                                      color: int.parse(hasil['state']) == 1
                                          ? Color.fromRGBO(76, 133, 186, 1)
                                          : Colors.black,
                                    ),
                                  ),
                                  const SizedBox(height: 5.0),
                                  Center(
                                    child: Text("AC 2",
                                        style: const TextStyle(
                                            fontSize: 20.0,
                                            color: Colors.black)),
                                  )
                                ],
                              ),
                              const SizedBox(
                                width: 20,
                              ),
                              Icon(
                                FontAwesomeIcons.powerOff,
                                size: 30.0,
                                color: int.parse(hasil['state']) == 1
                                    ? Colors.red
                                    : Colors.black,
                              )
                            ],
                          ),
                        ),
                      );
                    } else {
                      return getTampilanVar(7, getIcon("ac"),
                          Color.fromRGBO(76, 133, 186, 1), "AC 2");
                    }
                  },
                ),
                FutureBuilder(
                  future: getStateRelay(token, "8"),
                  builder: (BuildContext context, AsyncSnapshot snapshot) {
                    if (snapshot.connectionState == ConnectionState.done) {
                      var hasil = jsonDecode(snapshot.data);
                      if (hasil.toString() == "[]") {
                        return Text("Invalid token");
                      }
                      rVal[int.parse(hasil['relay']) - 1] =
                          int.parse(hasil['state']);
                      return InkWell(
                        customBorder: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(40),
                        ),
                        onTap: () {
                          setState(() {
                            setStateRelay(token, "8",
                                int.parse(hasil['state']) == 1 ? "0" : "1");
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
                                      color: int.parse(hasil['state']) == 1
                                          ? const Color.fromRGBO(
                                              184, 26, 183, 1)
                                          : Colors.black,
                                    ),
                                  ),
                                  const SizedBox(height: 5.0),
                                  const Center(
                                    child: Text("TV 2",
                                        style: TextStyle(
                                            fontSize: 20.0,
                                            color: Colors.black)),
                                  )
                                ],
                              ),
                              const SizedBox(
                                width: 20,
                              ),
                              Icon(
                                FontAwesomeIcons.powerOff,
                                size: 30.0,
                                color: int.parse(hasil['state']) == 1
                                    ? Colors.red
                                    : Colors.black,
                              )
                            ],
                          ),
                        ),
                      );
                    } else {
                      return getTampilanVar(8, getIcon("tv"),
                          const Color.fromRGBO(184, 26, 183, 1), "TV 2");
                    }
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
