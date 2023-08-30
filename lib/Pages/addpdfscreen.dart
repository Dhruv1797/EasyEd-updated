import 'dart:convert';
import 'package:dio/dio.dart';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';

import 'package:random_string/random_string.dart';
import 'package:easyed/Pages/addquestionscreen.dart';
import 'package:easyed/Pages/globalvariables.dart';
import 'package:easyed/Pages/notesscreen.dart';
import 'package:easyed/Pages/pdfviewerpage.dart';
import 'package:easyed/Pages/studentscreen.dart';
import 'package:easyed/auth/login_page.dart';
import 'package:easyed/helper/helper_function.dart';
import 'package:easyed/models/Datamodel.dart';

import 'package:http/http.dart' as http;
import 'package:easyed/models/Teacher.dart';
import 'package:easyed/service/auth_service.dart';
import 'package:easyed/widgets/widgets.dart';
import 'package:image_picker/image_picker.dart';

import 'package:file_picker/file_picker.dart';
import 'package:path/path.dart';

class AddPdfScreen extends StatefulWidget {
  static const routeName = '/addpdfscreen';
  // final String taskid;
  const AddPdfScreen({
    super.key,
  });

  @override
  State<AddPdfScreen> createState() => _AddPdfScreenState();
}

class _AddPdfScreenState extends State<AddPdfScreen> {
  final formKey = GlobalKey<FormState>();
  final _globalKey = GlobalKey<ScaffoldMessengerState>();
  bool isloading = false;
  VideoLecture lecturedata = VideoLecture(
      subject: "", topic: "", videoLink: "", videoTitle: "", id: "", v: 0);

  Note notesdata = Note(
      creator: "",
      noteClass: "",
      subject: "",
      topic: "",
      v: 0,
      isFree: true,
      price: "",
      notesPdfLink: "",
      id: "");
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
  TextEditingController creatorcontroller = TextEditingController();
  TextEditingController classcontroller = TextEditingController();
  TextEditingController subjectcontroller = TextEditingController();
  TextEditingController topiccontroller = TextEditingController();
  TextEditingController notehashcontroller = TextEditingController();
  TextEditingController isfreetypecontroller = TextEditingController();
  TextEditingController pricecontroller = TextEditingController();
  String filename = "";

  // TextEditingController pdfcontroller = TextEditingController();
  // TextEditingController answer1ccontroller = TextEditingController();
  // TextEditingController answer1dcontroller = TextEditingController();

  // TextEditingController mobile = TextEditingController();
  // TextEditingController jobcontroller = TextEditingController();
  String userName = "";
  String email = "";
  bool isuploaded = false;
  File? uploadpdf;
  bool isimageloading = false;
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

