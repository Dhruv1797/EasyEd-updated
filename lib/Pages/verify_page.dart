import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:easyed/auth/login_page.dart';
// import 'package:easyed/homescreen.dart';
import 'package:easyed/service/auth_service.dart';
import 'package:easyed/widgets/widgets.dart';
import 'package:easyed/Pages/test2screen.dart';

class Verifypage extends StatefulWidget {
  const Verifypage({super.key});

  @override
  State<Verifypage> createState() => _VerifypageState();
}

class _VerifypageState extends State<Verifypage> {
  bool isEmailVerified = false;
  Timer? timer;
  Timer? timer2;
  Timer? timer3;
  bool? canResendEmail = false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    isEmailVerified = FirebaseAuth.instance.currentUser!.emailVerified;

    if (!isEmailVerified) {
      sendVerificationEmail();
    }

    timer3 = Timer(Duration(seconds: 30), () {
      setState(() {
        canResendEmail = true;
      });
    });

    timer = Timer.periodic(Duration(seconds: 5), (_) => checkEmailVerified());
  }

  @override
  void dispose() {
    timer?.cancel();
    timer2?.cancel();
    timer3?.cancel();
    // TODO: implement dispose
    super.dispose();
  }

  Future checkEmailVerified() async {
    await FirebaseAuth.instance.currentUser!.reload();

    setState(() {
      isEmailVerified = FirebaseAuth.instance.currentUser!.emailVerified;
    });

    if (isEmailVerified) timer?.cancel();
  }

  Future sendVerificationEmail() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      await user?.sendEmailVerification();

      // setState(() {
      //   canResendEmail = false;
      // });
    } catch (e) {
      showSnackbar(context, Colors.red, "Please try again later.");
      // TODO
    }
  }

  @override
  Widget build(BuildContext context) {
    double deviceheight = MediaQuery.of(context).size.height;

    double devicewidth = MediaQuery.of(context).size.width;
    AuthService authService = AuthService();
    return isEmailVerified
        ? test2screen()
        : Scaffold(
            appBar: AppBar(
              title: Text(
                "Email Verification",
                style: TextStyle(fontWeight: FontWeight.w800),
              ),
            ),
            body: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Column(
                  // mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(50.0),
                      child: Container(
                        height: 150,
                        width: 150,
                        child: Image.asset("assets/email.png"),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: SizedBox(
                        width: devicewidth * 0.8,
                        child: Text(
                          "Verify your email address",
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.w700),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                    SizedBox(
                      width: devicewidth * 0.86,
                      child: Text(
                        "We have just send email verification link on your email. Please check and click on that to verify your Email address.",
                        style: TextStyle(
                          color: Colors.black54,
                          fontSize: 15,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 30.0),
                      child: TextButton(
                        onPressed: canResendEmail!
                            ? () {
                                // setState(() {
                                //   print(canResendEmail);
                                // });

                                setState(() {
                                  canResendEmail = false;
                                });

                                sendVerificationEmail();
                                timer2 = Timer(Duration(seconds: 30), () {
                                  setState(() {
                                    canResendEmail = true;
                                  });
                                });
                              }
                            : null,
                        child: Text(
                          "Resend E-mail Link",
                          style: TextStyle(
                              color:
                                  canResendEmail! ? Colors.blue : Colors.grey,
                              fontSize: 20,
                              fontWeight: FontWeight.w700),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 20.0),
                      child: TextButton(
                        onPressed: () async {
                          await authService.signOut();
                          Navigator.of(context).pushAndRemoveUntil(
                              MaterialPageRoute(
                                  builder: (context) => const LoginPage()),
                              (route) => false);
                        },
                        child: Text(
                          "<- Back to login",
                          style: TextStyle(
                              color: Colors.blue,
                              fontSize: 20,
                              fontWeight: FontWeight.w700),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                    // ElevatedButton(
                    //   onPressed: canResendEmail!
                    //       ? () {
                    //           // setState(() {
                    //           //   print(canResendEmail);
                    //           // });
                    //           sendVerificationEmail();
                    //         }
                    //       : null,

                    //   // : () {
                    //   //     sendVerificationEmail();
                    //   //   },
                    //   child: Text("Resent Email "),
                    // ),
                    // ElevatedButton(
                    //     onPressed: () async {
                    //       await authService.signOut();
                    //       Navigator.of(context).pushAndRemoveUntil(
                    //           MaterialPageRoute(
                    //               builder: (context) => const LoginPage()),
                    //           (route) => false);
                    //     },
                    //     child: Text("Cancel"))
                  ],
                ),
              ],
            ),
          );
  }
}
