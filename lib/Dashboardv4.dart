import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:get_storage/get_storage.dart';
import 'package:flutter/cupertino.dart';

class init_Dashboardv4 extends StatelessWidget {
  final box = GetStorage();
  String token = "";

  @override
  Widget build(BuildContext context) {
    token = box.read('token');
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
  String token = "";

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
      case "relay":
        return 'assets/images/lightning.svg';
      default:
        return 'assets/images/lightning.svg';
    }
  }

  @override
  Widget build(BuildContext context) {
    token = box.read('token').toString();
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
          Container(
              height: 180,
              decoration: const BoxDecoration(
                color: Color.fromRGBO(255, 255, 255, 255),
              ),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                child: ListView(
                    shrinkWrap: true,
                    scrollDirection: Axis.horizontal,
                    children: [
                      // Card(
                      //   shape: RoundedRectangleBorder(
                      //     borderRadius:
                      //         BorderRadius.circular(20), // if you need this
                      //     side: BorderSide(
                      //       color: Colors.grey.withOpacity(0.2),
                      //       width: 1,
                      //     ),
                      //   ),
                      //   child: Container(
                      //       padding: const EdgeInsets.fromLTRB(30, 0, 20, 0),
                      //       height: 180,
                      //       child: Center(
                      //         child: InkWell(
                      //           onTap: () {
                      //             setState(() {});
                      //           },
                      //           child: Row(
                      //             children: <Widget>[
                      //               Column(
                      //                 children: [
                      //                   SizedBox(height: 20.0),
                      //                   Center(child: icon_ac2),
                      //                   // SizedBox(height: 20.0),
                      //                   Center(
                      //                     child: Text("AC 1",
                      //                         style: TextStyle(
                      //                             fontSize: 20.0,
                      //                             color: Colors.black)),
                      //                   )
                      //                 ],
                      //               ),
                      //               const SizedBox(
                      //                 width: 20,
                      //               ),
                      //               const Icon(
                      //                 FontAwesomeIcons.powerOff,
                      //                 size: 30.0,
                      //                 color: Colors.red,
                      //               )
                      //             ],
                      //           ),
                      //         ),
                      //       )),
                      // ),
                      FutureBuilder(
                          future: getStateRelay(token, "1"),
                          builder:
                              (BuildContext context, AsyncSnapshot snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.done) {
                              var hasil = jsonDecode(snapshot.data);
                              if (hasil.toString() == "[]")
                                return Text("Invalid token");
                              // print(hasil);
                              vr1 = int.parse(hasil['state'].toString());
                              if (hasil['nama'] != null) {
                                nr1 = hasil['nama'].toString();
                              }
                              return Container(
                                  height: 160,
                                  decoration: const BoxDecoration(
                                    color: Color.fromRGBO(255, 255, 255, 255),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(25),
                                    child: ListView(
                                        shrinkWrap: true,
                                        scrollDirection: Axis.horizontal,
                                        children: [
                                          Card(
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(
                                                      20), // if you need this
                                              side: BorderSide(
                                                color: Colors.grey
                                                    .withOpacity(0.2),
                                                width: 1,
                                              ),
                                            ),
                                            child: Container(
                                                padding:
                                                    const EdgeInsets.fromLTRB(
                                                        30, 0, 20, 0),
                                                height: 180,
                                                child: Center(
                                                  child: InkWell(
                                                    onTap: () {
                                                      if (vr1 == 1) {
                                                        vr1 = 0;
                                                      } else {
                                                        vr1 = 1;
                                                      }
                                                      setState(() {
                                                        setStateRelay(
                                                            token,
                                                            "1",
                                                            vr1.toString());
                                                      });
                                                    },
                                                    child: Row(
                                                      children: <Widget>[
                                                        Column(
                                                          children: [
                                                            const SizedBox(
                                                                height: 20.0),
                                                            Center(
                                                                child: SizedBox(
                                                              height: 59,
                                                              width: 59,
                                                              child: SvgPicture
                                                                  .asset(
                                                                getIcon("ac"),
                                                                color: vr1 == 1
                                                                    ? Colors
                                                                        .amber
                                                                    : Colors
                                                                        .black,
                                                              ),
                                                            )),
                                                            const SizedBox(
                                                                height: 5.0),
                                                            Center(
                                                              child: Text(nr1,
                                                                  style: const TextStyle(
                                                                      fontSize:
                                                                          20.0,
                                                                      color: Colors
                                                                          .black)),
                                                            )
                                                          ],
                                                        ),
                                                        const SizedBox(
                                                          width: 20,
                                                        ),
                                                        Icon(
                                                          FontAwesomeIcons
                                                              .powerOff,
                                                          size: 30.0,
                                                          color: vr1 == 1
                                                              ? Colors.red
                                                              : Colors.black,
                                                        )
                                                      ],
                                                    ),
                                                  ),
                                                )),
                                          ),
                                        ]),
                                  ));
                            } else {
                              return const Center(
                                  child: CircularProgressIndicator());
                            }
                          }),
                      FutureBuilder(
                          future: getStateRelay(token, "2"),
                          builder:
                              (BuildContext context, AsyncSnapshot snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.done) {
                              var hasil = jsonDecode(snapshot.data);
                              if (hasil.toString() == "[]")
                                return Text("Invalid token");
                              // print(hasil);
                              vr2 = int.parse(hasil['state'].toString());
                              if (hasil['nama'] != null) {
                                nr2 = hasil['nama'].toString();
                              }
                              return Container(
                                  height: 180,
                                  decoration: const BoxDecoration(
                                    color: Color.fromRGBO(255, 255, 255, 255),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(25),
                                    child: ListView(
                                        shrinkWrap: true,
                                        scrollDirection: Axis.horizontal,
                                        children: [
                                          Card(
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(
                                                      20), // if you need this
                                              side: BorderSide(
                                                color: Colors.grey
                                                    .withOpacity(0.2),
                                                width: 1,
                                              ),
                                            ),
                                            child: Container(
                                                padding:
                                                    const EdgeInsets.fromLTRB(
                                                        30, 0, 20, 0),
                                                height: 180,
                                                child: Center(
                                                  child: InkWell(
                                                    onTap: () {
                                                      if (vr2 == 1) {
                                                        vr2 = 0;
                                                      } else {
                                                        vr2 = 1;
                                                      }
                                                      setState(() {
                                                        setStateRelay(
                                                            token,
                                                            "2",
                                                            vr2.toString());
                                                      });
                                                    },
                                                    child: Row(
                                                      children: <Widget>[
                                                        Column(
                                                          children: [
                                                            const SizedBox(
                                                                height: 20.0),
                                                            Center(
                                                                child: SizedBox(
                                                              height: 59,
                                                              width: 59,
                                                              child: SvgPicture
                                                                  .asset(
                                                                getIcon("ac"),
                                                                color: vr2 == 1
                                                                    ? Colors
                                                                        .amber
                                                                    : Colors
                                                                        .black,
                                                              ),
                                                            )),
                                                            const SizedBox(
                                                                height: 5.0),
                                                            Center(
                                                              child: Text(nr2,
                                                                  style: const TextStyle(
                                                                      fontSize:
                                                                          20.0,
                                                                      color: Colors
                                                                          .black)),
                                                            )
                                                          ],
                                                        ),
                                                        const SizedBox(
                                                          width: 20,
                                                        ),
                                                        Icon(
                                                          FontAwesomeIcons
                                                              .powerOff,
                                                          size: 30.0,
                                                          color: vr2 == 1
                                                              ? Colors.red
                                                              : Colors.black,
                                                        )
                                                      ],
                                                    ),
                                                  ),
                                                )),
                                          ),
                                        ]),
                                  ));
                            } else {
                              return const Center(
                                  child: CircularProgressIndicator());
                            }
                          }),
                      FutureBuilder(
                          future: getStateRelay(token, "3"),
                          builder:
                              (BuildContext context, AsyncSnapshot snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.done) {
                              var hasil = jsonDecode(snapshot.data);
                              if (hasil.toString() == "[]")
                                return Text("Invalid token");
                              // print(hasil);
                              vr3 = int.parse(hasil['state'].toString());
                              if (hasil['nama'] != null) {
                                nr3 = hasil['nama'].toString();
                              }
                              return Container(
                                  height: 180,
                                  decoration: const BoxDecoration(
                                    color: Color.fromRGBO(255, 255, 255, 255),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(25),
                                    child: ListView(
                                        shrinkWrap: true,
                                        scrollDirection: Axis.horizontal,
                                        children: [
                                          Card(
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(
                                                      20), // if you need this
                                              side: BorderSide(
                                                color: Colors.grey
                                                    .withOpacity(0.2),
                                                width: 1,
                                              ),
                                            ),
                                            child: Container(
                                                padding:
                                                    const EdgeInsets.fromLTRB(
                                                        30, 0, 20, 0),
                                                height: 180,
                                                child: Center(
                                                  child: InkWell(
                                                    onTap: () {
                                                      if (vr3 == 1) {
                                                        vr3 = 0;
                                                      } else {
                                                        vr3 = 1;
                                                      }
                                                      setState(() {
                                                        setStateRelay(
                                                            token,
                                                            "3",
                                                            vr3.toString());
                                                      });
                                                    },
                                                    child: Row(
                                                      children: <Widget>[
                                                        Column(
                                                          children: [
                                                            const SizedBox(
                                                                height: 20.0),
                                                            Center(
                                                                child: SizedBox(
                                                              height: 59,
                                                              width: 59,
                                                              child: SvgPicture
                                                                  .asset(
                                                                getIcon("ac"),
                                                                color: vr3 == 1
                                                                    ? Colors
                                                                        .amber
                                                                    : Colors
                                                                        .black,
                                                              ),
                                                            )),
                                                            const SizedBox(
                                                                height: 5.0),
                                                            Center(
                                                              child: Text(nr3,
                                                                  style: const TextStyle(
                                                                      fontSize:
                                                                          20.0,
                                                                      color: Colors
                                                                          .black)),
                                                            )
                                                          ],
                                                        ),
                                                        const SizedBox(
                                                          width: 20,
                                                        ),
                                                        Icon(
                                                          FontAwesomeIcons
                                                              .powerOff,
                                                          size: 30.0,
                                                          color: vr3 == 1
                                                              ? Colors.red
                                                              : Colors.black,
                                                        )
                                                      ],
                                                    ),
                                                  ),
                                                )),
                                          ),
                                        ]),
                                  ));
                            } else {
                              return const Center(
                                  child: CircularProgressIndicator());
                            }
                          }),
                      FutureBuilder(
                          future: getStateRelay(token, "4"),
                          builder:
                              (BuildContext context, AsyncSnapshot snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.done) {
                              var hasil = jsonDecode(snapshot.data);
                              if (hasil.toString() == "[]")
                                return Text("Invalid token");
                              // print(hasil);
                              vr4 = int.parse(hasil['state'].toString());
                              if (hasil['nama'] != null) {
                                nr4 = hasil['nama'].toString();
                              }
                              return Container(
                                  height: 180,
                                  decoration: const BoxDecoration(
                                    color: Color.fromRGBO(255, 255, 255, 255),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(25),
                                    child: ListView(
                                        shrinkWrap: true,
                                        scrollDirection: Axis.horizontal,
                                        children: [
                                          Card(
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(
                                                      20), // if you need this
                                              side: BorderSide(
                                                color: Colors.grey
                                                    .withOpacity(0.2),
                                                width: 1,
                                              ),
                                            ),
                                            child: Container(
                                                padding:
                                                    const EdgeInsets.fromLTRB(
                                                        30, 0, 20, 0),
                                                height: 180,
                                                child: Center(
                                                  child: InkWell(
                                                    onTap: () {
                                                      if (vr4 == 1) {
                                                        vr4 = 0;
                                                      } else {
                                                        vr4 = 1;
                                                      }
                                                      setState(() {
                                                        setStateRelay(
                                                            token,
                                                            "4",
                                                            vr4.toString());
                                                      });
                                                    },
                                                    child: Row(
                                                      children: <Widget>[
                                                        Column(
                                                          children: [
                                                            const SizedBox(
                                                                height: 20.0),
                                                            Center(
                                                                child: SizedBox(
                                                              height: 59,
                                                              width: 59,
                                                              child: SvgPicture
                                                                  .asset(
                                                                getIcon("ac"),
                                                                color: vr4 == 1
                                                                    ? Colors
                                                                        .amber
                                                                    : Colors
                                                                        .black,
                                                              ),
                                                            )),
                                                            const SizedBox(
                                                                height: 5.0),
                                                            Center(
                                                              child: Text(nr4,
                                                                  style: const TextStyle(
                                                                      fontSize:
                                                                          20.0,
                                                                      color: Colors
                                                                          .black)),
                                                            )
                                                          ],
                                                        ),
                                                        const SizedBox(
                                                          width: 20,
                                                        ),
                                                        Icon(
                                                          FontAwesomeIcons
                                                              .powerOff,
                                                          size: 30.0,
                                                          color: vr4 == 1
                                                              ? Colors.red
                                                              : Colors.black,
                                                        )
                                                      ],
                                                    ),
                                                  ),
                                                )),
                                          ),
                                        ]),
                                  ));
                            } else {
                              return const Center(
                                  child: CircularProgressIndicator());
                            }
                          }),
                    ]),
              )),
          const Padding(
            padding: EdgeInsets.fromLTRB(25, 25, 0, 0),
            child: Text(
              "Ruang Keluarga",
              style: TextStyle(fontSize: 30),
            ),
          ),
          Container(
            height: 180,
            decoration: const BoxDecoration(
              color: Color.fromRGBO(255, 255, 255, 255),
            ),
            child: Padding(
              padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
              child: ListView(
                  shrinkWrap: true,
                  scrollDirection: Axis.horizontal,
                  children: [
                    FutureBuilder(
                        future: getStateRelay(token, "5"),
                        builder:
                            (BuildContext context, AsyncSnapshot snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.done) {
                            var hasil = jsonDecode(snapshot.data);
                            if (hasil.toString() == "[]")
                              return Text("Invalid token");
                            // print(hasil);
                            vr5 = int.parse(hasil['state'].toString());
                            if (hasil['nama'] != null) {
                              nr5 = hasil['nama'].toString();
                            }
                            return Container(
                                height: 180,
                                decoration: const BoxDecoration(
                                  color: Color.fromRGBO(255, 255, 255, 255),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(25),
                                  child: ListView(
                                      shrinkWrap: true,
                                      scrollDirection: Axis.horizontal,
                                      children: [
                                        Card(
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                                20), // if you need this
                                            side: BorderSide(
                                              color:
                                                  Colors.grey.withOpacity(0.2),
                                              width: 1,
                                            ),
                                          ),
                                          child: Container(
                                              padding:
                                                  const EdgeInsets.fromLTRB(
                                                      30, 0, 20, 0),
                                              height: 180,
                                              child: Center(
                                                child: InkWell(
                                                  onTap: () {
                                                    if (vr5 == 1) {
                                                      vr5 = 0;
                                                    } else {
                                                      vr5 = 1;
                                                    }
                                                    setState(() {
                                                      setStateRelay(token, "5",
                                                          vr5.toString());
                                                    });
                                                  },
                                                  child: Row(
                                                    children: <Widget>[
                                                      Column(
                                                        children: [
                                                          const SizedBox(
                                                              height: 20.0),
                                                          Center(
                                                              child: SizedBox(
                                                            height: 59,
                                                            width: 59,
                                                            child: SvgPicture
                                                                .asset(
                                                              getIcon("ac"),
                                                              color: vr5 == 1
                                                                  ? Colors.amber
                                                                  : Colors
                                                                      .black,
                                                            ),
                                                          )),
                                                          const SizedBox(
                                                              height: 5.0),
                                                          Center(
                                                            child: Text(nr5,
                                                                style: const TextStyle(
                                                                    fontSize:
                                                                        20.0,
                                                                    color: Colors
                                                                        .black)),
                                                          )
                                                        ],
                                                      ),
                                                      const SizedBox(
                                                        width: 20,
                                                      ),
                                                      Icon(
                                                        FontAwesomeIcons
                                                            .powerOff,
                                                        size: 30.0,
                                                        color: vr5 == 1
                                                            ? Colors.red
                                                            : Colors.black,
                                                      )
                                                    ],
                                                  ),
                                                ),
                                              )),
                                        ),
                                      ]),
                                ));
                          } else {
                            return const Center(
                                child: CircularProgressIndicator());
                          }
                        }),
                    FutureBuilder(
                        future: getStateRelay(token, "6"),
                        builder:
                            (BuildContext context, AsyncSnapshot snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.done) {
                            var hasil = jsonDecode(snapshot.data);
                            if (hasil.toString() == "[]")
                              return Text("Invalid token");
                            // print(hasil);
                            vr6 = int.parse(hasil['state'].toString());
                            if (hasil['nama'] != null) {
                              nr6 = hasil['nama'].toString();
                            }
                            return Container(
                                height: 180,
                                decoration: const BoxDecoration(
                                  color: Color.fromRGBO(255, 255, 255, 255),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(25),
                                  child: ListView(
                                      shrinkWrap: true,
                                      scrollDirection: Axis.horizontal,
                                      children: [
                                        Card(
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                                20), // if you need this
                                            side: BorderSide(
                                              color:
                                                  Colors.grey.withOpacity(0.2),
                                              width: 1,
                                            ),
                                          ),
                                          child: Container(
                                              padding:
                                                  const EdgeInsets.fromLTRB(
                                                      30, 0, 20, 0),
                                              height: 180,
                                              child: Center(
                                                child: InkWell(
                                                  onTap: () {
                                                    if (vr6 == 1) {
                                                      vr6 = 0;
                                                    } else {
                                                      vr6 = 1;
                                                    }
                                                    setState(() {
                                                      setStateRelay(token, "6",
                                                          vr6.toString());
                                                    });
                                                  },
                                                  child: Row(
                                                    children: <Widget>[
                                                      Column(
                                                        children: [
                                                          const SizedBox(
                                                              height: 20.0),
                                                          Center(
                                                              child: SizedBox(
                                                            height: 59,
                                                            width: 59,
                                                            child: SvgPicture
                                                                .asset(
                                                              getIcon("ac"),
                                                              color: vr6 == 1
                                                                  ? Colors.amber
                                                                  : Colors
                                                                      .black,
                                                            ),
                                                          )),
                                                          const SizedBox(
                                                              height: 5.0),
                                                          Center(
                                                            child: Text(nr6,
                                                                style: const TextStyle(
                                                                    fontSize:
                                                                        20.0,
                                                                    color: Colors
                                                                        .black)),
                                                          )
                                                        ],
                                                      ),
                                                      const SizedBox(
                                                        width: 20,
                                                      ),
                                                      Icon(
                                                        FontAwesomeIcons
                                                            .powerOff,
                                                        size: 30.0,
                                                        color: vr6 == 1
                                                            ? Colors.red
                                                            : Colors.black,
                                                      )
                                                    ],
                                                  ),
                                                ),
                                              )),
                                        ),
                                      ]),
                                ));
                          } else {
                            return const Center(
                                child: CircularProgressIndicator());
                          }
                        }),
                    FutureBuilder(
                        future: getStateRelay(token, "7"),
                        builder:
                            (BuildContext context, AsyncSnapshot snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.done) {
                            var hasil = jsonDecode(snapshot.data);
                            if (hasil.toString() == "[]")
                              return Text("Invalid token");
                            // print(hasil);
                            vr7 = int.parse(hasil['state'].toString());
                            if (hasil['nama'] != null) {
                              nr7 = hasil['nama'].toString();
                            }
                            return Container(
                                height: 180,
                                decoration: const BoxDecoration(
                                  color: Color.fromRGBO(255, 255, 255, 255),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(25),
                                  child: ListView(
                                      shrinkWrap: true,
                                      scrollDirection: Axis.horizontal,
                                      children: [
                                        Card(
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                                20), // if you need this
                                            side: BorderSide(
                                              color:
                                                  Colors.grey.withOpacity(0.2),
                                              width: 1,
                                            ),
                                          ),
                                          child: Container(
                                              padding:
                                                  const EdgeInsets.fromLTRB(
                                                      30, 0, 20, 0),
                                              height: 180,
                                              child: Center(
                                                child: InkWell(
                                                  onTap: () {
                                                    if (vr7 == 1) {
                                                      vr7 = 0;
                                                    } else {
                                                      vr7 = 1;
                                                    }
                                                    setState(() {
                                                      setStateRelay(token, "7",
                                                          vr7.toString());
                                                    });
                                                  },
                                                  child: Row(
                                                    children: <Widget>[
                                                      Column(
                                                        children: [
                                                          const SizedBox(
                                                              height: 20.0),
                                                          Center(
                                                              child: SizedBox(
                                                            height: 59,
                                                            width: 59,
                                                            child: SvgPicture
                                                                .asset(
                                                              getIcon("ac"),
                                                              color: vr7 == 1
                                                                  ? Colors.amber
                                                                  : Colors
                                                                      .black,
                                                            ),
                                                          )),
                                                          const SizedBox(
                                                              height: 5.0),
                                                          Center(
                                                            child: Text(nr7,
                                                                style: const TextStyle(
                                                                    fontSize:
                                                                        20.0,
                                                                    color: Colors
                                                                        .black)),
                                                          )
                                                        ],
                                                      ),
                                                      const SizedBox(
                                                        width: 20,
                                                      ),
                                                      Icon(
                                                        FontAwesomeIcons
                                                            .powerOff,
                                                        size: 30.0,
                                                        color: vr7 == 1
                                                            ? Colors.red
                                                            : Colors.black,
                                                      )
                                                    ],
                                                  ),
                                                ),
                                              )),
                                        ),
                                      ]),
                                ));
                          } else {
                            return const Center(
                                child: CircularProgressIndicator());
                          }
                        }),
                    FutureBuilder(
                        future: getStateRelay(token, "8"),
                        builder:
                            (BuildContext context, AsyncSnapshot snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.done) {
                            var hasil = jsonDecode(snapshot.data);
                            if (hasil.toString() == "[]")
                              return Text("Invalid token");
                            // print(hasil);
                            vr8 = int.parse(hasil['state'].toString());
                            if (hasil['nama'] != null) {
                              nr8 = hasil['nama'].toString();
                            }
                            return Container(
                                height: 180,
                                decoration: const BoxDecoration(
                                  color: Color.fromRGBO(255, 255, 255, 255),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(25),
                                  child: ListView(
                                      shrinkWrap: true,
                                      scrollDirection: Axis.horizontal,
                                      children: [
                                        Card(
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                                20), // if you need this
                                            side: BorderSide(
                                              color:
                                                  Colors.grey.withOpacity(0.2),
                                              width: 1,
                                            ),
                                          ),
                                          child: Container(
                                              padding:
                                                  const EdgeInsets.fromLTRB(
                                                      30, 0, 20, 0),
                                              height: 180,
                                              child: Center(
                                                child: InkWell(
                                                  onTap: () {
                                                    if (vr8 == 1) {
                                                      vr8 = 0;
                                                    } else {
                                                      vr8 = 1;
                                                    }
                                                    setState(() {
                                                      setStateRelay(token, "8",
                                                          vr8.toString());
                                                    });
                                                  },
                                                  child: Row(
                                                    children: <Widget>[
                                                      Column(
                                                        children: [
                                                          const SizedBox(
                                                              height: 20.0),
                                                          Center(
                                                              child: SizedBox(
                                                            height: 59,
                                                            width: 59,
                                                            child: SvgPicture
                                                                .asset(
                                                              getIcon("ac"),
                                                              color: vr8 == 1
                                                                  ? Colors.amber
                                                                  : Colors
                                                                      .black,
                                                            ),
                                                          )),
                                                          const SizedBox(
                                                              height: 5.0),
                                                          Center(
                                                            child: Text(nr8,
                                                                style: const TextStyle(
                                                                    fontSize:
                                                                        20.0,
                                                                    color: Colors
                                                                        .black)),
                                                          )
                                                        ],
                                                      ),
                                                      const SizedBox(
                                                        width: 20,
                                                      ),
                                                      Icon(
                                                        FontAwesomeIcons
                                                            .powerOff,
                                                        size: 30.0,
                                                        color: vr8 == 1
                                                            ? Colors.red
                                                            : Colors.black,
                                                      )
                                                    ],
                                                  ),
                                                ),
                                              )),
                                        ),
                                      ]),
                                ));
                          } else {
                            return const Center(
                                child: CircularProgressIndicator());
                          }
                        }),
                  ]),
            ),
          )
        ],
      ),
    );
  }
}
