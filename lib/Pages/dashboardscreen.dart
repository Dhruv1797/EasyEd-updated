import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:page_view_dot_indicator/page_view_dot_indicator.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';
import 'package:easyed/Pages/LecturePage.dart';
import 'package:easyed/Pages/chapterscreen.dart';
import 'package:easyed/Pages/globalvariables.dart';
import 'package:easyed/Pages/lecturesscreen.dart';
import 'package:easyed/Pages/notesscreen.dart';
import 'package:easyed/Pages/pdfPage.dart';
import 'package:easyed/Pages/pdfviewerpage.dart';
import 'package:easyed/Pages/showtaskpage.dart';
import 'package:easyed/Pages/taskscreen.dart';
import 'package:easyed/models/Teacher.dart';
import 'package:easyed/pdf_api.dart';
import 'package:easyed/widgets/drawer.dart';
import 'package:easyed/widgets/widgets.dart';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

class Dashboard extends StatefulWidget {
  static const routeName = '/dashboard';
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  final uid = FirebaseAuth.instance.currentUser!.uid;
  List<Teacher> teacherslist = [];

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
  List<Gamelist> gameimageurls = [
    Gamelist("assets/1.png"),
    Gamelist("assets/2.png"),
    // Gamelist("assets/3.png"),
    // Gamelist("assets/game.png"),
    // Gamelist("assets/game.png"),
  ];

  late int selectedPage;
  late final PageController _pageController;
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  void handleClick(String value) {
    switch (value) {
      case 'Option 1':
        break;
      case 'Option 2':
        break;
    }
  }

