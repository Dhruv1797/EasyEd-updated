import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';
import 'package:easyed/Pages/lecturesscreen.dart';
import 'package:easyed/Pages/notesscreen.dart';
import 'package:easyed/widgets/drawer.dart';

class Contentscreen extends StatefulWidget {
  const Contentscreen({super.key});

  @override
  State<Contentscreen> createState() => _ContentscreenState();
}

class _ContentscreenState extends State<Contentscreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  List<ContentBoxlist> subjectBoxlist = [
    ContentBoxlist(
      "assets/Rectangle 130.png",
      "NOTES",
    ),
    ContentBoxlist(
      "assets/Rectangle 132.png",
      "Lectures",
    ),
  ];

  void handleClick(String value) {
    switch (value) {
      case 'Option 1':
        break;
      case 'Option 2':
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    double deviceheight = MediaQuery.of(context).size.height;
    double appbarheight = 45;

    double devicewidth = MediaQuery.of(context).size.width;

    return Scaffold(
      key: _scaffoldKey,
      drawer: MyDrawer(),
      body: SafeArea(
        child: SingleChildScrollView(
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
                        _scaffoldKey.currentState?.openDrawer();
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
                height: 150,
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
                child: Column(
                  children: [
                    SizedBox(
                      height: 23,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(6.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Circle",
                                style: TextStyle(
                                    color: Color.fromRGBO(11, 18, 31, 1),
                                    fontWeight: FontWeight.w500,
                                    fontSize: 26),
                              ),
                              Text(
                                "Rituraj Sharma",
                                style: TextStyle(
                                    color: Color.fromRGBO(112, 116, 126, 1),
                                    fontWeight: FontWeight.w400,
                                    fontSize: 12),
                              ),
                            ],
                          ),
                        ),
                        // SizedBox(
                        //   width: devicewidth * 0.4,
                        // ),
                        CircleAvatar(
                          radius: 46,
                          backgroundImage:
                              AssetImage("assets/Rectangle 129.png"),
                        )
                      ],
                    ),
                    SizedBox(
                      height: 35,
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Container(
                height: deviceheight * 0.5,
                width: devicewidth * 0.78,
                child: ListView.builder(
                  itemBuilder: (context, index) {
                    return buildlistitem(context, index);
                  },
                  itemCount: subjectBoxlist.length,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget buildlistitem(BuildContext context, int index) {
    double deviceheight = MediaQuery.of(context).size.height;

    double devicewidth = MediaQuery.of(context).size.width;
    ContentBoxlist subjectwidget = subjectBoxlist[index];
    return GestureDetector(
      onTap: () {
        print(index);
        if (index == 0) {
          PersistentNavBarNavigator.pushNewScreen(
            context,
            screen: NotesScreen(),
            withNavBar: true,
            pageTransitionAnimation: PageTransitionAnimation.cupertino,
          );
        }

        if (index == 1) {
          PersistentNavBarNavigator.pushNewScreen(
            context,
            screen: LecturesScreen(),
            withNavBar: true,
            pageTransitionAnimation: PageTransitionAnimation.cupertino,
          );
        }
      },
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          decoration: BoxDecoration(
            color: Color.fromRGBO(255, 255, 255, 1),
            borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(10),
                bottomRight: Radius.circular(10)),
            boxShadow: [
              BoxShadow(
                color: Color.fromRGBO(0, 0, 0, 0.25),
                blurRadius: 1.0,
                offset: Offset(0, 2),
              ),
            ],
          ),
          height: deviceheight * 0.21,
          width: devicewidth * 0.73,
          child: Column(
            children: [
              Container(
                height: 120,
                width: devicewidth * 0.73,
                child: Image.asset(
                  subjectwidget.imageurl,
                  fit: BoxFit.cover,
                ),
              ),
              SizedBox(
                height: 6,
              ),
              SizedBox(
                width: 12,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      subjectwidget.contentname,
                      style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w400,
                          color: Color.fromRGBO(38, 50, 56, 1)),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ContentBoxlist {
  final String contentname;
  final String imageurl;

  ContentBoxlist(
    this.imageurl,
    this.contentname,
  );
}