  Future selectpdf() async {
    FilePickerResult? file = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );
    if (File(file!.files.single.path!) != null) {
      uploadpdf = File(file.files.single.path!);

      setState(() {
        uploadpdf = File(file.files.single.path!);
      });

      isuploaded = true;
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
    print("uid from AddPdfScreen  ${uid}");
    AuthService authService = AuthService();
    return ScaffoldMessenger(
      child: Scaffold(
        // appBar: AppBar(
        //   toolbarHeight: 70,
        //   title: Container(
        //     // color: Colors.red,
        //     height: 80,
        //     width: 120,
        //     child: Center(
        //       child: Text(
        //         'ADD NOTES',
        //         style: TextStyle(fontWeight: FontWeight.w900),
        //       ),
        //     ),
        //   ),
        // ),
        body: SingleChildScrollView(
          child: Container(
              padding: EdgeInsets.all(20),
              child: Column(
                children: [
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                    "Upload",
                    style: TextStyle(
                      fontSize: 24.sp,
                      fontWeight: FontWeight.w700,
                      fontFamily: "Montserrat",
                      color: Color.fromRGBO(15, 15, 15, 1),
                    ),
                  ),

                  SizedBox(
                    height: 22.h,
                  ),

                  GestureDetector(
                    onTap: () async {
                      setState(() {
                        isimageloading = true;
                      });

                      await selectpdf();

                      filename = basename(uploadpdf!.path);

                      setState(() {
                        isimageloading = false;
                      });
                    },
                    child: Container(
                      height: 179.h,
                      width: 297.w,
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
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              child: SvgPicture.asset("assets/uploadicon.svg"),
                            ),
                            SizedBox(
                              height: 23.62,
                            ),
                            Text(
                              "Tap to Browse files",
                              style: TextStyle(
                                fontSize: 15.sp,
                                fontWeight: FontWeight.w600,
                                fontFamily: "Montserrat",
                                color: Color.fromRGBO(15, 15, 15, 1),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  // Text(userName),
                  // Text(email),
                  // Text(uid),
                  // Text(widget.taskid),

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

                  Form(
                    key: formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Padding(
                        //   padding: const EdgeInsets.all(8.0),
                        //   child: TextFormField(
                        //     controller: creatorcontroller,
                        //     decoration: InputDecoration(
                        //         focusedBorder: OutlineInputBorder(
                        //           borderSide: BorderSide(
                        //             width: 3,
                        //             color: Color.fromRGBO(86, 103, 253, 1),
                        //           ),
                        //         ),
                        //         enabledBorder: OutlineInputBorder(
                        //           borderSide: BorderSide(
                        //             width: 3,
                        //             color: Colors.black,
                        //           ), //<-- SEE HERE
                        //         ),
                        //         hintText: "creator Name"),
                        //     validator: (val) {
                        //       if (val!.length < 1) {
                        //         return "Please Enter creator name";
                        //       } else {
                        //         return null;
                        //       }
                        //     },
                        //   ),
                        // ),
                        SizedBox(
                          height: 30,
                        ),
                        Text(
                          "Class",
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
                              color: Color.fromRGBO(
                                  182, 214, 204, 1), // Border color
                            ),
                          ),
                          child: TextFormField(
                            controller: classcontroller,
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
                              hintText: ' @example 12th/11th',
                            ),
                            validator: (val) {
                              if (val!.length < 1) {
                                return "Please Enter class";
                              } else {
                                return null;
                              }
                            },
                          ),
                        ),
                        SizedBox(
                          height: 18.54,
                        ),
                        Text(
                          "Subject",
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
                              color: Color.fromRGBO(
                                  182, 214, 204, 1), // Border color
                            ),
                          ),
                          child: TextFormField(
                            controller: subjectcontroller,
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
                              hintText: ' @example Mathematics',
                            ),
                            validator: (val) {
                              if (val!.length < 1) {
                                return "Please Enter Subject";
                              } else {
                                return null;
                              }
                            },
                          ),
                        ),
                        SizedBox(
                          height: 18.54,
                        ),
                        Text(
                          "Topic",
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
                              color: Color.fromRGBO(
                                  182, 214, 204, 1), // Border color
                            ),
                          ),
                          child: TextFormField(
                            controller: topiccontroller,
                            // keyboardType: TextInputType.number,
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
                              hintText: ' @example Algebra',
                            ),
                            validator: (val) {
                              if (val!.length < 1) {
                                return "Please Enter Topic";
                              } else {
                                return null;
                              }
                            },
                          ),
                        ),
                        SizedBox(
                          height: 18.54,
                        ),

                        // Padding(
                        //   padding: const EdgeInsets.all(8.0),
                        //   child: TextFormField(
                        //     controller: classcontroller,
                        //     decoration: InputDecoration(
                        //         focusedBorder: OutlineInputBorder(
                        //           borderSide: BorderSide(
                        //             width: 3,
                        //             color: Color.fromRGBO(86, 103, 253, 1),
                        //           ),
                        //         ),
                        //         enabledBorder: OutlineInputBorder(
                        //           borderSide: BorderSide(
                        //             width: 3,
                        //             color: Colors.black,
                        //           ), //<-- SEE HERE
                        //         ),
                        //         hintText: "class"),
                        //     validator: (val) {
                        //       if (val!.length < 1) {
                        //         return "Please Enter class";
                        //       } else {
                        //         return null;
                        //       }
                        //     },
                        //   ),
                        // ),
                        // Padding(
                        //   padding: const EdgeInsets.all(8.0),
                        //   child: TextFormField(
                        //     controller: subjectcontroller,
                        //     decoration: InputDecoration(
                        //         focusedBorder: OutlineInputBorder(
                        //           borderSide: BorderSide(
                        //             width: 3,
                        //             color: Color.fromRGBO(86, 103, 253, 1),
                        //           ),
                        //         ),
                        //         enabledBorder: OutlineInputBorder(
                        //           borderSide: BorderSide(
                        //             width: 3,
                        //             color: Colors.black,
                        //           ), //<-- SEE HERE
                        //         ),
                        //         hintText: "subject name"),
                        //     validator: (val) {
                        //       if (val!.length < 1) {
                        //         return "Please Enter Subject";
                        //       } else {
                        //         return null;
                        //       }
                        //     },
                        //   ),
                        // ),
                        // Padding(
                        //   padding: const EdgeInsets.all(8.0),
                        //   child: TextFormField(
                        //     controller: topiccontroller,
                        //     decoration: InputDecoration(
                        //         focusedBorder: OutlineInputBorder(
                        //           borderSide: BorderSide(
                        //             width: 3,
                        //             color: Color.fromRGBO(86, 103, 253, 1),
                        //           ),
                        //         ),
                        //         enabledBorder: OutlineInputBorder(
                        //           borderSide: BorderSide(
                        //             width: 3,
                        //             color: Colors.black,
                        //           ), //<-- SEE HERE
                        //         ),
                        //         hintText: "topic name"),
                        //     validator: (val) {
                        //       if (val!.length < 1) {
                        //         return "Please Enter Topic";
                        //       } else {
                        //         return null;
                        //       }
                        //     },
                        //   ),
                        // ),
                        // TextField(
                        //   controller: notehashcontroller,
                        //   decoration: InputDecoration(
                        //       border: OutlineInputBorder(
                        //           // borderRadius: BorderRadius.circular(20),
                        //           ),
                        //       hintText: "notehash name"),
                        // ),
                        // Padding(
                        //   padding: const EdgeInsets.all(8.0),
                        //   child: TextFormField(
                        //     controller: isfreetypecontroller,
                        //     decoration: InputDecoration(
                        //         focusedBorder: OutlineInputBorder(
                        //           borderSide: BorderSide(
                        //             width: 3,
                        //             color: Color.fromRGBO(86, 103, 253, 1),
                        //           ),
                        //         ),
                        //         enabledBorder: OutlineInputBorder(
                        //           borderSide: BorderSide(
                        //             width: 3,
                        //             color: Colors.black,
                        //           ), //<-- SEE HERE
                        //         ),
                        //         hintText: "isfree name   true or false only !!"),
                        //   ),
                        // ),
                        // Padding(
                        //   padding: const EdgeInsets.all(8.0),
                        //   child: TextFormField(
                        //     controller: pricecontroller,
                        //     decoration: InputDecoration(
                        //         focusedBorder: OutlineInputBorder(
                        //           borderSide: BorderSide(
                        //             width: 3,
                        //             color: Color.fromRGBO(86, 103, 253, 1),
                        //           ),
                        //         ),
                        //         enabledBorder: OutlineInputBorder(
                        //           borderSide: BorderSide(
                        //             width: 3,
                        //             color: Colors.black,
                        //           ), //<-- SEE HERE
                        //         ),
                        //         hintText: "price"),
                        //   ),
                        // ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: isuploaded == true
                        ? GestureDetector(
                            onTap: () {
                              openPDF(context, uploadpdf!);
                            },
                            child: Padding(
                              padding: const EdgeInsets.only(
                                  left: 13.0, right: 8.0, top: 3),
                              child: Row(
                                children: [
                                  Container(
                                    child:
                                        SvgPicture.asset("assets/pdficon.svg"),
                                    height: 27,
                                    width: 27,
                                  ),
                                  // SizedBox(
                                  //   width: 22,
                                  // ),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 10),
                                    child: Container(
                                      width: 140,
                                      child: Text(
                                        filename,
                                        style: TextStyle(
                                            fontSize: 13,
                                            fontWeight: FontWeight.w600,
                                            color:
                                                Color.fromRGBO(38, 50, 56, 1)),
                                      ),
                                    ),
                                  ),
                                  // SizedBox(
                                  //   width: 64,
                                  // ),
                                ],
                              ),
                            ),
                          )
                        : Padding(
                            padding: const EdgeInsets.only(
                                left: 13.0, right: 8.0, top: 3),
                            child: Row(
                              children: [
                                Container(
                                  child: SvgPicture.asset("assets/pdficon.svg"),
                                  height: 27,
                                  width: 27,
                                ),
                                // SizedBox(
                                //   width: 22,
                                // ),
                                Padding(
                                  padding: const EdgeInsets.only(left: 10),
                                  child: Container(
                                    width: 140,
                                    child: Text(
                                      "Upload a PDF",
                                      style: TextStyle(
                                          fontSize: 13,
                                          fontWeight: FontWeight.w600,
                                          color: Color.fromRGBO(38, 50, 56, 1)),
                                    ),
                                  ),
                                ),
                                // SizedBox(
                                //   width: 64,
                                // ),
                              ],
                            ),
                          ),
                  ),

