import 'dart:convert';
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';
import 'package:easyed/Pages/pdfviewerpage.dart';
import 'package:easyed/Quiz/home.dart';
import 'package:easyed/models/Student.dart';
import 'package:easyed/models/Teacher.dart';
import 'package:easyed/pdf_api.dart';
import 'package:easyed/video_player_item.dart';
import 'package:easyed/widgets/widgets.dart';

class QuizPage extends StatefulWidget {
  const QuizPage({super.key});

  @override
  State<QuizPage> createState() => _QuizPageState();
}

class _QuizPageState extends State<QuizPage> {
  List _questions = [
    // {
    //   'questionText': 'What\'s your favorite color?',
    //   'answers': [
    //     {'text': 'Black', 'score': 1},
    //     {'text': 'Red', 'score': 0},
    //     {'text': 'Green', 'score': 0},
    //     {'text': 'White', 'score': 0},
    //   ],
    // },
    // {
    //   'questionText': 'What\'s your favorite animal?',
    //   'answers': [
    //     {'text': 'Rabbit', 'score': 1},
    //     {'text': 'Snake', 'score': 0},
    //     {'text': 'Elephant', 'score': 0},
    //     {'text': 'Lion', 'score': 0},
    //   ],
    // },
    // {
    //   'questionText': 'Who\'s your favorite instructor?',
    //   'answers': [
    //     {'text': 'Max', 'score': 1},
    //     {'text': 'Max', 'score': 0},
    //     {'text': 'Max', 'score': 0},
    //     {'text': 'Max', 'score': 0},
    //   ],
    // },
  ];

  Color aselectcolor = Colors.black;
  final uid = FirebaseAuth.instance.currentUser!.uid;
  List<Student> samplestudents = [];
  List<Teacher> teacherslist = [];
  List<Task> taskslist = [];
  int count = -1;

  Task sampletask = Task(
      creator: "",
      taskClass: "",
      subject: "",
      topic: "",
      questions: [],
      id: "");

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
        child: Padding(
          padding: const EdgeInsets.all(40.0),
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
              // Text(uid),

              Padding(
                padding: const EdgeInsets.only(top: 20.0),
                child: Container(
                  height: 600,
                  child: FutureBuilder(
                      future: gettaskdata(),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          return ListView.builder(
                              itemCount: taskslist.length,
                              itemBuilder: (context, index) {
                                if (count < taskslist.length) {
                                  count++;
                                  _questions.add({
                                    'questionText': index.toString() +
                                        ": " +
                                        taskslist[index].questions[0].question,
                                    'answers': [
                                      {
                                        'text': taskslist[index]
                                            .questions[0]
                                            .options[0]
                                            .optionText,
                                        'score': 1
                                      },
                                      {
                                        'text': taskslist[index]
                                            .questions[0]
                                            .options[1]
                                            .optionText,
                                        'score': 0
                                      },
                                      {
                                        'text': taskslist[index]
                                            .questions[0]
                                            .options[2]
                                            .optionText,
                                        'score': 0
                                      },
                                      {
                                        'text': taskslist[index]
                                            .questions[0]
                                            .options[3]
                                            .optionText,
                                        'score': 0
                                      },
                                    ],
                                  });
                                }
                                print(_questions.length);
                                return Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      _questions[index]['questionText']
                                          .toString(),
                                      style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.w800),
                                    ),
                                    Text(
                                      "A " +
                                          _questions[index]['answers'][0]
                                              ['text'],
                                      style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w500),
                                    ),
                                    Text(
                                      "B " +
                                          _questions[index]['answers'][1]
                                              ['text'],
                                      style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w500),
                                    ),
                                    Text(
                                      "C " +
                                          _questions[index]['answers'][2]
                                              ['text'],
                                      style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w500),
                                    ),
                                    Text(
                                      "D " +
                                          _questions[index]['answers'][3]
                                              ['text'],
                                      style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w500),
                                    ),

