import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
// ignore: import_of_legacy_library_into_null_safe
import 'package:barcode_scan/barcode_scan.dart';
import 'package:flutter/services.dart';
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
// import 'Dashboard.dart';
import 'package:get_storage/get_storage.dart';
import 'Dashboardv4.dart';

void main() async {
  await GetStorage.init('perumahan');
  final box = GetStorage();
  if (box.read('token') != null)
    runApp(init_Dashboardv4());
  else
    runApp(MyApp());
}

class MyApp extends StatelessWidget {
  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();

    return directory.path;
  }

  MyApp({Key? key}) : super(key: key);

  static const String _title = 'Perumahan App';
  final box = GetStorage();
  @override
  Widget build(BuildContext context) {
    if (box.read('token') != null) {
      return MaterialApp(
        title: _title,
        theme: ThemeData(
          primaryColor: Colors.white,
        ),
        home: Scaffold(
          body: init_Dashboardv4(),
        ),
      );
    } else {
      return MaterialApp(
        title: _title,
        theme: ThemeData(
          primaryColor: Colors.white,
        ),
        home: const Scaffold(
          body: MyStatefulWidget(),
        ),
      );
    }
  }
}

class MyStatefulWidget extends StatefulWidget {
  const MyStatefulWidget({Key? key}) : super(key: key);

  @override
  State<MyStatefulWidget> createState() => _MyStatefulWidgetState();
}

class _MyStatefulWidgetState extends State<MyStatefulWidget> {
  TextEditingController nameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  String barcode = "";
  String message = "";

  // String barcode = "";

  final box = GetStorage();

