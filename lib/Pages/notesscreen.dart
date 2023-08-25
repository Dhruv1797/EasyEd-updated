import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';
import 'package:easyed/Pages/addpdfscreen.dart';
import 'package:easyed/Pages/dashboardscreen.dart';
import 'package:easyed/Pages/pdfviewerpage.dart';
import 'package:easyed/Pages/taskpostscreen.dart';
import 'package:easyed/models/Teacher.dart';
import 'package:easyed/pdf_api.dart';

import 'package:easyed/widgets/drawer.dart';

import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:easyed/widgets/widgets.dart';

class NotesScreen extends StatefulWidget {
  static const routeName = '/notesscreen';
  const NotesScreen({super.key});

  @override
  State<NotesScreen> createState() => _NotesScreenState();
}

class _NotesScreenState extends State<NotesScreen> {
  Future onReturn() async => setState(() => getnotesdata());
  final uid = FirebaseAuth.instance.currentUser!.uid;
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  List<Note> noteslist = [];

  Note notesdata = Note(
      creator: "",
      noteClass: "",
      subject: "",
      topic: "",
      noteHash: "",
      isFree: true,
      price: "",
      notesPdfLink: "",
      id: "");

  List<Notesbox> subjectBoxlist = [
    Notesbox(
      "Basic Properties",
    ),
    Notesbox(
      "Basic Properties",
    ),
    Notesbox(
      "Basic Properties",
    ),
    Notesbox(
      "Basic Properties",
    ),
    Notesbox(
      "Basic Properties",
    ),
  ];

  // List<Teacher> teacherslist = [];
  // Teacher sampleteachers = Teacher(
  //     id: 'id',
  //     commons: [],
  //     userDetails: [],
  //     educationalDetails: [],
  //     tasks: [],
  //     notes: [],
  //     videoLecture: [],
  //     students: [],
  //     v: 1);

  // void handleClick(String value) {
  //   switch (value) {
  //     case 'Option 1':
  //       break;
  //     case 'Option 2':
  //       break;
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    double deviceheight = MediaQuery.of(context).size.height;
    double appbarheight = 45;

    double devicewidth = MediaQuery.of(context).size.width;

