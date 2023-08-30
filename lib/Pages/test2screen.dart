import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easyed/Pages/globalvariables.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';
import 'package:easyed/Pages/studentscreen.dart';
import 'package:easyed/auth/login_page.dart';
import 'package:easyed/helper/helper_function.dart';
import 'package:easyed/models/Datamodel.dart';

import 'package:http/http.dart' as http;
import 'package:easyed/models/Teacher.dart';
import 'package:easyed/service/auth_service.dart';
import 'package:easyed/widgets/widgets.dart';
import 'package:intl/intl.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:random_string/random_string.dart';

class test2screen extends StatefulWidget {
  static const routeName = '/test2screen';
  const test2screen({super.key});

  @override
  State<test2screen> createState() => _test2screenState();
}

Future<Teacher> submitdata({
  required Teacher teacherdata,
  context,
  // required DateTime createdOn,
  // required DateTime updatedOn,
  required String id,
}) async {
  List<Common> commonlist = <Common>[
    Common(createdOn: DateTime.now(), updatedOn: DateTime.now(), id: id)
  ];
  String jsonpayload = teacherToJson(teacherdata);

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

  var response = await http.post(
    Uri.https('api.easyeduverse.tech', '/api/user'),
    // Uri.https('easyed-backend.onrender.com', '/api/teacher'),
    headers: {'Content-Type': 'application/json'},
    // body: json.encode(sendData),
    body: json.encode(teacherdata),
  );

  var data = response.body;

  print(data);

  if (response.statusCode == 201) {
    String responsestring = response.body;
    teacherFromJson(responsestring);

    final snackBar = SnackBar(
      backgroundColor: Colors.green,
      duration: Duration(seconds: 1),
      dismissDirection: DismissDirection.horizontal,
      content: const Text(
        'Submit Sucessfully',
        style: TextStyle(),
      ),
    );
    ScaffoldMessenger.of(context).hideCurrentSnackBar();

    ScaffoldMessenger.of(context).showSnackBar(snackBar);

    return Teacher.fromJson(jsonDecode(response.body));
  } else {
    throw Exception(" Failed " + response.statusCode.toString());
  }
}

class _test2screenState extends State<test2screen> {
  bool isloading = false;
  bool isimageloading = false;
  bool isuploaded = false;
  final uid = FirebaseAuth.instance.currentUser!.uid;
  File? selectedImage;

  String? avatarurl =
      "https://firebasestorage.googleapis.com/v0/b/easyed-9df02.appspot.com/o/UserAvatarImages%2Faccount.png?alt=media&token=63577669-1e6e-4291-aca0-427354ef3b79";

