import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:get_storage/get_storage.dart';
import 'package:flutter/cupertino.dart';

class Dashboardv2 extends StatefulWidget {
  // const Dashboardv2({Key? key}) : super(key: key);
  const Dashboardv2();
  @override
  State<Dashboardv2> createState() => _Dashboardv2();
}

class _Dashboardv2 extends State<Dashboardv2> {
  final box = GetStorage();
  String token = "";
  Icon r1 = const Icon(
    FontAwesomeIcons.check,
    size: 90,
    color: Colors.green,
  );
  Icon r2 = const Icon(
    FontAwesomeIcons.check,
    size: 90,
    color: Colors.green,
  );
  Icon r3 = const Icon(
    FontAwesomeIcons.check,
    size: 90,
    color: Colors.green,
  );
  Icon r4 = const Icon(
    FontAwesomeIcons.check,
    size: 90,
    color: Colors.green,
  );
  Icon r5 = const Icon(
    FontAwesomeIcons.check,
    size: 90,
    color: Colors.green,
  );
  Icon r6 = const Icon(
    FontAwesomeIcons.check,
    size: 90,
    color: Colors.green,
  );
  Icon r7 = const Icon(
    FontAwesomeIcons.check,
    size: 90,
    color: Colors.green,
  );
  Icon r8 = const Icon(
    FontAwesomeIcons.check,
    size: 90,
    color: Colors.green,
  );

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

