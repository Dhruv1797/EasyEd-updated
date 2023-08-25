import 'dart:convert';
import 'package:dio/dio.dart';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';

import 'package:random_string/random_string.dart';
import 'package:easyed/Pages/addquestionscreen.dart';
import 'package:easyed/Pages/lecturesscreen.dart';
import 'package:easyed/Pages/studentscreen.dart';
import 'package:easyed/auth/login_page.dart';
import 'package:easyed/helper/helper_function.dart';
import 'package:easyed/models/Datamodel.dart';

import 'package:http/http.dart' as http;
import 'package:easyed/models/Teacher.dart';
import 'package:easyed/service/auth_service.dart';
import 'package:easyed/video_player_file_item.dart';
import 'package:easyed/widgets/widgets.dart';
import 'package:image_picker/image_picker.dart';

import 'package:file_picker/file_picker.dart';
import 'package:path/path.dart';

class AddVideoScreen extends StatefulWidget {
  static const routeName = '/addvideoscreen';
  // final String taskid;
  const AddVideoScreen({
    super.key,
  });

  @override
  State<AddVideoScreen> createState() => _AddVideoScreenState();
}

class _AddVideoScreenState extends State<AddVideoScreen> {
  final _globalKey = GlobalKey<ScaffoldMessengerState>();
  final formKey = GlobalKey<FormState>();
  bool isvideo = false;
  bool isvideoloading = false;
  bool isloading = false;
  VideoLecture lecturedata = VideoLecture(
      subject: "", topic: "", videoLink: "", videoTitle: "", id: "");
  bool submitteddata = false;
  // Teacher teacherdata = Teacher(
  //     id: "",
  //     commons: [],
  //     userDetails: [],
  //     educationalDetails: [],
  //     tasks: [],
  //     notes: [],
  //     videoLecture: [],
  //     students: [],
  //     v: 1);

  // Task taskdata = Task(
  //     creator: "",
  //     taskClass: "",
  //     subject: "",
  //     topic: "",
  //     questions: [],
  //     id: "");

  // DataModel modeldata =
  //     DataModel(name: "name", job: "job", id: "id", createdAt: DateTime.now());
  TextEditingController subjectcontroller = TextEditingController();
  TextEditingController topiccontroller = TextEditingController();
  TextEditingController videotitlecontroller = TextEditingController();

  // TextEditingController videocontroller = TextEditingController();
  // TextEditingController question1controller = TextEditingController();
  // TextEditingController question1typecontroller = TextEditingController();
  // TextEditingController answer1acontroller = TextEditingController();
  // TextEditingController answer1bcontroller = TextEditingController();
  // TextEditingController answer1ccontroller = TextEditingController();
  // TextEditingController answer1dcontroller = TextEditingController();

  // TextEditingController mobile = TextEditingController();
  // TextEditingController jobcontroller = TextEditingController();
  String userName = "";
  String email = "";

  File? uploadvideo;
  gettingUserData() async {
    await HelperFunctions.getUserEmailFromSF().then((value) {
      setState(() {
        email = value!;
      });
    });
    await HelperFunctions.getUserNameFromSF().then((val) {
      setState(() {
        userName = val!;
      });
    });
  }

  // Future<File?> pickVideoFromGallery(BuildContext context) async {
  //   File? video;
  //   try {
  //     final pickedVideo =
  //         await ImagePicker().pickVideo(source: ImageSource.gallery);

  //     if (pickedVideo != null) {
  //       video = File(pickedVideo.path);
  //     }
  //   } catch (e) {
  //     showSnackBar(context: context, content: e.toString());
  //   }
  //   return video;
  // }

