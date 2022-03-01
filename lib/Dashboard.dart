import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:get_storage/get_storage.dart';

class Dashboard extends StatelessWidget {
  Dashboard({Key? key}) : super(key: key);
  final box = GetStorage();
  List<Icon> test = [];
  var token = "";
// out: GetX is the best;
  Icon r1 = Icon(
    FontAwesomeIcons.check,
    size: 90,
    color: Colors.green,
  );
  Icon r2 = Icon(
    FontAwesomeIcons.check,
    size: 90,
    color: Colors.green,
  );
  Icon r3 = Icon(
    FontAwesomeIcons.check,
    size: 90,
    color: Colors.green,
  );
  Icon r4 = Icon(
    FontAwesomeIcons.check,
    size: 90,
    color: Colors.green,
  );
  Icon r5 = Icon(
    FontAwesomeIcons.check,
    size: 90,
    color: Colors.green,
  );
  Icon r6 = Icon(
    FontAwesomeIcons.check,
    size: 90,
    color: Colors.green,
  );
  Icon r7 = Icon(
    FontAwesomeIcons.check,
    size: 90,
    color: Colors.green,
  );
  Icon r8 = Icon(
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
    print('Token: ' + token);
    print('Relay: ' + relay);
    return response.body;
  }

  @override
  Widget build(BuildContext context) {
    token = box.read('token');
    return MaterialApp(
      home: Scaffold(
        // appBar: AppBar(
        //   title: Text('GridView'),
        // ),
        body: Center(
          child: Container(
            // height: 200,
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
                          r1 = Icon(
                            FontAwesomeIcons.check,
                            size: 90,
                            color: Colors.green,
                          );
                        } else {
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
                                onTap: () {},
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
                    })
              ],
            ),
          ),
        ),
      ),
    );
  }

  Card makeDashboardItem(String title, IconData icon, String relay, bg_color) {
    return Card(
        elevation: 1.0,
        margin: new EdgeInsets.all(8.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        color: bg_color,
        child: Container(
          decoration: BoxDecoration(
              color: bg_color,
              borderRadius: BorderRadius.all(Radius.circular(20))),
          child: new InkWell(
            onTap: () {},
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisSize: MainAxisSize.min,
              verticalDirection: VerticalDirection.down,
              children: <Widget>[
                SizedBox(height: 50.0),
                Center(
                    child: Icon(
                  icon,
                  size: 40.0,
                  color: Colors.black,
                )),
                SizedBox(height: 20.0),
                new Center(
                  child: new Text(title,
                      style:
                          new TextStyle(fontSize: 18.0, color: Colors.black)),
                )
              ],
            ),
          ),
        ));
  }
}
