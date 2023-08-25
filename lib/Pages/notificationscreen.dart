import 'package:flutter/material.dart';
import 'package:easyed/Pages/globalvariables.dart';

import 'package:easyed/widgets/drawer.dart';

class NOtificationScreen extends StatefulWidget {
  const NOtificationScreen({super.key});

  @override
  State<NOtificationScreen> createState() => _NOtificationScreenState();
}

class _NOtificationScreenState extends State<NOtificationScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  List<Notificationbox> subjectBoxlist = [
    Notificationbox(
        notification: "@raj123 liked your post", status: "Got a like!"),
    Notificationbox(
        notification: "@manoj43 liked your post", status: "Got a like!"),
    Notificationbox(
        notification: "@mohan92 liked your post", status: "Got a like!"),
    Notificationbox(
        notification: "@kunal51 liked your post", status: "Got a like!"),
  ];

  void handleClick(String value) {
    switch (value) {
      case 'Option 1':
        break;
      case 'Option 2':
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    double deviceheight = MediaQuery.of(context).size.height;
    double appbarheight = 45;

    double devicewidth = MediaQuery.of(context).size.width;
    String format = "video/png";
    String email = "dhruv2122@gmail.com";
    String emailid = "dhruvrastogi1797@kiet.edu";

    String username = emailid.split('@')[0];

    return Scaffold(
      key: _scaffoldKey,
      drawer: MyDrawer(),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                height: 90 - appbarheight,
              ),

              // Text(email.replaceFirst("@gmail.com", "")),
              Text(username),
              Text(format.contains("video").toString()),

              // Text(globalteacherdata.id.substring(17)),
              // Text(globalteacherdata.userDetails[0].lastName),
              // Text(globalusername!),
              Text(globalteacherdata.id),
              Container(
                width: devicewidth,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    GestureDetector(
                      onTap: () {
                        _scaffoldKey.currentState?.openDrawer();
                      },
                      child: Container(
                        height: 20,
                        width: 30,
                        child: Image.asset("assets/iconmenu.png"),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 35.0),
                      child: Text(
                        'Notifications',
                        style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                            color: Color.fromRGBO(38, 50, 56, 1)),
                      ),
                    ),
                    // PopupMenuButton<String>(
                    //   onSelected: handleClick,
                    //   itemBuilder: (BuildContext context) {
                    //     return {'Option 1', 'Option 2'}.map((String choice) {
                    //       return PopupMenuItem<String>(
                    //         value: choice,
                    //         child: Text(choice),
                    //       );
                    //     }).toList();
                    //   },
                    // ),
                  ],
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Container(
                height: deviceheight * 0.5,
                width: devicewidth * 0.98,
                child: ListView.builder(
                  itemBuilder: (context, index) {
                    return buildlistitem(context, index);
                  },
                  itemCount: subjectBoxlist.length,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget buildlistitem(BuildContext context, int index) {
    double deviceheight = MediaQuery.of(context).size.height;

    double devicewidth = MediaQuery.of(context).size.width;
    Notificationbox subjectwidget = subjectBoxlist[index];
    return GestureDetector(
      onTap: () {
        print(index);
      },
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          decoration: BoxDecoration(
            color: Color.fromRGBO(255, 255, 255, 1),
            borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(2),
                bottomRight: Radius.circular(2)),
            boxShadow: [
              BoxShadow(
                color: Color.fromRGBO(0, 0, 0, 0.25),
                blurRadius: 1.0,
                offset: Offset(0, 2),
              ),
            ],
          ),
          height: deviceheight * 0.098,
          width: devicewidth * 0.73,
          child: Column(
            children: [
              SizedBox(
                height: 6,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Row(
                    children: [
                      Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  subjectwidget.notification!,
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                      color: Color.fromRGBO(38, 50, 56, 1)),
                                ),
                                Text(
                                  subjectwidget.status!,
                                  style: TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w400,
                                      color: Color.fromRGBO(38, 50, 56, 1)),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  Container(
                      height: 24,
                      width: 24,
                      child: Image.asset(
                        "assets/likes.png",
                        color: Color.fromRGBO(38, 90, 232, 1),
                      ))
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class Notificationbox {
  final String? notification;
  final String? status;

  Notificationbox({
    required this.notification,
    required this.status,
  });
}