  void showSnackBar({required BuildContext context, required String content}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(content),
      ),
    );
  }

  Future selectVideo() async {
    FilePickerResult? file =
        await FilePicker.platform.pickFiles(type: FileType.video);
    if (File(file!.files.single.path!) != null) {
      uploadvideo = File(file.files.single.path!);

      setState(() {
        uploadvideo = File(file.files.single.path!);
      });

      isvideo = true;

      // await sendFileMessage(video, MessageEnum.video, currentuserid, sp,
      //     widget.partnercode, widget.connectcode, widget.getgrouprank);
    }
  }

  void initState() {
    super.initState();

    gettingUserData();
  }

  void _showSnackBarMsg(String msg) {
    var snackBar = SnackBar(content: Text('Hello World'));
    _globalKey.currentState!.showSnackBar(snackBar);
  }

  @override
  Widget build(BuildContext context) {
    double deviceheight = MediaQuery.of(context).size.height;
    double appbarheight = 45;

    double devicewidth = MediaQuery.of(context).size.width;
    // final String taskid = randomNumeric(24);
    final uid = FirebaseAuth.instance.currentUser!.uid;
    print("uid from AddVideoScreen  ${uid}");
    AuthService authService = AuthService();
    return ScaffoldMessenger(
      child: Scaffold(
        appBar: AppBar(
          toolbarHeight: 70,
          title: Container(
            // color: Colors.red,
            height: 80,
            width: 300,
            child: Center(
              child: Row(
                children: [
                  Text(
                    'ADD YOUR LECTURES',
                    style: TextStyle(fontWeight: FontWeight.w900),
                  ),
                ],
              ),
            ),
          ),
        ),
        body: SingleChildScrollView(
          child: Container(
              padding: EdgeInsets.all(20),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    uploadvideo != null
                        ? Container(
                            decoration:
                                BoxDecoration(border: Border.all(width: 3)),
                            height: 300,
                            width: 400,
                            child: VideoPlayerFileItem(
                              videofile: uploadvideo,
                            ))
                        : Container(
                            decoration:
                                BoxDecoration(border: Border.all(width: 3)),
                            height: deviceheight * 0.27,
                            width: devicewidth * 0.7,
                            child: Center(
                              child: Text("Upload Video "),
                            ),
                          ),
                    // Text(userName),
                    // Text(email),
                    // Text(uid),
                    // // Text(widget.taskid),

                    // GestureDetector(
                    //     onTap: () async {
                    //       await authService.signOut();
                    //       Navigator.of(context).pushAndRemoveUntil(
                    //           MaterialPageRoute(
                    //               builder: (context) => const LoginPage()),
                    //           (route) => false);
                    //     },
                    //     child: Text("Signout")),
                    // TextField(
                    //   controller: idcontroller,
                    //   decoration: InputDecoration(
                    //       border: OutlineInputBorder(
                    //           // borderRadius: BorderRadius.circular(20),
                    //           ),
                    //       hintText: "Enter id"),
                    // ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        ElevatedButton(
                            onPressed: (() async {
                              setState(() {
                                isvideoloading = true;
                              });

                              await selectVideo();

                              setState(() {
                                isvideoloading = false;
                              });
                            }),
                            child: isvideoloading
                                ? Container(
                                    height: 20,
                                    width: 20,
                                    child: CircularProgressIndicator(
                                        color: Color.fromRGBO(38, 90, 232, 1)),
                                  )
                                : Text("Upload")),
                      ],
                    ),

                    Form(
                      key: formKey,
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: TextFormField(
                              controller: subjectcontroller,
                              decoration: InputDecoration(
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      width: 3,
                                      color: Color(0xFF265AE8),
                                    ),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      width: 3,
                                      color: Colors.black,
                                    ), //<-- SEE HERE
                                  ),
                                  hintText: "Subject Name"),
                              validator: (val) {
                                if (val!.length < 1) {
                                  return "Please Enter Subject";
                                } else {
                                  return null;
                                }
                              },
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: TextFormField(
                              controller: topiccontroller,
                              decoration: InputDecoration(
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      width: 3,
                                      color: Color(0xFF265AE8),
                                    ),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      width: 3,
                                      color: Colors.black,
                                    ), //<-- SEE HERE
                                  ),
                                  hintText: "Topic Name"),
                              validator: (val) {
                                if (val!.length < 1) {
                                  return "Please Enter Topic";
                                } else {
                                  return null;
                                }
                              },
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: TextFormField(
                              controller: videotitlecontroller,
                              decoration: InputDecoration(
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      width: 3,
                                      color: Color(0xFF265AE8),
                                    ),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      width: 3,
                                      color: Colors.black,
                                    ), //<-- SEE HERE
                                  ),
                                  hintText: "Enter video title"),
                              validator: (val) {
                                if (val!.length < 1) {
                                  return "Please Enter video title";
                                } else {
                                  return null;
                                }
                              },
                            ),
                          ),
                        ],
                      ),
                    ),

                    // TextField(
                    //   controller: topiccontroller,
                    //   decoration: InputDecoration(
                    //       border: OutlineInputBorder(
                    //           // borderRadius: BorderRadius.circular(20),
                    //           ),
                    //       hintText: "Enter topic name"),
                    // ),
                    // TextField(
                    //   controller: question1controller,
                    //   decoration: InputDecoration(
                    //       border: OutlineInputBorder(
                    //           // borderRadius: BorderRadius.circular(20),
                    //           ),
                    //       hintText: "Enter question 1 "),
                    // ),
                    // TextField(
                    //   controller: question1typecontroller,
                    //   decoration: InputDecoration(
                    //       border: OutlineInputBorder(
                    //           // borderRadius: BorderRadius.circular(20),
                    //           ),
                    //       hintText: "Enter question 1 type "),
                    // ),
                    // TextField(
                    //   controller: answer1acontroller,
                    //   decoration: InputDecoration(
                    //       border: OutlineInputBorder(
                    //           // borderRadius: BorderRadius.circular(20),
                    //           ),
                    //       hintText: "Enter option a "),
                    // ),
                    // TextField(
                    //   controller: answer1bcontroller,
                    //   decoration: InputDecoration(
                    //       border: OutlineInputBorder(
                    //           // borderRadius: BorderRadius.circular(20),
                    //           ),
                    //       hintText: "Enter option b "),
                    // ),
                    // TextField(
                    //   controller: answer1ccontroller,
                    //   decoration: InputDecoration(
                    //       border: OutlineInputBorder(
                    //           // borderRadius: BorderRadius.circular(20),
                    //           ),
                    //       hintText: "Enter option c "),
                    // ),
                    // TextField(
                    //   controller: answer1dcontroller,
                    //   decoration: InputDecoration(
                    //       border: OutlineInputBorder(
                    //           // borderRadius: BorderRadius.circular(20),
                    //           ),
                    //       hintText: "Enter option d "),
                    // ),
                    SizedBox(
                      height: 20,
                    ),
                    // TextField(
                    //   controller: jobcontroller,
                    //   decoration: InputDecoration(
                    //       border: OutlineInputBorder(
                    //           // borderRadius: BorderRadius.circular(20),
                    //           ),
                    //       hintText: "job title"),
                    // ),
                    Padding(
                      padding: const EdgeInsets.only(top: 10.0),
                      child: Container(
                        width: 500,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              primary: Color(0xFF265AE8),
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30))),
                          onPressed: () async {
                            if (formKey.currentState!.validate()) {
                              if (!isvideo) {
                                final snackBar = SnackBar(
                                  behavior: SnackBarBehavior.floating,
                                  margin: EdgeInsets.only(),
                                  backgroundColor: Colors.black,
                                  duration: Duration(seconds: 1),
                                  dismissDirection: DismissDirection.horizontal,
                                  content: Container(
                                    height: 30,
                                    child: const Text(
                                      'Please upload image.',
                                      style: TextStyle(),
                                    ),
                                  ),
                                );

                                ScaffoldMessenger.of(context)
                                    .hideCurrentSnackBar();

                                ScaffoldMessenger.of(context)
                                    .showSnackBar(snackBar);
                              } else {
                                setState(() {
                                  isloading = true;
                                });

                                String id = uid;
                                String subjectname = subjectcontroller.text;
                                String topicname = topiccontroller.text;
                                String videotitlename =
                                    videotitlecontroller.text;

                                // String question1text = question1controller.text;
                                // String question1type = question1typecontroller.text;
                                // String answer1a = answer1acontroller.text;
                                // String answer1b = answer1bcontroller.text;
                                // String answer1c = answer1ccontroller.text;
                                // String answer1d = answer1dcontroller.text;

                                // Task taskdata = Task(
                                //   creator: creatorname,
                                //   taskClass: classnames,
                                //   subject: subjectname,
                                //   topic: topicname,
                                //    id:" widget.taskid",
                                //   questions: [
                                //     // Question(
                                //     //   question: question1text,
                                //     //   questionType: question1type,
                                //     //   options: [
                                //     //     Option(
                                //     //         optionNumber: "A",
                                //     //         optionText: answer1a,
                                //     //         id: "649ec068b4a2118b5424695d"),
                                //     //     Option(
                                //     //         optionNumber: "B",
                                //     //         optionText: answer1b,
                                //     //         id: "649ec068b4a2118b5424695e"),
                                //     //     Option(
                                //     //         optionNumber: "C",
                                //     //         optionText: answer1c,
                                //     //         id: "649ec068b4a2118b5424695f"),
                                //     //     Option(
                                //     //         optionNumber: "D",
                                //     //         optionText: answer1d,
                                //     //         id: "649ec068b4a2118b54246960"),
                                //     //   ],
                                //     //   id: "649ec068b4a2118b5424695c",
                                //     // )
                                //   ],
                                // );

                                // Teacher teacherdata = Teacher(
                                //     id: uid,
                                //     commons: [
                                //       Common(
                                //         createdOn:
                                //             DateTime.parse("2023-06-30T09:00:00.000Z"),
                                //         updatedOn:
                                //             DateTime.parse("2023-06-30T09:00:00.000Z"),
                                //         id: "649ebfb5b4a2118b5424694e",
                                //       )
                                //     ],
                                //     userDetails: [
                                //       UserDetail(
                                //           firstName: firstname,
                                //           lastName: lastname,
                                //           email: email,
                                //           mobile: mobile,
                                //           avatar: "",
                                //           id: "649ebfb5b4a2118b5424694e")
                                //     ],
                                //     educationalDetails: [
                                //       EducationalDetail(
                                //           instituteName: institutename,
                                //           educationalDetailClass: classname,
                                //           id: "649ebfb5b4a2118b5424694e")
                                //     ],
                                //     tasks: [],
                                //     notes: [],
                                //     videoLecture: [],
                                //     students: [],
                                //     v: 91);
                                ///////String job = jobcontroller.text;

                                // Teacher data = await submitdata(
                                //   teacherdata: teacherdata,
                                //   id: id,

                                await anothermethodsubmitdata(
                                    filepath: uploadvideo,
                                    subjectname: subjectname,
                                    topic: topicname,
                                    videotitle: videotitlename,
                                    uid: uid);

                                ///////// createdOn: DateTime.now(),
                                ////////// updatedOn: DateTime.now());
                                // );

                                // await FirebaseFirestore.instance
                                //     .collection("users")
                                //     .doc(uid)
                                //     .update({
                                //   "filldetails": true,
                                // });

                                // setState(() {
                                //   taskdata = datatask;
                                // });
                                setState(() {
                                  isloading = false;
                                });

                                PersistentNavBarNavigator.pushNewScreen(
                                  context,
                                  screen: LecturesScreen(),
                                  withNavBar:
                                      true, // OPTIONAL VALUE. True by default.
                                  pageTransitionAnimation:
                                      PageTransitionAnimation.cupertino,
                                );

                                // nextScreen(context, LecturesScreen());
                              }
                            }
                          },
                          child: isloading
                              ? Container(
                                  height: 20,
                                  width: 20,
                                  child: CircularProgressIndicator(
                                      color: Colors.white),
                                )
                              : Text(
                                  "Submit",
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 16),
                                ),
                        ),
                      ),
                    ),

                    // ElevatedButton(
                    //   onPressed: () {
                    //     if (submitteddata == false) {
                    //       final snackBar = SnackBar(
                    //         backgroundColor: Colors.red,
                    //         duration: Duration(seconds: 1),
                    //         dismissDirection: DismissDirection.horizontal,
                    //         content: const Text(
                    //           'Please Submit this question first',
                    //           style: TextStyle(),
                    //         ),
                    //       );
                    //       ScaffoldMessenger.of(context).hideCurrentSnackBar();

                    //       ScaffoldMessenger.of(context).showSnackBar(snackBar);
                    //     } else {
                    //       setState(() {
                    //         videotitlecontroller.text = "";
                    //         subjectcontroller.text = "";
                    //         topiccontroller.text = "";
                    //         uploadvideo = null;
                    //         // question1controller.text = "";
                    //         // question1typecontroller.text = "";
                    //         // answer1acontroller.text = "";
                    //         // answer1bcontroller.text = "";
                    //         // answer1ccontroller.text = "";
                    //         // answer1dcontroller.text = "";
                    //         submitteddata = false;
                    //       });
                    //     }
                    //   },
                    //   child: Text("Next Video "),
                    //  ),
                    // ElevatedButton(
                    //     onPressed: () {
                    //       nextScreen(
                    //           context,
                    //           AddQuestionScreen(
                    //             taskid: "widget.taskid",
                    //           ));
                    //     },
                    //     child: Text("add questions "))
                  ],
                ),
              )),
        ),
      ),
    );
  }

  Future submitdata(
      {required File? filepath,
      required String subjectname,
      required String topic,
      required String videotitle,
      // required Task taskdata,
      // required DateTime createdOn,
      // required DateTime updatedOn,
      // required String id,
      required String uid}) async {
    String filename = basename(filepath!.path);

    print("file base name ${filename}");

    try {
      FormData formdata = FormData.fromMap({
        "subject": subjectname,
        "topic": topic,
        "videotitle": videotitle,
        "video":
            await MultipartFile.fromFile(filepath.path, filename: filename),
      });

      Response response = await Dio().post(
        "https://api.easyeduverse.tech/api/user/$uid/lectures",
        // "https://easyed-backend.onrender.com/api/teacher/$uid/lectures",
        // "https://easyed-backend.onrender.com/api/teacher/cmKRXykJf9MyGenjXB2uwsQz5H13/lectures",
        data: formdata,
        // options: Options(
        //   contentType: 'multipart/form-data',
        //   headers: {
        //     "Accept": "application/x-www-form-urlencoded",
        //   },
        // ),
      );

      print("File upload response: $response");
      _showSnackBarMsg(response.data['message']);
    } catch (e) {
      print("expectation Caught: ${e}");
    }
    // List<Common> commonlist = <Common>[
    //   Common(createdOn: DateTime.now(), updatedOn: DateTime.now(), id: id)
    // ];
    // String jsonpayload = teacherToJson(teacherdata);

    // print(jsonpayload);
    // print(Common(createdOn: DateTime.now(), updatedOn: DateTime.now(), id: id)
    //     .toJson()
    //     .toString());
    // print("printing respose body part");
    // print(
    //   {
    //     "_id": id,
    //     "commons": json.encode([
    //       Common(createdOn: DateTime.now(), updatedOn: DateTime.now(), id: id)
    //           .toJson()
    //       // "createdOn": "2022-01-01T09:00:00.000Z",
    //       // "updatedOn": "2022-01-01T09:00:00.000Z"
    //     ])
    //   },
    // );

    // var response = await http.post(
    //   Uri.httpss('easyed-backend.onrender.com', '/api/teacher/${uid}/task'),
    //   headers: {'Content-Type': 'application/json'},
    //   // body: json.encode(sendData),
    //   body: json.encode(taskdata),
    // );

    // taskdata = Task.fromJson(json.decode(data));

    // if (response.statusCode == 201) {
    //   // String responsestring = response.body;
    //   // teacherFromJson(responsestring);

    //   return taskdata;
    // } else {
    //   return taskdata;
    // }
  }

  Future anothermethodsubmitdata(
      {required File? filepath,
      required String subjectname,
      required String topic,
      required String videotitle,
      // required Task taskdata,
      // required DateTime createdOn,
      // required DateTime updatedOn,
      // required String id,
      required String uid}) async {
    String filename = basename(filepath!.path);
    String url = "https://api.easyeduverse.tech/api/user/$uid/lectures";

    var request = http.MultipartRequest('POST', Uri.parse(url));

    request.fields['subject'] = subjectname;
    request.fields['topic'] = topic;
    request.fields['videotitle'] = videotitle;
    request.files.add(
      await http.MultipartFile.fromPath('video', filepath.path),
    );

    var response = await request.send();

    print("file base name ${filename}");

    if (response.statusCode == 200) {
      print('Video data uploaded successfully!');
    } else {
      print('Video data upload failed with status: ${response.statusCode}');
    }

    // try {
    //   FormData formdata = FormData.fromMap({
    //     "subject": subjectname,
    //     "topic": topic,
    //     "videotitle": videotitle,
    //     "video":
    //         await MultipartFile.fromFile(filepath.path, filename: filename),
    //   });

    //   Response response = await Dio().post(
    //     "https://api.easyeduverse.tech/api/user/$uid/lectures",
    //     // "https://easyed-backend.onrender.com/api/teacher/$uid/lectures",
    //     //  "https://easyed-backend.onrender.com/api/teacher/cmKRXykJf9MyGenjXB2uwsQz5H13/lectures",
    //     data: formdata,
    //     // options: Options(
    //     //   contentType: 'multipart/form-data',
    //     //   headers: {
    //     //     "Accept": "application/x-www-form-urlencoded",
    //     //   },
    //     // ),
    //   );

    //   print("File upload response: $response");
    //   _showSnackBarMsg(response.data['message']);
    // } catch (e) {
    //   print("expectation Caught: $e");
    // }
    // List<Common> commonlist = <Common>[
    //   Common(createdOn: DateTime.now(), updatedOn: DateTime.now(), id: id)
    // ];
    // String jsonpayload = teacherToJson(teacherdata);

    // print(jsonpayload);
    // print(Common(createdOn: DateTime.now(), updatedOn: DateTime.now(), id: id)
    //     .toJson()
    //     .toString());
    // print("printing respose body part");
    // print(
    //   {
    //     "_id": id,
    //     "commons": json.encode([
    //       Common(createdOn: DateTime.now(), updatedOn: DateTime.now(), id: id)
    //           .toJson()
    //       // "createdOn": "2022-01-01T09:00:00.000Z",
    //       // "updatedOn": "2022-01-01T09:00:00.000Z"
    //     ])
    //   },
    // );

    // var response = await http.post(
    //   Uri.httpss('easyed-backend.onrender.com', '/api/teacher/${uid}/task'),
    //   headers: {'Content-Type': 'application/json'},
    //   // body: json.encode(sendData),
    //   body: json.encode(taskdata),
    // );

    // taskdata = Task.fromJson(json.decode(data));

    // if (response.statusCode == 201) {
    //   // String responsestring = response.body;
    //   // teacherFromJson(responsestring);

    //   return taskdata;
    // } else {
    //   return taskdata;
    // }
  }
}
