import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:get_storage/get_storage.dart';
import 'package:flutter/cupertino.dart';

class init_Dashboardv4 extends StatelessWidget {
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
        body: Dashboardv4(),
      ),
    );
  }
}

class Dashboardv4 extends StatefulWidget {
  // const Dashboardv2({Key? key}) : super(key: key);
  const Dashboardv4();
  @override
  State<Dashboardv4> createState() => _Dashboardv4();
}

class _Dashboardv4 extends State<Dashboardv4> {
  final box = GetStorage();
  // String token = "";

  var vr1 = 0;
  var vr2 = 0;
  var vr3 = 0;
  var vr4 = 0;
  var vr5 = 0;
  var vr6 = 0;
  var vr7 = 0;
  var vr8 = 0;

  var nr1 = "Relay 1";
  var nr2 = "Relay 2";
  var nr3 = "Relay 3";
  var nr4 = "Relay 4";
  var nr5 = "Relay 5";
  var nr6 = "Relay 6";
  var nr7 = "Relay 7";
  var nr8 = "Relay 8";

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
      default:
        return 'assets/images/lightning.svg';
    }
  }

  @override
  Widget build(BuildContext context) {
    String token = box.read('token').toString();
    // print("token: " + token);
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
              )),
          const Padding(
            padding: EdgeInsets.fromLTRB(25, 25, 0, 0),
            child: Text(
              "Ruang Tamu",
              style: TextStyle(fontSize: 30),
            ),
          ),
          Center(
            child: GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              children: [
                FutureBuilder(
                  future: getStateRelay(token, "1"),
                  builder: (BuildContext context, AsyncSnapshot snapshot) {
                    if (snapshot.connectionState == ConnectionState.done) {
                      var hasil = jsonDecode(snapshot.data);
                      if (hasil.toString() == "[]") {
                        return Text("Invalid token");
                      }
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
                      return const Center(child: CircularProgressIndicator());
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
                      return const Center(child: CircularProgressIndicator());
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
                      return const Center(child: CircularProgressIndicator());
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
                      return const Center(child: CircularProgressIndicator());
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
                      return const Center(child: CircularProgressIndicator());
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
                      return const Center(child: CircularProgressIndicator());
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
                      return const Center(child: CircularProgressIndicator());
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
                                          ? const Color.fromRGBO(184, 26, 183, 1)
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
                      return const Center(child: CircularProgressIndicator());
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
