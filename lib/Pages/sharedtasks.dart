import 'dart:convert';
import 'dart:io';

import 'package:easyed/Pages/globalvariables.dart';
import 'package:easyed/Pages/sharedshowquestions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';
import 'package:random_string/random_string.dart';
import 'package:easyed/Pages/dashboardscreen.dart';
import 'package:easyed/Pages/pdfviewerpage.dart';
import 'package:easyed/Pages/showquestions.dart';
import 'package:easyed/Pages/taskpostscreen.dart';
import 'package:easyed/Quiz/home.dart';
import 'package:easyed/models/Student.dart';
import 'package:easyed/models/Teacher.dart';
import 'package:easyed/pdf_api.dart';
import 'package:easyed/video_player_item.dart';
import 'package:easyed/widgets/drawer.dart';
import 'package:easyed/widgets/widgets.dart';

class SharedTaskPage extends StatefulWidget {
  static const routeName = '/SharedTaskPage';
  const SharedTaskPage({super.key});

  @override
  State<SharedTaskPage> createState() => _SharedTaskPageState();
}

class _SharedTaskPageState extends State<SharedTaskPage> {
  final String taskid = randomNumeric(24);
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

  List<Sharedtask> sharedtasklist = [];
  Teacher taskteacherdata = Teacher(
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

  Color aselectcolor = Colors.black;
  final uid = FirebaseAuth.instance.currentUser!.uid;
  List<Student> samplestudents = [];
  List<Teacher> teacherslist = [];
  // List<Task> taskslist = [];
  int count = -1;

  Future<void> refreshdata() async {
    await Navigator.push(
            context, MaterialPageRoute(builder: (context) => SharedTaskPage()))
        .then((value) => onReturn());
  }

  Future onReturn() async => setState(() => gettaskdata());

  Task sampletask = Task(
      creator: "",
      taskClass: "",
      subject: "",
      topic: "",
      questions: [],
      id: "",
      v: 0);
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
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
      sharedtasks: []);
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
        body: SingleChildScrollView(
          child: SafeArea(
            child: Column(
              children: [
                Container(
                  height: 30,
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
                              "Shared",
                              style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.w900,
                                  fontSize: 30),
                            ),
                            Text(
                              "Tasks",
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
                        //           screen: TaskPostScreen(
                        //             taskid: taskid,
                        //           ),
                        //           withNavBar: true,
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
                        //             "Add Tasks",
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
                Padding(
                  padding: const EdgeInsets.only(left: 40.0, right: 40.0),
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

                      Container(
                        // color: Colors.red,
                        height: deviceheight * 0.795,
                        child: RefreshIndicator(
                          onRefresh: () async {
                            await refreshdata();
                          },
                          child: FutureBuilder(
                              future: gettaskdata(),
                              builder: (context, snapshot) {
                                if (snapshot.hasData) {
                                  return ListView.builder(
                                      itemCount: sharedtasklist.length,
                                      itemBuilder: (context, index) {
                                        // if (count < taskslist.length) {
                                        //   count++;
                                        //   _questions.add({
                                        //     'questionText': index.toString() +
                                        //         ": " +
                                        //         taskslist[index].questions[0].question,
                                        //     'answers': [
                                        //       {
                                        //         'text': taskslist[index]
                                        //             .questions[0]
                                        //             .options[0]
                                        //             .optionText,
                                        //         'score': 1
                                        //       },
                                        //       {
                                        //         'text': taskslist[index]
                                        //             .questions[0]
                                        //             .options[1]
                                        //             .optionText,
                                        //         'score': 0
                                        //       },
                                        //       {
                                        //         'text': taskslist[index]
                                        //             .questions[0]
                                        //             .options[2]
                                        //             .optionText,
                                        //         'score': 0
                                        //       },
                                        //       {
                                        //         'text': taskslist[index]
                                        //             .questions[0]
                                        //             .options[3]
                                        //             .optionText,
                                        //         'score': 0
                                        //       },
                                        //     ],
                                        //   });
                                        // }
                                        print(_questions.length);
                                        return Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            // Text(_questions[index]['questionText']
                                            //     .toString()),
                                            // Text(_questions[index]['answers'][0]['text']),
                                            // Text(_questions[index]['answers'][1]['text']),
                                            // Text(_questions[index]['answers'][2]['text']),
                                            // Text(_questions[index]['answers'][3]['text']),

                                            // Text(_questions.length.toString()),
                                            // Text("Teacher json"),
                                            // Text("In tasks "),

                                            GestureDetector(
                                              onTap: () {
                                                PersistentNavBarNavigator
                                                    .pushNewScreen(
                                                  context,
                                                  screen: SharedShowQuestions(
                                                    taskindex: index,
                                                    taskid:
                                                        sharedtasklist[index]
                                                            .tasksId!
                                                            .id,
                                                  ),
                                                  withNavBar:
                                                      true, // OPTIONAL VALUE. True by default.
                                                  pageTransitionAnimation:
                                                      PageTransitionAnimation
                                                          .cupertino,
                                                );

                                                // nextScreen(
                                                //     context,
                                                //     ShowQuestions(
                                                //       taskid: taskslist[index].id,
                                                //     ));
                                              },
                                              child: Container(
                                                width: 500,
                                                decoration: BoxDecoration(
                                                  // color: Colors.red,
                                                  color: Color.fromRGBO(
                                                      255, 255, 255, 1),
                                                  border: Border.all(
                                                    color: Color.fromRGBO(
                                                        182, 214, 204, 1),
                                                  ),
                                                  borderRadius:
                                                      BorderRadius.only(
                                                          topLeft: Radius
                                                              .circular(10),
                                                          topRight:
                                                              Radius.circular(
                                                                  10),
                                                          bottomLeft:
                                                              Radius.circular(
                                                                  10),
                                                          bottomRight:
                                                              Radius.circular(
                                                                  10)),
                                                  boxShadow: [
                                                    BoxShadow(
                                                      color: Color.fromRGBO(
                                                          182, 214, 204, 1),
                                                      blurRadius: 6.0,
                                                      offset: Offset(0, 6),
                                                    ),
                                                  ],
                                                ),
                                                // color: Colors.red,
                                                height: 100,
                                                child: Row(
                                                  children: [
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              top: 8.0,
                                                              bottom: 8.0,
                                                              left: 12,
                                                              right: 12),
                                                      child: Container(
                                                        height: 60,
                                                        width: 60,
                                                        // color: Colors.red,
                                                        child: Image.asset(
                                                            "assets/quiz.png"),
                                                      ),
                                                    ),
                                                    Expanded(
                                                      child:
                                                          SingleChildScrollView(
                                                        child: Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .center,
                                                          children: [
                                                            Row(
                                                              children: [
                                                                Text(
                                                                  "Sharedby: ",
                                                                  style: TextStyle(
                                                                      fontSize:
                                                                          15,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w700),
                                                                ),
                                                                Container(
                                                                  width: 140,
                                                                  // color: Colors
                                                                  //     .red,
                                                                  child: Text(
                                                                    sharedtasklist[
                                                                            index]
                                                                        .tasksId!
                                                                        .creator,
                                                                    maxLines: 2,
                                                                    style: TextStyle(
                                                                        color: Color.fromRGBO(
                                                                            38,
                                                                            90,
                                                                            232,
                                                                            1),
                                                                        fontSize:
                                                                            15,
                                                                        fontWeight:
                                                                            FontWeight.w700),
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                            Row(
                                                              children: [
                                                                Text(
                                                                  "Class: ",
                                                                  style: TextStyle(
                                                                      fontSize:
                                                                          15,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w700),
                                                                ),
                                                                Container(
                                                                  width: 140,
                                                                  child: Text(
                                                                    sharedtasklist[
                                                                            index]
                                                                        .tasksId!
                                                                        .taskClass,
                                                                    maxLines: 2,
                                                                    style: TextStyle(
                                                                        color: Color.fromRGBO(
                                                                            38,
                                                                            90,
                                                                            232,
                                                                            1),
                                                                        fontSize:
                                                                            15,
                                                                        fontWeight:
                                                                            FontWeight.w700),
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                            Row(
                                                              children: [
                                                                Text(
                                                                  "Subject: ",
                                                                  style: TextStyle(
                                                                      fontSize:
                                                                          15,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w700),
                                                                ),
                                                                Container(
                                                                  width: 140,
                                                                  child: Text(
                                                                    sharedtasklist[
                                                                            index]
                                                                        .tasksId!
                                                                        .subject,
                                                                    maxLines: 2,
                                                                    style: TextStyle(
                                                                        color: Color.fromRGBO(
                                                                            38,
                                                                            90,
                                                                            232,
                                                                            1),
                                                                        fontSize:
                                                                            15,
                                                                        fontWeight:
                                                                            FontWeight.w700),
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                            // Text(taskslist[index].id),
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                            // TextButton(
                                            //   onPressed: () async {
                                            //     _showTextFieldAlertDialog(
                                            //         context,
                                            //         taskslist[index].id);
                                            //   },
                                            //   child: Text("Share"),
                                            // ),

                                            SizedBox(
                                              height: 10,
                                            )

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

                      // ElevatedButton(
                      //     onPressed: () {
                      //       nextScreen(context, HomeScreen(questions: _questions));
                      //     },
                      //     child: Text("Quiz")),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showTextFieldAlertDialog(BuildContext context, String taskid) {
    TextEditingController textFieldController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Enter Text ${globalteacherdata.id}"),
          content: Column(
            children: [
              Text(taskid),
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

                await addshareData(taskid: taskid, sharedwith: enteredText);

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
      {required String taskid, required String sharedwith}) async {
    final String uemailid = FirebaseAuth.instance.currentUser!.email!;
    String? splituserid;

    splituserid = uemailid.split('@')[0];
    final String url =
        "https://api.easyeduverse.tech/api/user/${splituserid}/task/share";

    // Define the JSON data to be posted
    Map<String, String> jsonData = {
      "taskID": taskid,
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

  Future<List<Sharedtask>> gettaskdata() async {
    final String uemailid = FirebaseAuth.instance.currentUser!.email!;
    String? splituserid;

    splituserid = uemailid.split('@')[0];
    final response = await http.get(
        Uri.parse('https://api.easyeduverse.tech/api/user/${splituserid}'));
    // 'https://easyed-backend.onrender.com/api/teacher/${uid}/task'));
    var data = jsonDecode(response.body.toString());

    sharedtasklist = [];
    // taskslist = [];

    if (response.statusCode == 200) {
      taskteacherdata = Teacher.fromJson(data);

      print(taskteacherdata.sharednotes!.length.toString() + "length");
      for (Sharedtask index in taskteacherdata.sharedtasks!) {
        sharedtasklist.add(index);
      }

      print(sharedtasklist.length.toString() + "length of share");

      return sharedtasklist;
    } else {
      return sharedtasklist;
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
