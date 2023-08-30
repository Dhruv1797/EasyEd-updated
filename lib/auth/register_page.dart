import 'package:easyed/Pages/verify_page.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:easyed/Pages/test2screen.dart';

import 'package:easyed/helper/helper_function.dart';
import 'package:easyed/auth/login_page.dart';
import 'package:easyed/main.dart';

import 'package:easyed/service/auth_service.dart';
import 'package:easyed/widgets/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class RegisterPage extends StatefulWidget {
  static const routeName = '/registerpage';
  const RegisterPage({Key? key}) : super(key: key);

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  bool _isLoading = false;
  final formKey = GlobalKey<FormState>();
  String email = "";
  String password = "";
  String fullName = "";
  AuthService authService = AuthService();
  @override
  Widget build(BuildContext context) {
    double deviceheight = MediaQuery.of(context).size.height;
    double appbarheight = 45;

    double devicewidth = MediaQuery.of(context).size.width;
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        body: _isLoading
            ? Center(
                child: CircularProgressIndicator(
                    color: Color.fromRGBO(38, 90, 232, 1)))
            : SingleChildScrollView(
                child: Form(
                  key: formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      // const Text(
                      //   "MoveEasy",
                      //   style: TextStyle(
                      //       fontSize: 40, fontWeight: FontWeight.bold),
                      // ),
                      // const SizedBox(height: 10),
                      // const Text(
                      //     "Create your account now to chat and explore",
                      //     style: TextStyle(
                      //         fontSize: 15, fontWeight: FontWeight.w400)),
                      // SizedBox(
                      //     height: 400,
                      //     width: 500,
                      //     child: Image.asset(
                      //       "assets/Rectangle 129.png",
                      //       fit: BoxFit.cover,
                      //     )),

                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          SizedBox(
                            height: 86.h,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
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
                                  color: Color.fromRGBO(86, 103, 253, 1),
                                ),
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
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
                                  color: Color.fromRGBO(86, 103, 253, 1),
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
                                width: 40.w,
                              ),
                              Text(
                                "  Register to continue",
                                style: TextStyle(
                                  fontSize: 24.sp,
                                  fontWeight: FontWeight.w600,
                                  fontFamily: "Montserrat",
                                  color: Color.fromRGBO(148, 185, 174, 1),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 54.h,
                          ),
                          Padding(
                            padding: EdgeInsets.only(left: 23.0.w),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Full Name",
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
                                      hintText: '@example Rohan Singh',
                                    ),
                                    onChanged: (val) {
                                      setState(() {
                                        fullName = val;
                                      });
                                    },
                                    validator: (val) {
                                      if (val!.isNotEmpty) {
                                        return null;
                                      } else {
                                        return "Name cannot be empty";
                                      }
                                    },
                                  ),
                                ),
                                SizedBox(
                                  height: 18.54,
                                ),
                                Text(
                                  "Email address",
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
                                    obscureText: true,
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
                                register();
                                // setState(() {
                                //   isloading = true;
                                // });
                                // await login(snapshot);
                                // setState(() {
                                //   isloading = false;
                                // });
                              },
                              child: Container(
                                height: 61.h,
                                width: 267.w,
                                decoration: BoxDecoration(
                                  color: Color.fromRGBO(86, 103, 253, 1),
                                  borderRadius: BorderRadius.circular(12.r),
                                ),
                                child: Center(
                                  child: Text(
                                    "Sign up",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        fontSize: 20.sp,
                                        fontWeight: FontWeight.w600,
                                        fontFamily: "Exo",
                                        color:
                                            Color.fromRGBO(255, 255, 255, 1)),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 43.h,
                          ),
                          Padding(
                            padding: EdgeInsets.only(left: 74.0.w),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text(
                                  "You have account? ",
                                  style: TextStyle(
                                    fontSize: 16.sp,
                                    fontWeight: FontWeight.w400,
                                    fontFamily: "Montserrat",
                                    color: Color.fromRGBO(99, 109, 119, 1),
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    nextScreen(context, const LoginPage());
                                    // nextScreen(context, LoginPage());
                                  },
                                  child: Text(
                                    "Sign in",
                                    style: TextStyle(
                                      fontSize: 16.sp,
                                      fontWeight: FontWeight.w400,
                                      fontFamily: "Montserrat",
                                      color: Color.fromRGBO(86, 103, 253, 1),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),

                      // Container(
                      //   width: devicewidth,
                      //   height: deviceheight * 0.23,
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
                      //           "Sign up to continue",
                      //           style: TextStyle(
                      //               color: Colors.white,
                      //               fontSize: 24,
                      //               fontWeight: FontWeight.w400),
                      //         )
                      //       ],
                      //     ),
                      //   ),
                      // ),
                      // Container(
                      //     height: 290,
                      //     child: Image.asset("assets/register.jpg")),
                      // Padding(
                      //   padding: const EdgeInsets.only(left: 22.0, right: 22.0),
                      //   child: Column(
                      //     children: [
                      //       TextFormField(
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
                      //             labelText: "Full Name",
                      //             prefixIcon: Icon(
                      //               Icons.person,
                      //               color: Colors.black,
                      //             )),
                      //         onChanged: (val) {
                      //           setState(() {
                      //             fullName = val;
                      //           });
                      //         },
                      //         validator: (val) {
                      //           if (val!.isNotEmpty) {
                      //             return null;
                      //           } else {
                      //             return "Name cannot be empty";
                      //           }
                      //         },
                      //       ),
                      //       const SizedBox(
                      //         height: 15,
                      //       ),
                      //       TextFormField(
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
                      //             borderRadius: BorderRadius.circular(30))),
                      //     child: const Text(
                      //       "Register",
                      //       style: TextStyle(color: Colors.white, fontSize: 16),
                      //     ),
                      //     onPressed: () {
                      //       register();
                      //     },
                      //   ),
                      // ),
                      // const SizedBox(
                      //   height: 10,
                      // ),
                      // Text.rich(TextSpan(
                      //   text: "Already have an account? ",
                      //   style:
                      //       const TextStyle(color: Colors.black, fontSize: 14),
                      //   children: <TextSpan>[
                      //     TextSpan(
                      //         text: "Login now",
                      //         style: const TextStyle(
                      //             color: Color.fromRGBO(86, 103, 253, 1),
                      //             decoration: TextDecoration.underline),
                      //         recognizer: TapGestureRecognizer()
                      //           ..onTap = () {
                      //             nextScreen(context, const LoginPage());
                      //           }),
                      //   ],
                      // )),
                    ],
                  ),
                ),
              ),
      ),
    );
  }

  register() async {
    if (formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });
      await authService
          .registerUserWithEmailandPassword(fullName, email, password)
          .then((value) async {
        if (value == true) {
          // saving the shared preference state
          await HelperFunctions.saveUserLoggedInStatus(true);
          await HelperFunctions.saveUserEmailSF(email);
          await HelperFunctions.saveUserNameSF(fullName);
          nextScreenReplace(context, Verifypage());
        } else {
          showSnackbar(context, Colors.red, value);
          setState(() {
            _isLoading = false;
          });
        }
      });
    }
  }
}
