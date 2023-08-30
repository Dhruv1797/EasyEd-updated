import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:easyed/Pages/studentscreen.dart';
import 'package:easyed/Pages/test2screen.dart';

import 'package:easyed/helper/helper_function.dart';
import 'package:easyed/auth/register_page.dart';
import 'package:easyed/main.dart';
// import 'package:easyed/navbarscreen.dart';
import 'package:easyed/service/auth_service.dart';
import 'package:easyed/service/database_service.dart';
import 'package:easyed/widgets/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

class LoginPage extends StatefulWidget {
  static const routeName = '/loginpage';
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool isloading = false;
  FocusNode focusNodeemail = FocusNode();
  FocusNode focusNodepassword = FocusNode();
  final formKey = GlobalKey<FormState>();
  String email = "";
  String password = "";
  bool _isLoading = false;
  AuthService authService = AuthService();
  bool _isSignedIn = false;
  @override
  void initState() {
    super.initState();
    getgroupRank;
    getUserLoggedInStatus();
  }

  getgroupRank(
    int rank,
    var data,
    String? uid,
  ) {
    for (int i = 0; i < data.length; i++) {
      if ("${uid}" == data[i].reference.id) {
        rank = i + 1;
      }
    }

    return rank;

    // if (rank == data.length) {
    //   return -1;
    // } else {
    //   return rank;
    // }
  }

  getUserLoggedInStatus() async {
    await HelperFunctions.getUserLoggedInStatus().then((value) {
      if (value != null) {
        setState(() {
          _isSignedIn = value;
        });
      }
    });
  }

