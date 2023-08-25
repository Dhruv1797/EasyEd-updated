// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';

// import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';
// import 'package:easyed/models/post.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert';

// class ModelSheetKeyboard extends StatefulWidget {
//   final int index2;
//   const ModelSheetKeyboard({
//     Key? key,
//     required this.index2,
//   }) : super(key: key);

//   @override
//   State<ModelSheetKeyboard> createState() => _ModelSheetKeyboardState();
// }

// class _ModelSheetKeyboardState extends State<ModelSheetKeyboard> {
//   TextEditingController commentcontroller = TextEditingController();
//   Future onReturn() async => setState(() => getpostdata());
//   final uid = FirebaseAuth.instance.currentUser!.uid;

//   List<Post> postlist = [];

//   List<Comment> commentlist = [];

//   Post postdata = Post(
//       id: '',
//       userId: '',
//       post: '',
//       avatar: '',
//       content: '',
//       isBlocked: false,
//       date: DateTime.now(),
//       likes: [],
//       comments: [],
//       v: 1);

//   @override
//   Widget build(BuildContext context) {
//     double deviceheight = MediaQuery.of(context).size.height;
//     double appbarheight = 45;

//     double devicewidth = MediaQuery.of(context).size.width;
//     return Stack(
//       alignment: AlignmentDirectional.topCenter,
//       clipBehavior: Clip.none,
//       children: [
//         // Positioned(
//         //   top: -15,
//         //   child: Container(
//         //     width: 60,
//         //     height: 7,
//         //     margin: const EdgeInsets.only(bottom: 20),
//         //     decoration: BoxDecoration(
//         //       borderRadius: BorderRadius.circular(5),
//         //       color: Colors.white,
//         //     ),
//         //   ),
//         // ),
//         Column(children: [
//           // GestureDetector(
//           //   onTap: () {},
//           //   child: Container(
//           //     color: Colors.yellow,
//           //     height: 20,
//           //   ),
//           // ),
//           Padding(
//             padding: const EdgeInsets.all(14.0),
//             child: TextFormField(
//               controller: commentcontroller,
//               decoration: InputDecoration(
//                 focusedBorder: OutlineInputBorder(
//                   borderSide: BorderSide(
//                     width: 3,
//                     color: Color(0xFF265AE8),
//                   ),
//                 ),
//                 enabledBorder: OutlineInputBorder(
//                   borderSide: BorderSide(
//                     width: 3,
//                     color: Colors.black,
//                   ), //<-- SEE HERE
//                 ),
//                 hintText: "Enter comment..",
//                 suffixIcon: IconButton(
//                   iconSize: 20,
//                   onPressed: () async {
//                     String userid = uid;
//                     String comment = commentcontroller.text;

//                     // print(widget.index2);
//                     // print(postlist[widget.index2].avatar);
//                     // print(postlist[widget.index2].id);

//                     await addcommentpost(
//                         avatarphoto: postlist[widget.index2].avatar,
//                         postid: postlist[widget.index2].id,
//                         comment: comment,
//                         userid: userid);

//                     commentcontroller.text = "";

//                     // final snackBar = SnackBar(
//                     //   behavior: SnackBarBehavior.floating,
//                     //   margin: EdgeInsets.only(),
//                     //   backgroundColor: Colors.black,
//                     //   duration: Duration(seconds: 1),
//                     //   dismissDirection: DismissDirection.horizontal,
//                     //   content: Container(
//                     //     height: 30,
//                     //     child: const Text(
//                     //       'Comment added Sucessfully.',
//                     //       style: TextStyle(),
//                     //     ),
//                     //   ),
//                     // );

//                     // ScaffoldMessenger.of(context).hideCurrentSnackBar();

//                     // ScaffoldMessenger.of(context).showSnackBar(snackBar);
//                   },
//                   icon: ImageIcon(
//                     AssetImage('assets/sent.png'),
//                     color: Colors.black,
//                   ),
//                 ),
//               ),
//             ),
//           ),

//           SingleChildScrollView(
//             child: Container(
//               color: Colors.red,
//               height: deviceheight * 0.74,
//               child: FutureBuilder(
//                   future: getpostdata(),
//                   builder: (context, snapshot) {
//                     if (snapshot.hasData) {
//                       return Padding(
//                         padding: const EdgeInsets.all(14.0),
//                         child: TextFormField(
//                           controller: commentcontroller,
//                           decoration: InputDecoration(
//                             focusedBorder: OutlineInputBorder(
//                               borderSide: BorderSide(
//                                 width: 3,
//                                 color: Color(0xFF265AE8),
//                               ),
//                             ),
//                             enabledBorder: OutlineInputBorder(
//                               borderSide: BorderSide(
//                                 width: 3,
//                                 color: Colors.black,
//                               ), //<-- SEE HERE
//                             ),
//                             hintText: "Enter comment..",
//                             suffixIcon: IconButton(
//                               iconSize: 20,
//                               onPressed: () async {
//                                 String userid = uid;
//                                 String comment = commentcontroller.text;

