import 'dart:convert';
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:easyed/Pages/globalvariables.dart';
import 'package:easyed/Pages/pdfviewerpage.dart';
import 'package:easyed/models/Student.dart';
import 'package:easyed/models/Teacher.dart';
import 'package:easyed/pdf_api.dart';
import 'package:easyed/video_player_item.dart';
import 'package:easyed/widgets/drawer.dart';
import 'package:easyed/widgets/widgets.dart';

class ShowProfileScreen extends StatefulWidget {
  static const routeName = '/showprofile';
  const ShowProfileScreen({super.key});

  @override
  State<ShowProfileScreen> createState() => _ShowProfileScreenState();
}

class _ShowProfileScreenState extends State<ShowProfileScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  final uid = FirebaseAuth.instance.currentUser!.uid;
  final String uemailid = FirebaseAuth.instance.currentUser!.email!;
  String? splituserid;
  // List<Student> samplestudents = [];
  List<Teacher> teacherslist = [];

  void handleClick(String value) {
    switch (value) {
      case 'Option 1':
        break;
      case 'Option 2':
        break;
    }
  }

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
  @override
  Widget build(BuildContext context) {
    double deviceheight = MediaQuery.of(context).size.height;
    double appbarheight = 45;

    double devicewidth = MediaQuery.of(context).size.width;
    return Scaffold(
      drawer: MyDrawer(),
      key: _scaffoldKey,
      body: SafeArea(
        child: SingleChildScrollView(
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
                height: 90 - appbarheight,
              ),

              // Text(email.replaceFirst("@gmail.com", "")),

              // Text(globalteacherdata.id.substring(17)),
              // Text(globalteacherdata.userDetails[0].lastName),
              // Text(globalusername!),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  width: devicewidth,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
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
                          'Profile Details',
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
              ),
              // SizedBox(
              //   height: 20,
              // ),
              Container(
                height: deviceheight * 0.8,
                color: Colors.white,
                child: FutureBuilder(
                    future: getTeacherdata(),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        return Container(
                          width: devicewidth,
                          color: Colors.white,
                          child: Column(
                            // crossAxisAlignment: CrossAxisAlignment.center,
                            // mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              // Text("Teacher json"),
                              Padding(
                                padding: const EdgeInsets.all(30.0),
                                child: CircleAvatar(
                                  radius: 90,
                                  backgroundImage: NetworkImage(
                                      globalteacherdata.userDetails[0].avatar),
                                ),
                              ),
                              Container(
                                // height: 60,
                                width: 700,
                                child: Card(
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Row(
                                      children: [
                                        Text(
                                          "Name: ",
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 22,
                                              fontWeight: FontWeight.w800),
                                        ),
                                        Text(
                                          sampleteachers
                                              .userDetails[0].firstName,
                                          style: TextStyle(
                                              color: Colors.blue,
                                              fontSize: 17,
                                              fontWeight: FontWeight.w800),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              Container(
                                // height: 60,
                                width: 700,
                                child: Card(
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Row(
                                      children: [
                                        Text(
                                          "Userid: ",
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 22,
                                              fontWeight: FontWeight.w800),
                                        ),
                                        Text(
                                          sampleteachers
                                              .userDetails[0].lastName,
                                          style: TextStyle(
                                              color: Colors.blue,
                                              fontSize: 17,
                                              fontWeight: FontWeight.w800),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              Container(
                                // height: 60,
                                width: 700,
                                child: Card(
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Row(
                                      children: [
                                        Text(
                                          "email: ",
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 22,
                                              fontWeight: FontWeight.w800),
                                        ),
                                        Text(
                                          sampleteachers.userDetails[0].email,
                                          style: TextStyle(
                                              color: Colors.blue,
                                              fontSize: 17,
                                              fontWeight: FontWeight.w800),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              Container(
                                // height: 60,
                                width: 700,
                                child: Card(
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Row(
                                      children: [
                                        Text(
                                          "Mobile No: ",
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 22,
                                              fontWeight: FontWeight.w800),
                                        ),
                                        Text(
                                          sampleteachers.userDetails[0].mobile,
                                          style: TextStyle(
                                              color: Colors.blue,
                                              fontSize: 17,
                                              fontWeight: FontWeight.w800),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              Container(
                                // height: 60,
                                width: 700,
                                child: Card(
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Row(
                                      children: [
                                        Text(
                                          "InstituteName: ",
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 22,
                                              fontWeight: FontWeight.w800),
                                        ),
                                        Expanded(
                                          child: Text(
                                            sampleteachers.educationalDetails[0]
                                                .instituteName,
                                            style: TextStyle(
                                                color: Colors.blue,
                                                fontSize: 17,
                                                fontWeight: FontWeight.w800),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              Container(
                                // height: 60,
                                width: 700,
                                child: Card(
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Row(
                                      children: [
                                        Text(
                                          "Profession: ",
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 22,
                                              fontWeight: FontWeight.w800),
                                        ),
                                        Text(
                                          sampleteachers.educationalDetails[0]
                                              .educationalDetailClass,
                                          style: TextStyle(
                                              color: Colors.blue,
                                              fontSize: 17,
                                              fontWeight: FontWeight.w800),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              // Text(
                              //     "Userid: ${sampleteachers.userDetails[0].lastName}"),
                              // Text(
                              //     "email: ${sampleteachers.userDetails[0].email}"),
                              // Text(
                              //     "Mobile No.: ${sampleteachers.userDetails[0].mobile}"),
                              // Text(
                              //     "InstituteName.: ${sampleteachers.educationalDetails[0].instituteName}"),
                              // Text(
                              //     "Class: ${sampleteachers.educationalDetails[0].educationalDetailClass}"),
                            ],
                          ),
                        );
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
      ),
    );
  }

  // Future<List<Student>> getStudentdata() async {
  //   final response = await http
  //       .get(Uri.parse('https://easyed-backend.onrender.com/api/student'));
  //   var data = jsonDecode(response.body.toString());

  //   if (response.statusCode == 200) {
  //     for (Map<String, dynamic> index in data) {
  //       samplestudents.add(Student.fromJson(index));
  //     }
  //     return samplestudents;
  //   } else {
  //     return samplestudents;
  //   }
  // }

  Future<Teacher> getTeacherdata() async {
    splituserid = uemailid.split('@')[0];
    final response = await http.get(Uri.parse(
        // 'http://ec2-13-234-152-69.ap-south-1.compute.amazonaws.com/api/user/${uid}'));

        'https://api.easyeduverse.tech/api/user/${splituserid}'));
    // Uri.parse('https://easyed-backend.onrender.com/api/teacher/${uid}'));
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
}