  @override
  void initState() {
    selectedPage = 0;
    _pageController = PageController(initialPage: selectedPage);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final pageCount = gameimageurls.length;
    double deviceheight = MediaQuery.of(context).size.height;
    double appbarheight = 45;

    double devicewidth = MediaQuery.of(context).size.width;
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        key: _scaffoldKey,
        drawer: MyDrawer(),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                height: 90 - appbarheight,
              ),
              Container(
                width: devicewidth,
                child: Row(
                  children: [
                    SizedBox(
                      width: 29,
                    ),
                    GestureDetector(
                      onTap: () {
                        _scaffoldKey.currentState!.openDrawer();
                      },
                      child: Container(
                        height: 20,
                        width: 30,
                        child: Image.asset("assets/iconmenu.png"),
                      ),
                    ),
                    SizedBox(
                      width: devicewidth * 0.7,
                    ),
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
              Container(
                // height: deviceheight * 0.15,
                width: devicewidth * 0.95,
                decoration: BoxDecoration(
                  color: Color.fromRGBO(255, 255, 255, 1),
                  // border: Border.all(),
                  borderRadius: BorderRadius.all(Radius.circular(1)),
                  boxShadow: [
                    BoxShadow(
                      color: Color.fromRGBO(0, 0, 0, 0.25),
                      blurRadius: 1.0,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                child: FutureBuilder(
                    future: getTeacherdata(),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        return Column(
                          children: [
                            SizedBox(
                              height: 90.h,
                            ),

                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                SizedBox(
                                  width: 125.w,
                                ),
                                Text(
                                  "Lib",
                                  style: TextStyle(
                                    fontSize: 24.sp,
                                    fontWeight: FontWeight.w700,
                                    fontFamily: "Montserrat",
                                    color: Color.fromRGBO(0, 0, 0, 1),
                                  ),
                                ),
                                Text(
                                  "rary",
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
                              height: 34.h,
                            ),

                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    PersistentNavBarNavigator
                                        .pushNewScreenWithRouteSettings(
                                      settings: RouteSettings(
                                          name: NotesScreen.routeName),
                                      context,
                                      screen: NotesScreen(),
                                      withNavBar: true,
                                      pageTransitionAnimation:
                                          PageTransitionAnimation.cupertino,
                                    );
                                  },
                                  child: Container(
                                    width: 108.2,
                                    height: 108.2,
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      border: Border.all(
                                        width: 1.0, // 1px border width
                                        color: Color.fromRGBO(
                                            182, 214, 204, 1), // Border color
                                      ),
                                      borderRadius:
                                          BorderRadius.circular(11.1.r),
                                      boxShadow: [
                                        BoxShadow(
                                          color:
                                              Color.fromRGBO(182, 214, 204, 1),
                                          offset: Offset(4, 7), // x=4, y=7
                                          blurRadius: 7, // Blur radius
                                        ),
                                      ],
                                    ),

                                    child: Center(
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Container(
                                            height: 34.2.h,
                                            width: 27.w,
                                            child: SvgPicture.asset(
                                                "assets/notesicon.svg"),
                                          ),
                                          SizedBox(
                                            height: 9.8.h,
                                          ),
                                          Text(
                                            "Notes",
                                            style: TextStyle(
                                              fontSize: 15.sp,
                                              fontWeight: FontWeight.w600,
                                              fontFamily: "Montserrat",
                                              color: Color.fromRGBO(
                                                  99, 109, 119, 1),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    // Add child content if needed
                                  ),
                                ),
                                SizedBox(
                                  width: 24.42.w,
                                ),
                                GestureDetector(
                                  onTap: () {
                                    PersistentNavBarNavigator.pushNewScreen(
                                      context,
                                      screen: LecturesScreen(),
                                      withNavBar:
                                          true, // OPTIONAL VALUE. True by default.
                                      pageTransitionAnimation:
                                          PageTransitionAnimation.cupertino,
                                    );
                                  },
                                  child: Container(
                                    width: 108.2,
                                    height: 108.2,
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      border: Border.all(
                                        width: 1.0, // 1px border width
                                        color: Color.fromRGBO(
                                            182, 214, 204, 1), // Border color
                                      ),
                                      borderRadius:
                                          BorderRadius.circular(11.1.r),
                                      boxShadow: [
                                        BoxShadow(
                                          color:
                                              Color.fromRGBO(182, 214, 204, 1),
                                          offset: Offset(4, 7), // x=4, y=7
                                          blurRadius: 7, // Blur radius
                                        ),
                                      ],
                                    ),

                                    child: Center(
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Container(
                                            height: 34.h,
                                            width: 34.w,
                                            child: SvgPicture.asset(
                                                "assets/lectureicon.svg"),
                                          ),
                                          SizedBox(
                                            height: 9.8.h,
                                          ),
                                          Text(
                                            "Lectures",
                                            style: TextStyle(
                                              fontSize: 15.sp,
                                              fontWeight: FontWeight.w600,
                                              fontFamily: "Montserrat",
                                              color: Color.fromRGBO(
                                                  99, 109, 119, 1),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    // Add child content if needed
                                  ),
                                ),
                              ],
                            ),

                            SizedBox(
                              height: 24.42.h,
                            ),
                            GestureDetector(
                              onTap: () {
                                PersistentNavBarNavigator.pushNewScreen(
                                  context,
                                  // screen: QuizPage(),
                                  screen: ShowTaskPage(),
                                  withNavBar: true,
                                  pageTransitionAnimation:
                                      PageTransitionAnimation.cupertino,
                                );
                              },
                              child: Container(
                                width: 108.2,
                                height: 108.2,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  border: Border.all(
                                    width: 1.0, // 1px border width
                                    color: Color.fromRGBO(
                                        182, 214, 204, 1), // Border color
                                  ),
                                  borderRadius: BorderRadius.circular(11.1.r),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Color.fromRGBO(182, 214, 204, 1),
                                      offset: Offset(4, 7), // x=4, y=7
                                      blurRadius: 7, // Blur radius
                                    ),
                                  ],
                                ),

                                child: Center(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Container(
                                        height: 25.h,
                                        width: 28.93.w,
                                        child: SvgPicture.asset(
                                            "assets/taskicon.svg"),
                                      ),
                                      SizedBox(
                                        height: 9.8.h,
                                      ),
                                      Text(
                                        "Tasks",
                                        style: TextStyle(
                                          fontSize: 15.sp,
                                          fontWeight: FontWeight.w600,
                                          fontFamily: "Montserrat",
                                          color:
                                              Color.fromRGBO(99, 109, 119, 1),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                // Add child content if needed
                              ),
                            ),

                            SvgPicture.asset("assets/homescene.svg"),

                            // Row(
                            //   mainAxisAlignment: MainAxisAlignment.start,
                            //   children: [
                            //     SizedBox(
                            //       width: 22,
                            //     ),
                            //     Column(
                            //       mainAxisAlignment: MainAxisAlignment.center,
                            //       crossAxisAlignment: CrossAxisAlignment.start,
                            //       children: [
                            //         Container(
                            //           width: devicewidth * 0.6,
                            //           // color: Colors.red,
                            //           child: Text(
                            //             "Namaste," +
                            //                 globalteacherdata
                            //                     .userDetails[0].firstName +
                            //                 "!",
                            //             maxLines: 2,
                            //             style: TextStyle(
                            //                 color:
                            //                     Color.fromRGBO(11, 18, 31, 1),
                            //                 fontWeight: FontWeight.w500,
                            //                 fontSize: 26),
                            //           ),
                            //         ),
                            //         Text(
                            //           "What do you wanna learn today?",
                            //           style: TextStyle(
                            //               color:
                            //                   Color.fromRGBO(112, 116, 126, 1),
                            //               fontWeight: FontWeight.w400,
                            //               fontSize: 12),
                            //         ),
                            //       ],
                            //     ),
                            //     SizedBox(
                            //       width: 50,
                            //     ),
                            //     CircleAvatar(
                            //       radius: 23,
                            //       backgroundImage: NetworkImage(
                            //           globalteacherdata.userDetails[0].avatar),
                            //     )
                            //   ],
                            // ),
                            // SizedBox(
                            //   height: 35,
                            // ),
                            // Container(
                            //   height: 46,
                            //   width: 292,
                            //   child: TextField(
                            //     style: TextStyle(
                            //         color: Color.fromRGBO(255, 255, 255, 1),
                            //         fontSize: 12,
                            //         fontWeight: FontWeight.w400),
                            //     decoration: InputDecoration(
                            //         suffixIconColor: Color.fromRGBO(255, 255, 255, 1),
                            //         suffixIcon: ImageIcon(
                            //             AssetImage("assets/searchicon.png"),
                            //             size: 15),
                            //         border: OutlineInputBorder(
                            //           borderRadius: BorderRadius.circular(10.0),
                            //         ),
                            //         filled: true,
                            //         hintStyle: TextStyle(
                            //             color: Color.fromRGBO(255, 255, 255, 1),
                            //             fontSize: 12,
                            //             fontWeight: FontWeight.w400),
                            //         hintText: "search here",
                            //         fillColor: Color.fromRGBO(38, 90, 232, 1)),
                            //   ),
                            // )
                          ],
                        );
                      } else {
                        return Center(
                          child: CircularProgressIndicator(),
                        );
                      }
                    }),
              ),
              // Column(
              //   children: [
              //     Padding(
              //       padding: const EdgeInsets.only(top: 40.0),
              //       child: Container(
              //         // color: Colors.red,
              //         height: deviceheight * 0.22,
              //         width: devicewidth,
              //         // color: Colors.red,
              //         child: PageView.builder(
              //           allowImplicitScrolling: true, pageSnapping: true,
              //           // dragStartBehavior: DragStartBehavior.start,
              //           scrollBehavior: ScrollBehavior(
              //               androidOverscrollIndicator:
              //                   AndroidOverscrollIndicator.glow),

              //           controller: _pageController,
              //           itemBuilder: buildlistitem,

              //           itemCount: gameimageurls.length,
              //           onPageChanged: (page) {
              //             setState(() {
              //               selectedPage = page;
              //             });
              //           },
              //           // children: List.generate(pageCount, (index) {
              //           //   return Container(
              //           //     child: Center(
              //           //       child: Text('Page $index'),
              //           //     ),
              //           //   );
              //           // }),
              //         ),
              //       ),
              //     ),
              //     Padding(
              //       padding: const EdgeInsets.all(24),
              //       child: PageViewDotIndicator(
              //         currentItem: selectedPage,
              //         count: pageCount,
              //         unselectedColor: Colors.black26,
              //         selectedColor: Colors.black,
              //         duration: Duration(milliseconds: 200),
              //         boxShape: BoxShape.circle,
              //       ),
              //     ),
              //     SizedBox(
              //       height: 2,
              //     ),
              //   ],
              // ),
              // Padding(
              //   padding: const EdgeInsets.only(top: 8.0),
              //   child: Center(
              //     child: Text(
              //       textAlign: TextAlign.center,
              //       "Embrace the thrill of\n learning.",
              //       style: TextStyle(fontSize: 28, fontWeight: FontWeight.w700),
              //     ),
              //   ),
              // ),
              // Padding(
              //   padding: const EdgeInsets.only(top: 30.0),
              //   child: Container(
              //     // color: Colors.red,
              //     child: Row(
              //       mainAxisAlignment: MainAxisAlignment.center,
              //       children: [
              //         GestureDetector(
              //           onTap: () {
              //             PersistentNavBarNavigator
              //                 .pushNewScreenWithRouteSettings(
              //               settings:
              //                   RouteSettings(name: NotesScreen.routeName),
              //               context,
              //               screen: NotesScreen(),
              //               withNavBar: true,
              //               pageTransitionAnimation:
              //                   PageTransitionAnimation.cupertino,
              //             );
              //           },
              //           child: Padding(
              //             padding: const EdgeInsets.all(8.0),
              //             child: Container(
              //               height: 60,
              //               width: 67,
              //               decoration: BoxDecoration(
              //                 borderRadius: BorderRadius.circular(10),
              //                 color: Color.fromRGBO(86, 103, 253, 1),
              //               ),
              //               child:
              //                   Center(child: Image.asset("assets/notes.png")),
              //             ),
              //           ),
              //         ),
              //         GestureDetector(
              //           onTap: () {
              //             PersistentNavBarNavigator.pushNewScreen(
              //               context,
              //               // screen: QuizPage(),
              //               screen: ShowTaskPage(),
              //               withNavBar: true,
              //               pageTransitionAnimation:
              //                   PageTransitionAnimation.cupertino,
              //             );
              //           },
              //           child: Padding(
              //             padding: const EdgeInsets.all(8.0),
              //             child: Container(
              //               height: 60,
              //               width: 67,
              //               decoration: BoxDecoration(
              //                 borderRadius: BorderRadius.circular(10),
              //                 color: Color.fromRGBO(86, 103, 253, 1),
              //               ),
              //               child:
              //                   Center(child: Image.asset("assets/task.png")),
              //             ),
              //           ),
              //         ),
              //         GestureDetector(
              //           onTap: () {
              //             PersistentNavBarNavigator.pushNewScreen(
              //               context,
              //               screen: LecturesScreen(),
              //               withNavBar:
              //                   true, // OPTIONAL VALUE. True by default.
              //               pageTransitionAnimation:
              //                   PageTransitionAnimation.cupertino,
              //             );

              //             // nextScreen(context, LecturesScreen());
              //           },
              //           child: Padding(
              //             padding: const EdgeInsets.all(8.0),
              //             child: Container(
              //               height: 60,
              //               width: 67,
              //               decoration: BoxDecoration(
              //                 borderRadius: BorderRadius.circular(10),
              //                 color: Color.fromRGBO(86, 103, 253, 1),
              //               ),
              //               child: Center(
              //                   child: Container(
              //                       height: 35,
              //                       width: 35,
              //                       child: Image.asset("assets/lectures.png"))),
              //             ),
              //           ),
              //         ),
              //         // GestureDetector(
              //         //   onTap: () async {
              //         //     final url =
              //         //         'https://cdn.filestackcontent.com/7w7wb68oSvGPstbLvtSB';
              //         //     final file = await PDFApi.loadNetwork(url);

              //         //     openPDF(context, file);
              //         //   },
              //         //   child: Padding(
              //         //     padding: const EdgeInsets.all(8.0),
              //         //     child: Container(
              //         //       height: 50,
              //         //       width: 80,
              //         //       color: Colors.red,
              //         //       child: Center(child: Text("pdf download")),
              //         //     ),
              //         //   ),
              //         // ),
              //       ],
              //     ),
              //   ),
              // ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildlistitem(BuildContext context, int index) {
    Gamelist gamewidget = gameimageurls[index];
    // return SizedBox(
    //   width: MediaQuery.of(context).size.width - 20,
    //   height: 300,
    //   child: Container(
    //     // key: itemKey,
    //     // color: Colors.red,
    //     height: 30,
    //     width: MediaQuery.of(context).size.width - 20,
    //     child: Column(
    //       children: [
    //         // Container(
    //         //   height: 2,
    //         //   width: 108,
    //         //   color: Colors.black,
    //         // ),
    //         Container(
    //           height: 30,
    //         ),
    //         Row(
    //           children: [
    //             // Container(
    //             //   height: 52,
    //             //   width: 7,
    //             //   color: Colors.black,
    //             // ),
    //             Container(
    //               height: 10,
    //               width: 22,
    //             ),
    //             Container(
    //               // color: Colors.red,
    //               width: MediaQuery.of(context).size.width - 80,
    //               height: 40,
    //               child: FittedBox(
    //                 fit: BoxFit.fitWidth,
    //                 child: Text(
    //                   textwidget.imageurl,
    //                   style: TextStyle(
    //                     color: Color.fromRGBO(136, 75, 197, 3),
    //                     fontSize: 24,
    //                     fontWeight: FontWeight.w500,
    //                   ),
    //                 ),
    //               ),
    //             ),
    //           ],
    //         ),
    //         Container(
    //           height: 20,
    //         ),
    //         // Row(
    //         //   children: [
    //         //     SizedBox(
    //         //       width: 25,
    //         //     ),
    //         //     Container(
    //         //       height: 2,
    //         //       width: 108,
    //         //       color: Colors.black,
    //         //     ),
    //         //   ],
    //         // ),
    //       ],
    //     ),
    //   ),
    // );

    // return Container(
    //   height: 50,
    //   color: Colors.yellow,
    //   width: 50,
    // );

    return Column(
      children: [
        Container(
          height: 178,
          width: globaldevicewidth,
          child: Transform.scale(
            scale: index == selectedPage ? 1 : 0.9,
            child: Card(
              elevation: 6,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Image.asset(
                  gamewidget.imageurl,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
        ),
      ],
    );
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

  Future<Teacher> getTeacherdata() async {
    final String uemailid = FirebaseAuth.instance.currentUser!.email!;
    String? splituserid;

    splituserid = uemailid.split('@')[0];
    final response = await http.get(
        Uri.parse('https://api.easyeduverse.tech/api/user/${splituserid}'));
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
}

class Gamelist {
  final String imageurl;

  Gamelist(this.imageurl);
}