  @override
  Widget build(BuildContext context) {
    // if (box.read('token') != null) {
    //   Navigator.push(
    //     context,
    //     MaterialPageRoute(builder: (context) => Dashboard()),
    //   );
    // }
    token = box.read('token');
    var vr1 = 1;
    var vr2 = 1;
    var vr3 = 1;
    var vr4 = 1;
    var vr5 = 1;
    var vr6 = 1;
    var vr7 = 1;
    var vr8 = 1;
    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: Container(
            child: GridView.count(
              scrollDirection: Axis.vertical,
              crossAxisCount: 2,
              children: <Widget>[
                FutureBuilder(
                    future: getStateRelay(token, "1"),
                    builder: (BuildContext context, AsyncSnapshot snapshot) {
                      if (snapshot.connectionState == ConnectionState.done) {
                        var hasil = jsonDecode(snapshot.data);
                        if (hasil['state'] == "1") {
                          vr1 = 1;
                          r1 = Icon(
                            FontAwesomeIcons.check,
                            size: 90,
                            color: Colors.green,
                          );
                        } else {
                          vr1 = 0;
                          r1 = Icon(
                            FontAwesomeIcons.times,
                            size: 90,
                            color: Colors.red,
                          );
                        }
                        return Card(
                            elevation: 1.0,
                            margin: new EdgeInsets.all(8.0),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            color: Color.fromRGBO(255, 255, 255, 200),
                            child: Container(
                              // height: 80,
                              decoration: const BoxDecoration(
                                  color: Color.fromRGBO(32, 201, 151, 200),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(20))),
                              child: InkWell(
                                onTap: () {
                                  if (vr1 == 1) {
                                    vr1 = 0;
                                  } else {
                                    vr1 = 1;
                                  }
                                  setState(() {
                                    setStateRelay(token, "1", vr1.toString());
                                  });
                                },
                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.stretch,
                                  mainAxisSize: MainAxisSize.min,
                                  verticalDirection: VerticalDirection.down,
                                  children: <Widget>[
                                    SizedBox(height: 50.0),
                                    Center(child: r1),
                                    SizedBox(height: 20.0),
                                    Center(
                                      child: Text("Relay 1",
                                          style: TextStyle(
                                              fontSize: 18.0,
                                              color: Colors.black)),
                                    )
                                  ],
                                ),
                              ),
                            ));
                      } else {
                        return const Center(child: CircularProgressIndicator());
                      }
                    }),
                FutureBuilder(
                    future: getStateRelay(token, "2"),
                    builder: (BuildContext context, AsyncSnapshot snapshot) {
                      if (snapshot.connectionState == ConnectionState.done) {
                        var hasil = jsonDecode(snapshot.data);
                        var nama = hasil['nama'];
                        if (nama == null) {
                          nama = "Relay 2";
                        }
                        if (hasil['state'] == "1") {
                          vr2 = 1;
                          r2 = Icon(
                            FontAwesomeIcons.check,
                            size: 90,
                            color: Colors.green,
                          );
                        } else {
                          vr2 = 0;
                          r2 = Icon(
                            FontAwesomeIcons.times,
                            size: 90,
                            color: Colors.red,
                          );
                        }
                        return Card(
                            elevation: 1.0,
                            margin: new EdgeInsets.all(8.0),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            color: Color.fromRGBO(255, 255, 255, 200),
                            child: Container(
                              // height: 80,
                              decoration: const BoxDecoration(
                                  color: Color.fromRGBO(32, 201, 151, 200),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(20))),
                              child: InkWell(
                                onTap: () {
                                  if (vr2 == 1) {
                                    vr2 = 0;
                                  } else {
                                    vr2 = 1;
                                  }
                                  setState(() {
                                    setStateRelay(token, "2", vr2.toString());
                                  });
                                },
                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.stretch,
                                  mainAxisSize: MainAxisSize.min,
                                  verticalDirection: VerticalDirection.down,
                                  children: <Widget>[
                                    SizedBox(height: 50.0),
                                    Center(child: r2),
                                    SizedBox(height: 20.0),
                                    Center(
                                      child: Text(nama,
                                          style: TextStyle(
                                              fontSize: 18.0,
                                              color: Colors.black)),
                                    )
                                  ],
                                ),
                              ),
                            ));
                      } else {
                        return const Center(child: CircularProgressIndicator());
                      }
                    }),
                FutureBuilder(
                    future: getStateRelay(token, "3"),
                    builder: (BuildContext context, AsyncSnapshot snapshot) {
                      if (snapshot.connectionState == ConnectionState.done) {
                        var hasil = jsonDecode(snapshot.data);
                        if (hasil['state'] == "1") {
                          vr3 = 1;
                          r3 = Icon(
                            FontAwesomeIcons.check,
                            size: 90,
                            color: Colors.green,
                          );
                        } else {
                          vr3 = 0;
                          r3 = Icon(
                            FontAwesomeIcons.times,
                            size: 90,
                            color: Colors.red,
                          );
                        }
                        return Card(
                            elevation: 1.0,
                            margin: new EdgeInsets.all(8.0),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            color: Color.fromRGBO(255, 255, 255, 200),
                            child: Container(
                              // height: 80,
                              decoration: const BoxDecoration(
                                  color: Color.fromRGBO(32, 201, 151, 200),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(20))),
                              child: InkWell(
                                onTap: () {
                                  if (vr3 == 1) {
                                    vr3 = 0;
                                  } else {
                                    vr3 = 1;
                                  }
                                  setState(() {
                                    setStateRelay(token, "3", vr3.toString());
                                  });
                                },
                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.stretch,
                                  mainAxisSize: MainAxisSize.min,
                                  verticalDirection: VerticalDirection.down,
                                  children: <Widget>[
                                    SizedBox(height: 50.0),
                                    Center(child: r3),
                                    SizedBox(height: 20.0),
                                    Center(
                                      child: Text("Relay 3",
                                          style: TextStyle(
                                              fontSize: 18.0,
                                              color: Colors.black)),
                                    )
                                  ],
                                ),
                              ),
                            ));
                      } else {
                        return const Center(child: CircularProgressIndicator());
                      }
                    }),
                FutureBuilder(
                    future: getStateRelay(token, "4"),
                    builder: (BuildContext context, AsyncSnapshot snapshot) {
                      if (snapshot.connectionState == ConnectionState.done) {
                        var hasil = jsonDecode(snapshot.data);
                        if (hasil['state'] == "1") {
                          vr4 = 1;
                          r4 = Icon(
                            FontAwesomeIcons.check,
                            size: 90,
                            color: Colors.green,
                          );
                        } else {
                          vr4 = 0;
                          r4 = Icon(
                            FontAwesomeIcons.times,
                            size: 90,
                            color: Colors.red,
                          );
                        }
                        return Card(
                            elevation: 1.0,
                            margin: new EdgeInsets.all(8.0),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            color: Color.fromRGBO(255, 255, 255, 200),
                            child: Container(
                              // height: 80,
                              decoration: const BoxDecoration(
                                  color: Color.fromRGBO(32, 201, 151, 200),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(20))),
                              child: InkWell(
                                onTap: () {
                                  if (vr4 == 1) {
                                    vr4 = 0;
                                  } else {
                                    vr4 = 1;
                                  }
                                  setState(() {
                                    setStateRelay(token, "4", vr4.toString());
                                  });
                                },
                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.stretch,
                                  mainAxisSize: MainAxisSize.min,
                                  verticalDirection: VerticalDirection.down,
                                  children: <Widget>[
                                    SizedBox(height: 50.0),
                                    Center(child: r4),
                                    SizedBox(height: 20.0),
                                    Center(
                                      child: Text("Relay 4",
                                          style: TextStyle(
                                              fontSize: 18.0,
                                              color: Colors.black)),
                                    )
                                  ],
                                ),
                              ),
                            ));
                      } else {
                        return const Center(child: CircularProgressIndicator());
                      }
                    }),
                FutureBuilder(
                    future: getStateRelay(token, "5"),
                    builder: (BuildContext context, AsyncSnapshot snapshot) {
                      if (snapshot.connectionState == ConnectionState.done) {
                        var hasil = jsonDecode(snapshot.data);
                        if (hasil['state'] == "1") {
                          vr5 = 1;
                          r5 = Icon(
                            FontAwesomeIcons.check,
                            size: 90,
                            color: Colors.green,
                          );
                        } else {
                          vr5 = 0;
                          r5 = Icon(
                            FontAwesomeIcons.times,
                            size: 90,
                            color: Colors.red,
                          );
                        }
                        return Card(
                            elevation: 1.0,
                            margin: new EdgeInsets.all(8.0),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            color: Color.fromRGBO(255, 255, 255, 200),
                            child: Container(
                              // height: 80,
                              decoration: const BoxDecoration(
                                  color: Color.fromRGBO(32, 201, 151, 200),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(20))),
                              child: InkWell(
                                onTap: () {
                                  if (vr5 == 1) {
                                    vr5 = 0;
                                  } else {
                                    vr5 = 1;
                                  }
                                  setState(() {
                                    setStateRelay(token, "5", vr5.toString());
                                  });
                                },
                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.stretch,
                                  mainAxisSize: MainAxisSize.min,
                                  verticalDirection: VerticalDirection.down,
                                  children: <Widget>[
                                    SizedBox(height: 50.0),
                                    Center(child: r5),
                                    SizedBox(height: 20.0),
                                    Center(
                                      child: Text("Relay 5",
                                          style: TextStyle(
                                              fontSize: 18.0,
                                              color: Colors.black)),
                                    )
                                  ],
                                ),
                              ),
                            ));
                      } else {
                        return const Center(child: CircularProgressIndicator());
                      }
                    }),
                FutureBuilder(
                    future: getStateRelay(token, "6"),
                    builder: (BuildContext context, AsyncSnapshot snapshot) {
                      if (snapshot.connectionState == ConnectionState.done) {
                        var hasil = jsonDecode(snapshot.data);
                        if (hasil['state'] == "1") {
                          vr6 = 1;
                          r6 = Icon(
                            FontAwesomeIcons.check,
                            size: 90,
                            color: Colors.green,
                          );
                        } else {
                          vr6 = 0;
                          r6 = Icon(
                            FontAwesomeIcons.times,
                            size: 90,
                            color: Colors.red,
                          );
                        }
                        return Card(
                            elevation: 1.0,
                            margin: new EdgeInsets.all(8.0),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            color: Color.fromRGBO(255, 255, 255, 200),
                            child: Container(
                              // height: 80,
                              decoration: const BoxDecoration(
                                  color: Color.fromRGBO(32, 201, 151, 200),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(20))),
                              child: InkWell(
                                onTap: () {
                                  if (vr6 == 1) {
                                    vr6 = 0;
                                  } else {
                                    vr6 = 1;
                                  }
                                  setState(() {
                                    setStateRelay(token, "6", vr6.toString());
                                  });
                                },
                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.stretch,
                                  mainAxisSize: MainAxisSize.min,
                                  verticalDirection: VerticalDirection.down,
                                  children: <Widget>[
                                    SizedBox(height: 50.0),
                                    Center(child: r6),
                                    SizedBox(height: 20.0),
                                    Center(
                                      child: Text("Relay 6",
                                          style: TextStyle(
                                              fontSize: 18.0,
                                              color: Colors.black)),
                                    )
                                  ],
                                ),
                              ),
                            ));
                      } else {
                        return const Center(child: CircularProgressIndicator());
                      }
                    }),
                FutureBuilder(
                    future: getStateRelay(token, "7"),
                    builder: (BuildContext context, AsyncSnapshot snapshot) {
                      if (snapshot.connectionState == ConnectionState.done) {
                        var hasil = jsonDecode(snapshot.data);
                        if (hasil['state'] == "1") {
                          vr7 = 1;
                          r7 = Icon(
                            FontAwesomeIcons.check,
                            size: 90,
                            color: Colors.green,
                          );
                        } else {
                          vr7 = 0;
                          r7 = Icon(
                            FontAwesomeIcons.times,
                            size: 90,
                            color: Colors.red,
                          );
                        }
                        return Card(
                            elevation: 1.0,
                            margin: new EdgeInsets.all(8.0),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            color: Color.fromRGBO(255, 255, 255, 200),
                            child: Container(
                              // height: 80,
                              decoration: const BoxDecoration(
                                  color: Color.fromRGBO(32, 201, 151, 200),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(20))),
                              child: InkWell(
                                onTap: () {
                                  if (vr7 == 1) {
                                    vr7 = 0;
                                  } else {
                                    vr7 = 1;
                                  }
                                  setState(() {
                                    setStateRelay(token, "7", vr7.toString());
                                  });
                                },
                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.stretch,
                                  mainAxisSize: MainAxisSize.min,
                                  verticalDirection: VerticalDirection.down,
                                  children: <Widget>[
                                    SizedBox(height: 50.0),
                                    Center(child: r7),
                                    SizedBox(height: 20.0),
                                    Center(
                                      child: Text("Relay 7",
                                          style: TextStyle(
                                              fontSize: 18.0,
                                              color: Colors.black)),
                                    )
                                  ],
                                ),
                              ),
                            ));
                      } else {
                        return const Center(child: CircularProgressIndicator());
                      }
                    }),
                FutureBuilder(
                    future: getStateRelay(token, "8"),
                    builder: (BuildContext context, AsyncSnapshot snapshot) {
                      if (snapshot.connectionState == ConnectionState.done) {
                        var hasil = jsonDecode(snapshot.data);
                        if (hasil['state'] == "1") {
                          vr8 = 1;
                          r8 = Icon(
                            FontAwesomeIcons.check,
                            size: 90,
                            color: Colors.green,
                          );
                        } else {
                          vr8 = 0;
                          r8 = Icon(
                            FontAwesomeIcons.times,
                            size: 90,
                            color: Colors.red,
                          );
                        }
                        return Card(
                            elevation: 1.0,
                            margin: new EdgeInsets.all(8.0),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            color: Color.fromRGBO(255, 255, 255, 200),
                            child: Container(
                              // height: 80,
                              decoration: const BoxDecoration(
                                  color: Color.fromRGBO(32, 201, 151, 200),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(20))),
                              child: InkWell(
                                onTap: () {
                                  if (vr8 == 1) {
                                    vr8 = 0;
                                  } else {
                                    vr8 = 1;
                                  }
                                  setState(() {
                                    setStateRelay(token, "8", vr8.toString());
                                  });
                                },
                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.stretch,
                                  mainAxisSize: MainAxisSize.min,
                                  verticalDirection: VerticalDirection.down,
                                  children: <Widget>[
                                    SizedBox(height: 50.0),
                                    Center(child: r8),
                                    SizedBox(height: 20.0),
                                    Center(
                                      child: Text("Relay 8",
                                          style: TextStyle(
                                              fontSize: 18.0,
                                              color: Colors.black)),
                                    )
                                  ],
                                ),
                              ),
                            ));
                      } else {
                        return const Center(child: CircularProgressIndicator());
                      }
                    }),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
