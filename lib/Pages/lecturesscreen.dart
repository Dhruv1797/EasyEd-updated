import 'dart:convert';
import 'dart:io';
import 'package:easyed/Pages/globalvariables.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';
import 'package:easyed/Pages/addVideoScreen.dart';
import 'package:easyed/Pages/dashboardscreen.dart';
import 'package:easyed/Pages/videoplayerscreen.dart';
import 'package:easyed/models/Teacher.dart';
import 'package:http/http.dart' as http;
import 'package:easyed/video_player_item.dart';

import 'package:easyed/widgets/drawer.dart';
import 'package:easyed/widgets/widgets.dart';

class LecturesScreen extends StatefulWidget {
  static const routeName = '/lecturesscreen';
  const LecturesScreen({super.key});

  @override
  State<LecturesScreen> createState() => _LecturesScreenState();
}

class _LecturesScreenState extends State<LecturesScreen> {
  final uid = FirebaseAuth.instance.currentUser!.uid;
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  List<VideoLecture> lectureslist = [];

  VideoLecture videoslecture = VideoLecture(
      subject: '', topic: '', videoLink: '', videoTitle: '', id: '', v: 0);

  List<videoBoxlist> subjectBoxlist = [
    videoBoxlist(
      imageurl: "assets/pic1.png",
      livestatus: "Live at 04:20",
      mentorname: "By xyyscyvsuc",
      rating: "4.5",
      topicname: "Circle",
    ),
    videoBoxlist(
      imageurl: "assets/pic2.png",
      livestatus: "Live at 04:20",
      mentorname: "By AKO  School",
      rating: "4.2",
      topicname: "Ellipse ",
    ),
    videoBoxlist(
      imageurl: "assets/pic3.png",
      livestatus: "Live at 04:20",
      mentorname: "By xyyscyvsuc",
      rating: "4.4",
      topicname: "Circle",
    ),
    videoBoxlist(
      imageurl: "assets/pic1.png",
      livestatus: "Live at 05:30",
      mentorname: "By AKO  School",
      rating: "4.4",
      topicname: "Periphrases",
    ),
    videoBoxlist(
      imageurl: "assets/pic2.png",
      livestatus: "Live at 06:30",
      mentorname: "By AKO Language School",
      rating: "4.1",
      topicname: "Imperfect",
    ),
  ];

  List<Teacher> teacherslist = [];

  // List<Student> sampleteachers = [];
  Teacher sampleteachers = Teacher(
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
    sharedtasks: [],
  );

  void handleClick(String value) {
    switch (value) {
      case 'Option 1':
        break;
      case 'Option 2':
        break;
    }
  }

  Future<void> refreshdata() async {
    await Navigator.push(
            context, MaterialPageRoute(builder: (context) => LecturesScreen()))
        .then((value) => onReturn());
  }

  Future onReturn() async => setState(() => getlecturesdata());

