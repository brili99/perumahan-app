import 'dart:developer';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:get_storage/get_storage.dart';

import 'package:http/http.dart' as http;
import 'dart:convert';

import 'Dashboardv4.dart';

class QRViewExample extends StatefulWidget {
  const QRViewExample({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _QRViewExampleState();
}

class _QRViewExampleState extends State<QRViewExample> {
  Barcode? result;
  QRViewController? controller;
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  final box = GetStorage();

  // In order to get hot reload to work we need to pause the camera if the platform
  // is android, or resume the camera if the platform is iOS.
  @override
  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid) {
      controller!.pauseCamera();
    }
    controller!.resumeCamera();
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
      res = jsonDecode(response.body);
      // print(res);
      if (res["msg"] == "success") {
        box.write('token', res["token"]);
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => init_Dashboardv4()),
        );
        // print("doLogin");
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

  bool forOnce = true;

  @override
  Widget build(BuildContext context) {
    // String? token;

    if (result != null) {
      if (forOnce) {
        forOnce = false;
        dologinQR(result!.code.toString());
      }
    }

    return Scaffold(
      body: Column(
        children: <Widget>[
          Expanded(flex: 4, child: _buildQrView(context)),
          // Expanded(
          //   flex: 1,
          //   child: FittedBox(
          //     fit: BoxFit.contain,
          //     child: Column(
          //       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          //       children: <Widget>[
          //         // if (result == null)
          //           //   Text(
          //           //       'Barcode Type: ${describeEnum(result!.format)}   Data: ${result!.code}')
          //           // else
          //           // const Text('Scan a QR', style: ,),
          //         // Row(
          //         //   mainAxisAlignment: MainAxisAlignment.center,
          //         //   crossAxisAlignment: CrossAxisAlignment.center,
          //         //   children: <Widget>[
          //         //     Container(
          //         //       margin: const EdgeInsets.all(8),
          //         //       child: ElevatedButton(
          //         //           onPressed: () async {
          //         //             await controller?.toggleFlash();
          //         //             setState(() {});
          //         //           },
          //         //           child: FutureBuilder(
          //         //             future: controller?.getFlashStatus(),
          //         //             builder: (context, snapshot) {
          //         //               return Text('Flash: ${snapshot.data}');
          //         //             },
          //         //           )),
          //         //     ),
          //         //     Container(
          //         //       margin: const EdgeInsets.all(8),
          //         //       child: ElevatedButton(
          //         //           onPressed: () async {
          //         //             await controller?.flipCamera();
          //         //             setState(() {});
          //         //           },
          //         //           child: FutureBuilder(
          //         //             future: controller?.getCameraInfo(),
          //         //             builder: (context, snapshot) {
          //         //               if (snapshot.data != null) {
          //         //                 return Text(
          //         //                     'Camera facing ${describeEnum(snapshot.data!)}');
          //         //               } else {
          //         //                 return const Text('loading');
          //         //               }
          //         //             },
          //         //           )),
          //         //     )
          //         //   ],
          //         // ),
          //         // Row(
          //         //   mainAxisAlignment: MainAxisAlignment.center,
          //         //   crossAxisAlignment: CrossAxisAlignment.center,
          //         //   children: <Widget>[
          //         //     Container(
          //         //       margin: const EdgeInsets.all(8),
          //         //       child: ElevatedButton(
          //         //         onPressed: () async {
          //         //           await controller?.pauseCamera();
          //         //         },
          //         //         child: const Text('pause',
          //         //             style: TextStyle(fontSize: 20)),
          //         //       ),
          //         //     ),
          //         //     Container(
          //         //       margin: const EdgeInsets.all(8),
          //         //       child: ElevatedButton(
          //         //         onPressed: () async {
          //         //           await controller?.resumeCamera();
          //         //         },
          //         //         child: const Text('resume',
          //         //             style: TextStyle(fontSize: 20)),
          //         //       ),
          //         //     )
          //         //   ],
          //         // ),
          //       ],
          //     ),
          //   ),
          // )
        ],
      ),
    );
  }

  Widget _buildQrView(BuildContext context) {
    // For this example we check how width or tall the device is and change the scanArea and overlay accordingly.
    var scanArea = (MediaQuery.of(context).size.width < 400 ||
            MediaQuery.of(context).size.height < 400)
        ? 150.0
        : 300.0;
    // To ensure the Scanner view is properly sizes after rotation
    // we need to listen for Flutter SizeChanged notification and update controller
    return QRView(
      key: qrKey,
      onQRViewCreated: _onQRViewCreated,
      overlay: QrScannerOverlayShape(
          borderColor: Colors.red,
          borderRadius: 10,
          borderLength: 30,
          borderWidth: 10,
          cutOutSize: scanArea),
      onPermissionSet: (ctrl, p) => _onPermissionSet(context, ctrl, p),
    );
  }

  void _onQRViewCreated(QRViewController controller) {
    setState(() {
      this.controller = controller;
    });
    controller.scannedDataStream.listen((scanData) {
      setState(() {
        result = scanData;
      });
    });
  }

  void _onPermissionSet(BuildContext context, QRViewController ctrl, bool p) {
    log('${DateTime.now().toIso8601String()}_onPermissionSet $p');
    if (!p) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('no Permission')),
      );
    }
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }
}
