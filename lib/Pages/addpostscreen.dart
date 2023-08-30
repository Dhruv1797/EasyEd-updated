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
import 'package:easyed/Pages/globalvariables.dart';
import 'package:easyed/Pages/showpostscreen.dart';
import 'package:easyed/Pages/studentscreen.dart';
import 'package:easyed/auth/login_page.dart';
import 'package:easyed/helper/helper_function.dart';
import 'package:easyed/models/Datamodel.dart';

import 'package:http/http.dart' as http;
import 'package:easyed/models/Teacher.dart';
import 'package:easyed/models/post.dart';
import 'package:easyed/service/auth_service.dart';
import 'package:easyed/widgets/widgets.dart';
import 'package:image_picker/image_picker.dart';

import 'package:file_picker/file_picker.dart';
import 'package:path/path.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';

class AddPostScreen extends StatefulWidget {
  static const routeName = '/addpost';
  // final String taskid;
  const AddPostScreen({
    super.key,
  });

  @override
  State<AddPostScreen> createState() => _AddPostScreenState();
}

class _AddPostScreenState extends State<AddPostScreen> {
  bool istextonly = false;
  int sizeInBytes = 0;
  double sizeInMb = 0;
  bool greatersizeprompt = false;
  String filename = "";
  final formKey = GlobalKey<FormState>();
  bool isimage = false;
  final uid = FirebaseAuth.instance.currentUser!.uid;
  final _globalKey = GlobalKey<ScaffoldMessengerState>();
  bool isloading = false;
  bool isloadingsubmit = false;
  VideoLecture lecturedata = VideoLecture(
      subject: "", topic: "", videoLink: "", videoTitle: "", id: "", v: 0);
  List<Teacher> teacherslist = [];

  bool isimageloading = false;
  bool isvideoloading = false;

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

  // Post postdata = Post(
  //     id: '',
  //     userId: "",
  //     post: "",
  //     avatar: "",
  //     content: "",
  //     isBlocked: false,
  //     date: DateTime.now(),
  //     likes: [],
  //     comments: [],
  //     v: 1);

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
  TextEditingController contentcontroller = TextEditingController();
  // TextEditingController topiccontroller = TextEditingController();
  // TextEditingController videotitlecontroller = TextEditingController();
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

  File? uploadimage;
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

  Future selectimage() async {
    FilePickerResult? file =
        await FilePicker.platform.pickFiles(type: FileType.image);
    if (File(file!.files.single.path!) != null) {
      uploadimage = File(file.files.single.path!);

      setState(() {
        uploadimage = File(file.files.single.path!);
        filename = basename(uploadimage!.path);
        sizeInBytes = uploadimage!.lengthSync();
        sizeInMb = sizeInBytes / (1024 * 1024);
      });

      isimage = true;

      // await sendFileMessage(video, MessageEnum.video, currentuserid, sp,
      //     widget.partnercode, widget.connectcode, widget.getgrouprank);
    }
  }