  Widget build(BuildContext context) {
    double deviceheight = MediaQuery.of(context).size.height;
    double appbarheight = 45;

    double devicewidth = MediaQuery.of(context).size.width;
    final String? uid =
        _isSignedIn ? FirebaseAuth.instance.currentUser!.uid : "";
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        body: _isLoading
            ? Center(
                child: CircularProgressIndicator(
                    color: Theme.of(context).primaryColor),
              )
            : SingleChildScrollView(
                child: StreamBuilder(
                    stream: FirebaseFirestore.instance
                        .collection('users')
                        .snapshots(),
                    builder: (BuildContext context, AsyncSnapshot snapshot) {
                      if (snapshot.data == null)
                        return Container(
                          height: 400,
                          width: 400,
                          child: Center(
                              child: CircularProgressIndicator(
                                  color: Color.fromRGBO(38, 90, 232, 1))),
                        );

                      var data = snapshot.data!.docs;
                      int rank = 0;

                      int grouprank = getgroupRank(rank, data, uid) - 1;

                      bool isshow = grouprank == -1
                          ? false
                          : snapshot.data.docs[grouprank].data()['filldetails'];

                      return Form(
                          key: formKey,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  SizedBox(
                                    height: 86.h,
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      SizedBox(
                                        width: 58.w,
                                      ),
                                      Text(
                                        " Welcome Back to ",
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          fontSize: 24.sp,
                                          fontWeight: FontWeight.w700,
                                          fontFamily: "Montserrat",
                                          color:
                                              Color.fromRGBO(86, 103, 253, 1),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      SizedBox(
                                        width: 130.w,
                                      ),
                                      Text(
                                        "Easy",
                                        style: TextStyle(
                                          fontSize: 24.sp,
                                          fontWeight: FontWeight.w700,
                                          fontFamily: "Montserrat",
                                          color: Color.fromRGBO(2, 2, 2, 1),
                                        ),
                                      ),
                                      Text(
                                        "Ed",
                                        style: TextStyle(
                                          fontSize: 24.sp,
                                          fontWeight: FontWeight.w700,
                                          fontFamily: "Montserrat",
                                          color:
                                              Color.fromRGBO(86, 103, 253, 1),
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 14.h,
                                  ),
                                  Row(
                                    children: [
                                      SizedBox(
                                        width: 55.w,
                                      ),
                                      Text(
                                        " Sign in to continue",
                                        style: TextStyle(
                                          fontSize: 24.sp,
                                          fontWeight: FontWeight.w600,
                                          fontFamily: "Montserrat",
                                          color:
                                              Color.fromRGBO(148, 185, 174, 1),
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 68.h,
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(left: 23.0.w),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "Email address",
                                          style: TextStyle(
                                            fontSize: 15.sp,
                                            fontWeight: FontWeight.w600,
                                            fontFamily: "Montserrat",
                                            color:
                                                Color.fromRGBO(99, 109, 119, 1),
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
                                            borderRadius:
                                                BorderRadius.circular(7.45),
                                            boxShadow: [
                                              BoxShadow(
                                                color: Color.fromRGBO(
                                                    182, 214, 204, 1),
                                                spreadRadius: 2,
                                                blurRadius: 6.r,
                                                offset: Offset(0, 6),
                                              ),
                                            ],
                                            border: Border.all(
                                              width: 1.0, // 1px border width
                                              color: Color.fromRGBO(182, 214,
                                                  204, 1), // Border color
                                            ),
                                          ),
                                          child: TextFormField(
                                            focusNode: focusNodeemail,
                                            style: TextStyle(
                                              fontSize: 14.sp,
                                              fontWeight: FontWeight.w200,
                                              fontFamily: "Montserrat",
                                              color:
                                                  Color.fromRGBO(54, 67, 86, 1),
                                            ),
                                            decoration: InputDecoration(
                                              contentPadding:
                                                  EdgeInsets.all(10.0),
                                              border: InputBorder.none,
                                              hintStyle: TextStyle(
                                                fontSize: 14.sp,
                                                fontWeight: FontWeight.w200,
                                                fontFamily: "Montserrat",
                                                color: Color.fromRGBO(
                                                    54, 67, 86, 1),
                                              ),
                                              hintText: 'abc123@example.com',
                                            ),
                                            onChanged: (val) {
                                              setState(() {
                                                email = val;
                                              });
                                            },

                                            // check tha validation
                                            validator: (val) {
                                              return RegExp(
                                                          r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@gmail\.com$")
                                                      .hasMatch(val!)
                                                  ? null
                                                  : "Please enter a valid Gmail address only.";
                                            },
                                          ),
                                        ),
                                        SizedBox(
                                          height: 18.54,
                                        ),
                                        Text(
                                          "Password",
                                          style: TextStyle(
                                            fontSize: 15.sp,
                                            fontWeight: FontWeight.w600,
                                            fontFamily: "Montserrat",
                                            color:
                                                Color.fromRGBO(99, 109, 119, 1),
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
                                            borderRadius:
                                                BorderRadius.circular(7.45),
                                            boxShadow: [
                                              BoxShadow(
                                                color: Color.fromRGBO(
                                                    182, 214, 204, 1),
                                                spreadRadius: 2,
                                                blurRadius: 6.r,
                                                offset: Offset(0, 6),
                                              ),
                                            ],
                                            border: Border.all(
                                              width: 1.0, // 1px border width
                                              color: Color.fromRGBO(182, 214,
                                                  204, 1), // Border color
                                            ),
                                          ),
                                          child: TextFormField(
                                            obscureText: true,
                                            focusNode: focusNodepassword,
                                            style: TextStyle(
                                              fontSize: 14.sp,
                                              fontWeight: FontWeight.w200,
                                              fontFamily: "Montserrat",
                                              color:
                                                  Color.fromRGBO(54, 67, 86, 1),
                                            ),
                                            decoration: InputDecoration(
                                              contentPadding:
                                                  EdgeInsets.all(10.0),
                                              border: InputBorder.none,
                                              hintStyle: TextStyle(
                                                fontSize: 14.sp,
                                                fontWeight: FontWeight.w200,
                                                fontFamily: "Montserrat",
                                                color: Color.fromRGBO(
                                                    54, 67, 86, 1),
                                              ),
                                              hintText: '***********',
                                            ),
                                            validator: (val) {
                                              if (val!.length < 6) {
                                                return "Password must be at least 6 characters";
                                              } else {
                                                return null;
                                              }
                                            },
                                            onChanged: (val) {
                                              setState(() {
                                                password = val;
                                              });
                                            },
                                          ),
                                        ),
                                        SizedBox(
                                          height: 46.85,
                                        ),
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(left: 47.0.w),
                                    child: GestureDetector(
                                      onTap: () async {
                                        setState(() {
                                          isloading = true;
                                        });
                                        await login(snapshot);
                                        setState(() {
                                          isloading = false;
                                        });
                                      },
                                      child: Container(
                                        height: 61.h,
                                        width: 267.w,
                                        decoration: BoxDecoration(
                                          color:
                                              Color.fromRGBO(86, 103, 253, 1),
                                          borderRadius:
                                              BorderRadius.circular(12.r),
                                        ),
                                        child: Center(
                                          child: Text(
                                            "Sign in",
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
                                  SizedBox(
                                    height: 43.h,
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(left: 65.0.w),
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Text(
                                          "Don't have account? ",
                                          style: TextStyle(
                                            fontSize: 16.sp,
                                            fontWeight: FontWeight.w400,
                                            fontFamily: "Montserrat",
                                            color:
                                                Color.fromRGBO(99, 109, 119, 1),
                                          ),
                                        ),
                                        GestureDetector(
                                          onTap: () {
                                            nextScreen(
                                                context, const RegisterPage());
                                            // nextScreen(context, LoginPage());
                                          },
                                          child: Text(
                                            "Sign up",
                                            style: TextStyle(
                                              fontSize: 16.sp,
                                              fontWeight: FontWeight.w400,
                                              fontFamily: "Montserrat",
                                              color: Color.fromRGBO(
                                                  86, 103, 253, 1),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),

                              // const Text(
                              //   "Groupie",
                              //   style: TextStyle(
                              //       fontSize: 40, fontWeight: FontWeight.bold),
                              // ),
                              // const SizedBox(height: 10),
                              // const Text("Login now to see what they are talking!",
                              //     style: TextStyle(
                              //         fontSize: 15, fontWeight: FontWeight.w400)),
                              // SizedBox(
                              //   height: 400,
                              //   width: 500,
                              //   child: SvgPicture.asset("assets/exam.svg"),
                              // ),

                              // Container(
                              //   width: devicewidth,
                              //   height: deviceheight * 0.30,
                              //   decoration: ShapeDecoration(
                              //     color: Color.fromRGBO(86, 103, 253, 1),
                              //     shape: RoundedRectangleBorder(
                              //       borderRadius: BorderRadius.circular(42),
                              //     ),
                              //     shadows: [
                              //       BoxShadow(
                              //         color: Color(0x3F000000),
                              //         blurRadius: 4,
                              //         offset: Offset(0, 4),
                              //         spreadRadius: 0,
                              //       )
                              //     ],
                              //   ),
                              //   child: Center(
                              //     child: Column(
                              //       mainAxisAlignment: MainAxisAlignment.center,
                              //       children: [
                              //         Text(
                              //           textAlign: TextAlign.center,
                              //           "Welcome Back to\n EasyED",
                              //           style: TextStyle(
                              //               color: Colors.white,
                              //               fontSize: 24,
                              //               fontWeight: FontWeight.w700),
                              //         ),
                              //         Text(
                              //           "Sign in to continue",
                              //           style: TextStyle(
                              //               color: Colors.white,
                              //               fontSize: 24,
                              //               fontWeight: FontWeight.w400),
                              //         )
                              //       ],
                              //     ),
                              //   ),
                              // ),

                              // SizedBox(
                              //   height: 300,
                              //   width: 500,
                              //   child: SvgPicture.asset("assets/exam.svg"),
                              // ),

                              // Padding(
                              //   padding: const EdgeInsets.only(
                              //       left: 30.0, right: 30.0, bottom: 30.0),
                              //   child: Column(
                              //     children: [
                              //       TextFormField(
                              //         focusNode: focusNodeemail,
                              //         decoration: InputDecoration(
                              //             focusedBorder: OutlineInputBorder(
                              //               borderSide: BorderSide(
                              //                 color: Color.fromRGBO(86, 103, 253, 1),
                              //               ),
                              //             ),
                              //             enabledBorder: OutlineInputBorder(
                              //               borderSide: BorderSide(
                              //                 width: 3,
                              //                 color: Color.fromRGBO(86, 103, 253, 1),
                              //               ), //<-- SEE HERE
                              //             ),
                              //             labelText: "Email",
                              //             prefixIcon: Icon(
                              //               Icons.email,
                              //               color: Colors.black,
                              //             )),
                              //         onChanged: (val) {
                              //           setState(() {
                              //             email = val;
                              //           });
                              //         },

                              //         // check tha validation
                              //         validator: (val) {
                              //           return RegExp(
                              //                       r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                              //                   .hasMatch(val!)
                              //               ? null
                              //               : "Please enter a valid email";
                              //         },
                              //       ),
                              //       const SizedBox(height: 15),
                              //       TextFormField(
                              //         focusNode: focusNodepassword,
                              //         obscureText: true,
                              //         decoration: InputDecoration(
                              //             focusedBorder: OutlineInputBorder(
                              //               borderSide: BorderSide(
                              //                 color: Color.fromRGBO(86, 103, 253, 1),
                              //               ),
                              //             ),
                              //             enabledBorder: OutlineInputBorder(
                              //               borderSide: BorderSide(
                              //                 width: 3,
                              //                 color: Color.fromRGBO(86, 103, 253, 1),
                              //               ), //<-- SEE HERE
                              //             ),
                              //             labelText: "Password",
                              //             prefixIcon: Icon(
                              //               Icons.lock,
                              //               color: Colors.black,
                              //             )),
                              //         validator: (val) {
                              //           if (val!.length < 6) {
                              //             return "Password must be at least 6 characters";
                              //           } else {
                              //             return null;
                              //           }
                              //         },
                              //         onChanged: (val) {
                              //           setState(() {
                              //             password = val;
                              //           });
                              //         },
                              //       ),
                              //     ],
                              //   ),
                              // ),

                              // const SizedBox(
                              //   height: 20,
                              // ),
                              // SizedBox(
                              //   width: 270,
                              //   child: ElevatedButton(
                              //     style: ElevatedButton.styleFrom(
                              //         primary: Color.fromRGBO(86, 103, 253, 1),
                              //         elevation: 0,
                              //         shape: RoundedRectangleBorder(
                              //             borderRadius:
                              //                 BorderRadius.circular(30))),
                              //     child: isloading
                              //         ? Container(
                              //             height: 20,
                              //             width: 20,
                              //             child: CircularProgressIndicator(
                              //                 color: Colors.white),
                              //           )
                              //         : Text(
                              //             "Sign In",
                              //             style: TextStyle(
                              //                 color: Colors.white,
                              //                 fontSize: 16),
                              //           ),
                              //     onPressed: () async {
                              //       setState(() {
                              //         isloading = true;
                              //       });
                              //       await login(snapshot);
                              //       setState(() {
                              //         isloading = false;
                              //       });
                              //     },
                              //   ),
                              // ),
                              // const SizedBox(
                              //   height: 10,
                              // ),
                              // Text.rich(TextSpan(
                              //   text: "Don't have an account? ",
                              //   style: const TextStyle(
                              //       color: Colors.black, fontSize: 14),
                              //   children: <TextSpan>[
                              //     TextSpan(
                              //         text: "Register here",
                              //         style: const TextStyle(
                              //           color: Color.fromRGBO(86, 103, 253, 1),
                              //           // decoration: TextDecoration.underline,
                              //         ),
                              //         recognizer: TapGestureRecognizer()
                              //           ..onTap = () {
                              //             nextScreen(
                              //                 context, const RegisterPage());
                              //           }),
                              //   ],
                              // )),
                            ],
                          ));
                    }),
              ),
      ),
    );
  }

  Future login(AsyncSnapshot snapshots) async {
    if (formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });
      await authService
          .loginWithUserNameandPassword(email, password)
          .then((value) async {
        if (value == true) {
          QuerySnapshot snapshot =
              await DatabaseService(uid: FirebaseAuth.instance.currentUser!.uid)
                  .gettingUserData(email);
          // saving the values to our shared preferences
          await HelperFunctions.saveUserLoggedInStatus(true);
          await HelperFunctions.saveUserEmailSF(email);
          await HelperFunctions.saveUserNameSF(snapshot.docs[0]['fullName']);

          _isSignedIn = true;

          print(" login _isSignedIn ${_isSignedIn} ");

          final String? uid = _isSignedIn
              ? await FirebaseAuth.instance.currentUser!.uid
              : "not get";

          print("login  ${uid}");

          var data = snapshots.data!.docs;
          int rank = 0;

          int grouprank = await getgroupRank(rank, data, uid) - 1;

          print("login grouprank  ${grouprank}");
          Timer(Duration(seconds: 5), () {});

          bool isshow = grouprank == -1
              ? false
              : await snapshots.data.docs[grouprank].data()['filldetails'];

          print("login isshow ${isshow}");

          Timer(Duration(seconds: 5), () {});

          isshow
              ? nextScreenReplace(context, StudentScreen())
              : nextScreenReplace(context, test2screen());
        } else {
          showSnackbar(context, Colors.red, "Invalid Login Credentials");
          setState(() {
            _isLoading = false;
          });
        }
      });
    }
  }
}
