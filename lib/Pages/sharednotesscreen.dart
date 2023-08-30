import 'package:easyed/Pages/globalvariables.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
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

class SharedNotesScreen extends StatefulWidget {
  static const routeName = '/SharedNotesScreen';
  const SharedNotesScreen({super.key});

  @override
  State<SharedNotesScreen> createState() => _SharedNotesScreenState();
}

class _SharedNotesScreenState extends State<SharedNotesScreen> {
  Future onReturn() async => setState(() => getnotesdata());
  final uid = FirebaseAuth.instance.currentUser!.uid;
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  List<Note> noteslist = [];

  List<Sharednote> sharednoteslist = [];
  Teacher teacherdata = Teacher(
      id: 'id',
      commons: [],
      userDetails: [],
      educationalDetails: [],
      tasks: [],
      notes: [],
      videoLecture: [],
      // students: [],
      v: 1,
      sharedlectures: [],
      sharednotes: [],
      sharedtasks: []);

  Note notesdata = Note(
      creator: "",
      noteClass: "",
      subject: "",
      topic: "",
      isFree: true,
      price: "",
      notesPdfLink: "",
      id: "",
      v: 0);

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
                      mainAxisAlignment: MainAxisAlignment.start,
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
                              "SharedPdf",
                              style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.w900,
                                  fontSize: 30),
                            ),
                            Text(
                              "Notes",
                              style: TextStyle(
                                  color: Color.fromRGBO(86, 103, 253, 1),
                                  fontWeight: FontWeight.w900,
                                  fontSize: 30),
                            ),
                          ],
                        ),

                        // InkWell(
                        //   child: ElevatedButton(
                        //       style: ElevatedButton.styleFrom(
                        //           elevation: 5,
                        //           backgroundColor:
                        //               Color.fromRGBO(86, 103, 253, 1),
                        //           shape: RoundedRectangleBorder(
                        //             borderRadius: BorderRadius.circular(30),
                        //           )),
                        //       onPressed: () async {
                        //         PersistentNavBarNavigator.pushNewScreen(
                        //           context,
                        //           screen: AddPdfScreen(),
                        //           withNavBar:
                        //               true, // OPTIONAL VALUE. True by default.
                        //           pageTransitionAnimation:
                        //               PageTransitionAnimation.cupertino,
                        //         );

                        //         // nextScreen(context, AddPdfScreen());
                        //       },
                        //       child: Row(
                        //         children: [
                        //           Text(
                        //             "+ ",
                        //             style: TextStyle(
                        //               color: Colors.white,
                        //               fontSize: 24,
                        //             ),
                        //           ),
                        //           Text(
                        //             "Add Notes",
                        //             style: TextStyle(
                        //                 color: Colors.white,
                        //                 fontWeight: FontWeight.w600),
                        //           ),
                        //         ],
                        //       )),
                        // ),
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
                // Container(
                //   height: 100,
                //   width: devicewidth * 0.95,
                //   decoration: BoxDecoration(
                //     color: Color.fromRGBO(255, 255, 255, 1),
                //     borderRadius: BorderRadius.all(Radius.circular(1)),
                //     boxShadow: [
                //       BoxShadow(
                //         color: Color.fromRGBO(0, 0, 0, 0.25),
                //         blurRadius: 1.0,
                //         offset: Offset(0, 2),
                //       ),
                //     ],
                //   ),
                //   child: Column(
                //     children: [
                //       // SizedBox(
                //       //   height: 23,
                //       // ),
                //       Row(
                //         mainAxisAlignment: MainAxisAlignment.spaceAround,
                //         children: [
                //           // SizedBox(
                //           //   width: 22,
                //           // ),
                //           Column(
                //             crossAxisAlignment: CrossAxisAlignment.start,
                //             children: [
                //               Text(
                //                 "STUDY",
                //                 style: TextStyle(
                //                     color: Color.fromRGBO(11, 18, 31, 1),
                //                     fontWeight: FontWeight.w500,
                //                     fontSize: 26),
                //               ),
                //               Text(
                //                 "Get Notes!",
                //                 style: TextStyle(
                //                     color: Color.fromRGBO(112, 116, 126, 1),
                //                     fontWeight: FontWeight.w400,
                //                     fontSize: 12),
                //               ),
                //             ],
                //           ),

                //           CircleAvatar(
                //             radius: 46,
                //             backgroundImage:
                //                 AssetImage("assets/Rectangle 129.png"),
                //           )
                //         ],
                //       ),
                //       // SizedBox(
                //       //   height: 35,
                //       // ),
                //     ],
                //   ),
                // ),
                SizedBox(
                  height: 20,
                ),
                Container(
                  // color: Colors.red,
                  height: deviceheight * 0.76,
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
                              itemCount: sharednoteslist.length,
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
    Sharednote sharednotedata = sharednoteslist[index];
    // Note notedata = noteslist[index];
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

            final String url = sharednotedata.notesId!.notesPdfLink;

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
              border: Border.all(
                color: Color.fromRGBO(182, 214, 204, 1),
              ),
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(10),
                  topRight: Radius.circular(10),
                  bottomLeft: Radius.circular(10),
                  bottomRight: Radius.circular(10)),
              boxShadow: [
                BoxShadow(
                  color: Color.fromRGBO(182, 214, 204, 1),
                  blurRadius: 6.0,
                  offset: Offset(0, 6),
                ),
              ],
            ),
            child: Column(
              children: [
                SizedBox(
                  height: 9.h,
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: 13.w,
                    ),
                    Container(
                      height: 41.3,
                      width: 31,
                      child: SvgPicture.asset("assets/pdficon.svg"),
                    ),
                    SizedBox(
                      width: 17.w,
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          // color: Colors.red,
                          width: 150.w,
                          child: Text(
                            sharednotedata.notesId!.topic,
                            style: TextStyle(
                              fontSize: 15.sp,
                              fontWeight: FontWeight.w600,
                              fontFamily: "Montserrat",
                              color: Color.fromRGBO(66, 72, 78, 1),
                            ),
                          ),
                        ),
                        Container(
                          // color: Colors.red,
                          width: 150.w,
                          child: Text(
                            "By: " + sharednotedata.sharedBy,
                            style: TextStyle(
                              fontSize: 10.sp,
                              fontWeight: FontWeight.w400,
                              fontFamily: "Montserrat",
                              color: Color.fromRGBO(66, 72, 78, 1),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      width: 30.w,
                    ),
                    // GestureDetector(
                    //   onTap: () async {
                    //     _showTextFieldAlertDialog(context, notedata.id);
                    //   },
                    //   child: Container(
                    //     height: 24.44,
                    //     width: 22,
                    //     child: SvgPicture.asset("assets/shareicon.svg"),
                    //   ),
                    // )
                  ],
                ),

                SizedBox(
                  height: 8.h,
                )
                // Column(
                //   crossAxisAlignment: CrossAxisAlignment.start,
                //   children: [
                //     Padding(
                //       padding:
                //           const EdgeInsets.only(left: 13.0, right: 8.0, top: 3),
                //       child: isloading
                //           ? Container(
                //               height: 20,
                //               width: 20,
                //               child:
                //                   CircularProgressIndicator(color: Colors.blue),
                //             )
                //           : Column(
                //               mainAxisAlignment: MainAxisAlignment.start,
                //               crossAxisAlignment: CrossAxisAlignment.start,
                //               children: [
                //                 Row(
                //                   children: [
                //                     Container(
                //                       child: Image.asset("assets/pdf.png"),
                //                       height: 27,
                //                       width: 27,
                //                     ),
                //                     // SizedBox(
                //                     //   width: 22,
                //                     // ),
                //                     Padding(
                //                       padding: const EdgeInsets.only(left: 10),
                //                       child: Container(
                //                         width: 140,
                //                         child: SingleChildScrollView(
                //                           child: Text(
                //                             sharednotedata.notesId!.topic,
                //                             maxLines: 2,
                //                             style: TextStyle(
                //                                 fontSize: 13,
                //                                 fontWeight: FontWeight.w600,
                //                                 color: Color.fromRGBO(
                //                                     38, 50, 56, 1)),
                //                           ),
                //                         ),
                //                       ),
                //                     ),
                //                     // SizedBox(
                //                     //   width: 64,
                //                     // ),
                //                   ],
                //                 ),
                //                 Padding(
                //                   padding: const EdgeInsets.only(right: 5),
                //                   child: Container(
                //                     // color: Colors.red,
                //                     child: Column(
                //                       crossAxisAlignment:
                //                           CrossAxisAlignment.start,
                //                       mainAxisAlignment:
                //                           MainAxisAlignment.center,
                //                       children: [
                //                         SingleChildScrollView(
                //                           child: Text(
                //                             "By: " + sharednotedata.sharedBy,
                //                             style: TextStyle(
                //                                 fontWeight: FontWeight.w800,
                //                                 fontSize: 12),
                //                           ),
                //                         ),
                //                       ],
                //                     ),
                //                     height: 27,
                //                     width: devicewidth * 0.7.w,
                //                   ),
                //                 ),
                //                 // TextButton(
                //                 //   onPressed: () async {
                //                 //     _showTextFieldAlertDialog(
                //                 //         context, notedata.id);
                //                 //   },
                //                 //   child: Text("Share"),
                //                 // ),
                //               ],
                //             ),
                //  ),
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
                //  ],
                //  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showTextFieldAlertDialog(BuildContext context, String noteid) {
    TextEditingController textFieldController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Enter Text ${globalteacherdata.id}"),
          content: Column(
            children: [
              Text(noteid),
              TextField(
                controller: textFieldController,
                decoration: InputDecoration(labelText: "Text"),
              ),
            ],
          ),
          actions: <Widget>[
            ElevatedButton(
              onPressed: () async {
                // Handle the submit button press
                String enteredText = textFieldController.text;
                // You can do something with the entered text here
                print("Entered Text: $enteredText");

                await addshareData(
                    notesid: noteid,
                    sharedwith: "Pz8iqku9fOOItWMnrRAsYRDUyy52");

                // Close the alert dialog
                // Navigator.of(context).pop();
              },
              child: Text("Submit"),
            ),
            ElevatedButton(
              onPressed: () {
                // Close the alert dialog without doing anything
                Navigator.of(context).pop();
              },
              child: Text("Cancel"),
            ),
          ],
        );
      },
    );
  }

  Future<void> addshareData(
      {required String notesid, required String sharedwith}) async {
    final String url =
        "https://api.easyeduverse.tech/api/user/a4hzHBEO2JY3MM8haoldPEQ6j983/notes/share";

    // Define the JSON data to be posted
    Map<String, String> jsonData = {
      "notesid": notesid,
      "sharedwith": sharedwith,
    };

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode(jsonData),
      );

      if (response.statusCode == 200) {
        print("Data posted successfully");
        // You can handle the response here if needed
      } else {
        print("Failed to post data. Status code: ${response.statusCode}");
        // You can handle errors here
      }
    } catch (e) {
      print("Error: $e");
      // Handle exceptions here
    }
  }

  Future<List<Sharednote>> getnotesdata() async {
    final String uemailid = FirebaseAuth.instance.currentUser!.email!;
    String? splituserid;

    splituserid = uemailid.split('@')[0];
    final response = await http.get(
        Uri.parse('https://api.easyeduverse.tech/api/user/${splituserid}'));
    // 'https://easyed-backend.onrender.com/api/teacher/$uid/notes'));
    var data = jsonDecode(response.body.toString());

    // print(data.toString());
    sharednoteslist = [];
    noteslist = [];
    if (response.statusCode == 200) {
      teacherdata = Teacher.fromJson(data);

      print(teacherdata.sharednotes!.length.toString() + "length");
      for (Sharednote index in teacherdata.sharednotes!) {
        sharednoteslist.add(index);
      }

      print(sharednoteslist.length.toString() + "length of share");

      // teacherslist.add(sampleteachers);

      // print(sampleteachers.toString());
      // for (Map<String, dynamic> index in data) {
      //   sampleteachers.add(Teacher.fromJson(index));
      // }
      return sharednoteslist;
    } else {
      return sharednoteslist;
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
    await Navigator.push(context,
            MaterialPageRoute(builder: (context) => SharedNotesScreen()))
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
