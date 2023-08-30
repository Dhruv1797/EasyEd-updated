import 'package:easyed/Pages/sharednotesscreen.dart';
import 'package:easyed/Pages/sharedtasks.dart';
import 'package:easyed/Pages/sharedvideolectures.dart';
import 'package:easyed/models/Teacher.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';
import 'package:easyed/Pages/dashboardscreen.dart';
import 'package:easyed/Pages/editprofilesecreen.dart';
import 'package:easyed/Pages/globalvariables.dart';
import 'package:easyed/Pages/notificationscreen.dart';
import 'package:easyed/Pages/postsScreen.dart';
import 'package:easyed/Pages/showpostscreen.dart';
import 'package:easyed/Pages/showprofilescreen.dart';
import 'package:easyed/auth/login_page.dart';
import 'package:easyed/auth/register_page.dart';
import 'package:easyed/service/auth_service.dart';
import 'package:easyed/widgets/widgets.dart';

class MyDrawer extends StatefulWidget {
  @override
  State<MyDrawer> createState() => _MyDrawerState();
}

class _MyDrawerState extends State<MyDrawer> {
  @override
  Widget build(BuildContext context) {
    AuthService authService = AuthService();
    return Drawer(
      child: Container(
        color: Color.fromRGBO(86, 103, 253, 1),
        child: ListView(
          children: [
            SizedBox(
              height: 60,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    SizedBox(
                      width: 30,
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.of(context).pop();
                        // _scaffoldKey.currentState?.openDrawer();
                      },
                      child: Container(
                        height: 20,
                        width: 30,
                        child: Image.asset(
                          "assets/iconmenu.png",
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 10,
                ),
                Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Container(
                        height: 59,
                        width: 59,
                        // color: Colors.red,
                        child: CircleAvatar(
                          backgroundImage: NetworkImage(
                              globalteacherdata.userDetails[0].avatar),
                        ),
                      ),
                    ),
                    Container(
                      width: 160,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            globalteacherdata.userDetails[0].firstName,
                            style: TextStyle(
                                color: Color.fromRGBO(255, 255, 255, 1),
                                fontSize: 20,
                                fontWeight: FontWeight.w700),
                          ),
                          Text(
                            "@" + globalteacherdata.userDetails[0].lastName,
                            style: TextStyle(
                                color: Color.fromRGBO(255, 255, 255, 1),
                                fontSize: 15,
                                fontWeight: FontWeight.w400),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(28.0),
              child: Container(
                height: 1,
                width: 400,
                color: Color.fromRGBO(255, 255, 255, 1),
              ),
            ),
            ListTile(
              onTap: () {
                PersistentNavBarNavigator.pushNewScreen(
                  context,
                  screen: ShowProfileScreen(),
                  withNavBar: true, // OPTIONAL VALUE. True by default.
                  pageTransitionAnimation: PageTransitionAnimation.cupertino,
                );
              },
              leading: ImageIcon(AssetImage("assets/user.png")),
              iconColor: Colors.white,
              title: Text(
                "Profile Details",
                style: TextStyle(
                    color: Color.fromRGBO(255, 255, 255, 1),
                    fontSize: 15,
                    fontWeight: FontWeight.w600),
              ),
            ),
            ListTile(
              onTap: () {
                PersistentNavBarNavigator.pushNewScreen(
                  context,
                  screen: Dashboard(),
                  withNavBar: true, // OPTIONAL VALUE. True by default.
                  pageTransitionAnimation: PageTransitionAnimation.cupertino,
                );
              },
              leading: ImageIcon(AssetImage("assets/home.png")),
              iconColor: Colors.white,
              title: Text(
                "Dashboard",
                style: TextStyle(
                    color: Color.fromRGBO(255, 255, 255, 1),
                    fontSize: 15,
                    fontWeight: FontWeight.w600),
              ),
            ),
            // ListTile(
            //   onTap: () {
            //     PersistentNavBarNavigator.pushNewScreen(
            //       context,
            //       screen: NOtificationScreen(),
            //       withNavBar: true, // OPTIONAL VALUE. True by default.
            //       pageTransitionAnimation: PageTransitionAnimation.cupertino,
            //     );
            //   },
            //   leading: ImageIcon(AssetImage("assets/bell.png")),
            //   iconColor: Colors.white,
            //   title: Text(
            //     "Notifications",
            //     style: TextStyle(
            //         color: Color.fromRGBO(255, 255, 255, 1),
            //         fontSize: 15,
            //         fontWeight: FontWeight.w600),
            //   ),
            // ),
            ListTile(
              onTap: () {
                PersistentNavBarNavigator.pushNewScreen(
                  context,
                  screen: ShowPostScreen(),
                  withNavBar: true, // OPTIONAL VALUE. True by default.
                  pageTransitionAnimation: PageTransitionAnimation.cupertino,
                );
              },
              leading: ImageIcon(AssetImage("assets/socialnetwork.png")),
              iconColor: Colors.white,
              title: Text(
                "Network",
                style: TextStyle(
                    color: Color.fromRGBO(255, 255, 255, 1),
                    fontSize: 15,
                    fontWeight: FontWeight.w600),
              ),
            ),
            ListTile(
              onTap: () {
                PersistentNavBarNavigator.pushNewScreen(
                  context,
                  screen: SharedNotesScreen(),
                  withNavBar: true, // OPTIONAL VALUE. True by default.
                  pageTransitionAnimation: PageTransitionAnimation.cupertino,
                );
              },
              leading: ImageIcon(AssetImage("assets/socialnetwork.png")),
              iconColor: Colors.white,
              title: Text(
                "Shared notes",
                style: TextStyle(
                    color: Color.fromRGBO(255, 255, 255, 1),
                    fontSize: 15,
                    fontWeight: FontWeight.w600),
              ),
            ),
            ListTile(
              onTap: () {
                PersistentNavBarNavigator.pushNewScreen(
                  context,
                  screen: SharedLecturesvideos(),
                  withNavBar: true, // OPTIONAL VALUE. True by default.
                  pageTransitionAnimation: PageTransitionAnimation.cupertino,
                );
              },
              leading: ImageIcon(AssetImage("assets/socialnetwork.png")),
              iconColor: Colors.white,
              title: Text(
                "Shared videos",
                style: TextStyle(
                    color: Color.fromRGBO(255, 255, 255, 1),
                    fontSize: 15,
                    fontWeight: FontWeight.w600),
              ),
            ),
            ListTile(
              onTap: () {
                PersistentNavBarNavigator.pushNewScreen(
                  context,
                  screen: SharedTaskPage(),
                  withNavBar: true, // OPTIONAL VALUE. True by default.
                  pageTransitionAnimation: PageTransitionAnimation.cupertino,
                );
              },
              leading: ImageIcon(AssetImage("assets/socialnetwork.png")),
              iconColor: Colors.white,
              title: Text(
                "Shared Tasks",
                style: TextStyle(
                    color: Color.fromRGBO(255, 255, 255, 1),
                    fontSize: 15,
                    fontWeight: FontWeight.w600),
              ),
            ),
            // ListTile(
            //   onTap: () {},
            //   leading: Icon(CupertinoIcons.share, color: Colors.white),
            //   title: Text(
            //     "Share the app",
            //     style: TextStyle(
            //         color: Color.fromRGBO(255, 255, 255, 1),
            //         fontSize: 15,
            //         fontWeight: FontWeight.w600),
            //   ),
            // ),
            // ListTile(
            //   onTap: () {},
            //   leading: Icon(CupertinoIcons.mail_solid, color: Colors.white),
            //   title: Text(
            //     "Contact us",
            //     style: TextStyle(
            //         color: Color.fromRGBO(255, 255, 255, 1),
            //         fontSize: 15,
            //         fontWeight: FontWeight.w600),
            //   ),
            // ),
            // ListTile(
            //   onTap: () {},
            //   leading: Icon(CupertinoIcons.settings_solid, color: Colors.white),
            //   title: Text(
            //     "Language",
            //     style: TextStyle(
            //         color: Color.fromRGBO(255, 255, 255, 1),
            //         fontSize: 15,
            //         fontWeight: FontWeight.w600),
            //   ),
            // ),
            // ListTile(
            //   onTap: () {
            //     nextScreen(context, PostsScreen());
            //   },
            //   leading:
            //       Icon(CupertinoIcons.photo_camera_solid, color: Colors.white),
            //   title: Text(
            //     "Posts Screen",
            //     style: TextStyle(
            //         color: Color.fromRGBO(255, 255, 255, 1),
            //         fontSize: 15,
            //         fontWeight: FontWeight.w600),
            //   ),
            // ),
            ListTile(
              onTap: () async {
                showDialog(
                    barrierDismissible: false,
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: const Text("Logout"),
                        content: const Text("Are you sure you want to logout?"),
                        actions: [
                          IconButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            icon: const Icon(
                              Icons.cancel,
                              color: Colors.red,
                            ),
                          ),
                          IconButton(
                            onPressed: () async {
                              await authService.signOut();
                              Navigator.of(context).pushAndRemoveUntil(
                                  MaterialPageRoute(
                                      builder: (context) => const LoginPage()),
                                  (route) => false);
                            },
                            icon: const Icon(
                              Icons.done,
                              color: Colors.green,
                            ),
                          ),
                        ],
                      );
                    });
              },
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
              leading: Icon(Icons.exit_to_app, color: Colors.white),
              title: Text(
                "Log out",
                style: TextStyle(
                    color: Color.fromRGBO(255, 255, 255, 1),
                    fontSize: 15,
                    fontWeight: FontWeight.w600),
              ),
            )
          ],
        ),
      ),
    );
  }
}