  Future selectvideo() async {
    FilePickerResult? file =
        await FilePicker.platform.pickFiles(type: FileType.video);
    if (File(file!.files.single.path!) != null) {
      uploadimage = File(file.files.single.path!);

      setState(() {
        uploadimage = File(file.files.single.path!);
        filename = basename(uploadimage!.path);
        sizeInBytes = uploadimage!.lengthSync();
        sizeInMb = sizeInBytes / (1024 * 1024);
      });

      isimage = true;

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
    // final String taskid = randomNumeric(24);
    final uid = FirebaseAuth.instance.currentUser!.uid;
    print("uid from AddPostScreen  ${uid}");
    AuthService authService = AuthService();
    return ScaffoldMessenger(
      child: Scaffold(
        appBar: AppBar(
          toolbarHeight: 100,
          title: Text(
            'ADD POSTS',
            style:
                TextStyle(fontWeight: FontWeight.w700, fontFamily: 'Poppins'),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: FutureBuilder(
              future: getTeacherdata(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                } else {
                  if (uploadimage != null) {
                    sizeInBytes = uploadimage!.lengthSync();
                    sizeInMb = sizeInBytes / (1024 * 1024);
                  }

                  return ListView.builder(
                      itemCount: 1,
                      itemBuilder: (context, index) {
                        return Container(
                            padding: EdgeInsets.all(20),
                            child: Column(
                              children: [
                                // Text(sampleteachers.userDetails[0].avatar),
                                // Text(userName),
                                // Text(email),
                                // Text(uid),
                                // // Text(widget.taskid),

                                // GestureDetector(
                                //     onTap: () async {
                                //       await authService.signOut();
                                //       Navigator.of(context).pushAndRemoveUntil(
                                //           MaterialPageRoute(
                                //               builder: (context) =>
                                //                   const LoginPage()),
                                //           (route) => false);
                                //     },
                                //     child: Text("Signout")),

                                uploadimage != null
                                    ? Row(
                                        children: [
                                          Container(
                                              height: 40,
                                              width: 40,
                                              child: Image.asset(
                                                  "assets/files.png")),
                                          Container(
                                              // color: Colors.red,
                                              width: globaldevicewidth! * 0.7,
                                              child: Text(
                                                filename,
                                                style: TextStyle(
                                                    fontWeight:
                                                        FontWeight.w800),
                                              )),
                                        ],
                                      )
                                    : Row(
                                        children: [
                                          Container(
                                              height: 40,
                                              width: 40,
                                              child: Image.asset(
                                                  "assets/files.png")),
                                          Container(
                                              // color: Colors.red,
                                              width: globaldevicewidth! * 0.7,
                                              child: Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 3.0),
                                                child: Text(
                                                  "Please upload a file",
                                                  style: TextStyle(
                                                      fontFamily: 'Poppins',
                                                      fontWeight:
                                                          FontWeight.w800),
                                                ),
                                              )),
                                        ],
                                      ),

                                greatersizeprompt
                                    ? Row(
                                        children: [
                                          Text(
                                            "please upload file less than 50 mb",
                                            style: TextStyle(color: Colors.red),
                                          ),
                                        ],
                                      )
                                    : Text(""),

                                // TextField(
                                //   controller: idcontroller,
                                //   decoration: InputDecoration(
                                //       border: OutlineInputBorder(
                                //           // borderRadius: BorderRadius.circular(20),
                                //           ),
                                //       hintText: "Enter id"),
                                // ),
                                // TextField(
                                //   controller: subjectcontroller,
                                //   decoration: InputDecoration(
                                //       border: OutlineInputBorder(
                                //           // borderRadius: BorderRadius.circular(20),
                                //           ),
                                //       hintText: "Subject Name"),
                                // ),
                                Padding(
                                  padding: const EdgeInsets.only(top: 24.0),
                                  child: Form(
                                    key: formKey,
                                    child: Container(
                                      decoration: BoxDecoration(
                                        // color: Colors.red,
                                        color: Color.fromRGBO(255, 255, 255, 1),
                                        border: Border.all(
                                          color:
                                              Color.fromRGBO(182, 214, 204, 1),
                                        ),
                                        borderRadius: BorderRadius.only(
                                            topLeft: Radius.circular(10),
                                            topRight: Radius.circular(10),
                                            bottomLeft: Radius.circular(10),
                                            bottomRight: Radius.circular(10)),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Color.fromRGBO(
                                                182, 214, 204, 1),
                                            blurRadius: 6.0,
                                            offset: Offset(0, 6),
                                          ),
                                        ],
                                      ),
                                      child: TextFormField(
                                        style: TextStyle(
                                            fontWeight: FontWeight.w600,
                                            fontFamily: 'Poppins'),
                                        minLines: 15,
                                        maxLines: 20,
                                        keyboardType: TextInputType.multiline,
                                        controller: contentcontroller,
                                        decoration: InputDecoration(
                                            focusedBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                width: 1,
                                                color: Color.fromRGBO(
                                                    182, 214, 204, 1),
                                              ), //<-- SEE HERE
                                            ),
                                            enabledBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                width: 1,
                                                color: Color.fromRGBO(
                                                    182, 214, 204, 1),
                                              ), //<-- SEE HERE
                                            ),
                                            hintText: "Enter content.."),
                                        validator: (val) {
                                          if (val!.length < 1) {
                                            return "Please Enter Content";
                                          } else {
                                            return null;
                                          }
                                        },
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 15.h,
                                ),

                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    GestureDetector(
                                      onTap: () async {
                                        setState(() {
                                          greatersizeprompt = false;
                                          isimageloading = true;
                                        });

                                        await selectimage();

                                        setState(() {
                                          isimageloading = false;
                                        });
                                      },
                                      child: isimageloading
                                          ? Container(
                                              height: 20,
                                              width: 20,
                                              child: CircularProgressIndicator(
                                                  color: Color.fromRGBO(
                                                      38, 90, 232, 1)),
                                            )
                                          : Container(
                                              height: 40,
                                              width: 40,
                                              child: Image.asset(
                                                  "assets/photocamera.png"),
                                            ),
                                    ),
                                    SizedBox(width: 20),
                                    GestureDetector(
                                      onTap: () async {
                                        setState(() {
                                          greatersizeprompt = false;
                                          isvideoloading = true;
                                        });

                                        await selectvideo();

                                        setState(() {
                                          isvideoloading = false;
                                        });
                                      },
                                      child: isvideoloading
                                          ? Container(
                                              height: 20,
                                              width: 20,
                                              child: CircularProgressIndicator(
                                                  color: Color.fromRGBO(
                                                      38, 90, 232, 1)),
                                            )
                                          : Container(
                                              height: 40,
                                              width: 40,
                                              child: Image.asset(
                                                  "assets/videocamera.png"),
                                            ),
                                    ),
                                  ],
                                ),
                                // TextField(
                                //   controller: videotitlecontroller,
                                //   decoration: InputDecoration(
                                //       border: OutlineInputBorder(
                                //           // borderRadius: BorderRadius.circular(20),
                                //           ),
                                //       hintText: "Enter video title"),
                                // ),

                                // ElevatedButton(
                                //     onPressed: (() async {
                                //       setState(() {
                                //         isloading = true;
                                //       });

                                //       await selectimage();

                                //       setState(() {
                                //         isloading = false;
                                //       });
                                //     }),
                                //     child: Text("Upload image")),
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
                                  padding: const EdgeInsets.only(top: 17.0),
                                  child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                        primary:
                                            Color.fromRGBO(86, 103, 253, 1),
                                        elevation: 0,
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(30))),
                                    onPressed: () async {
                                      if (formKey.currentState!.validate()) {
                                        if (!isimage) {
                                          // if (!isimage) {
                                          //code commented data
                                          // final snackBar = SnackBar(
                                          //   behavior: SnackBarBehavior.floating,
                                          //   margin: EdgeInsets.only(),
                                          //   backgroundColor: Colors.black,
                                          //   duration: Duration(seconds: 1),
                                          //   dismissDirection:
                                          //       DismissDirection.horizontal,
                                          //   content: Container(
                                          //     height: 30,
                                          //     child: const Text(
                                          //       'Please upload Content.',
                                          //       style: TextStyle(),
                                          //     ),
                                          //   ),
                                          // );

                                          // ScaffoldMessenger.of(context)
                                          //     .hideCurrentSnackBar();

                                          // ScaffoldMessenger.of(context)
                                          //     .showSnackBar(snackBar);

                                          setState(() {
                                            isloadingsubmit = true;
                                          });

                                          String userid = uid;
                                          String content =
                                              contentcontroller.text;

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

                                          await anothermethodsubmitdatatextonly(
                                              // filepath: uploadimage,
                                              content: content,
                                              uid: userid,
                                              avatarimage: sampleteachers
                                                  .userDetails[0].avatar);

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
                                            isloadingsubmit = false;
                                          });

                                          submitteddata = true;

                                          PersistentNavBarNavigator
                                              .pushNewScreen(
                                            context,
                                            screen: ShowPostScreen(),
                                            withNavBar:
                                                true, // OPTIONAL VALUE. True by default.
                                            pageTransitionAnimation:
                                                PageTransitionAnimation
                                                    .cupertino,
                                          );
                                          //code commented data

                                          // setState(() {
                                          //   isloadingsubmit = true;
                                          // });

                                          // String userid = uid;
                                          // String content =
                                          //     contentcontroller.text;

                                          // // String question1text = question1controller.text;
                                          // // String question1type = question1typecontroller.text;
                                          // // String answer1a = answer1acontroller.text;
                                          // // String answer1b = answer1bcontroller.text;
                                          // // String answer1c = answer1ccontroller.text;
                                          // // String answer1d = answer1dcontroller.text;

                                          // // Task taskdata = Task(
                                          // //   creator: creatorname,
                                          // //   taskClass: classnames,
                                          // //   subject: subjectname,
                                          // //   topic: topicname,
                                          // //    id:" widget.taskid",
                                          // //   questions: [
                                          // //     // Question(
                                          // //     //   question: question1text,
                                          // //     //   questionType: question1type,
                                          // //     //   options: [
                                          // //     //     Option(
                                          // //     //         optionNumber: "A",
                                          // //     //         optionText: answer1a,
                                          // //     //         id: "649ec068b4a2118b5424695d"),
                                          // //     //     Option(
                                          // //     //         optionNumber: "B",
                                          // //     //         optionText: answer1b,
                                          // //     //         id: "649ec068b4a2118b5424695e"),
                                          // //     //     Option(
                                          // //     //         optionNumber: "C",
                                          // //     //         optionText: answer1c,
                                          // //     //         id: "649ec068b4a2118b5424695f"),
                                          // //     //     Option(
                                          // //     //         optionNumber: "D",
                                          // //     //         optionText: answer1d,
                                          // //     //         id: "649ec068b4a2118b54246960"),
                                          // //     //   ],
                                          // //     //   id: "649ec068b4a2118b5424695c",
                                          // //     // )
                                          // //   ],
                                          // // );

                                          // // Teacher teacherdata = Teacher(
                                          // //     id: uid,
                                          // //     commons: [
                                          // //       Common(
                                          // //         createdOn:
                                          // //             DateTime.parse("2023-06-30T09:00:00.000Z"),
                                          // //         updatedOn:
                                          // //             DateTime.parse("2023-06-30T09:00:00.000Z"),
                                          // //         id: "649ebfb5b4a2118b5424694e",
                                          // //       )
                                          // //     ],
                                          // //     userDetails: [
                                          // //       UserDetail(
                                          // //           firstName: firstname,
                                          // //           lastName: lastname,
                                          // //           email: email,
                                          // //           mobile: mobile,
                                          // //           avatar: "",
                                          // //           id: "649ebfb5b4a2118b5424694e")
                                          // //     ],
                                          // //     educationalDetails: [
                                          // //       EducationalDetail(
                                          // //           instituteName: institutename,
                                          // //           educationalDetailClass: classname,
                                          // //           id: "649ebfb5b4a2118b5424694e")
                                          // //     ],
                                          // //     tasks: [],
                                          // //     notes: [],
                                          // //     videoLecture: [],
                                          // //     students: [],
                                          // //     v: 91);
                                          // ///////String job = jobcontroller.text;

                                          // // Teacher data = await submitdata(
                                          // //   teacherdata: teacherdata,
                                          // //   id: id,

                                          // await submittextdataonly(
                                          //     filepath: uploadimage,
                                          //     content: content,
                                          //     uid: userid,
                                          //     avatarimage: sampleteachers
                                          //         .userDetails[0].avatar);

                                          // ///////// createdOn: DateTime.now(),
                                          // ////////// updatedOn: DateTime.now());
                                          // // );

                                          // // await FirebaseFirestore.instance
                                          // //     .collection("users")
                                          // //     .doc(uid)
                                          // //     .update({
                                          // //   "filldetails": true,
                                          // // });

                                          // // setState(() {
                                          // //   taskdata = datatask;
                                          // // });
                                          // setState(() {
                                          //   isloadingsubmit = false;
                                          // });

                                          // submitteddata = true;

                                          // PersistentNavBarNavigator
                                          //     .pushNewScreen(
                                          //   context,
                                          //   screen: ShowPostScreen(),
                                          //   withNavBar:
                                          //       true, // OPTIONAL VALUE. True by default.
                                          //   pageTransitionAnimation:
                                          //       PageTransitionAnimation
                                          //           .cupertino,
                                          // );

                                          // nextScreen(context, ShowPostScreen());
                                        } else {
                                          if (sizeInMb > 50) {
                                            setState(() {
                                              greatersizeprompt = true;
                                            });

                                            print(sizeInMb);
                                          } else {
                                            setState(() {
                                              isloadingsubmit = true;
                                            });

                                            String userid = uid;
                                            String content =
                                                contentcontroller.text;

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
                                                filepath: uploadimage,
                                                content: content,
                                                uid: userid,
                                                avatarimage: sampleteachers
                                                    .userDetails[0].avatar);

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
                                              isloadingsubmit = false;
                                            });

                                            submitteddata = true;

                                            PersistentNavBarNavigator
                                                .pushNewScreen(
                                              context,
                                              screen: ShowPostScreen(),
                                              withNavBar:
                                                  true, // OPTIONAL VALUE. True by default.
                                              pageTransitionAnimation:
                                                  PageTransitionAnimation
                                                      .cupertino,
                                            );

                                            // nextScreen(context, ShowPostScreen());
                                          }
                                        }
                                      }
                                    },
                                    child: isloadingsubmit
                                        ? Container(
                                            height: 20,
                                            width: 20,
                                            child: CircularProgressIndicator(
                                                color: Colors.white),
                                          )
                                        : Text(
                                            "Submit",
                                            style: TextStyle(
                                                fontFamily: 'Poppins',
                                                fontWeight: FontWeight.w700,
                                                color: Colors.white,
                                                fontSize: 16),
                                          ),
                                  ),
                                ),

                                // ElevatedButton(
                                //   onPressed: () {
                                //     if (submitteddata == false) {
                                //       final snackBar = SnackBar(
                                //         backgroundColor: Colors.red,
                                //         duration: Duration(seconds: 1),
                                //         dismissDirection:
                                //             DismissDirection.horizontal,
                                //         content: const Text(
                                //           'Please Submit this question first',
                                //           style: TextStyle(),
                                //         ),
                                //       );
                                //       ScaffoldMessenger.of(context)
                                //           .hideCurrentSnackBar();

                                //       ScaffoldMessenger.of(context)
                                //           .showSnackBar(snackBar);
                                //     } else {
                                //       setState(() {
                                //         contentcontroller.text = "";

                                //         uploadimage = null;
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
                                //   child: Text("Next post "),
                                // ),
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
                            ));
                      });
                }
              }),
        ),
      ),
    );
  }

  Future submitdata(
      {required File? filepath,
      required String content,
      required String avatarimage,
      // required String topic,
      // required String videotitle,
      // required Task taskdata,
      // required DateTime createdOn,
      // required DateTime updatedOn,
      // required String id,
      required String uid}) async {
    String filename = basename(filepath!.path);

    print("file base name ${filename}");

    try {
      FormData formdata = FormData.fromMap({
        "userId": globalteacherdata.userDetails[0].lastName,
        "post": await MultipartFile.fromFile(filepath.path, filename: filename),
        "avatar": avatarimage,
        "content": content,
      });

      Response response = await Dio()
          .post("https://api.easyeduverse.tech/api/post", data: formdata);

      print("File upload response: $response");
      _showSnackBarMsg(response.data['message']);
    } catch (e) {
      print("expectation Caugch: $e");
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
    //   Uri.https('easyed-backend.onrender.com', '/api/teacher/${uid}/task'),
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

  Future submittextdataonly(
      {required File? filepath,
      required String content,
      required String avatarimage,
      // required String topic,
      // required String videotitle,
      // required Task taskdata,
      // required DateTime createdOn,
      // required DateTime updatedOn,
      // required String id,
      required String uid}) async {
    // String filename = basename(filepath!.path);

    // print("file base name ${filename}");

    try {
      FormData formdata = FormData.fromMap({
        "userId": globalteacherdata.userDetails[0].lastName,
        "post": "text",
        "avatar": avatarimage,
        "content": content,
      });

      Response response = await Dio()
          .post("https://api.easyeduverse.tech/api/post", data: formdata);

      print("File upload response: $response");
      _showSnackBarMsg(response.data['message']);
    } catch (e) {
      print("expectation Caugch: $e");
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
    //   Uri.https('easyed-backend.onrender.com', '/api/teacher/${uid}/task'),
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

  Future<Teacher> getTeacherdata() async {
    final String uemailid = FirebaseAuth.instance.currentUser!.email!;
    String? splituserid;

    splituserid = uemailid.split('@')[0];

    final response = await http.get(
        Uri.parse('https://api.easyeduverse.tech/api/user/${splituserid}'));
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

  Future anothermethodsubmitdata(
      {required File? filepath,
      required String content,
      required String avatarimage,

      // required Task taskdata,
      // required DateTime createdOn,
      // required DateTime updatedOn,
      // required String id,
      required String uid}) async {
    String filename = basename(filepath!.path);
    String url = "https://api.easyeduverse.tech/api/post";

    var request = http.MultipartRequest('POST', Uri.parse(url));

    request.fields['userId'] = globalteacherdata.userDetails[0].lastName;

    request.fields['avatar'] = avatarimage;
    request.fields['content'] = content;

    request.files.add(
      await http.MultipartFile.fromPath('post', filepath.path),
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
    //     "http://ec2-13-234-152-69.ap-south-1.compute.amazonaws.com/api/user/$uid/lectures",
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
    //   Uri.https('easyed-backend.onrender.com', '/api/teacher/${uid}/task'),
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

  Future anothermethodsubmitdatatextonly(
      {required String content,
      required String avatarimage,

      // required Task taskdata,
      // required DateTime createdOn,
      // required DateTime updatedOn,
      // required String id,
      required String uid}) async {
    // String filename = basename(filepath!.path);
    String url = "https://api.easyeduverse.tech/api/post";

    var request = http.MultipartRequest('POST', Uri.parse(url));

    request.fields['userId'] = globalteacherdata.userDetails[0].lastName;

    request.fields['avatar'] = avatarimage;
    request.fields['content'] = content;

    // request.files.add(
    //   await http.MultipartFile.fromPath('post', filepath.path),
    // );

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
    //     "http://ec2-13-234-152-69.ap-south-1.compute.amazonaws.com/api/user/$uid/lectures",
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
    //   Uri.https('easyed-backend.onrender.com', '/api/teacher/${uid}/task'),
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
