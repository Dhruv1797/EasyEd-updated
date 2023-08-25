import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';
import 'package:easyed/Pages/pdfviewerpage.dart';
import 'package:easyed/models/Student.dart';
import 'package:easyed/models/Teacher.dart';
import 'package:easyed/pdf_api.dart';
import 'package:easyed/video_player_item.dart';
import 'package:easyed/widgets/widgets.dart';

class TestPage extends StatefulWidget {
  const TestPage({super.key});

  @override
  State<TestPage> createState() => _TestPageState();
}

class _TestPageState extends State<TestPage> {
  List<Student> samplestudents = [];
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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // Container(
            //   height: 300,
            //   child: FutureBuilder(
            //       future: getStudentdata(),
            //       builder: (context, snapshot) {
            //         if (snapshot.hasData) {
            //           return ListView.builder(
            //               itemCount: 1,
            //               itemBuilder: (context, index) {
            //                 return Container(
            //                   width: 300,
            //                   color: Colors.yellow,
            //                   height: 150,
            //                   child: Column(
            //                     crossAxisAlignment: CrossAxisAlignment.start,
            //                     children: [
            //                       Text("Student Json"),
            //                       // SizedBox(
            //                       //   height: 40,
            //                       // ),
            //                       Text("IN USER DETAILS :"),
            //                       Text(
            //                           "first Name : ${samplestudents[index].userDetails[index].firstName}"),

            //                       Text(
            //                           "avatar url : ${samplestudents[index].userDetails[index].avatar}"),
            //                       SizedBox(
            //                         height: 40,
            //                       ),
            //                     ],
            //                   ),
            //                 );
            //               });
            //         } else {
            //           return Center(
            //             child: CircularProgressIndicator(),
            //           );
            //         }
            //       }),
            // ),
            Container(
              height: 600,
              child: FutureBuilder(
                  future: getTeacherdata(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return ListView.builder(
                          itemCount: teacherslist.length,
                          itemBuilder: (context, index) {
                            return Container(
                              width: 300,
                              color: Colors.red,
                              height: 600,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text("Teacher json"),
                                  Text("In tasks "),
                                  Text(
                                      "creator : ${sampleteachers.tasks[index].creator.toString()} "),
                                  Text(
                                      "class : ${sampleteachers.tasks[index].taskClass}"),
                                  Text(
                                      "Subject ${sampleteachers.tasks[index].subject}"),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Text("In notes"),
                                  Text(
                                      "topic : ${sampleteachers.notes[index].topic}"),
                                  GestureDetector(
                                    onTap: () async {
                                      final url = sampleteachers
                                          .notes[index].notesPdfLink;
                                      final file =
                                          await PDFApi.loadNetwork(url);

                                      openPDF(context, file);
                                    },
                                    child: Container(
                                      color: Colors.pink,
                                      height: 20,
                                      width: 30,
                                      child: Text("pdf"),
                                    ),
                                  ),
                                  Text(
                                      "notesPDFLink ${sampleteachers.notes[index].notesPdfLink}"),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Text("In videoLecture"),
                                  Text(
                                      "videoTitle : ${sampleteachers.videoLecture[index].videoTitle}"),
                                  Text(
                                      "videoLink : ${sampleteachers.videoLecture[index].videoLink} "),
                                  VideoPlayerItem(
                                      videoUrl: sampleteachers
                                          .videoLecture[index].videoLink)
                                ],
                              ),
                            );
                          });
                    } else {
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                  }),
            ),
          ],
        ),
      ),
    );
  }

  Future<List<Student>> getStudentdata() async {
    final response = await http
        .get(Uri.parse('https://easyed-backend.onrender.com/api/student'));
    var data = jsonDecode(response.body.toString());

    if (response.statusCode == 200) {
      for (Map<String, dynamic> index in data) {
        samplestudents.add(Student.fromJson(index));
      }
      return samplestudents;
    } else {
      return samplestudents;
    }
  }

  Future<Teacher> getTeacherdata() async {
    final response = await http
        .get(Uri.parse('https://api.easyeduverse.tech/api/user/sonamWangchik'));
    // 'https://easyed-backend.onrender.com/api/teacher/sonamWangchik'));
    var data = jsonDecode(response.body.toString());

    // print(data.toString());

    if (response.statusCode == 200) {
      sampleteachers = Teacher.fromJson(data);
      // sampleteachers. = dat;

      teacherslist.add(sampleteachers);

      // print(sampleteachers.toString());
      // for (Map<String, dynamic> index in data) {
      //   sampleteachers.add(Teacher.fromJson(index));
      // }
      return sampleteachers;
    } else {
      return sampleteachers;
    }
  }

  void openPDF(BuildContext context, File file) {
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
