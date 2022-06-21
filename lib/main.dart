import 'package:flutter_launcher_icons/android.dart';
import 'package:flutter_launcher_icons/constants.dart';
import 'package:flutter_launcher_icons/custom_exceptions.dart';
import 'package:flutter_launcher_icons/ios.dart';
import 'package:flutter_launcher_icons/main.dart';
import 'package:flutter_launcher_icons/utils.dart';
import 'package:flutter_launcher_icons/xml_templates.dart';

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
// ignore: import_of_legacy_library_into_null_safe
// import 'package:barcode_scan/barcode_scan.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:flutter/services.dart';
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
// import 'Dashboard.dart';
import 'package:get_storage/get_storage.dart';
import 'Dashboardv8.dart';
import 'DeviceInfo.dart';
import 'QRViewExample.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'Session.dart';
import 'package:fluttertoast/fluttertoast.dart';

// import 'package:dio/dio.dart';
// import 'package:dio_cookie_manager/dio_cookie_manager.dart';
// import 'package:cookie_jar/cookie_jar.dart';
void main() async {
  await GetStorage.init();
  GetStorage box = GetStorage();
  if (box.read('token') != null) {
    runApp(init_Dashboardv8());
  } else
    runApp(MyApp());
}

class MyApp extends StatelessWidget {
  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();

    return directory.path;
  }

  MyApp({Key? key}) : super(key: key);

  static const String _title = 'Perumahan App';

  // final box = GetStorage();
  @override
  Widget build(BuildContext context) {
    // if (box.read('token') != null) {
    //   return MaterialApp(
    //     title: _title,
    //     theme: ThemeData(
    //       primaryColor: Colors.white,
    //     ),
    //     home: Scaffold(
    //       body: init_Dashboardv8(),
    //     ),
    //   );
    // } else {
    return MaterialApp(
      title: _title,
      theme: ThemeData(
        primaryColor: Colors.white,
      ),
      home: const Scaffold(
        body: MyStatefulWidget(),
      ),
    );
    // }
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
  Session session = Session();
  GlobalKey globalKey = GlobalKey();

  String? sessionApi = "";

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    String token = box.read('token').toString();
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/imagesv2/backgorund.png"),
            fit: BoxFit.cover,
          ),
        ),
        child: ListView(
          children: [
            const Padding(
              padding: EdgeInsets.only(
                left: 20,
                top: 10,
                right: 20,
                bottom: 10,
              ),
              child: Text(
                "Selamat Datang di :",
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
            ),
            Padding(
                padding: const EdgeInsets.only(
                  left: 50,
                  top: 10,
                  right: 50,
                  bottom: 10,
                ),
                child: Image.asset("assets/imagesv2/logo graha mas.png")),
            Container(
              padding: const EdgeInsets.only(
                left: 50,
                top: 20,
                right: 50,
                bottom: 5,
              ),
              child: TextField(
                controller: nameController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(12.0))),
                  fillColor: Color.fromARGB(255, 216, 216, 216),
                  filled: true,
                  labelText: 'User Name',
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.only(
                left: 50,
                top: 10,
                right: 50,
                bottom: 10,
              ),
              child: TextField(
                obscureText: true,
                controller: passwordController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(12.0))),
                  fillColor: Color.fromARGB(255, 216, 216, 216),
                  filled: true,
                  labelText: 'Password',
                ),
              ),
            ),
            Center(
              child: TextButton(
                style: ElevatedButton.styleFrom(onPrimary: Colors.white),
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
            ),
            const SizedBox(
              height: 100,
            ),
            Container(
                padding: const EdgeInsets.only(
                  left: 50,
                  top: 10,
                  right: 50,
                  bottom: 10,
                ),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    primary: Color.fromARGB(255, 216, 216, 216),
                    shape: new RoundedRectangleBorder(
                      borderRadius: new BorderRadius.circular(12.0),
                    ),
                  ),
                  child: const Padding(
                    padding: EdgeInsets.only(
                      left: 0,
                      top: 10,
                      right: 0,
                      bottom: 10,
                    ),
                    child: Text('Login',
                        style: TextStyle(color: Colors.black, fontSize: 20)),
                  ),
                  onPressed: () {
                    dologin(nameController.text, passwordController.text);
                  },
                )),
            if (defaultTargetPlatform == TargetPlatform.iOS ||
                defaultTargetPlatform == TargetPlatform.android)
              Container(
                  padding: const EdgeInsets.only(
                    left: 50,
                    top: 10,
                    right: 50,
                    bottom: 10,
                  ),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      primary: Color.fromARGB(255, 216, 216, 216),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                    ),
                    child: const Padding(
                      padding: EdgeInsets.only(
                        left: 0,
                        top: 10,
                        right: 0,
                        bottom: 10,
                      ),
                      child: Text('Scan with QR',
                          style: TextStyle(color: Colors.black, fontSize: 20)),
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const QRViewExample()),
                      );
                    },
                  )),
          ],
        ),
      ),
    );
  }

  Future<dynamic> dologin(String user, String pass) async {
    var res;
    res = await session.post('https://iot.tigamas.com/api/app/login',
        jsonEncode(<String, String>{'user': user, 'pass': pass}));
    // debugPrint(res['sess_id']);
    // print(res);
    if (res["msg"] == "success") {
      box.write('token', res["token"]);
      box.write('nama', res["nama_pengguna"]);
      // box.write('session', res["sess_id"]);
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => init_Dashboardv8()),
      );
    } else if (res["msg"] == "wrong") {
      //Wrong password
      debugPrint("Salah password atau user");
      Fluttertoast.showToast(
          msg: "Salah password",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
    } else if (res["msg"] == "NotPass") {
      //No more user available
      Fluttertoast.showToast(
          msg: "Tidak ada user tersedia",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
    }

    return res;
  }

  Future<dynamic> dologinQR(String token) async {
    var res;
    res = await session.post('https://iot.tigamas.com/api/app/loginQR',
        jsonEncode(<String, String>{'token': token}));
    if (res["msg"] == "success") {
      box.write('token', res["token"]);
      box.write('nama', res["nama_pengguna"]);
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => init_Dashboardv8()),
      );
    }
    return jsonEncode(res);
  }
}
// }

class ForgotPassword extends StatelessWidget {
  const ForgotPassword({Key? key}) : super(key: key);

  _launchURL(var _url) async {
    if (!await launch(_url)) throw 'Could not launch $_url';
  }

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
            const url = "https://wa.me/+628987295940?text=Saya lupa password";
            var encoded = Uri.encodeFull(url);
            _launchURL(encoded);
          },
          child: const Text('Hubungi admin dengan Whatsapp'),
        ),
      ),
    );
  }
}