                  // ElevatedButton(
                  //     onPressed: (() async {
                  //       setState(() {
                  //         isimageloading = true;
                  //       });

                  //       await selectpdf();

                  //       filename = basename(uploadpdf!.path);

                  //       setState(() {
                  //         isimageloading = false;
                  //       });
                  //     }),
                  //     child: isimageloading
                  //         ? Container(
                  //             height: 20,
                  //             width: 20,
                  //             child: CircularProgressIndicator(
                  //                 color: Color.fromRGBO(38, 90, 232, 1)),
                  //           )
                  //         : Text("Upload")),
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
                  // SizedBox(
                  //   height: 20,
                  // ),
                  // TextField(
                  //   controller: jobcontroller,
                  //   decoration: InputDecoration(
                  //       border: OutlineInputBorder(
                  //           // borderRadius: BorderRadius.circular(20),
                  //           ),
                  //       hintText: "job title"),
                  // ),
                  Padding(
                    padding: EdgeInsets.only(top: 10.0.h),
                    child: Container(
                      width: 500,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            primary: Color.fromRGBO(86, 103, 253, 1),
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30))),
                        onPressed: () async {
                          if (formKey.currentState!.validate()) {
                            if (!isuploaded) {
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
                              // final snackBar = SnackBar(
                              //   behavior: SnackBarBehavior.floating,
                              //   margin: EdgeInsets.only(),
                              //   backgroundColor: Colors.black,
                              //   duration: Duration(seconds: 1),
                              //   dismissDirection: DismissDirection.horizontal,
                              //   content: Container(
                              //     height: 30,
                              //     child: const Text(
                              //       'Likes Updated Sucessfully.',
                              //       style: TextStyle(),
                              //     ),
                              //   ),
                              // );

                              // ScaffoldMessenger.of(context)
                              //     .hideCurrentSnackBar();

                              // ScaffoldMessenger.of(context)
                              //     .showSnackBar(snackBar);
                            } else {
                              setState(() {
                                isloading = true;
                              });
                              String id = uid;
                              // String creatorname = creatorcontroller.text;
                              String creatorname =
                                  globalteacherdata.userDetails[0].lastName;
                              String classname = classcontroller.text;
                              String subjectname = subjectcontroller.text;
                              String topicname = topiccontroller.text;
                              String notehash = 123456.toString();
                              String isfree = true.toString();
                              String price = 0.toString();

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

                              await submitdata(
                                  filepath: uploadpdf,
                                  creatorname: creatorname,
                                  classname: classname,
                                  subjectname: subjectname,
                                  topicname: topicname,
                                  notehash: notehash,
                                  isfree: isfree,
                                  price: price,
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
                                screen: NotesScreen(),
                                withNavBar:
                                    true, // OPTIONAL VALUE. True by default.
                                pageTransitionAnimation:
                                    PageTransitionAnimation.cupertino,
                              );

                              // nextScreen(context, NotesScreen());
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
                  //         creatorcontroller.text = "";
                  //         classcontroller.text = "";
                  //         subjectcontroller.text = "";
                  //         topiccontroller.text = "";
                  //         notehashcontroller.text = "";
                  //         isfreetypecontroller.text = "";
                  //         pricecontroller.text = "";

                  //         uploadpdf = null;
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
                  //   child: Text("Next pdf "),
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
              )),
        ),
      ),
    );
  }

  Future submitdata(
      {required File? filepath,
      required String creatorname,
      required String classname,
      required String subjectname,
      required String topicname,
      required String notehash,
      required String isfree,
      required String price,

      // required Task taskdata,
      // required DateTime createdOn,
      // required DateTime updatedOn,
      // required String id,
      required String uid}) async {
    String filename = basename(filepath!.path);
    final String uemailid = FirebaseAuth.instance.currentUser!.email!;
    String? splituserid;

    splituserid = uemailid.split('@')[0];

    print("file base name ${filename}");

    try {
      FormData formdata = FormData.fromMap({
        "creator": creatorname,
        "class": classname,
        "subject": subjectname,
        "topic": topicname,
        "notehash": notehash,
        "isfree": isfree,
        "price": price,
        "pdf": await MultipartFile.fromFile(filepath.path, filename: filename),
      });

      Response response = await Dio()
          .post("https://api.easyeduverse.tech/api/user/${splituserid}/notes",
              // "https://easyed-backend.onrender.com/api/teacher/$uid/notes",
              data: formdata);

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
