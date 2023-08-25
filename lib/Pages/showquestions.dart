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

class ShowQuestions extends StatefulWidget {
  static const routeName = '/showquestions';
  final String taskid;
  const ShowQuestions({super.key, required this.taskid});

  @override
  State<ShowQuestions> createState() => _ShowQuestionsState();
}

class _ShowQuestionsState extends State<ShowQuestions> {
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
  List<Question> questionslist = [];

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
    Future onReturn() async => setState(() => gettingtaskdata());
    Future<void> refreshdata() async {
      await Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => ShowQuestions(
                    taskid: widget.taskid,
                  ))).then((value) => onReturn());
    }

    double deviceheight = MediaQuery.of(context).size.height;
    double appbarheight = 45;

    double devicewidth = MediaQuery.of(context).size.width;
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              children: [
                Container(
                  // color: Colors.yellow,
                  width: devicewidth,
                  height: deviceheight * 0.1,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "QUIZ",
                        style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.w900,
                            fontSize: 30),
                      ),
                      Text(
                        "QUESTIONS",
                        style: TextStyle(
                            color: Color.fromRGBO(38, 90, 232, 1),
                            fontWeight: FontWeight.w900,
                            fontSize: 30),
                      ),
                    ],
                  ),
                ),
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
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Container(
                    decoration: BoxDecoration(
                      // color: Colors.red,
                      border: Border.all(width: 3),
                    ),
                    height: deviceheight * 0.65,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: RefreshIndicator(
                        onRefresh: () async {
                          await refreshdata();
                        },
                        child: FutureBuilder(
                            future: gettingtaskdata(),
                            builder: (context, snapshot) {
                              if (snapshot.hasData) {
                                return ListView.builder(
                                    itemCount: questionslist.length,
                                    itemBuilder: (context, index) {
                                      if (count < questionslist.length) {
                                        count++;
                                        _questions.add({
                                          'questionText': index.toString() +
                                              ": " +
                                              questionslist[index].question,
                                          'answers': [
                                            {
                                              'text': questionslist[index]
                                                  .options[0]
                                                  .optionText,
                                              'score': questionslist[index]
                                                          .options[0]
                                                          .answer
                                                          .toString() ==
                                                      "true"
                                                  ? 1
                                                  : 0,
                                            },
                                            {
                                              'text': questionslist[index]
                                                  .options[1]
                                                  .optionText,
                                              'score': questionslist[index]
                                                          .options[1]
                                                          .answer
                                                          .toString() ==
                                                      "true"
                                                  ? 1
                                                  : 0,
                                            },
                                            {
                                              'text': questionslist[index]
                                                  .options[2]
                                                  .optionText,
                                              'score': questionslist[index]
                                                          .options[2]
                                                          .answer
                                                          .toString() ==
                                                      "true"
                                                  ? 1
                                                  : 0,
                                            },
                                            {
                                              'text': questionslist[index]
                                                  .options[3]
                                                  .optionText,
                                              'score': questionslist[index]
                                                          .options[3]
                                                          .answer
                                                          .toString() ==
                                                      "true"
                                                  ? 1
                                                  : 0,
                                            },
                                          ],
                                        });
                                      }
                                      print(_questions.length);
                                      return Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          // _questions list that send to quiz
                                          // Text(_questions[index]['questionText']
                                          //     .toString()),
                                          // Text(_questions[index]['answers'][0]['text']),
                                          // Text(_questions[index]['answers'][1]['text']),
                                          // Text(_questions[index]['answers'][2]['text']),
                                          // Text(_questions[index]['answers'][3]['text']),

                                          // Text(_questions.length.toString()),
                                          // Text("Teacher json"),
                                          // Text("In tasks "),
                                          // Text("creator : ${sampletask.creator} "),
                                          Text(
                                            index.toString() +
                                                ": " +
                                                questionslist[index].question,
                                            style: TextStyle(
                                                fontSize: 20,
                                                fontWeight: FontWeight.w800),
                                          ),

                                          Padding(
                                            padding: const EdgeInsets.only(
                                                left: 12.0,
                                                top: 8.0,
                                                bottom: 8.0),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  "A: " +
                                                      questionslist[index]
                                                          .options[0]
                                                          .optionText,
                                                  style: TextStyle(
                                                      color: Colors.grey,
                                                      fontWeight:
                                                          FontWeight.w700),
                                                ),
                                                // Text(questionslist[index]
                                                //     .options[0]
                                                //     .answer
                                                //     .toString()),
                                                Text(
                                                  "B: " +
                                                      questionslist[index]
                                                          .options[1]
                                                          .optionText,
                                                  style: TextStyle(
                                                      color: Colors.grey,
                                                      fontWeight:
                                                          FontWeight.w700),
                                                ),
                                                // Text(questionslist[index]
                                                //     .options[1]
                                                //     .answer
                                                //     .toString()),
                                                Text(
                                                  "C: " +
                                                      questionslist[index]
                                                          .options[2]
                                                          .optionText,
                                                  style: TextStyle(
                                                      color: Colors.grey,
                                                      fontWeight:
                                                          FontWeight.w700),
                                                ),
                                                // Text(questionslist[index]
                                                //     .options[2]
                                                //     .answer
                                                //     .toString()),
                                                Text(
                                                  "D: " +
                                                      questionslist[index]
                                                          .options[3]
                                                          .optionText,
                                                  style: TextStyle(
                                                      color: Colors.grey,
                                                      fontWeight:
                                                          FontWeight.w700),
                                                ),
                                                // Text(questionslist[index]
                                                //     .options[3]
                                                //     .answer
                                                //     .toString()),
                                              ],
                                            ),
                                          ),

                                          // Text(sampletask.questions)
                                          // Text("class : ${taskslist[0].taskClass}"),
                                          // Text("Subject ${taskslist[0].subject}"),

                                          // SizedBox(
                                          //   height: 30,
                                          // )

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
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.only(top: 35.0),
                  child: Column(
                    children: [
                      Container(
                        width: 250,
                        child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                primary: Color(0xFF265AE8),
                                elevation: 0,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(30))),
                            onPressed: () {
                              PersistentNavBarNavigator.pushNewScreen(
                                context,
                                screen: HomeScreen(questions: _questions),
                                withNavBar:
                                    true, // OPTIONAL VALUE. True by default.
                                pageTransitionAnimation:
                                    PageTransitionAnimation.cupertino,
                              );

                              // nextScreen(
                              //     context, HomeScreen(questions: _questions));
                            },
                            child: Text(
                              "Start Quiz",
                              style:
                                  TextStyle(color: Colors.white, fontSize: 16),
                            )),
                      ),
                    ],
                  ),
                ),

                // ElevatedButton(
                //     onPressed: () {
                //       nextScreen(context, HomeScreen(questions: _questions));
                //     },
                //     child: Text("Quiz")),
              ],
            ),
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

    taskslist = [];
    if (response.statusCode == 200) {
      for (Map<String, dynamic> index in data) {
        taskslist.add(Task.fromJson(index));
      }
      return taskslist;
    } else {
      return taskslist;
    }
  }

  Future<List<Question>> gettingtaskdata() async {
    final response = await http.get(Uri.parse(
        'https://api.easyeduverse.tech/api/user/${uid}/task/${widget.taskid}'));
    // 'https://easyed-backend.onrender.com/api/teacher/${uid}/task/${widget.taskid}'));
    var data = jsonDecode(response.body.toString());

    // print(data.toString());

    if (response.statusCode == 200) {
      // print(data);
      sampletask = Task.fromJson(data);
      // sampleteachers. = dat;

      questionslist = questionslist = List<Question>.from(sampletask.questions
          .map((q) => Question(
              question: q.question,
              questionType: q.questionType,
              options: q.options,
              id: q.id)));

      print(questionslist[0].toJson());

      // teacherslist.add(sampleteachers);

      // print(sampleteachers.toString());
      // for (Map<String, dynamic> index in data) {
      //   sampleteachers.add(Teacher.fromJson(index));
      // }
      return questionslist;
    } else {
      return questionslist;
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