  @override
  Widget build(BuildContext context) {
    print(uid);
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
        // floatingActionButton: FloatingActionButton(
        //   child: Icon(Icons.add),
        //   onPressed: () {
        //     nextScreen(context, AddVideoScreen());
        //   },
        // ),
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
                              "Lecture",
                              style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.w900,
                                  fontSize: 23),
                            ),
                            Text(
                              "Notes",
                              style: TextStyle(
                                  color: Color.fromRGBO(86, 103, 253, 1),
                                  fontWeight: FontWeight.w900,
                                  fontSize: 23),
                            ),
                          ],
                        ),

                        InkWell(
                          child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  elevation: 5,
                                  backgroundColor:
                                      Color.fromRGBO(86, 103, 253, 1),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(30),
                                  )),
                              onPressed: () async {
                                PersistentNavBarNavigator.pushNewScreen(
                                  context,
                                  screen: AddVideoScreen(),
                                  withNavBar:
                                      true, // OPTIONAL VALUE. True by default.
                                  pageTransitionAnimation:
                                      PageTransitionAnimation.cupertino,
                                );
                                // nextScreen(context, AddVideoScreen());
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
                                    "Add Lecture",
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
                  height: 100.h,
                  width: devicewidth * 0.95,
                  decoration: BoxDecoration(
                    color: Color.fromRGBO(255, 255, 255, 1),
                    borderRadius: BorderRadius.all(Radius.circular(1)),
                  ),
                  child: Column(
                    children: [
                      SizedBox(
                        height: 23,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          // SizedBox(
                          //   width: 22,
                          // ),
                          Padding(
                            padding: const EdgeInsets.only(
                              left: 20.0,
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Video Course",
                                  style: TextStyle(
                                      color: Color.fromRGBO(11, 18, 31, 1),
                                      fontWeight: FontWeight.w500,
                                      fontSize: 20),
                                ),
                                Text(
                                  "All Cousre",
                                  style: TextStyle(
                                      color: Color.fromRGBO(112, 116, 126, 1),
                                      fontWeight: FontWeight.w400,
                                      fontSize: 12),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 35,
                      ),
                    ],
                  ),
                ),
                Container(
                  // color: Colors.red,
                  height: deviceheight * 0.651,
                  width: devicewidth * 0.95,
                  child: RefreshIndicator(
                    onRefresh: () async {
                      await refreshdata();
                    },
                    child: FutureBuilder(
                        future: getlecturesdata(),
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            return ListView.builder(
                              itemCount: lectureslist.length,
                              itemBuilder: (context, index) {
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
    // videoBoxlist subjectwidget = subjectBoxlist[index];
    VideoLecture lecturedata = lectureslist[index];
    final String videourl = lecturedata.videoLink;
    return GestureDetector(
      onTap: () {
        // print(index);
        // if (index == 0) {}

        final String videourl = lecturedata.videoLink;

        PersistentNavBarNavigator.pushNewScreen(
          context,
          screen: VideoPlayerScreen(videourl: videourl),
          withNavBar: true, // OPTIONAL VALUE. True by default.
          pageTransitionAnimation: PageTransitionAnimation.cupertino,
        );

        // nextScreen(context, VideoPlayerScreen(videourl: videourl));
      },
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
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
          // height: deviceheight * 0.135,
          width: devicewidth * 0.73,
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
                    decoration: BoxDecoration(
                      // color: Colors.red,
                      color: Color.fromRGBO(217, 217, 217, 1),
                      // border: Border.all(
                      //   color: Color.fromRGBO(182, 214, 204, 1),
                      // ),
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(4.49),
                          topRight: Radius.circular(4.49),
                          bottomLeft: Radius.circular(4.49),
                          bottomRight: Radius.circular(4.49)),
                      // boxShadow: [
                      //   BoxShadow(
                      //     color: Color.fromRGBO(182, 214, 204, 1),
                      //     blurRadius: 6.0,
                      //     offset: Offset(0, 6),
                      //   ),
                      // ],
                    ),
                    height: 55.3.h,
                    width: 73.w,
                    child: Center(
                      child: SvgPicture.asset("assets/videoicon.svg"),
                    ),
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
                          lecturedata.videoTitle,
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
                          lecturedata.topic,
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
                  GestureDetector(
                    onTap: () async {
                      _showTextFieldAlertDialog(context, lecturedata.id);
                    },
                    child: Container(
                      height: 24.44,
                      width: 22,
                      child: SvgPicture.asset("assets/shareicon.svg"),
                    ),
                  )
                ],
              ),
              SizedBox(
                height: 8.h,
              ),
              // Row(
              //   children: [
              //     Container(
              //         height: 108,
              //         width: 190,
              //         decoration: BoxDecoration(
              //           color: Colors.black,
              //           borderRadius: BorderRadius.only(
              //               bottomLeft: Radius.circular(10),
              //               bottomRight: Radius.circular(10)),
              //         ),
              //         child: VideoPlayerItem(videoUrl: videourl)),
              //     Padding(
              //       padding: const EdgeInsets.only(left: 22.0, bottom: 30),
              //       child: Column(
              //         crossAxisAlignment: CrossAxisAlignment.start,
              //         children: [
              //           Row(
              //             mainAxisAlignment: MainAxisAlignment.start,
              //             children: [
              //               // Container(
              //               //   height: 12,
              //               //   width: 12,
              //               //   child: Image.asset("assets/star.png"),
              //               // ),
              //               // Padding(
              //               //   padding: const EdgeInsets.only(left: 8.0),
              //               //   child: Text(
              //               //     subjectwidget.rating!,
              //               //     style: TextStyle(
              //               //         fontSize: 10,
              //               //         fontWeight: FontWeight.w600,
              //               //         color: Color.fromRGBO(38, 50, 56, 1)),
              //               //   ),
              //               // ),
              //             ],
              //           ),
              //           Container(
              //             width: 135,
              //             child: Text(
              //               lecturedata.videoTitle,
              //               maxLines: 2,
              //               style: TextStyle(
              //                   fontSize: 15,
              //                   fontWeight: FontWeight.w500,
              //                   color: Color.fromRGBO(38, 50, 56, 1)),
              //             ),
              //           ),
              //           Container(
              //             // color: const Color.fromRGBO(244, 67, 54, 1),
              //             width: 135,
              //             child: Text(
              //               lecturedata.topic,
              //               maxLines: 2,
              //               style: TextStyle(
              //                   fontSize: 12,
              //                   fontWeight: FontWeight.w400,
              //                   color: Color.fromRGBO(117, 124, 142, 1)),
              //             ),
              //           ),
              //           // Text(
              //           //   lecturedata.subject,
              //           //   style: TextStyle(
              //           //       fontSize: 12,
              //           //       fontWeight: FontWeight.w400,
              //           //       color: Color.fromRGBO(117, 124, 142, 1)),
              //           // ),
              //           Padding(
              //             padding: const EdgeInsets.only(top: 6.0),
              //             child: Container(
              //               decoration: BoxDecoration(
              //                 color: Color.fromRGBO(175, 179, 193, 1),
              //                 borderRadius: BorderRadius.only(
              //                     topLeft: Radius.circular(10),
              //                     topRight: Radius.circular(10),
              //                     bottomLeft: Radius.circular(10),
              //                     bottomRight: Radius.circular(10)),
              //               ),
              //               child: Padding(
              //                 padding: const EdgeInsets.all(6.0),
              //                 child: Container(
              //                   width: 60,
              //                   child: Text(
              //                     lecturedata.subject,
              //                     maxLines: 2,
              //                     style: TextStyle(
              //                         fontSize: 10,
              //                         fontWeight: FontWeight.w500,
              //                         color: Color.fromRGBO(255, 255, 255, 1)),
              //                   ),
              //                 ),
              //               ),
              //             ),
              //           ),
              //         ],
              //       ),
              //     ),
              //   ],
              // ),
              // TextButton(
              //   onPressed: () async {
              //     _showTextFieldAlertDialog(context, lecturedata.id);
              //   },
              //   child: Text("Share"),
              // ),
            ],
          ),
        ),
      ),
    );
  }

  void _showTextFieldAlertDialog(BuildContext context, String lectureid) {
    TextEditingController textFieldController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          surfaceTintColor: Colors.white,
          title: Text(
            "SHARE",
            style: TextStyle(
              fontSize: 15.sp,
              fontWeight: FontWeight.w600,
              fontFamily: "Montserrat",
              color: Color.fromRGBO(99, 109, 119, 1),
            ),
          ),
          // title: Text("Enter Text ${globalteacherdata.id}"),
          //  Text(lectureid),
          content: Container(
            height: 100,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Username",
                  style: TextStyle(
                    fontSize: 15.sp,
                    fontWeight: FontWeight.w600,
                    fontFamily: "Montserrat",
                    color: Color.fromRGBO(99, 109, 119, 1),
                  ),
                ),
                SizedBox(
                  height: 11.67,
                ),
                Container(
                  width: 316.0.w,
                  height: 49.14.h,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(7.45),
                    boxShadow: [
                      BoxShadow(
                        color: Color.fromRGBO(182, 214, 204, 1),
                        spreadRadius: 2,
                        blurRadius: 6.r,
                        offset: Offset(0, 6),
                      ),
                    ],
                    border: Border.all(
                      width: 1.0, // 1px border width
                      color: Color.fromRGBO(182, 214, 204, 1), // Border color
                    ),
                  ),
                  child: TextFormField(
                    controller: textFieldController,
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w200,
                      fontFamily: "Montserrat",
                      color: Color.fromRGBO(54, 67, 86, 1),
                    ),
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.all(10.0),
                      border: InputBorder.none,
                      hintStyle: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w200,
                        fontFamily: "Montserrat",
                        color: Color.fromRGBO(54, 67, 86, 1),
                      ),
                      hintText: ' @example Bamn',
                    ),
                    // validator: (val) {
                    //   if (val!.length < 1) {
                    //     return "Please Enter Subject";
                    //   } else {
                    //     return null;
                    //   }
                    // },
                  ),
                ),
                // TextField(
                //   controller: textFieldController,
                //   decoration: InputDecoration(labelText: "@example bamn"),
                // ),
              ],
            ),
          ),
          actions: <Widget>[
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                primary: Color.fromRGBO(86, 103, 253, 1),
              ),
              onPressed: () async {
                // Handle the submit button press
                String enteredText = textFieldController.text;
                // You can do something with the entered text here
                print("Entered Text: $enteredText");

                await addshareData(
                    lectureid: lectureid, sharedwith: enteredText);

                Navigator.of(context).pop();

                // Close the alert dialog
                // Navigator.of(context).pop();
              },
              child: Text(
                "Submit",
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w200,
                  fontFamily: "Montserrat",
                  color: Colors.white,
                ),
              ),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                primary: Color.fromRGBO(86, 103, 253, 1),
              ),
              onPressed: () {
                // Close the alert dialog without doing anything
                Navigator.of(context).pop();
              },
              child: Text(
                "Cancel",
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w200,
                  fontFamily: "Montserrat",
                  color: Colors.white,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Future<void> addshareData(
      {required String lectureid, required String sharedwith}) async {
    final String uemailid = FirebaseAuth.instance.currentUser!.email!;
    String? splituserid;

    splituserid = uemailid.split('@')[0];
    final String url =
        "https://api.easyeduverse.tech/api/user/${splituserid}/lectures/share";

    // Define the JSON data to be posted
    Map<String, String> jsonData = {
      "lectureID": lectureid,
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

  Future<List<VideoLecture>> getlecturesdata() async {
    final String uemailid = FirebaseAuth.instance.currentUser!.email!;
    String? splituserid;

    splituserid = uemailid.split('@')[0];

    final response = await http.get(Uri.parse(
        'https://api.easyeduverse.tech/api/user/$splituserid/lectures'));
    // 'https://easyed-backend.onrender.com/api/teacher/$uid/lectures'));
    var data = jsonDecode(response.body.toString());

    // print(data.toString());
    lectureslist = [];
    if (response.statusCode == 200) {
      for (Map<String, dynamic> index in data) {
        lectureslist.add(VideoLecture.fromJson(index));
      }
      // teacherslist.add(sampleteachers);

      // print(sampleteachers.toString());
      // for (Map<String, dynamic> index in data) {
      //   sampleteachers.add(Teacher.fromJson(index));
      // }
      return lectureslist;
    } else {
      return lectureslist;
    }
  }
}

class videoBoxlist {
  final String? rating;
  final String? imageurl;
  final String? topicname;
  final String? livestatus;
  final String? mentorname;

  videoBoxlist({
    required this.mentorname,
    required this.imageurl,
    required this.rating,
    required this.topicname,
    required this.livestatus,
  });
}
