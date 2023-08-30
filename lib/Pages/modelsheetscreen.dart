import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';
import 'package:easyed/Pages/globalvariables.dart';
import 'package:easyed/Pages/modelsheetkeyboard.dart';
import 'package:easyed/models/post.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';

class ModelSheetScreen extends StatefulWidget {
  final int index1;
  final String postingid;
  final int pagenumber;
  const ModelSheetScreen({
    Key? key,
    required this.index1,
    required this.postingid,
    required this.pagenumber,
  }) : super(key: key);

  @override
  State<ModelSheetScreen> createState() => _ModelSheetScreenState();
}

class _ModelSheetScreenState extends State<ModelSheetScreen> {
  int calculatedpageindex = 0;

  bool isloading = false;
  TextEditingController commentcontroller = TextEditingController();
  bool isKeyboardVisible = false;
  double sheetHeight = globaldeviceheight! * 0.68;
  // Initial height of the bottom sheet
  @override
  void initState() {
    super.initState();
    // Listen for keyboard visibility changes
    KeyboardVisibilityController().onChange.listen((bool visible) {
      setState(() {
        isKeyboardVisible = visible;
        // Adjust the bottom sheet height based on keyboard visibility
        if (visible) {
          // Calculate the height you want to set when the keyboard is open
          sheetHeight = MediaQuery.of(context).size.height *
              0.46; // Example: 60% of the screen height
          setState(() {});
        } else {
          // Reset the bottom sheet height when the keyboard is closed
          sheetHeight = globaldeviceheight! * 0.68;
          setState(() {}); // Initial height of the bottom sheet
        }
      });
    });
  }

  Future onReturn() async => setState(() => getpostdata());
  final uid = FirebaseAuth.instance.currentUser!.uid;

  List<Post> postlist = [];

  List<Comment> commentlist = [];

  Post postdata = Post(posts: [], currentPage: 0, totalPages: 0, totalCount: 0);