                                    // Text(_questions.length.toString()),
                                    // Text("Teacher json"),
                                    // Text("In tasks "),
                                    // Text("creator : ${taskslist[index].creator} "),
                                    // Text("class : ${taskslist[index].taskClass}"),
                                    // Text("Subject ${taskslist[index].subject}"),

                                    // Text("Question ${index}" +
                                    //     ": " +
                                    //     taskslist[index].questions[0].question),
                                    // SizedBox(
                                    //   height: 10,
                                    // ),

                                    // GestureDetector(
                                    //   onTap: () {
                                    //     setState(() {
                                    //       print(index);
                                    //       if (index == 0) {
                                    //         aselectcolor = Colors.blue;
                                    //       }
                                    //     });
                                    //   },
                                    //   child: Text(
                                    //     "A" +
                                    //         ": " +
                                    //         taskslist[index]
                                    //             .questions[0]
                                    //             .options[0]
                                    //             .optionText,
                                    //     style: index == 0
                                    //         ? TextStyle(color: aselectcolor)
                                    //         : TextStyle(color: Colors.black),
                                    //   ),
                                    // ),

                                    // Text("B" +
                                    //     ": " +
                                    //     taskslist[index]
                                    //         .questions[0]
                                    //         .options[1]
                                    //         .optionText),
                                    // Text("C" +
                                    //     ": " +
                                    //     taskslist[index]
                                    //         .questions[0]
                                    //         .options[2]
                                    //         .optionText),
                                    // Text("D" +
                                    //     ": " +
                                    //     taskslist[index]
                                    //         .questions[0]
                                    //         .options[3]
                                    //         .optionText),

                                    // Text("In notes"),
                                    // Text(
                                    //     "topic : ${sampleteachers.notes[index].topic}"),
                                    // GestureDetector(
                                    //   onTap: () async {
                                    //     final url = sampleteachers
                                    //         .notes[index].notesPdfLink;
                                    //     final file =
                                    //         await PDFApi.loadNetwork(url);

                                    //     openPDF(context, file);
                                    //   },
                                    //   child: Container(
                                    //     color: Colors.pink,
                                    //     height: 20,
                                    //     width: 30,
                                    //     child: Text("pdf"),
                                    //   ),
                                    // ),
                                    // Text(
                                    //     "notesPDFLink ${sampleteachers.notes[index].notesPdfLink}"),
                                    // SizedBox(
                                    //   height: 10,
                                    // ),
                                    // Text("In videoLecture"),
                                    // Text(
                                    //     "videoTitle : ${sampleteachers.videoLecture[index].videoTitle}"),
                                    // Text(
                                    //     "videoLink : ${sampleteachers.videoLecture[index].videoLink} "),
                                    // VideoPlayerItem(
                                    //     videoUrl: sampleteachers
                                    //         .videoLecture[index].videoLink)
                                  ],
                                );
                              });
                        } else {
                          return Center(
                            child: CircularProgressIndicator(),
                          );
                        }
                      }),
                ),
              ),

              ElevatedButton(
                  onPressed: () {
                    PersistentNavBarNavigator.pushNewScreen(
                      context,
                      screen: HomeScreen(questions: _questions),
                      withNavBar: true, // OPTIONAL VALUE. True by default.
                      pageTransitionAnimation:
                          PageTransitionAnimation.cupertino,
                    );

                    // nextScreen(context, HomeScreen(questions: _questions));
                  },
                  child: Text("Quiz")),
            ],
          ),
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

  Future<List<Task>> gettaskdata() async {
    final response = await http
        .get(Uri.parse('https://api.easyeduverse.tech/api/user/${uid}/task'));
    // 'https://easyed-backend.onrender.com/api/teacher/${uid}/task'));
    var data = jsonDecode(response.body.toString());

    if (response.statusCode == 200) {
      for (Map<String, dynamic> index in data) {
        taskslist.add(Task.fromJson(index));
      }
      return taskslist;
    } else {
      return taskslist;
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
