import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';
import 'package:easyed/Pages/dashboardscreen.dart';

import 'package:easyed/Pages/notificationscreen.dart';
import 'package:easyed/Pages/postsScreen.dart';
import 'package:easyed/Pages/showpostscreen.dart';
import 'package:easyed/Pages/showprofilescreen.dart';

import 'package:easyed/Pages/studentscreen.dart';

class BottomNavigationwidget extends StatefulWidget {
  const BottomNavigationwidget({super.key});

  @override
  State<BottomNavigationwidget> createState() => _BottomNavigationwidgetState();
}

class _BottomNavigationwidgetState extends State<BottomNavigationwidget> {
  PersistentTabController _controller =
      PersistentTabController(initialIndex: 0);

//Screens for each nav items.
  List<Widget> _NavScreens() {
    return [
      //  Page3(),
      ShowPostScreen(),
      // Page1(),
      Dashboard(),
      // NOtificationScreen(),

      // Page4(),
      ShowProfileScreen(),
    ];
  }

  List<PersistentBottomNavBarItem> _navBarsItems() {
    return [
      PersistentBottomNavBarItem(
        icon: ImageIcon(AssetImage("assets/socialnetwork.png")),
        // title: ("Help"),
        activeColorPrimary: Color.fromRGBO(255, 255, 255, 1),
        inactiveColorPrimary: Colors.black,
      ),

      // PersistentBottomNavBarItem(
      //   icon: ImageIcon(AssetImage("assets/home.png")),
      //   // title: ("Home"),
      //   activeColorPrimary: Color.fromRGBO(255, 255, 255, 1),
      //   inactiveColorPrimary: Colors.black,
      // ),
      PersistentBottomNavBarItem(
        icon: ImageIcon(AssetImage("assets/home.png")),
        // title: ("Home"),
        activeColorPrimary: Color.fromRGBO(255, 255, 255, 1),
        inactiveColorPrimary: Colors.black,
      ),
      // PersistentBottomNavBarItem(
      //   icon: ImageIcon(AssetImage("assets/bell.png")),
      //   // title: ("OFFERS"),
      //   activeColorPrimary: Color.fromRGBO(255, 255, 255, 1),
      //   inactiveColorPrimary: Colors.black,
      // ),

      PersistentBottomNavBarItem(
        icon: ImageIcon(AssetImage("assets/user.png")),
        // title: ("ProfileScreen"),
        activeColorPrimary: Color.fromRGBO(255, 255, 255, 1),
        inactiveColorPrimary: Colors.black,
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    double deviceheight = MediaQuery.of(context).size.height;
    // double appbarheight = 45;

    double devicewidth = MediaQuery.of(context).size.width;
    return Center(
      child: PersistentTabView(
        navBarHeight: deviceheight * 0.08,
        context,
        controller: _controller,
        screens: _NavScreens(),
        items: _navBarsItems(),
        confineInSafeArea: true,
        backgroundColor: Color.fromRGBO(38, 90, 232, 1),
        handleAndroidBackButtonPress: true,
        resizeToAvoidBottomInset: true,
        hideNavigationBarWhenKeyboardShows: true,
        decoration: NavBarDecoration(
          borderRadius: BorderRadius.circular(10.0),
        ),
        popAllScreensOnTapOfSelectedTab: true,
        navBarStyle: NavBarStyle.style3,
      ),
    );
  }
}