  @override
  Widget build(BuildContext context) {
    // if (box.read('token') != null) {
    //   Navigator.push(
    //     context,
    //     MaterialPageRoute(builder: (context) => Dashboard()),
    //   );
    // }

    var screenSize = MediaQuery.of(context).size;
    double maxWidth = screenSize.width > 500 ? 500 : screenSize.width;
    return Padding(
        padding: const EdgeInsets.all(10),
        child: ListView(
          children: <Widget>[
            Container(
                alignment: Alignment.center,
                padding: const EdgeInsets.all(10),
                child: const Text(
                  'Perumahan Tiga Mas',
                  style: TextStyle(
                      color: Color.fromRGBO(254, 211, 44, 1),
                      fontWeight: FontWeight.w500,
                      fontSize: 30),
                )),
            Container(
                alignment: Alignment.center,
                padding: const EdgeInsets.all(10),
                child: const Text(
                  'Sign in',
                  style: TextStyle(fontSize: 20),
                )),
            Container(
              padding: const EdgeInsets.all(10),
              child: TextField(
                controller: nameController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'User Name',
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
              child: TextField(
                obscureText: true,
                controller: passwordController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Password',
                ),
              ),
            ),
            TextButton(
              style: ElevatedButton.styleFrom(onPrimary: Colors.black),
              onPressed: () {
                //forgot password screen
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const ForgotPassword()),
                );
              },
              child: const Text('Forgot Password'),
            ),
            Container(
                margin: const EdgeInsets.only(top: 20.0),
                height: 50,
                // width: screenSize.width > 200 ? 500 : screenSize.width,
                padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      primary: Color.fromRGBO(254, 233, 44, 1),
                      onPrimary: Colors.black),
                  child: const Text('Login'),
                  onPressed: () {
                    // print(nameController.text);
                    // print(passwordController.text);
                    // doLogin(nameController.text, passwordController.text);
                    dologin(nameController.text, passwordController.text);
                  },
                )),
            if (defaultTargetPlatform == TargetPlatform.iOS ||
                defaultTargetPlatform == TargetPlatform.android)
              Container(
                  margin: const EdgeInsets.only(top: 20.0),
                  height: 50,
                  padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        primary: Color.fromRGBO(254, 233, 44, 1),
                        onPrimary: Colors.black),
                    child: const Text('Scan with QR'),
                    onPressed: () async {
                      //scan qr
                      if (defaultTargetPlatform == TargetPlatform.iOS ||
                          defaultTargetPlatform == TargetPlatform.android) {
                        try {
                          ScanResult qrScanResult = await BarcodeScanner.scan();
                          String qrResult = qrScanResult.rawContent;
                          // String barcode = (await BarcodeScanner.scan()) as String;
                          // print(barcode);
                          dologinQR(qrResult);
                          setState(() {
                            box.write('token', qrResult);
                            barcode = qrResult;
                          });
                        } on PlatformException catch (error) {
                          if (error.code == BarcodeScanner.cameraAccessDenied) {
                            setState(() {
                              barcode =
                                  'Izin kamera tidak diizinkan oleh si pengguna';
                            });
                          } else {
                            setState(() {
                              barcode = 'Error: $error';
                            });
                          }
                        }
                      }
                    },
                  )),
            Text(
              message,
              textAlign: TextAlign.center,
            ),
            // Row(
            //   children: <Widget>[
            //     const Text('Does not have account?'),
            //     TextButton(
            //       child: const Text(
            //         'Sign in',
            //         style: TextStyle(fontSize: 20),
            //       ),
            //       onPressed: () {
            //         //signup screen
            //       },
            //     )
            //   ],
            //   mainAxisAlignment: MainAxisAlignment.center,
            // ),
          ],
        ));
  }

  Future<dynamic> dologin(String user, String pass) async {
    var res;
    await http
        .post(
      Uri.parse('https://iot.tigamas.com/api/app/login'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'user': user,
        'pass': pass,
      }),
    )
        .then((http.Response response) {
      // final int statusCode = response.statusCode;
      // print("====response ${response.body.toString()}");
      res = jsonDecode(response.body);
      if (res["msg"] == "success") {
        box.write('token', res["token"]);
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => init_Dashboardv4()),
        );
      } else {
        //Wrong password
      }
      // if (statusCode < 200 || statusCode >= 400 || json == null) {
      //   print(jsonDecode(response.body)["message"]);
      // }
      // return response.body;
    });
    return res;
  }

  Future<dynamic> dologinQR(String token) async {
    var res;
    await http
        .post(
      Uri.parse('https://iot.tigamas.com/api/app/loginQR'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{'token': token}),
    )
        .then((http.Response response) {
      // final int statusCode = response.statusCode;
      // print("====response ${response.body.toString()}");
      res = jsonDecode(response.body)["msg"];
      print(res);
      if (res == "success") {
        // box.write('token', res["token"]);
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => init_Dashboardv4()),
        );
      } else {
        //Wrong password
      }
      // if (statusCode < 200 || statusCode >= 400 || json == null) {
      //   print(jsonDecode(response.body)["message"]);
      // }
      // return response.body;
    });
    return res;
  }

  Future<dynamic> changeRelay(String token, String sw) async {
    var res;
    await http
        .post(
      Uri.parse('https://iot.tigamas.com/api/app/loginQR'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{'token': token, 'switch': sw}),
    )
        .then((http.Response response) {
      // final int statusCode = response.statusCode;
      // print("====response ${response.body.toString()}");
      res = jsonDecode(response.body)["msg"];
      if (res == "success") {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => init_Dashboardv4()),
        );
      } else {
        //Wrong password
      }
      // if (statusCode < 200 || statusCode >= 400 || json == null) {
      //   print(jsonDecode(response.body)["message"]);
      // }
      // return response.body;
    });
    return res;
  }
}

// class Dashboard extends StatelessWidget {
//   const Dashboard({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       // appBar: AppBar(
//       //   title: const Text('Dashboard'),
//       // ),
//       body: Center(
//         child: ElevatedButton(
//           onPressed: () {
//             // Navigate back to first route when tapped.
//           },
//           child: const Text('Go back!'),
//         ),
//       ),
//     );
//   }
// }

class ForgotPassword extends StatelessWidget {
  const ForgotPassword({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Forgot password'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            // Navigate back to first route when tapped.
          },
          child: const Text('Go back!'),
        ),
      ),
    );
  }
}
