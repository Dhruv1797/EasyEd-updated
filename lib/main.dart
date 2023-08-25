import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:easyed/Pages/verify_page.dart';
import 'package:flutter/material.dart';
import 'package:easyed/Pages/addVideoScreen.dart';
import 'package:easyed/Pages/addpdfscreen.dart';
import 'package:easyed/Pages/addpostscreen.dart';
import 'package:easyed/Pages/dashboardscreen.dart';
import 'package:easyed/Pages/lecturesscreen.dart';
import 'package:easyed/Pages/notesscreen.dart';
import 'package:easyed/Pages/pdfPage.dart';
import 'package:easyed/Pages/postsScreen.dart';
import 'package:easyed/Pages/quizpage.dart';
import 'package:easyed/Pages/showpostscreen.dart';
import 'package:easyed/Pages/showprofilescreen.dart';
import 'package:easyed/Pages/showquestions.dart';
import 'package:easyed/Pages/showtaskpage.dart';
import 'package:easyed/Pages/signin.dart';

import 'package:easyed/Pages/studentscreen.dart';
import 'package:easyed/Pages/taskpostscreen.dart';
import 'package:easyed/Pages/taskscreen.dart';
import 'package:easyed/Pages/test1screen.dart';
import 'package:easyed/Pages/test2screen.dart';
import 'package:easyed/Pages/testpage.dart';
import 'package:easyed/Pages/testscreen.dart';
import 'package:easyed/auth/login_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:easyed/auth/register_page.dart';
import 'package:easyed/helper/helper_function.dart';
import 'dart:io';
import 'package:flutter_screenutil/flutter_screenutil.dart';
// class MyHttpOverrides extends HttpOverrides {
//   @override
//   HttpClient createHttpClient(SecurityContext? context) {
//     return super.createHttpClient(context)
//       ..badCertificateCallback =
//           (X509Certificate cert, String host, int port) => true;
//   }
// }

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  // HttpOverrides.global = MyHttpOverrides();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
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
    final String? uid =
        _isSignedIn ? FirebaseAuth.instance.currentUser!.uid : "";
    // print(FirebaseAuth.instance.currentUser!.uid);
    return StreamBuilder(
        stream: FirebaseFirestore.instance.collection('users').snapshots(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.data == null)
            return Center(child: CircularProgressIndicator());
          var data = snapshot.data!.docs;
          int rank = 0;

          int grouprank = getgroupRank(rank, data, uid) - 1;

          bool isshow = grouprank == -1
              ? false
              : snapshot.data.docs[grouprank].data()['filldetails'];

          return ScreenUtilInit(
              designSize: const Size(360, 800),
              builder: (context, child) {
                return MaterialApp(
                  debugShowCheckedModeBanner: false,
                  theme: ThemeData(
                    colorScheme:
                        ColorScheme.fromSeed(seedColor: Colors.deepPurple),
                    useMaterial3: true,
                  ),
                  // home: ShowPostScreen(),
                  // home: LoginPage(),
                  home: AnimatedSplashScreen(
                    splash: Image.asset('assets/easyedblack.png'),
                    splashIconSize: 200,
                    splashTransition: SplashTransition.fadeTransition,
                    backgroundColor: Colors.white,
                    duration: 500,
                    nextScreen: _isSignedIn
                        ? isshow
                            ? StudentScreen()
                            : Verifypage()
                        : LoginPage(),
                  ),

                  routes: {
                    LoginPage.routeName: (ctx) => LoginPage(),
                    RegisterPage.routeName: (ctx) => RegisterPage(),
                    Dashboard.routeName: (ctx) => Dashboard(),
                    test2screen.routeName: (ctx) => test2screen(),
                    ShowPostScreen.routeName: (ctx) => ShowPostScreen(),
                    AddPostScreen.routeName: (ctx) => AddPostScreen(),
                    NotesScreen.routeName: (ctx) => NotesScreen(),
                    LecturesScreen.routeName: (ctx) => LecturesScreen(),
                    ShowTaskPage.routeName: (ctx) => ShowTaskPage(),
                    AddPdfScreen.routeName: (ctx) => AddPdfScreen(),
                    AddVideoScreen.routeName: (ctx) => AddVideoScreen(),
                  },
                );
              });
        });
  }
}