    return WillPopScope(
      onWillPop: () async {
        PersistentNavBarNavigator.pushNewScreen(
          context,
          screen: Dashboard(),
          withNavBar: true, // OPTIONAL VALUE. True by default.
          pageTransitionAnimation: PageTransitionAnimation.cupertino,
        );

        return false;
      },
      child: Scaffold(
        key: _scaffoldKey,
        drawer: MyDrawer(),
        body: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  height: 90 - appbarheight,
                ),
                Container(
                  width: devicewidth,
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // SizedBox(
                        //   width: 29,
                        // ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: GestureDetector(
                            onTap: () {
                              _scaffoldKey.currentState?.openDrawer();
                            },
                            child: Container(
                              height: 20,
                              width: 30,
                              child: Image.asset("assets/iconmenu.png"),
                            ),
                          ),
                        ),
                        Row(
                          children: [
                            Text(
                              "Pdf",
                              style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.w900,
                                  fontSize: 30),
                            ),
                            Text(
                              "Notes",
                              style: TextStyle(
                                  color: Color.fromRGBO(38, 90, 232, 1),
                                  fontWeight: FontWeight.w900,
                                  fontSize: 30),
                            ),
                          ],
                        ),

                        InkWell(
                          child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  elevation: 5,
                                  backgroundColor:
                                      Color.fromRGBO(38, 90, 232, 1),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(30),
                                  )),
                              onPressed: () async {
                                PersistentNavBarNavigator.pushNewScreen(
                                  context,
                                  screen: AddPdfScreen(),
                                  withNavBar:
                                      true, // OPTIONAL VALUE. True by default.
                                  pageTransitionAnimation:
                                      PageTransitionAnimation.cupertino,
                                );

                                // nextScreen(context, AddPdfScreen());
                              },
                              child: Row(
                                children: [
                                  Text(
                                    "+ ",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 24,
                                    ),
                                  ),
                                  Text(
                                    "Add Notes",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w600),
                                  ),
                                ],
                              )),
                        ),
                        // SizedBox(
                        //   width: devicewidth * 0.7,
                        // ),
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
                ),
                Container(
                  height: 100,
                  width: devicewidth * 0.95,
                  decoration: BoxDecoration(
                    color: Color.fromRGBO(255, 255, 255, 1),
                    borderRadius: BorderRadius.all(Radius.circular(1)),
                    boxShadow: [
                      BoxShadow(
                        color: Color.fromRGBO(0, 0, 0, 0.25),
                        blurRadius: 1.0,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      // SizedBox(
                      //   height: 23,
                      // ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          // SizedBox(
                          //   width: 22,
                          // ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "STUDY",
                                style: TextStyle(
                                    color: Color.fromRGBO(11, 18, 31, 1),
                                    fontWeight: FontWeight.w500,
                                    fontSize: 26),
                              ),
                              Text(
                                "Get Notes!",
                                style: TextStyle(
                                    color: Color.fromRGBO(112, 116, 126, 1),
                                    fontWeight: FontWeight.w400,
                                    fontSize: 12),
                              ),
                            ],
                          ),

                          CircleAvatar(
                            radius: 46,
                            backgroundImage:
                                AssetImage("assets/Rectangle 129.png"),
                          )
                        ],
                      ),
                      // SizedBox(
                      //   height: 35,
                      // ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Container(
                  height: deviceheight * 0.5,
                  width: devicewidth * 0.78,
                  child: RefreshIndicator(
                    onRefresh: () async {
                      await refreshdata();
                    },
                    child: FutureBuilder(
                        future: getnotesdata(),
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            return ListView.builder(
                              itemCount: noteslist.length,
                              itemBuilder: (context, index) {
                                print(noteslist.length);
                                return buildlistitem(context, index);
                              },
                            );
                          } else {
                            return Center(
                              child: CircularProgressIndicator(),
                            );
                          }
                        }),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildlistitem(BuildContext context, int index) {
    double deviceheight = MediaQuery.of(context).size.height;

    double devicewidth = MediaQuery.of(context).size.width;
    // Notesbox subjectwidget = subjectBoxlist[index];
    Note notedata = noteslist[index];
    return GestureDetector(
      onTap: () {
        print(index);
        if (index == 0) {}
      },
      child: Padding(
        padding: const EdgeInsets.only(top: 13, bottom: 7),
        child: GestureDetector(
          onTap: () async {
            // if (isloading = true) {
            //   return;
            // }
            // refreshdata();

            setState(() {
              isloading = true;
            });

            final String url = notedata.notesPdfLink;

            final file = await PDFApi.loadNetwork(url);

            await openPDF(context, file);

            setState(() {
              isloading = false;
            });
          },
          child: Container(
            // height: deviceheight * 0.06,
            width: devicewidth * 0.73,
            decoration: BoxDecoration(
              // color: Colors.red,
              color: Color.fromRGBO(255, 255, 255, 1),
              border: Border.all(),
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(10),
                  topRight: Radius.circular(10),
                  bottomLeft: Radius.circular(10),
                  bottomRight: Radius.circular(10)),
              boxShadow: [
                BoxShadow(
                  color: Color.fromRGBO(0, 0, 0, 0.25),
                  blurRadius: 1.0,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              children: [
                SizedBox(
                  height: 6,
                ),
                SizedBox(
                  width: 12,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding:
                          const EdgeInsets.only(left: 13.0, right: 8.0, top: 3),
                      child: isloading
                          ? Container(
                              height: 20,
                              width: 20,
                              child:
                                  CircularProgressIndicator(color: Colors.blue),
                            )
                          : Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Container(
                                      child: Image.asset("assets/pdf.png"),
                                      height: 27,
                                      width: 27,
                                    ),
                                    // SizedBox(
                                    //   width: 22,
                                    // ),
                                    Padding(
                                      padding: const EdgeInsets.only(left: 10),
                                      child: Container(
                                        width: 140,
                                        child: SingleChildScrollView(
                                          child: Text(
                                            notedata.topic,
                                            maxLines: 2,
                                            style: TextStyle(
                                                fontSize: 13,
                                                fontWeight: FontWeight.w600,
                                                color: Color.fromRGBO(
                                                    38, 50, 56, 1)),
                                          ),
                                        ),
                                      ),
                                    ),
                                    // SizedBox(
                                    //   width: 64,
                                    // ),
                                  ],
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(right: 5),
                                  child: Container(
                                    // color: Colors.red,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        SingleChildScrollView(
                                          child: Text(
                                            "By: " + notedata.creator,
                                            style: TextStyle(
                                                fontWeight: FontWeight.w800,
                                                fontSize: 12),
                                          ),
                                        ),
                                      ],
                                    ),
                                    height: 27,
                                    width: devicewidth * 0.7.w,
                                  ),
                                ),
                              ],
                            ),
                    ),
                    // Padding(
                    //   padding: const EdgeInsets.only(left: 2.0, top: 3),
                    //   child: Column(
                    //     children: [
                    //       Container(
                    //         // color: Colors.red,
                    //         child: SingleChildScrollView(
                    //           child: Center(
                    //               child: Text(
                    //             "By: " + notedata.creator,
                    //             style: TextStyle(
                    //                 fontWeight: FontWeight.w800, fontSize: 12),
                    //           )),
                    //         ),
                    //         height: 27,
                    //         width: 90,
                    //       ),
                    //     ],
                    //   ),
                    // ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<List<Note>> getnotesdata() async {
    final response = await http
        .get(Uri.parse('https://api.easyeduverse.tech/api/user/$uid/notes'));
    // 'https://easyed-backend.onrender.com/api/teacher/$uid/notes'));
    var data = jsonDecode(response.body.toString());

    // print(data.toString());
    noteslist = [];
    if (response.statusCode == 200) {
      for (Map<String, dynamic> index in data) {
        noteslist.add(Note.fromJson(index));
      }
      // teacherslist.add(sampleteachers);

      // print(sampleteachers.toString());
      // for (Map<String, dynamic> index in data) {
      //   sampleteachers.add(Teacher.fromJson(index));
      // }
      return noteslist;
    } else {
      return noteslist;
    }
  }

  // Future<Teacher> getTeacherdata() async {
  //   final response = await http.get(Uri.parse(
  //       'https://easyed-backend.onrender.com/api/teacher/sonamWangchik'));
  //   var data = jsonDecode(response.body.toString());

  //   // print(data.toString());

  //   if (response.statusCode == 200) {
  //     sampleteachers = Teacher.fromJson(data);
  //     // sampleteachers. = dat;

  //     teacherslist.add(sampleteachers);

  //     // print(sampleteachers.toString());
  //     // for (Map<String, dynamic> index in data) {
  //     //   sampleteachers.add(Teacher.fromJson(index));
  //     // }
  //     return sampleteachers;
  //   } else {
  //     return sampleteachers;
  //   }
  // }
  Future<void> refreshdata() async {
    await Navigator.push(
            context, MaterialPageRoute(builder: (context) => NotesScreen()))
        .then((value) => onReturn());
  }

  Future openPDF(BuildContext context, File file) async {
    // refreshdata();
    PersistentNavBarNavigator.pushNewScreen(
      context,
      screen: PDFViewerPage(
        file: file,
      ),
      withNavBar: true, // OPTIONAL VALUE. True by default.
      pageTransitionAnimation: PageTransitionAnimation.cupertino,
    );
    // nextScreen(
    //     context,
    //     PDFViewerPage(
    //       file: file,
    //     ));
  }
}

class Notesbox {
  final String contentname;

  Notesbox(
    this.contentname,
  );
}