//                                 // print(widget.index2);
//                                 // print(postlist[widget.index2].avatar);
//                                 // print(postlist[widget.index2].id);

//                                 await addcommentpost(
//                                     avatarphoto: postlist[widget.index2].avatar,
//                                     postid: postlist[widget.index2].id,
//                                     comment: comment,
//                                     userid: userid);

//                                 commentcontroller.text = "";

//                                 // final snackBar = SnackBar(
//                                 //   behavior: SnackBarBehavior.floating,
//                                 //   margin: EdgeInsets.only(),
//                                 //   backgroundColor: Colors.black,
//                                 //   duration: Duration(seconds: 1),
//                                 //   dismissDirection: DismissDirection.horizontal,
//                                 //   content: Container(
//                                 //     height: 30,
//                                 //     child: const Text(
//                                 //       'Comment added Sucessfully.',
//                                 //       style: TextStyle(),
//                                 //     ),
//                                 //   ),
//                                 // );

//                                 // ScaffoldMessenger.of(context).hideCurrentSnackBar();

//                                 // ScaffoldMessenger.of(context).showSnackBar(snackBar);
//                               },
//                               icon: ImageIcon(
//                                 AssetImage('assets/sent.png'),
//                                 color: Colors.black,
//                               ),
//                             ),
//                           ),
//                         ),
//                       );
//                     } else {
//                       return Container(
//                         width: devicewidth,
//                         child: Column(
//                           mainAxisAlignment: MainAxisAlignment.start,
//                           children: [
//                             Container(
//                               height: 40,
//                               width: 40,
//                               child: CircularProgressIndicator(
//                                 color: Colors.blue,
//                               ),
//                             ),
//                           ],
//                         ),
//                       );
//                     }
//                   }),
//             ),
//           ),

//           // // SignInButton(
//           // //   onTap: () {},
//           // //   iconPath: 'assets/logos/email.png',
//           // //   textLabel: 'Sign in with email',
//           // //   backgroundColor: Colors.white,
//           // //   elevation: 5.0,
//           // // ),
//           // // const SizedBox(
//           // //   height: 20,
//           // // ),
//           // // const Center(
//           // //   child: Text(
//           // //     'OR',
//           // //     style: TextStyle(fontSize: 18),
//           // //   ),
//           // // ),
//           // // const SizedBox(
//           // //   height: 30,
//           // // ),
//           // // SignInButton(
//           // //   onTap: () {},
//           // //   iconPath: 'assets/logos/google.png',
//           // //   textLabel: 'Sign in with Google',
//           // //   backgroundColor: Colors.grey.shade300,
//           // //   elevation: 0.0,
//           // // ),
//           // const SizedBox(
//           //   height: 14,
//           // ),
//           // // SignInButton(
//           // //   onTap: () {},
//           // //   iconPath: 'assets/logos/facebook.png',
//           // //   textLabel: 'Sign in with Facebook',
//           // //   backgroundColor: Colors.blue.shade300,
//           // //   elevation: 0.0,
//           // // ),
//         ])
//       ],
//     );
//   }

//   Future<List<Post>> getpostdata() async {
//     final response = await http.get(
//         Uri.parse('https://easyed-social-media-backend.onrender.com/api/post'));
//     var data = jsonDecode(response.body.toString());

//     // print(data.toString());

//     if (response.statusCode == 200) {
//       for (Map<String, dynamic> index in data) {
//         postlist.add(Post.fromJson(index));
//       }

//       // print(sampleteachers.toString());
//       // for (Map<String, dynamic> index in data) {
//       //   sampleteachers.add(Teacher.fromJson(index));
//       // }
//       return postlist;
//     } else {
//       return postlist;
//     }
//   }

//   Future deletecommentpost(
//       {required String postid,
//       required String commentid,
//       required String userid}) async {
//     print(commentid);
//     print(postid);
//     var response = await http.delete(
//       Uri.httpss('easyed-social-media-backend.onrender.com',
//           '/comment/${postid}/${commentid}'),
//       headers: {'Content-Type': 'application/json'},
//       // body: json.encode(sendData),
//       body: json.encode({"userId": userid}),
//     );

//     var data = response.body;

//     print(data);
//   }

//   Future addcommentpost(
//       {required String avatarphoto,
//       required String postid,
//       required String comment,
//       required String userid}) async {
//     var response = await http.post(
//       Uri.httpss(
//           'easyed-social-media-backend.onrender.com', '/comment/${postid}'),
//       headers: {'Content-Type': 'application/json'},
//       // body: json.encode(sendData),
//       body: json.encode(
//           {"userId": userid, "comment": comment, "avatar": avatarphoto}),
//     );

//     var data = response.body;

//     print(data);
//   }
//   // Future<void> refreshdata() async {
//   //   await Navigator.push(
//   //       context,
//   //       MaterialPageRoute(
//   //           builder: (context) => ModelSheetKeyboard(
//   //                 index1: widget.index1,
//   //               ))).then((value) => onReturn());
//   // }
// }
