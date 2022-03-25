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

import 'chatMessageModel.dart';

List<ChatMessage> messages = [
  ChatMessage(messageContent: "Test", messageType: "receiver"),
  // ChatMessage(messageContent: "How have you been?", messageType: "receiver"),
  // ChatMessage(
  //     messageContent: "Hey Kriss, I am doing fine dude. wbu?",
  //     messageType: "sender"),
  // ChatMessage(messageContent: "ehhhh, doing OK.", messageType: "receiver"),
  // ChatMessage(
  //     messageContent: "Is there any thing wrong?", messageType: "sender"),
];

class init_Chat extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // String token = box.read('token');
    return MaterialApp(
      title: "Dashboard",
      theme: ThemeData(
        primaryColor: Colors.white,
      ),
      home: const Scaffold(
        body: Chat(),
      ),
    );
  }
}

class Chat extends StatefulWidget {
  // const Dashboardv2({Key? key}) : super(key: key);
  const Chat();
  @override
  State<Chat> createState() => _Chat();
}

class _Chat extends State<Chat> {
  final box = GetStorage();
  TextEditingController msgController = TextEditingController();

  @override
  void initState() {
    super.initState();
    String token = box.read('token').toString();
    getMessage(token);
    setState(() {});

    // sinkronisasi pesan dari admin
    Timer.periodic(new Duration(seconds: 5), (timer) {
      // debugPrint(timer.tick.toString());
      getSyncTimestamp(token);
      // print("check");
    });
  }

  int timestampMsg = 0;
  getSyncTimestamp(String token) async {
    var response = await http.post(
      Uri.parse("https://iot.tigamas.com/api/app/action"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(<String, String>{
        "action": "getLastMessageFromAdmin",
        "token": token,
      }),
    );
    var data = json.decode(response.body);
    if (data['msg'] == "success") {
      //Jika terdapat perubahan pesan
      if (timestampMsg != data['data']) {
        timestampMsg = data['data'];
        getMessage(token);
        //penambahan notif pesan jika diperlukan
      } else {
        print("pesan sama");
      }
    }
  }

  sendMessage(String token, String message) async {
    var response = await http.post(
      Uri.parse("https://iot.tigamas.com/api/app/action"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(<String, String>{
        "action": "sendMessage",
        "token": token,
        "message": message,
      }),
    );
    if (json.decode(response.body)['msg'] == "success") {
      messages.add(ChatMessage(messageContent: message, messageType: "sender"));
    } else {
      // msg fail
    }
    // rVal = json.decode(response.body)['data'].cast<int>();
    setState(() {});
    // print(rVal);
    return response.body;
  }

  getMessage(String token) async {
    messages = [];
    var response = await http.post(
      Uri.parse("https://iot.tigamas.com/api/app/action"),
      headers: {"Content-Type": "application/json"},
      body:
          jsonEncode(<String, String>{"action": "getMessage", "token": token}),
    );
    var data = json.decode(response.body);
    // print(data['data'].length);
    if (data['msg'] == "success") {
      for (var i = 0; i < data['data'].length; i++) {
        // print(data['data'][i]);
        var msgType =
            data['data'][i]['from_admin'] == 1 ? "receiver" : "sender";
        messages.add(ChatMessage(
            messageContent: data['data'][i]['content'], messageType: msgType));
      }
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    String token = box.read('token').toString();
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        flexibleSpace: SafeArea(
          child: Container(
            padding: EdgeInsets.only(right: 16),
            child: Row(
              children: <Widget>[
                IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: Icon(
                    Icons.arrow_back,
                    color: Colors.black,
                  ),
                ),
                SizedBox(
                  width: 2,
                ),
                // CircleAvatar(
                //   backgroundImage: NetworkImage(
                //       "https://randomuser.me/api/portraits/men/5.jpg"),
                //   maxRadius: 20,
                // ),
                SizedBox(
                  width: 12,
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        "Admin",
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w600),
                      ),
                      SizedBox(
                        height: 6,
                      ),
                      Text(
                        "Online",
                        style: TextStyle(
                            color: Colors.grey.shade600, fontSize: 13),
                      ),
                    ],
                  ),
                ),
                Icon(
                  Icons.settings,
                  color: Colors.black54,
                ),
              ],
            ),
          ),
        ),
      ),
      body: Stack(
        children: <Widget>[
          ListView.builder(
            itemCount: messages.length,
            shrinkWrap: true,
            padding: EdgeInsets.only(top: 10, bottom: 10),
            physics: NeverScrollableScrollPhysics(),
            itemBuilder: (context, index) {
              return Container(
                padding:
                    EdgeInsets.only(left: 14, right: 14, top: 10, bottom: 10),
                child: Align(
                  alignment: (messages[index].messageType == "receiver"
                      ? Alignment.topLeft
                      : Alignment.topRight),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: (messages[index].messageType == "receiver"
                          ? Colors.grey.shade200
                          : Color.fromRGBO(254, 233, 44, 1)),
                    ),
                    padding: EdgeInsets.all(16),
                    child: Text(
                      messages[index].messageContent,
                      style: TextStyle(fontSize: 15),
                    ),
                  ),
                ),
              );
            },
          ),
          Align(
            alignment: Alignment.bottomLeft,
            child: Container(
              padding: EdgeInsets.only(left: 10, bottom: 10, top: 10),
              height: 60,
              width: double.infinity,
              color: Colors.white,
              child: Row(
                children: <Widget>[
                  // GestureDetector(
                  //   onTap: () {},
                  //   child: Container(
                  //     height: 30,
                  //     width: 30,
                  //     decoration: BoxDecoration(
                  //       color: Colors.lightBlue,
                  //       borderRadius: BorderRadius.circular(30),
                  //     ),
                  //     child: Icon(
                  //       Icons.add,
                  //       color: Colors.white,
                  //       size: 20,
                  //     ),
                  //   ),
                  // ),
                  SizedBox(
                    width: 15,
                  ),
                  Expanded(
                    child: TextField(
                      controller: msgController,
                      decoration: InputDecoration(
                          hintText: "Write message...",
                          hintStyle: TextStyle(color: Colors.black54),
                          border: InputBorder.none),
                    ),
                  ),
                  SizedBox(
                    width: 15,
                  ),
                  FloatingActionButton(
                    onPressed: () {
                      if (msgController.text != "") {
                        sendMessage(token, msgController.text);
                      }
                    },
                    child: Icon(
                      Icons.send,
                      color: Colors.black,
                      size: 18,
                    ),
                    backgroundColor: Color.fromRGBO(254, 233, 44, 1),
                    elevation: 0,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
