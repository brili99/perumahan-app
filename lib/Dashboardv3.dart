import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:get_storage/get_storage.dart';
import 'package:flutter/cupertino.dart';

class Dashboardv3 extends StatefulWidget {
  // const Dashboardv2({Key? key}) : super(key: key);
  const Dashboardv3();
  @override
  State<Dashboardv3> createState() => _Dashboardv3();
}

class _Dashboardv3 extends State<Dashboardv3> {
  final box = GetStorage();
  String token = "";

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

  Color cr1 = Colors.red;
  Color cr2 = Colors.red;
  Color cr3 = Colors.red;
  Color cr4 = Colors.red;
  Color cr5 = Colors.red;
  Color cr6 = Colors.red;
  Color cr7 = Colors.red;
  Color cr8 = Colors.red;

  @override
  Widget build(BuildContext context) {
    token = box.read('token');
    return Container(
      child: ListView(
        children: [
          Container(
              height: 180,
              decoration: const BoxDecoration(
                // color: Color.fromRGBO(254, 233, 44, 1),
                image: DecorationImage(
                    alignment: Alignment.topCenter,
                    image: AssetImage("images/bg_dashboard2.png"),
                    fit: BoxFit.contain),
              )),
          const Padding(
            padding: EdgeInsets.all(25),
            child: Text(
              "Ruang Tamu",
              style: TextStyle(fontSize: 30),
            ),
          ),
          SizedBox(
              height: 180,
              child: Padding(
                padding: EdgeInsets.all(25),
                child: ListView(
                    shrinkWrap: true,
                    scrollDirection: Axis.horizontal,
                    children: [
                      Card(
                        shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(20), // if you need this
                          side: BorderSide(
                            color: Colors.grey.withOpacity(0.2),
                            width: 1,
                          ),
                        ),
                        child: Container(
                            padding: const EdgeInsets.fromLTRB(30, 0, 20, 0),
                            height: 180,
                            child: Center(
                              child: InkWell(
                                onTap: () {
                                  setState(() {});
                                },
                                child: Row(
                                  children: <Widget>[
                                    Column(
                                      children: const [
                                        SizedBox(height: 20.0),
                                        Center(
                                            child: Icon(
                                          FontAwesomeIcons.fan,
                                          size: 40.0,
                                          color: Colors.green,
                                        )),
                                        SizedBox(height: 20.0),
                                        Center(
                                          child: Text("Fan 1",
                                              style: TextStyle(
                                                  fontSize: 20.0,
                                                  color: Colors.black)),
                                        )
                                      ],
                                    ),
                                    const SizedBox(
                                      width: 20,
                                    ),
                                    const Icon(
                                      FontAwesomeIcons.powerOff,
                                      size: 30.0,
                                      color: Colors.red,
                                    )
                                  ],
                                ),
                              ),
                            )),
                      ),
                      Card(
                        shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(20), // if you need this
                          side: BorderSide(
                            color: Colors.grey.withOpacity(0.2),
                            width: 1,
                          ),
                        ),
                        child: Container(
                            padding: const EdgeInsets.fromLTRB(30, 0, 20, 0),
                            height: 180,
                            child: Center(
                              child: InkWell(
                                onTap: () {
                                  setState(() {});
                                },
                                child: Row(
                                  children: <Widget>[
                                    Column(
                                      children: const [
                                        SizedBox(height: 20.0),
                                        Center(
                                            child: Icon(
                                          FontAwesomeIcons.fan,
                                          size: 40.0,
                                          color: Colors.green,
                                        )),
                                        SizedBox(height: 20.0),
                                        Center(
                                          child: Text("Fan 1",
                                              style: TextStyle(
                                                  fontSize: 20.0,
                                                  color: Colors.black)),
                                        )
                                      ],
                                    ),
                                    const SizedBox(
                                      width: 20,
                                    ),
                                    const Icon(
                                      FontAwesomeIcons.powerOff,
                                      size: 30.0,
                                      color: Colors.red,
                                    )
                                  ],
                                ),
                              ),
                            )),
                      ),
                      Card(
                        shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(20), // if you need this
                          side: BorderSide(
                            color: Colors.grey.withOpacity(0.2),
                            width: 1,
                          ),
                        ),
                        child: Container(
                            padding: const EdgeInsets.fromLTRB(30, 0, 20, 0),
                            height: 180,
                            child: Center(
                              child: InkWell(
                                onTap: () {
                                  setState(() {});
                                },
                                child: Row(
                                  children: <Widget>[
                                    Column(
                                      children: const [
                                        SizedBox(height: 20.0),
                                        Center(
                                            child: Icon(
                                          FontAwesomeIcons.fan,
                                          size: 40.0,
                                          color: Colors.green,
                                        )),
                                        SizedBox(height: 20.0),
                                        Center(
                                          child: Text("Fan 1",
                                              style: TextStyle(
                                                  fontSize: 20.0,
                                                  color: Colors.black)),
                                        )
                                      ],
                                    ),
                                    const SizedBox(
                                      width: 20,
                                    ),
                                    const Icon(
                                      FontAwesomeIcons.powerOff,
                                      size: 30.0,
                                      color: Colors.red,
                                    )
                                  ],
                                ),
                              ),
                            )),
                      ),
                      Card(
                        shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(20), // if you need this
                          side: BorderSide(
                            color: Colors.grey.withOpacity(0.2),
                            width: 1,
                          ),
                        ),
                        child: Container(
                            padding: const EdgeInsets.fromLTRB(30, 0, 20, 0),
                            height: 180,
                            child: Center(
                              child: InkWell(
                                onTap: () {
                                  setState(() {});
                                },
                                child: Row(
                                  children: <Widget>[
                                    Column(
                                      children: const [
                                        SizedBox(height: 20.0),
                                        Center(
                                            child: Icon(
                                          FontAwesomeIcons.fan,
                                          size: 40.0,
                                          color: Colors.green,
                                        )),
                                        SizedBox(height: 20.0),
                                        Center(
                                          child: Text("Fan 1",
                                              style: TextStyle(
                                                  fontSize: 20.0,
                                                  color: Colors.black)),
                                        )
                                      ],
                                    ),
                                    const SizedBox(
                                      width: 20,
                                    ),
                                    const Icon(
                                      FontAwesomeIcons.powerOff,
                                      size: 30.0,
                                      color: Colors.red,
                                    )
                                  ],
                                ),
                              ),
                            )),
                      ),
                      Card(
                        shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(20), // if you need this
                          side: BorderSide(
                            color: Colors.grey.withOpacity(0.2),
                            width: 1,
                          ),
                        ),
                        child: Container(
                            padding: const EdgeInsets.fromLTRB(30, 0, 20, 0),
                            height: 180,
                            child: Center(
                              child: InkWell(
                                onTap: () {
                                  setState(() {});
                                },
                                child: Row(
                                  children: <Widget>[
                                    Column(
                                      children: const [
                                        SizedBox(height: 20.0),
                                        Center(
                                            child: Icon(
                                          FontAwesomeIcons.fan,
                                          size: 40.0,
                                          color: Colors.green,
                                        )),
                                        SizedBox(height: 20.0),
                                        Center(
                                          child: Text("Fan 1",
                                              style: TextStyle(
                                                  fontSize: 20.0,
                                                  color: Colors.black)),
                                        )
                                      ],
                                    ),
                                    const SizedBox(
                                      width: 20,
                                    ),
                                    const Icon(
                                      FontAwesomeIcons.powerOff,
                                      size: 30.0,
                                      color: Colors.red,
                                    )
                                  ],
                                ),
                              ),
                            )),
                      ),
                      Card(
                        shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(20), // if you need this
                          side: BorderSide(
                            color: Colors.grey.withOpacity(0.2),
                            width: 1,
                          ),
                        ),
                        child: Container(
                            padding: const EdgeInsets.fromLTRB(30, 0, 20, 0),
                            height: 180,
                            child: Center(
                              child: InkWell(
                                onTap: () {
                                  setState(() {});
                                },
                                child: Row(
                                  children: <Widget>[
                                    Column(
                                      children: const [
                                        SizedBox(height: 20.0),
                                        Center(
                                            child: Icon(
                                          FontAwesomeIcons.fan,
                                          size: 40.0,
                                          color: Colors.green,
                                        )),
                                        SizedBox(height: 20.0),
                                        Center(
                                          child: Text("Fan 1",
                                              style: TextStyle(
                                                  fontSize: 20.0,
                                                  color: Colors.black)),
                                        )
                                      ],
                                    ),
                                    const SizedBox(
                                      width: 20,
                                    ),
                                    const Icon(
                                      FontAwesomeIcons.powerOff,
                                      size: 30.0,
                                      color: Colors.red,
                                    )
                                  ],
                                ),
                              ),
                            )),
                      ),
                      Card(
                        shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(20), // if you need this
                          side: BorderSide(
                            color: Colors.grey.withOpacity(0.2),
                            width: 1,
                          ),
                        ),
                        child: Container(
                            padding: const EdgeInsets.fromLTRB(30, 0, 20, 0),
                            height: 180,
                            child: Center(
                              child: InkWell(
                                onTap: () {
                                  setState(() {});
                                },
                                child: Row(
                                  children: <Widget>[
                                    Column(
                                      children: const [
                                        SizedBox(height: 20.0),
                                        Center(
                                            child: Icon(
                                          FontAwesomeIcons.fan,
                                          size: 40.0,
                                          color: Colors.green,
                                        )),
                                        SizedBox(height: 20.0),
                                        Center(
                                          child: Text("Fan 1",
                                              style: TextStyle(
                                                  fontSize: 20.0,
                                                  color: Colors.black)),
                                        )
                                      ],
                                    ),
                                    const SizedBox(
                                      width: 20,
                                    ),
                                    const Icon(
                                      FontAwesomeIcons.powerOff,
                                      size: 30.0,
                                      color: Colors.red,
                                    )
                                  ],
                                ),
                              ),
                            )),
                      ),
                      Card(
                        shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(20), // if you need this
                          side: BorderSide(
                            color: Colors.grey.withOpacity(0.2),
                            width: 1,
                          ),
                        ),
                        child: Container(
                            padding: const EdgeInsets.fromLTRB(30, 0, 20, 0),
                            height: 180,
                            child: Center(
                              child: InkWell(
                                onTap: () {
                                  setState(() {});
                                },
                                child: Row(
                                  children: <Widget>[
                                    Column(
                                      children: const [
                                        SizedBox(height: 20.0),
                                        Center(
                                            child: Icon(
                                          FontAwesomeIcons.fan,
                                          size: 40.0,
                                          color: Colors.green,
                                        )),
                                        SizedBox(height: 20.0),
                                        Center(
                                          child: Text("Fan 1",
                                              style: TextStyle(
                                                  fontSize: 20.0,
                                                  color: Colors.black)),
                                        )
                                      ],
                                    ),
                                    const SizedBox(
                                      width: 20,
                                    ),
                                    const Icon(
                                      FontAwesomeIcons.powerOff,
                                      size: 30.0,
                                      color: Colors.red,
                                    )
                                  ],
                                ),
                              ),
                            )),
                      ),
                    ]),
              )),
        ],
      ),
    );
  }
}