  @override
  Widget build(BuildContext context) {
    double deviceheight = MediaQuery.of(context).size.height;
    double appbarheight = 45;

    double devicewidth = MediaQuery.of(context).size.width;
    return WillPopScope(
      onWillPop: () async {
        Navigator.pop(context);

        return false;
      },
      child: Stack(
        alignment: AlignmentDirectional.topCenter,
        clipBehavior: Clip.none,
        children: [
          // Positioned(
          //   top: -15,
          //   child: Container(
          //     width: 60,
          //     height: 7,
          //     margin: const EdgeInsets.only(bottom: 20),
          //     decoration: BoxDecoration(
          //       borderRadius: BorderRadius.circular(5),
          //       color: Colors.white,
          //     ),
          //   ),
          // ),
          Container(
            height: sheetHeight,
            child: Column(children: [
              Container(
                // color: Colors.pink,
                height: 45.h,
                width: devicewidth,
                child: Center(
                  child: Text(
                    "Comments",
                    style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w900,
                        fontFamily: 'Poppins'),
                  ),
                ),
              ),
              Divider(),
              Expanded(
                child: StreamBuilder<Post>(
                    stream: getPostDataStream(),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        commentlist = commentlist = List<Comment>.from(
                          snapshot.data!.posts[widget.index1].comments.map(
                            (q) => Comment(
                                user: q.user,
                                comment: q.comment,
                                avatar: q.avatar,
                                id: q.id,
                                date: q.date),
                          ),
                        );

                        return Container(
                          // color: Colors.red,
                          height: deviceheight * 0.4,
                          child: ListView.builder(
                              itemCount: commentlist.length,
                              itemBuilder: (context, ind) {
                                return Column(
                                  children: [
                                    Card(
                                      elevation: 1,
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Row(
                                              children: [
                                                Container(
                                                  height: 35,
                                                  width: 35,
                                                  child: CircleAvatar(
                                                    backgroundImage:
                                                        NetworkImage(
                                                            commentlist[ind]
                                                                .avatar),
                                                  ),
                                                ),
                                                // SizedBox(
                                                //   width: 30,
                                                // ),
                                                // Text(snapshot.data![].comments[0]
                                                //     .comment),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 14.0),
                                                  child: Container(
                                                    width: devicewidth * 0.6,
                                                    // color: Colors.red,
                                                    child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Text(
                                                          "@" +
                                                              commentlist[ind]
                                                                  .user
                                                                  .toString(),
                                                          style: TextStyle(
                                                              fontFamily:
                                                                  'Poppins',
                                                              color:
                                                                  Colors.black,
                                                              fontSize: 9.sp,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w900),
                                                        ),
                                                        Text(
                                                          commentlist[ind]
                                                              .comment,
                                                          style: TextStyle(
                                                              color: Colors
                                                                  .black54,
                                                              fontFamily:
                                                                  'Poppins',
                                                              fontSize: 12.sp,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            //// working delete button///////////////////////////////

                                            // // Text(commentlist[ind].id),
                                            // globalteacherdata.userDetails[0]
                                            //             .lastName ==
                                            //         postdata
                                            //             .posts[widget.index1]
                                            //             .comments[ind]
                                            //             .user
                                            //     // uid ==
                                            //     //         postdata
                                            //     //             .posts[widget.index1]
                                            //     //             .comments[ind]
                                            //     //             .user
                                            //     ? TextButton(
                                            //         onPressed: () async {
                                            //           // String
                                            //           //     commentid =
                                            //           //     ;

                                            //           print(ind.toString() +
                                            //               "ind value from modelsheet");

                                            //           print(postdata
                                            //                   .posts[
                                            //                       widget.index1]
                                            //                   .comments[ind]
                                            //                   .id +
                                            //               "cOMMENT ID from sheet");
                                            //           await deletecommentpost(
                                            //               postid: postdata
                                            //                   .posts[
                                            //                       widget.index1]
                                            //                   .id,
                                            //               commentid: postdata
                                            //                   .posts[
                                            //                       widget.index1]
                                            //                   .comments[ind]
                                            //                   .id,
                                            //               userid: postdata
                                            //                   .posts[
                                            //                       widget.index1]
                                            //                   .comments[ind]
                                            //                   .user);

                                            //           setState(() {
                                            //             getpostdata();
                                            //           });

                                            //           // print(index);
                                            //         },
                                            //         child: Text(
                                            //           "delete",
                                            //           style: TextStyle(
                                            //               fontFamily: 'Poppins',
                                            //               color: Colors.red),
                                            //         ))
                                            //     : Container(),

                                            //// working delete button///////////////////////////////
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                );
                              }),
                        );
                      } else {
                        return Container(
                          width: devicewidth,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Container(
                                height: 40,
                                width: 40,
                                child: CircularProgressIndicator(
                                  color: Colors.blue,
                                ),
                              ),
                            ],
                          ),
                        );
                      }
                    }),
              ),

              // SignInButton(
              //   onTap: () {},
              //   iconPath: 'assets/logos/email.png',
              //   textLabel: 'Sign in with email',
              //   backgroundColor: Colors.white,
              //   elevation: 5.0,
              // ),
              // const SizedBox(
              //   height: 20,
              // ),
              // const Center(
              //   child: Text(
              //     'OR',
              //     style: TextStyle(fontSize: 18),
              //   ),
              // ),
              // const SizedBox(
              //   height: 30,
              // ),
              // SignInButton(
              //   onTap: () {},
              //   iconPath: 'assets/logos/google.png',
              //   textLabel: 'Sign in with Google',
              //   backgroundColor: Colors.grey.shade300,
              //   elevation: 0.0,
              // ),
              const SizedBox(
                height: 14,
              ),
              // SignInButton(
              //   onTap: () {},
              //   iconPath: 'assets/logos/facebook.png',
              //   textLabel: 'Sign in with Facebook',
              //   backgroundColor: Colors.blue.shade300,
              //   elevation: 0.0,
              // ),

              Padding(
                padding: const EdgeInsets.all(14.0),
                child: TextFormField(
                  style: TextStyle(
                      color: Colors.black54,
                      fontFamily: 'Poppins',
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w600),
                  controller: commentcontroller,
                  decoration: InputDecoration(
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        width: 3,
                        color: Color.fromRGBO(86, 103, 253, 1),
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        width: 3,
                        color: Colors.black,
                      ), //<-- SEE HERE
                    ),
                    hintText: "Enter comment..",
                    suffixIcon: IconButton(
                      iconSize: 20,
                      onPressed: () async {
                        setState(() {
                          isloading = true;
                        });

                        String userid = uid;
                        String comment = commentcontroller.text;

                        print(postdata.posts[widget.index1].id +
                            "post id from add comment");

                        await addcommentpost(
                            avatarphoto:
                                globalteacherdata.userDetails[0].avatar,
                            postid: postdata.posts[widget.index1].id,
                            comment: comment,
                            userid: userid);

                        commentcontroller.text = "";

                        setState(() {
                          getpostdata();
                        });

                        // final snackBar = SnackBar(
                        //   behavior: SnackBarBehavior.floating,
                        //   margin: EdgeInsets.only(),
                        //   backgroundColor: Colors.black,
                        //   duration: Duration(seconds: 1),
                        //   dismissDirection: DismissDirection.horizontal,
                        //   content: Container(
                        //     height: 30,
                        //     child: const Text(
                        //       'Comment added Sucessfully.',
                        //       style: TextStyle(),
                        //     ),
                        //   ),
                        // );

                        // ScaffoldMessenger.of(context).hideCurrentSnackBar();

                        // ScaffoldMessenger.of(context).showSnackBar(snackBar);

                        // await getpostdata();

                        setState(() {
                          isloading = false;
                        });
                      },
                      icon: isloading
                          ? Container(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                  color: Color.fromRGBO(38, 90, 232, 1)),
                            )
                          : ImageIcon(
                              AssetImage('assets/sent.png'),
                              color: Colors.black,
                            ),
                    ),
                  ),
                ),
              ),

              // TextField()
            ]),
          )
        ],
      ),
    );
  }

  Future addcommentpost(
      {required String avatarphoto,
      required String postid,
      required String comment,
      required String userid}) async {
    var response = await http.post(
      Uri.https('api.easyeduverse.tech', '/comment/${postid}'),
      // Uri.https(
      //     'easyed-social-media-backend.onrender.com', '/comment/${postid}'),
      headers: {'Content-Type': 'application/json'},
      // body: json.encode(sendData),
      body: json.encode({
        "userId": globalteacherdata.userDetails[0].lastName,
        "comment": comment,
        "avatar": avatarphoto
      }),
      // body: json.encode(
      //     {"userId": userid, "comment": comment, "avatar": avatarphoto}),
    );

    var data = response.body;

    print(data);
  }

  Future<Post> getpostdata() async {
    final response = await http.get(Uri.parse(
        'https://api.easyeduverse.tech/api/post?page=${widget.pagenumber}'));
    // Uri.parse('https://easyed-social-media-backend.onrender.com/api/post'));
    var data = jsonDecode(response.body.toString());

    // print(data.toString());

    if (response.statusCode == 200) {
      postdata = Post.fromJson(data);
      // print(sampleteachers.toString());
      // for (Map<String, dynamic> index in data) {
      //   sampleteachers.add(Teacher.fromJson(index));
      // }
      return postdata;
    } else {
      return postdata;
    }
  }

  Stream<Post> getPostDataStream() {
    // Use Stream.fromFuture to convert the Future to a Stream
    return Stream.fromFuture(getpostdata());
  }

  Future deletecommentpost(
      {required String postid,
      required String commentid,
      required String userid}) async {
    print(commentid);
    print(postid);
    var response = await http.delete(
      Uri.https('api.easyeduverse.tech', '/comment/${postid}/${commentid}'),
      // Uri.https('easyed-social-media-backend.onrender.com',
      //     '/comment/${postid}/${commentid}'),
      headers: {'Content-Type': 'application/json'},
      // body: json.encode(sendData),
      body: json.encode({"userId": userid}),
    );

    var data = response.body;

    print(data);
  }

  // Future<void> refreshdata() async {
  //   await Navigator.push(
  //       context,
  //       MaterialPageRoute(
  //           builder: (context) => ModelSheetScreen(
  //             postid: wid,
  //                 index1: widget.index1,
  //               ))).then((value) => onReturn());
  // }
}
