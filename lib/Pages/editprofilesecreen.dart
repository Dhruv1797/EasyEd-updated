import 'package:flutter/material.dart';

import 'package:easyed/widgets/drawer.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    double deviceheight = MediaQuery.of(context).size.height;
    double appbarheight = 45;

    double devicewidth = MediaQuery.of(context).size.width;

    return Scaffold(
      resizeToAvoidBottomInset: true,
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
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Container(
                        height: 20,
                        width: 30,
                        child: Image.asset("assets/backarrow.png"),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 30.0),
                      child: Text(
                        "Edit profile",
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.w600),
                      ),
                    ),
                    SizedBox(
                      width: 40,
                    ),
                    GestureDetector(
                      onTap: () {
                        _scaffoldKey.currentState?.openDrawer();
                      },
                      child: Container(
                        height: 40,
                        width: 60,
                        child: TextButton(
                          child: Text(
                            "Done",
                            style: TextStyle(fontSize: 12),
                          ),
                          onPressed: () {},
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 1,
                    )
                  ],
                ),
              ),
              Container(
                height: 180,
                width: devicewidth * 0.95,
                decoration: BoxDecoration(
                  color: Color.fromRGBO(255, 255, 255, 1),
                  // border: Border.all(),
                  borderRadius: BorderRadius.all(Radius.circular(1)),
                ),
                child: Column(
                  children: [
                    SizedBox(
                      height: 23,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        CircleAvatar(
                          radius: 56,
                          backgroundImage: AssetImage("assets/Ellipse321.png"),
                        )
                      ],
                    ),
                    Container(
                      height: 45,
                      child: Text(
                        "We recommend an image of \n          at least 800x800px.",
                        style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w400,
                            color: Color.fromRGBO(119, 126, 144, 1)),
                      ),
                    )
                  ],
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Container(
                height: deviceheight * 0.55,
                width: devicewidth * 0.95,
                // color: Colors.red,
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      CustomTextfield(
                          devicewidth: devicewidth,
                          fieldname: "Full Name",
                          hinttext: "Ayano Nana"),
                      CustomTextfield(
                          devicewidth: devicewidth,
                          fieldname: "Email",
                          hinttext: "ayanonana@gmail.com"),
                      CustomTextfield(
                          devicewidth: devicewidth,
                          fieldname: "Password",
                          hinttext: "ayano123321"),
                      CustomTextfield(
                          devicewidth: devicewidth,
                          fieldname: "Mobile",
                          hinttext: "78454565565"),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class CustomTextfield extends StatelessWidget {
  final String? fieldname;
  final String? hinttext;
  const CustomTextfield({
    super.key,
    required this.devicewidth,
    this.fieldname,
    this.hinttext,
  });

  final double devicewidth;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
      child: Container(
        height: 80,
        child: Row(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 30.0, right: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 12),
                    child: Text(
                      fieldname!,
                      style: TextStyle(
                          color: Color.fromRGBO(53, 57, 69, 1),
                          fontSize: 12,
                          fontWeight: FontWeight.w700),
                    ),
                  ),
                  Container(
                    height: 51,
                    width: devicewidth * 0.8,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border:
                          Border.all(color: Color.fromRGBO(175, 179, 193, 1)),
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(60),
                          topRight: Radius.circular(60),
                          bottomLeft: Radius.circular(60),
                          bottomRight: Radius.circular(60)),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(
                          top: 8, left: 18.0, right: 16.0),
                      child: TextField(
                        style: TextStyle(
                            color: Color.fromRGBO(175, 179, 193, 1),
                            fontSize: 16,
                            fontWeight: FontWeight.w400),
                        decoration: InputDecoration.collapsed(
                            filled: true,
                            hintStyle: TextStyle(
                                color: Color.fromRGBO(175, 179, 193, 1),
                                fontSize: 16,
                                fontWeight: FontWeight.w400),
                            hintText: hinttext!,
                            fillColor: Colors.white70),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
