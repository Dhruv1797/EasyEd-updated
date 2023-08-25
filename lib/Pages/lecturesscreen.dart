import 'dart:convert';
import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
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
      subject: '', topic: '', videoLink: '', videoTitle: '', id: '');

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
      students: [],
      v: 1);

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

                        Row(
                          children: [
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
                                      fontSize: 20.sp),
                                ),
                                Text(
                                  "Notes",
                                  style: TextStyle(
                                      color: Color.fromRGBO(38, 90, 232, 1),
                                      fontWeight: FontWeight.w900,
                                      fontSize: 20.sp),
                                ),
                              ],
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
                                        fontWeight: FontWeight.w600,
                                        fontSize: 11.sp),
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
                  height: 150,
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
                            padding: const EdgeInsets.only(left: 20.0, top: 10),
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
                  height: deviceheight * 0.59,
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
            color: Color.fromRGBO(255, 255, 255, 1),
            borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(10),
                bottomRight: Radius.circular(10)),
          ),
          // height: deviceheight * 0.135,
          width: devicewidth * 0.73,
          child: Column(
            children: [
              Row(
                children: [
                  Container(
                      height: 108,
                      width: 200,
                      decoration: BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(10),
                            bottomRight: Radius.circular(10)),
                      ),
                      child: VideoPlayerItem(videoUrl: videourl)),
                  Padding(
                    padding: const EdgeInsets.only(left: 22.0, bottom: 30),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            // Container(
                            //   height: 12,
                            //   width: 12,
                            //   child: Image.asset("assets/star.png"),
                            // ),
                            // Padding(
                            //   padding: const EdgeInsets.only(left: 8.0),
                            //   child: Text(
                            //     subjectwidget.rating!,
                            //     style: TextStyle(
                            //         fontSize: 10,
                            //         fontWeight: FontWeight.w600,
                            //         color: Color.fromRGBO(38, 50, 56, 1)),
                            //   ),
                            // ),
                          ],
                        ),
                        Container(
                          // color: Colors.red,
                          width: 75.w,
                          child: Text(
                            lecturedata.videoTitle,
                            maxLines: 2,
                            style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w500,
                                color: Color.fromRGBO(38, 50, 56, 1)),
                          ),
                        ),
                        Container(
                          // color: Colors.red,
                          // color: const Color.fromRGBO(244, 67, 54, 1),
                          width: 75.w,
                          child: Text(
                            lecturedata.topic,
                            maxLines: 2,
                            style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w400,
                                color: Color.fromRGBO(117, 124, 142, 1)),
                          ),
                        ),
                        // Text(
                        //   lecturedata.subject,
                        //   style: TextStyle(
                        //       fontSize: 12,
                        //       fontWeight: FontWeight.w400,
                        //       color: Color.fromRGBO(117, 124, 142, 1)),
                        // ),
                        Padding(
                          padding: const EdgeInsets.only(top: 6.0),
                          child: Container(
                            decoration: BoxDecoration(
                              color: Color.fromRGBO(175, 179, 193, 1),
                              borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(10),
                                  topRight: Radius.circular(10),
                                  bottomLeft: Radius.circular(10),
                                  bottomRight: Radius.circular(10)),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(6.0),
                              child: Container(
                                // color: Colors.red,
                                width: 75.w,
                                child: Text(
                                  lecturedata.subject,
                                  maxLines: 2,
                                  style: TextStyle(
                                      fontSize: 10,
                                      fontWeight: FontWeight.w500,
                                      color: Color.fromRGBO(255, 255, 255, 1)),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<List<VideoLecture>> getlecturesdata() async {
    final response = await http
        .get(Uri.parse('https://api.easyeduverse.tech/api/user/$uid/lectures'));
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