  void showSnackBar({required BuildContext context, required String content}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(content),
      ),
    );
  }

  getRank(
    int rank,
    var data,
    String? partnercode,
  ) {
    for (int i = 0; i < data.length; i++) {
      if (partnercode == data[i].reference.id) {
        rank = i + 1;
      }
    }
    return rank;
  }

  Future<File?> pickImageFromGallery(BuildContext context) async {
    File? image;
    try {
      // final pickedImage =
      //     await ImagePicker().pickImage(source: ImageSource.gallery);
      final pickedImage =
          await ImagePicker().pickImage(source: ImageSource.gallery);

      if (pickedImage != null) {
        image = File(pickedImage.path);
      }
    } catch (e) {
      showSnackBar(context: context, content: e.toString());
    }
    return image;
  }

  Future getImage() async {
    var image = await pickImageFromGallery(context);

    setState(() {
      selectedImage = image;
    });

    isuploaded = true;

    print(selectedImage);
  }

  Future uploadavatar() async {
    if (selectedImage != null) {
      setState(() {});

      // DateTime now = DateTime.now();
      // String formattedDate = DateFormat('yyyy-MM-dd').format(now);

      /// upload image to firebase storage
      Reference firebaseStorageRef = FirebaseStorage.instance
          .ref()
          .child("UserAvatarImages")
          .child(uid)
          .child("${randomAlphaNumeric(9)}.jpg");

      ///create a task to upload this data to our storage
      final UploadTask task = firebaseStorageRef.putFile(selectedImage!);

      var downoadUrl = await (await task).ref.getDownloadURL();
      print("this is url $downoadUrl");

      avatarurl = downoadUrl;
    } else {}
  }

  Teacher teacherdata = Teacher(
    id: "",
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

  // DataModel modeldata =
  //     DataModel(name: "name", job: "job", id: "id", createdAt: DateTime.now());
  TextEditingController idcontroller = TextEditingController();
  TextEditingController firstnamecontroller = TextEditingController();
  TextEditingController lastnamecontroller = TextEditingController();
  TextEditingController emailcontroller = TextEditingController();
  TextEditingController mobilecontroller = TextEditingController();
  TextEditingController instituteNamecontroller = TextEditingController();
  TextEditingController classcontroller = TextEditingController();
  String emailid = "";
  String fullname = "";
  final formKey = GlobalKey<FormState>();
  // TextEditingController mobile = TextEditingController();
  // TextEditingController jobcontroller = TextEditingController();
  String userName = "";
  String email = "";
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

  void initState() {
    super.initState();

    gettingUserData();
  }

  @override
  Widget build(BuildContext context) {
    final uid = FirebaseAuth.instance.currentUser!.uid;
    print("uid from test2screen  ${uid}");
    AuthService authService = AuthService();
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        // appBar: AppBar(
        //   title: Text(
        //     'Personal Informations',
        //     style: TextStyle(fontWeight: FontWeight.w700),
        //   ),
        // ),
        body: SingleChildScrollView(
          child: StreamBuilder(
              stream:
                  FirebaseFirestore.instance.collection('users').snapshots(),
              builder: (context, snapshot) {
                if (snapshot.data == null)
                  return Center(child: CircularProgressIndicator());

                var data = snapshot.data!.docs;
                int rank = 0;
                int uidrank = getRank(rank, data, uid) - 1;

                fullname = snapshot.data!.docs[uidrank].data()['fullName'];
                emailid = snapshot.data!.docs[uidrank].data()['email'];
                return Container(
                    // padding: EdgeInsets.all(1),
                    child: Padding(
                  padding: EdgeInsets.only(left: 20.0.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: 72.w,
                      ),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          SizedBox(
                            width: 50.w,
                          ),
                          Text(
                            "Create your profile",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 24.sp,
                              fontWeight: FontWeight.w700,
                              fontFamily: "Montserrat",
                              color: Color.fromRGBO(86, 103, 253, 1),
                            ),
                          ),
                        ],
                      ),

                      SizedBox(
                        height: 30.h,
                      ),
                      // Text(snapshot.data!.docs[uidrank].data()['email']),
                      // Text(snapshot.data!.docs[uidrank].data()['fullName']),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          SizedBox(
                            width: 110.w,
                          ),
                          GestureDetector(
                              onTap: () async {
                                setState(() {
                                  isimageloading = true;
                                });

                                await getImage();
                                setState(() {
                                  isimageloading = false;
                                });
                              },
                              child: isimageloading
                                  ? Container(
                                      height: 20,
                                      width: 20,
                                      child: CircularProgressIndicator(
                                          color:
                                              Color.fromRGBO(38, 90, 232, 1)),
                                    )
                                  : Padding(
                                      padding:
                                          const EdgeInsets.only(bottom: 30.0),
                                      child: selectedImage != null
                                          ? Container(
                                              margin: EdgeInsets.symmetric(
                                                  horizontal: 16),
                                              height: 83,
                                              width: 83,
                                              child: ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(6),
                                                child: CircleAvatar(
                                                  backgroundColor: Colors.white,
                                                  backgroundImage: Image.file(
                                                    selectedImage!,
                                                    fit: BoxFit.cover,
                                                  ).image,
                                                  radius: 50,
                                                  // child: Image.file(
                                                  //   selectedImage!,
                                                  //   fit: BoxFit.cover,
                                                  // ),
                                                ),
                                              ),
                                            )
                                          : Container(
                                              height: 83.h,
                                              width: 83.w,
                                              child: Stack(
                                                alignment:
                                                    Alignment.bottomRight,
                                                children: [
                                                  SvgPicture.asset(
                                                      "assets/profilepicture.svg"),
                                                  GestureDetector(
                                                    onTap: () async {
                                                      setState(() {
                                                        isimageloading = true;
                                                      });

                                                      await getImage();
                                                      setState(() {
                                                        isimageloading = false;
                                                      });
                                                    },
                                                    child: SvgPicture.asset(
                                                      "assets/greencamera.svg",
                                                      height: 24,
                                                      width: 24,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                    )),
                        ],
                      ),

                      // Text(userName),
                      // Text(email),
                      // Text(uid),

                      // TextFormField(
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
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                              "Mobile No.",
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
                                keyboardType: TextInputType.number,
                                controller: mobilecontroller,
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
                                  hintText: ' @example 9343XXXX24',
                                ),
                                validator: (val) {
                                  if (val!.length < 1) {
                                    return "Enter Mobile Number";
                                  } else if (val.length != 10) {
                                    return "Please Enter 10 digit Mobile Number";
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
                              "Institute",
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
                                controller: instituteNamecontroller,
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
                                  hintText: ' @example NIT/IIT/XYZ School',
                                ),
                                validator: (val) {
                                  if (val!.length < 1) {
                                    return "Enter Institute Name";
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
                              "Profession",
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
                                  hintText: '@example Student/Teacher',
                                ),
                                validator: (val) {
                                  if (val!.length < 1) {
                                    return "Enter Profession ";
                                  } else {
                                    return null;
                                  }
                                },
                              ),
                            ),
                            SizedBox(
                              height: 80.85,
                            ),

                            Padding(
                              padding: EdgeInsets.only(left: 24.0.w),
                              child: GestureDetector(
                                onTap: () async {
                                  // for makeing optional image
                                  if (formKey.currentState!.validate()) {
                                    print(isuploaded);
                                    if (isuploaded == false) {
                                      avatarurl =
                                          "https://firebasestorage.googleapis.com/v0/b/easyed-9df02.appspot.com/o/UserAvatarImages%2Faccount.png?alt=media&token=63577669-1e6e-4291-aca0-427354ef3b79";

                                      setState(() {
                                        isloading = true;
                                      });

                                      String id = uid;
                                      // String id = uid;
                                      String firstname = fullname;
                                      // String firstname = firstnamecontroller.text;
                                      String lastname = emailid.split('@')[0];
                                      String email = emailid;
                                      // String email = emailcontroller.text;
                                      String mobile = mobilecontroller.text;
                                      String institutename =
                                          instituteNamecontroller.text;
                                      String classname = classcontroller.text;

                                      Teacher teacherdata = Teacher(
                                        id: id,
                                        commons: [
                                          Common(
                                            createdOn: DateTime.parse(
                                                "2023-06-30T09:00:00.000Z"),
                                            updatedOn: DateTime.parse(
                                                "2023-06-30T09:00:00.000Z"),
                                            id: "649ebfb5b4a2118b5424694e",
                                          )
                                        ],
                                        userDetails: [
                                          UserDetail(
                                              firstName: firstname,
                                              lastName: lastname,
                                              email: email,
                                              mobile: mobile,
                                              avatar: avatarurl!,
                                              id: "649ebfb5b4a2118b5424694e")
                                        ],
                                        educationalDetails: [
                                          EducationalDetail(
                                              instituteName: institutename,
                                              educationalDetailClass: classname,
                                              id: "649ebfb5b4a2118b5424694e")
                                        ],
                                        tasks: [],
                                        notes: [],
                                        videoLecture: [],
                                        // students: [],
                                        v: 0,
                                        sharedlectures: [],
                                        sharednotes: [],
                                        sharedtasks: [],
                                      );
                                      ///////String job = jobcontroller.text;

                                      Teacher data = await submitdata(
                                          teacherdata: teacherdata,
                                          id: id,
                                          context: context

                                          ///////// createdOn: DateTime.now(),
                                          ////////// updatedOn: DateTime.now());
                                          );

                                      await FirebaseFirestore.instance
                                          .collection("users")
                                          .doc(uid)
                                          .update({
                                        "filldetails": true,
                                      });

                                      setState(() {
                                        teacherdata = data;
                                      });

                                      setState(() {
                                        isloading = false;
                                      });

                                      PersistentNavBarNavigator.pushNewScreen(
                                        context,
                                        screen: StudentScreen(),
                                        withNavBar:
                                            true, // OPTIONAL VALUE. True by default.
                                        pageTransitionAnimation:
                                            PageTransitionAnimation.cupertino,
                                      );

                                      // nextScreen(context, StudentScreen());
                                      // final snackBar = SnackBar(
                                      //   backgroundColor: Colors.red,
                                      //   duration: Duration(seconds: 1),
                                      //   dismissDirection: DismissDirection.horizontal,
                                      //   content: const Text(
                                      //     'Please upload the Profile Picture.',
                                      //     style: TextStyle(),
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
                                      await uploadavatar();

                                      globalsplitusername =
                                          emailid.split('@')[0];

                                      String id = globalsplitusername!;
                                      String firstname = fullname;
                                      // String firstname = firstnamecontroller.text;
                                      String lastname = emailid.split('@')[0];
                                      String email = emailid;
                                      // String email = emailcontroller.text;
                                      String mobile = mobilecontroller.text;
                                      String institutename =
                                          instituteNamecontroller.text;
                                      String classname = classcontroller.text;

                                      Teacher teacherdata = Teacher(
                                        id: id,
                                        commons: [
                                          Common(
                                            createdOn: DateTime.parse(
                                                "2023-06-30T09:00:00.000Z"),
                                            updatedOn: DateTime.parse(
                                                "2023-06-30T09:00:00.000Z"),
                                            id: "649ebfb5b4a2118b5424694e",
                                          )
                                        ],
                                        userDetails: [
                                          UserDetail(
                                              firstName: firstname,
                                              lastName: lastname,
                                              email: email,
                                              mobile: mobile,
                                              avatar: avatarurl!,
                                              id: "649ebfb5b4a2118b5424694e")
                                        ],
                                        educationalDetails: [
                                          EducationalDetail(
                                              instituteName: institutename,
                                              educationalDetailClass: classname,
                                              id: "649ebfb5b4a2118b5424694e")
                                        ],
                                        tasks: [],
                                        notes: [],
                                        videoLecture: [],
                                        // students: [],
                                        v: 91,
                                        sharedlectures: [],
                                        sharednotes: [],
                                        sharedtasks: [],
                                      );
                                      ///////String job = jobcontroller.text;

                                      Teacher data = await submitdata(
                                          teacherdata: teacherdata,
                                          id: id,
                                          context: context

                                          ///////// createdOn: DateTime.now(),
                                          ////////// updatedOn: DateTime.now());
                                          );

                                      await FirebaseFirestore.instance
                                          .collection("users")
                                          .doc(uid)
                                          .update({
                                        "filldetails": true,
                                      });

                                      setState(() {
                                        teacherdata = data;
                                      });

                                      setState(() {
                                        isloading = false;
                                      });

                                      PersistentNavBarNavigator.pushNewScreen(
                                        context,
                                        screen: StudentScreen(),
                                        withNavBar:
                                            true, // OPTIONAL VALUE. True by default.
                                        pageTransitionAnimation:
                                            PageTransitionAnimation.cupertino,
                                      );

                                      // nextScreen(context, StudentScreen());
                                    }
                                  }
                                },
                                child: Container(
                                  height: 61.h,
                                  width: 267.w,
                                  decoration: BoxDecoration(
                                    color: Color.fromRGBO(86, 103, 253, 1),
                                    borderRadius: BorderRadius.circular(12.r),
                                  ),
                                  child: Center(
                                    child: isloading
                                        ? Container(
                                            height: 20,
                                            width: 20,
                                            child: CircularProgressIndicator(
                                                color: Colors.white),
                                          )
                                        : Text(
                                            "Sign up",
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                                fontSize: 20.sp,
                                                fontWeight: FontWeight.w600,
                                                fontFamily: "Exo",
                                                color: Color.fromRGBO(
                                                    255, 255, 255, 1)),
                                          ),
                                  ),
                                ),
                              ),
                            ),
                            // Padding(
                            //   padding: const EdgeInsets.all(8.0),
                            //   child: TextFormField(
                            //     controller: firstnamecontroller,
                            //     decoration: InputDecoration(
                            //         focusedBorder: OutlineInputBorder(
                            //           borderSide: BorderSide(
                            //             color: Color.fromRGBO(86, 103, 253, 1),
                            //           ),
                            //         ),
                            //         enabledBorder: OutlineInputBorder(
                            //           borderSide: BorderSide(
                            //             width: 3,
                            //             color: Color.fromRGBO(86, 103, 253, 1),
                            //           ), //<-- SEE HERE
                            //         ),
                            //         hintText: "Full Name"),
                            //     validator: (val) {
                            //       if (val!.length < 1) {
                            //         return "Enter Full Name";
                            //       } else {
                            //         return null;
                            //       }
                            //     },
                            //   ),
                            // ),
                            // Padding(
                            //   padding: const EdgeInsets.all(8.0),
                            //   child: TextFormField(
                            //     controller: lastnamecontroller,
                            //     decoration: InputDecoration(
                            //         focusedBorder: OutlineInputBorder(
                            //           borderSide: BorderSide(
                            //             color: Color.fromRGBO(86, 103, 253, 1),
                            //           ),
                            //         ),
                            //         enabledBorder: OutlineInputBorder(
                            //           borderSide: BorderSide(
                            //             width: 3,
                            //             color: Color.fromRGBO(86, 103, 253, 1),
                            //           ), //<-- SEE HERE
                            //         ),
                            //         hintText: "Last Name"),
                            //     validator: (val) {
                            //       if (val!.length < 1) {
                            //         return "Enter Last Name";
                            //       } else {
                            //         return null;
                            //       }
                            //     },
                            //   ),
                            // ),
                            // Padding(
                            //   padding: const EdgeInsets.all(8.0),
                            //   child: TextFormField(
                            //     controller: emailcontroller,
                            //     decoration: InputDecoration(
                            //         focusedBorder: OutlineInputBorder(
                            //           borderSide: BorderSide(
                            //             color: Color.fromRGBO(86, 103, 253, 1),
                            //           ),
                            //         ),
                            //         enabledBorder: OutlineInputBorder(
                            //           borderSide: BorderSide(
                            //             width: 3,
                            //             color: Color.fromRGBO(86, 103, 253, 1),
                            //           ), //<-- SEE HERE
                            //         ),
                            //         hintText: "Enter Email"),
                            //     validator: (val) {
                            //       if (val!.length < 1) {
                            //         return "Enter Email";
                            //       } else {
                            //         return null;
                            //       }
                            //     },
                            //   ),
                            // ),
                            // Padding(
                            //   padding: const EdgeInsets.all(8.0),
                            //   child: TextFormField(
                            //     keyboardType: TextInputType.number,
                            //     controller: mobilecontroller,
                            //     decoration: InputDecoration(
                            //         focusedBorder: OutlineInputBorder(
                            //           borderSide: BorderSide(
                            //             color: Color.fromRGBO(86, 103, 253, 1),
                            //           ),
                            //         ),
                            //         enabledBorder: OutlineInputBorder(
                            //           borderSide: BorderSide(
                            //             width: 3,
                            //             color: Color.fromRGBO(86, 103, 253, 1),
                            //           ), //<-- SEE HERE
                            //         ),
                            //         hintText: "Enter Mobile number"),
                            //     validator: (val) {
                            //       if (val!.length < 1) {
                            //         return "Enter Mobile Number";
                            //       } else if (val.length != 10) {
                            //         return "Please Enter 10 digit Mobile Number";
                            //       } else {
                            //         return null;
                            //       }
                            //     },
                            //   ),
                            // ),
                            // Padding(
                            //   padding: const EdgeInsets.all(8.0),
                            //   child: TextFormField(
                            //     controller: instituteNamecontroller,
                            //     decoration: InputDecoration(
                            //         focusedBorder: OutlineInputBorder(
                            //           borderSide: BorderSide(
                            //             color: Color.fromRGBO(86, 103, 253, 1),
                            //           ),
                            //         ),
                            //         enabledBorder: OutlineInputBorder(
                            //           borderSide: BorderSide(
                            //             width: 3,
                            //             color: Color.fromRGBO(86, 103, 253, 1),
                            //           ), //<-- SEE HERE
                            //         ),
                            //         hintText: "Enter Institute Name"),
                            //     validator: (val) {
                            //       if (val!.length < 1) {
                            //         return "Enter Institute Name";
                            //       } else {
                            //         return null;
                            //       }
                            //     },
                            //   ),
                            // ),
                            // Padding(
                            //   padding: const EdgeInsets.all(8.0),
                            //   child: TextFormField(
                            //     controller: classcontroller,
                            //     decoration: InputDecoration(
                            //         focusedBorder: OutlineInputBorder(
                            //           borderSide: BorderSide(
                            //             color: Color.fromRGBO(86, 103, 253, 1),
                            //           ),
                            //         ),
                            //         enabledBorder: OutlineInputBorder(
                            //           borderSide: BorderSide(
                            //             width: 3,
                            //             color: Color.fromRGBO(86, 103, 253, 1),
                            //           ), //<-- SEE HERE
                            //         ),
                            //         hintText: "Enter Profession "),
                            //     validator: (val) {
                            //       if (val!.length < 1) {
                            //         return "Enter Profession ";
                            //       } else {
                            //         return null;
                            //       }
                            //     },
                            //   ),
                            // ),
                          ],
                        ),
                      ),

                      // ElevatedButton(
                      //     onPressed: () {
                      //       getImage();
                      //     },
                      //     child: Text("get image")),
                      // ElevatedButton(
                      //     onPressed: () {
                      //       uploadavatar();
                      //     },
                      //     child: Text("upload image")),
                      // TextFormField(
                      //   controller: jobcontroller,
                      //   decoration: InputDecoration(
                      //       border: OutlineInputBorder(
                      //           // borderRadius: BorderRadius.circular(20),
                      //           ),
                      //       hintText: "job title"),
                      // ),
                      // ElevatedButton(
                      //     onPressed: () async {
                      //       await uploadavatar();

                      //       String id = uid;
                      //       String firstname = firstnamecontroller.text;
                      //       String lastname = lastnamecontroller.text;
                      //       String email = emailcontroller.text;
                      //       String mobile = mobilecontroller.text;
                      //       String institutename = instituteNamecontroller.text;
                      //       String classname = classcontroller.text;

                      //       Teacher teacherdata = Teacher(
                      //           id: id,
                      //           commons: [
                      //             Common(
                      //               createdOn:
                      //                   DateTime.parse("2023-06-30T09:00:00.000Z"),
                      //               updatedOn:
                      //                   DateTime.parse("2023-06-30T09:00:00.000Z"),
                      //               id: "649ebfb5b4a2118b5424694e",
                      //             )
                      //           ],
                      //           userDetails: [
                      //             UserDetail(
                      //                 firstName: firstname,
                      //                 lastName: lastname,
                      //                 email: email,
                      //                 mobile: mobile,
                      //                 avatar: avatarurl!,
                      //                 id: "649ebfb5b4a2118b5424694e")
                      //           ],
                      //           educationalDetails: [
                      //             EducationalDetail(
                      //                 instituteName: institutename,
                      //                 educationalDetailClass: classname,
                      //                 id: "649ebfb5b4a2118b5424694e")
                      //           ],
                      //           tasks: [],
                      //           notes: [],
                      //           videoLecture: [],
                      //           students: [],
                      //           v: 91);
                      //       ///////String job = jobcontroller.text;

                      //       Teacher data = await submitdata(
                      //           teacherdata: teacherdata, id: id, context: context

                      //           ///////// createdOn: DateTime.now(),
                      //           ////////// updatedOn: DateTime.now());
                      //           );

                      //       await FirebaseFirestore.instance
                      //           .collection("users")
                      //           .doc(uid)
                      //           .update({
                      //         "filldetails": true,
                      //       });

                      //       setState(() {
                      //         teacherdata = data;
                      //       });

                      //       nextScreen(context, StudentScreen());
                      //     },
                      //     child: Text("Submit",  )),

                      // SizedBox(
                      //   width: 200,
                      //   child: ElevatedButton(
                      //     style: ElevatedButton.styleFrom(
                      //         primary: Color.fromRGBO(86, 103, 253, 1),
                      //         elevation: 0,
                      //         shape: RoundedRectangleBorder(
                      //             borderRadius: BorderRadius.circular(30))),
                      //     child: isloading
                      //         ? Container(
                      //             height: 20,
                      //             width: 20,
                      //             child: CircularProgressIndicator(
                      //                 color: Colors.white),
                      //           )
                      //         : Text(
                      //             "Submit",
                      //             style: TextStyle(
                      //                 color: Colors.white, fontSize: 16),
                      //           ),
                      //     onPressed: () async {
                      //       // for makeing optional image
                      //       if (formKey.currentState!.validate()) {
                      //         print(isuploaded);
                      //         if (isuploaded == false) {
                      //           avatarurl =
                      //               "https://firebasestorage.googleapis.com/v0/b/easyed-9df02.appspot.com/o/UserAvatarImages%2Faccount.png?alt=media&token=63577669-1e6e-4291-aca0-427354ef3b79";

                      //           setState(() {
                      //             isloading = true;
                      //           });

                      //           String id = uid;
                      //           // String id = uid;
                      //           String firstname = fullname;
                      //           // String firstname = firstnamecontroller.text;
                      //           String lastname = emailid.split('@')[0];
                      //           String email = emailid;
                      //           // String email = emailcontroller.text;
                      //           String mobile = mobilecontroller.text;
                      //           String institutename =
                      //               instituteNamecontroller.text;
                      //           String classname = classcontroller.text;

                      //           Teacher teacherdata = Teacher(
                      //             id: id,
                      //             commons: [
                      //               Common(
                      //                 createdOn: DateTime.parse(
                      //                     "2023-06-30T09:00:00.000Z"),
                      //                 updatedOn: DateTime.parse(
                      //                     "2023-06-30T09:00:00.000Z"),
                      //                 id: "649ebfb5b4a2118b5424694e",
                      //               )
                      //             ],
                      //             userDetails: [
                      //               UserDetail(
                      //                   firstName: firstname,
                      //                   lastName: lastname,
                      //                   email: email,
                      //                   mobile: mobile,
                      //                   avatar: avatarurl!,
                      //                   id: "649ebfb5b4a2118b5424694e")
                      //             ],
                      //             educationalDetails: [
                      //               EducationalDetail(
                      //                   instituteName: institutename,
                      //                   educationalDetailClass: classname,
                      //                   id: "649ebfb5b4a2118b5424694e")
                      //             ],
                      //             tasks: [],
                      //             notes: [],
                      //             videoLecture: [],
                      //             // students: [],
                      //             v: 0,
                      //             sharedlectures: [],
                      //             sharednotes: [],
                      //             sharedtasks: [],
                      //           );
                      //           ///////String job = jobcontroller.text;

                      //           Teacher data = await submitdata(
                      //               teacherdata: teacherdata,
                      //               id: id,
                      //               context: context

                      //               ///////// createdOn: DateTime.now(),
                      //               ////////// updatedOn: DateTime.now());
                      //               );

                      //           await FirebaseFirestore.instance
                      //               .collection("users")
                      //               .doc(uid)
                      //               .update({
                      //             "filldetails": true,
                      //           });

                      //           setState(() {
                      //             teacherdata = data;
                      //           });

                      //           setState(() {
                      //             isloading = false;
                      //           });

                      //           PersistentNavBarNavigator.pushNewScreen(
                      //             context,
                      //             screen: StudentScreen(),
                      //             withNavBar:
                      //                 true, // OPTIONAL VALUE. True by default.
                      //             pageTransitionAnimation:
                      //                 PageTransitionAnimation.cupertino,
                      //           );

                      //           // nextScreen(context, StudentScreen());
                      //           // final snackBar = SnackBar(
                      //           //   backgroundColor: Colors.red,
                      //           //   duration: Duration(seconds: 1),
                      //           //   dismissDirection: DismissDirection.horizontal,
                      //           //   content: const Text(
                      //           //     'Please upload the Profile Picture.',
                      //           //     style: TextStyle(),
                      //           //   ),
                      //           // );
                      //           // ScaffoldMessenger.of(context)
                      //           //     .hideCurrentSnackBar();

                      //           // ScaffoldMessenger.of(context)
                      //           //     .showSnackBar(snackBar);
                      //         } else {
                      //           setState(() {
                      //             isloading = true;
                      //           });
                      //           await uploadavatar();

                      //           globalsplitusername = emailid.split('@')[0];

                      //           String id = globalsplitusername!;
                      //           String firstname = fullname;
                      //           // String firstname = firstnamecontroller.text;
                      //           String lastname = emailid.split('@')[0];
                      //           String email = emailid;
                      //           // String email = emailcontroller.text;
                      //           String mobile = mobilecontroller.text;
                      //           String institutename =
                      //               instituteNamecontroller.text;
                      //           String classname = classcontroller.text;

                      //           Teacher teacherdata = Teacher(
                      //             id: id,
                      //             commons: [
                      //               Common(
                      //                 createdOn: DateTime.parse(
                      //                     "2023-06-30T09:00:00.000Z"),
                      //                 updatedOn: DateTime.parse(
                      //                     "2023-06-30T09:00:00.000Z"),
                      //                 id: "649ebfb5b4a2118b5424694e",
                      //               )
                      //             ],
                      //             userDetails: [
                      //               UserDetail(
                      //                   firstName: firstname,
                      //                   lastName: lastname,
                      //                   email: email,
                      //                   mobile: mobile,
                      //                   avatar: avatarurl!,
                      //                   id: "649ebfb5b4a2118b5424694e")
                      //             ],
                      //             educationalDetails: [
                      //               EducationalDetail(
                      //                   instituteName: institutename,
                      //                   educationalDetailClass: classname,
                      //                   id: "649ebfb5b4a2118b5424694e")
                      //             ],
                      //             tasks: [],
                      //             notes: [],
                      //             videoLecture: [],
                      //             // students: [],
                      //             v: 91,
                      //             sharedlectures: [],
                      //             sharednotes: [],
                      //             sharedtasks: [],
                      //           );
                      //           ///////String job = jobcontroller.text;

                      //           Teacher data = await submitdata(
                      //               teacherdata: teacherdata,
                      //               id: id,
                      //               context: context

                      //               ///////// createdOn: DateTime.now(),
                      //               ////////// updatedOn: DateTime.now());
                      //               );

                      //           await FirebaseFirestore.instance
                      //               .collection("users")
                      //               .doc(uid)
                      //               .update({
                      //             "filldetails": true,
                      //           });

                      //           setState(() {
                      //             teacherdata = data;
                      //           });

                      //           setState(() {
                      //             isloading = false;
                      //           });

                      //           PersistentNavBarNavigator.pushNewScreen(
                      //             context,
                      //             screen: StudentScreen(),
                      //             withNavBar:
                      //                 true, // OPTIONAL VALUE. True by default.
                      //             pageTransitionAnimation:
                      //                 PageTransitionAnimation.cupertino,
                      //           );

                      //           // nextScreen(context, StudentScreen());
                      //         }
                      //       }
                      //     },
                      //   ),
                      // ),
                    ],
                  ),
                ));
              }),
        ),
      ),
    );
  }
}
