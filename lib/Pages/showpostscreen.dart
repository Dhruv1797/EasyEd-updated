import 'dart:async';
import 'dart:convert';
import 'dart:ffi';

import 'dart:io';

import 'package:easyed/Pages/expandpostscreen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:http/http.dart' as http;
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';
import 'package:easyed/Pages/addpostscreen.dart';
import 'package:easyed/Pages/globalvariables.dart';
import 'package:easyed/Pages/modelsheetscreen.dart';
import 'package:easyed/Pages/pdfviewerpage.dart';
import 'package:easyed/models/Student.dart';
import 'package:easyed/models/Teacher.dart';
import 'package:easyed/models/post.dart';
import 'package:easyed/pdf_api.dart';
import 'package:easyed/video_player_item.dart';
import 'package:easyed/widgets/drawer.dart';
import 'package:easyed/widgets/examplemenu.dart';
import 'package:easyed/widgets/widgets.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:insta_image_viewer/insta_image_viewer.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ShowPostScreen extends StatefulWidget {
  static const routeName = '/showpostscreen';
  const ShowPostScreen({super.key});

  @override
  State<ShowPostScreen> createState() => _ShowPostScreenState();
}

class _ShowPostScreenState extends State<ShowPostScreen> {
  int caculatedpageindex = 0;
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  int page = 1;
  final scrollcontroller = ScrollController();
  String alreadylikedmessage = "Post already liked";
  bool isalreadyliked = false;

  String alreadynotlikedmessage = "Post has not yet been liked";
  bool isalreadyunliked = false;
  bool isloading = false;

  int adInterval = 5;

  List<PostElement> postelementlist = [];
  List<Object> postelementlistads = [];

  Future onReturn() async => setState(() => getpostdata());
  TextEditingController commentcontroller = TextEditingController();
  final uid = FirebaseAuth.instance.currentUser!.uid;
  // List<Student> samplestudents = [];
  List<Teacher> teacherslist = [];

  List<Post> postlist = [];

  List<Comment> commentlist = [];

  bool islike = false;

  String currentpostid = "";

  bool? isCurrentUserLiked = false;

  bool iscurrentindexpostisavideo = false;

  bool iscurrentpostistextonly = false;

  Post postdata = Post(posts: [], currentPage: 0, totalPages: 0, totalCount: 0);
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
    sharedtasks: [],
  );

  StreamController<Post> poststreeamcontroller = StreamController();

  @override
  void initState() {
    // refreshdata();
    // TODO: implement initState
    super.initState();
    initBannerAD();
    getpostdata();

    scrollcontroller.addListener(scrolllistener);
  }

  late BannerAd bannerAd;
  bool isAdloaded = false;
  initBannerAD() {
    bannerAd = BannerAd(
      size: AdSize.largeBanner,
      adUnitId: "ca-app-pub-5815010106350331/1285255064",
      listener: BannerAdListener(
        onAdLoaded: (ad) {
          setState(() {
            isAdloaded = true;
          });
        },
        onAdFailedToLoad: (ad, error) {
          ad.dispose();
          print(error);
        },
      ),
      request: const AdRequest(),
    );

    bannerAd.load();
  }

  @override
  Widget build(BuildContext context) {
    double deviceheight = MediaQuery.of(context).size.height;
    double appbarheight = 45;

    double devicewidth = MediaQuery.of(context).size.width;
    return WillPopScope(
      onWillPop: () async => false,
      child: ScaffoldMessenger(
        child: Scaffold(
          key: _scaffoldKey,
          drawer: MyDrawer(),
          body: SafeArea(
            child: Column(
              children: [
                // islike ? Text("like") : Text("unlike"),
                Container(
                  height: 80.h,
                  child: Padding(
                    padding: const EdgeInsets.only(
                      top: 30,
                      left: 14.0,
                      right: 14.0,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: GestureDetector(
                                onTap: () {
                                  _scaffoldKey.currentState?.openDrawer();
                                },
                                child: Container(
                                  height: 20,
                                  width: 30,
                                  child: Image.asset("assets/iconmenu.png"),
                                ),
                              ),
                            ),

                            // Container(
                            //     height: 200,
                            //     width: 200,
                            //     child: Image.asset(
                            //       "assets/easyed.png",
                            //       height: 100,
                            //     )),
                            Text(
                              "EASY",
                              style: TextStyle(
                                  fontFamily: 'Poppins',
                                  color: Colors.black,
                                  fontWeight: FontWeight.w900,
                                  fontSize: 30),
                            ),
                            Text(
                              "ED",
                              style: TextStyle(
                                  fontFamily: 'Poppins',
                                  color: Color.fromRGBO(86, 103, 253, 1),
                                  fontWeight: FontWeight.w900,
                                  fontSize: 30),
                            ),
                          ],
                        ),
                        Container(
                          height: 28.h,
                          width: 130.w,
                          child: InkWell(
                            child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                    elevation: 5,
                                    backgroundColor:
                                        Color.fromRGBO(86, 103, 253, 1),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(30),
                                    )),
                                onPressed: () async {
                                  PersistentNavBarNavigator.pushNewScreen(
                                    context,
                                    screen: AddPostScreen(),
                                    withNavBar:
                                        true, // OPTIONAL VALUE. True by default.
                                    pageTransitionAnimation:
                                        PageTransitionAnimation.cupertino,
                                  );

                                  // nextScreen(context, AddPostScreen());
                                },
                                child: Text(
                                  "Post/Ask",
                                  style: TextStyle(
                                    fontWeight: FontWeight.w700,
                                    fontFamily: 'Poppins',
                                    color: Colors.white,
                                    fontSize: 11.sp,
                                  ),
                                )),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Container(
                  // color: Colors.red,
                  height: deviceheight * 0.82,
                  child: ListView.builder(
                      controller: scrollcontroller,
                      itemCount: postelementlist.length +
                          (postelementlist.length ~/ adInterval),
                      // itemCount: postelementlist.length,
                      itemBuilder: (context, index) {
                        // NativeAd nativeAd = NativeAd(
                        //   adUnitId: 'ca-app-pub-3940256099942544/2247696110',
                        //   nativeTemplateStyle: NativeTemplateStyle(
                        //     templateType: TemplateType.medium,
                        //   ),
                        //   request: AdRequest(),
                        //   listener: NativeAdListener(
                        //     onAdLoaded: (Ad ad) {
                        //       print("Ad Loaded");
                        //     },
                        //     onAdFailedToLoad: (Ad ad, LoadAdError error) {
                        //       print("Ad failed to load");
                        //       ad.dispose();
                        //     },
                        //     onAdOpened: (Ad ad) {
                        //       print("Ad Loaded");
                        //     },
                        //   ),
                        // );

                        BannerAd bAd = BannerAd(
                          size: AdSize.fullBanner,
                          adUnitId: 'ca-app-pub-5815010106350331/1285255064',
                          listener: BannerAdListener(
                            onAdLoaded: (Ad ad) {
                              print("Ad Loaded");
                            },
                            onAdFailedToLoad: (Ad ad, LoadAdError error) {
                              print("Ad failed to load");
                              ad.dispose();
                            },
                            onAdOpened: (Ad ad) {
                              print("Ad Loaded");
                            },
                          ),
                          request: AdRequest(),
                        );

                        if (index % (adInterval + 1) == adInterval) {
                          return isAdloaded
                              ? SizedBox(
                                  height: bAd.size.height.toDouble(),
                                  width: bAd.size.width.toDouble(),
                                  child: AdWidget(
                                    ad: bAd..load(),
                                    key: ValueKey<String>('ad_$index'),
                                  ),
                                )
                              : SizedBox();
                        } else {
                          int itemIndex = index - (index ~/ (adInterval + 1));

                          bool iscurrentindexpostalreadylikedbyuser =
                              postelementlist[itemIndex]
                                  .likes
                                  .any((element) => element.user == uid);

                          if (postelementlist[itemIndex].postFormat != null) {
                            // if (postlist[index]
                            //         .postFormat!
                            //         .contains("video") ||
                            //     postlist[index]
                            //         .postFormat!
                            //         .contains("application")) {
                            //   iscurrentindexpostisavideo = true;

                            iscurrentpostistextonly = postelementlist[itemIndex]
                                .postFormat!
                                .contains("null");
                            // }
                            iscurrentindexpostisavideo =
                                postelementlist[itemIndex]
                                        .postFormat!
                                        .contains("video") ||
                                    postelementlist[itemIndex]
                                        .postFormat!
                                        .contains("application");
                            // iscurrentindexpostisavideo = postlist[index]
                            //     .postFormat!
                            //     .contains("application");
                          }

                          commentlist = commentlist = List<Comment>.from(
                            postelementlist[itemIndex].comments.map(
                                  (q) => Comment(
                                      user: q.user,
                                      comment: q.comment,
                                      avatar: q.avatar,
                                      id: q.id,
                                      date: q.date),
                                ),
                          );

                          return GestureDetector(
                            onTap: () {
                              print(itemIndex);
                              print(iscurrentindexpostisavideo);
                              nextScreen(
                                  context,
                                  ExpandPOstS(
                                    iscurrentposttextonly:
                                        postelementlist[itemIndex]
                                            .postFormat!
                                            .contains("null"),
                                    index: itemIndex,
                                    iscurrentindexpostisavideo:
                                        postelementlist[itemIndex]
                                                .postFormat
                                                .contains("video") ||
                                            postelementlist[itemIndex]
                                                .postFormat
                                                .contains("application"),
                                    imageurl: postelementlist[itemIndex].post,
                                    decriptions:
                                        postelementlist[itemIndex].content,
                                  ));
                            },
                            child: Container(
                              width: 360.w,
                              // color: Colors.red,
                              height: 391.h,
                              //add single child scroll view here
                              child: SingleChildScrollView(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    // Text("Teacher json"),

                                    Container(
                                      decoration: BoxDecoration(
                                        // color: Colors.yellow,
                                        border: Border.all(
                                            width: 1.w,
                                            color: Color.fromRGBO(
                                                178, 178, 178, 1)),
                                        // borderRadius: BorderRadius.circular(20),
                                        // boxShadow: [
                                        //   BoxShadow(
                                        //     color: Colors.grey,
                                        //     offset: const Offset(
                                        //       5.0,
                                        //       5.0,
                                        //     ),
                                        //     blurRadius: 1.0,
                                        //     spreadRadius: 1.0,
                                        //   ), //BoxShadow
                                        //   // BoxShadow(
                                        //   //   color: Colors.white,
                                        //   //   offset: const Offset(0.0, 0.0),
                                        //   //   blurRadius: 0.0,
                                        //   //   spreadRadius: 0.0,
                                        //   // ), //BoxShadow
                                        // ],
                                      ),
                                      height: 391.h,
                                      width: 600,
                                      child: SingleChildScrollView(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Container(
                                              // color: Colors.pink,
                                              height: 50.h,
                                              child: Column(
                                                children: [
                                                  SizedBox(
                                                    height: 9.h,
                                                  ),
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      Row(
                                                        children: [
                                                          SizedBox(
                                                            width: 13.w,
                                                          ),
                                                          Container(
                                                            height: 41.h,
                                                            width: 41.w,
                                                            child: CircleAvatar(
                                                              backgroundColor:
                                                                  Colors.blue,
                                                              // radius: 41.r,
                                                              backgroundImage:
                                                                  NetworkImage(
                                                                postelementlist[
                                                                        itemIndex]
                                                                    .avatar,
                                                              ),
                                                            ),
                                                          ),
                                                          SizedBox(
                                                            width: 10.w,
                                                          ),
                                                          Container(
                                                            // color: Colors.blue,
                                                            width: 235.w,
                                                            height: 30.sp,
                                                            // color: Colors.red,
                                                            child: Column(
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .start,
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .center,
                                                              children: [
                                                                Text(
                                                                  postelementlist[
                                                                          itemIndex]
                                                                      .userId,
                                                                  maxLines: 1,
                                                                  style: TextStyle(
                                                                      fontFamily:
                                                                          'Poppins',
                                                                      fontSize:
                                                                          14.sp,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w800),
                                                                ),
                                                              ],
                                                            ),
                                                          )
                                                        ],
                                                      ),
                                                      Padding(
                                                        padding:
                                                            EdgeInsets.only(
                                                                right: 16.0.w),
                                                        child: GestureDetector(
                                                          onTap: () {},
                                                          child: Container(
                                                            // color: Colors.red,
                                                            height: 21.h,
                                                            width: 21.w,
                                                            child: ExampleMenu(
                                                              unlikepostfunction:
                                                                  () async {
                                                                caculatedpageindex =
                                                                    (itemIndex /
                                                                                10)
                                                                            .toInt() +
                                                                        1;

                                                                print("Caclualted page index from unlike" +
                                                                    caculatedpageindex
                                                                        .toString());

                                                                await unlikepost(
                                                                    postid:
                                                                        postelementlist[itemIndex]
                                                                            .id,
                                                                    userid:
                                                                        uid);

                                                                setState(() {
                                                                  getpostdataforlike(
                                                                      index:
                                                                          itemIndex);
                                                                });

                                                                final snackBar =
                                                                    SnackBar(
                                                                  behavior:
                                                                      SnackBarBehavior
                                                                          .floating,
                                                                  margin:
                                                                      EdgeInsets
                                                                          .only(),
                                                                  backgroundColor:
                                                                      Colors
                                                                          .black,
                                                                  duration:
                                                                      Duration(
                                                                          seconds:
                                                                              1),
                                                                  dismissDirection:
                                                                      DismissDirection
                                                                          .horizontal,
                                                                  content:
                                                                      Container(
                                                                    height: 30,
                                                                    child:
                                                                        const Text(
                                                                      'Post Disliked Sucessfully.',
                                                                      style:
                                                                          TextStyle(
                                                                        fontFamily:
                                                                            'Poppins',
                                                                      ),
                                                                    ),
                                                                  ),
                                                                );
                                                                ScaffoldMessenger.of(
                                                                        context)
                                                                    .hideCurrentSnackBar();

                                                                ScaffoldMessenger.of(
                                                                        context)
                                                                    .showSnackBar(
                                                                        snackBar);

                                                                setState(() {
                                                                  islike = true;
                                                                });
                                                              },
                                                              builder: (_,
                                                                      showMenu) =>
                                                                  CupertinoButton(
                                                                onPressed:
                                                                    showMenu,
                                                                padding:
                                                                    EdgeInsets
                                                                        .zero,
                                                                pressedOpacity:
                                                                    1,
                                                                child:
                                                                    ImageIcon(
                                                                  AssetImage(
                                                                      'assets/more.png'),
                                                                  color: Color
                                                                      .fromRGBO(
                                                                          0,
                                                                          0,
                                                                          0,
                                                                          1),
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ),
                                            // Container(
                                            //   height: 300,
                                            //   width: 600,
                                            //   child: Image.network(
                                            //     postlist[index].post,
                                            //     fit: BoxFit.fitWidth,
                                            //   ),
                                            // ),

                                            Padding(
                                              padding:
                                                  EdgeInsets.only(top: 7.0.h),
                                              child: Column(
                                                children: [
                                                  Container(
                                                      height: 251.h,
                                                      width: 354.w,
                                                      child: iscurrentpostistextonly
                                                          ? Container(
                                                              // color: Colors.red,
                                                              // height: 300,
                                                              // width: 300,
                                                              child: Row(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .center,
                                                                children: [
                                                                  SingleChildScrollView(
                                                                    child:
                                                                        Container(
                                                                      decoration:
                                                                          BoxDecoration(
                                                                              border: Border.all()),
                                                                      height:
                                                                          251.h,
                                                                      width:
                                                                          354.w,
                                                                      child:
                                                                          SingleChildScrollView(
                                                                        child:
                                                                            Container(
                                                                          child:
                                                                              Padding(
                                                                            padding:
                                                                                const EdgeInsets.only(
                                                                              left: 12.0,
                                                                              right: 12.0,
                                                                            ),
                                                                            child:
                                                                                Text(
                                                                              postelementlist[itemIndex].content,
                                                                              style: TextStyle(fontWeight: FontWeight.w600, fontFamily: 'Poppins'),
                                                                            ),
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                  // Text(postelementlist[index]
                                                                  //     .content),
                                                                ],
                                                              ),
                                                            )
                                                          : iscurrentindexpostisavideo
                                                              ? VideoPlayerItem(
                                                                  videoUrl:
                                                                      postelementlist[
                                                                              itemIndex]
                                                                          .post,
                                                                )
                                                              : InstaImageViewer(
                                                                  disableSwipeToDismiss:
                                                                      true,
                                                                  child:
                                                                      CachedNetworkImage(
                                                                    fit: BoxFit
                                                                        .fitWidth,
                                                                    imageUrl:
                                                                        postelementlist[itemIndex]
                                                                            .post,
                                                                    placeholder: (context, url) => Container(
                                                                        // color: Colors.red,
                                                                        height: 251.h,
                                                                        width: 354.w,
                                                                        child: Center(
                                                                            child: CircularProgressIndicator(
                                                                          color: Color.fromRGBO(
                                                                              38,
                                                                              90,
                                                                              232,
                                                                              1),
                                                                        ))),
                                                                    errorWidget: (context,
                                                                            url,
                                                                            error) =>
                                                                        const Icon(
                                                                            Icons.error),
                                                                    fadeOutDuration:
                                                                        const Duration(
                                                                            seconds:
                                                                                1),
                                                                    fadeInDuration:
                                                                        const Duration(
                                                                            seconds:
                                                                                3),
                                                                  ),
                                                                )),
                                                  Padding(
                                                    padding: EdgeInsets.only(
                                                        top: 11.0.h,
                                                        left: 15.w),
                                                    child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Container(
                                                          width: devicewidth *
                                                              0.75,
                                                          child: Text(
                                                            postelementlist[
                                                                    itemIndex]
                                                                .userId,
                                                            style: TextStyle(
                                                              fontFamily:
                                                                  'Poppins',
                                                              fontSize: 10.sp,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w800,
                                                              color: Color
                                                                  .fromRGBO(0,
                                                                      0, 0, 1),
                                                            ),
                                                          ),
                                                        ),
                                                        Row(
                                                          children: [
                                                            // CircleAvatar(
                                                            //   backgroundColor:
                                                            //       Colors.blue,
                                                            //   radius: 26,
                                                            //   backgroundImage:
                                                            //       NetworkImage(
                                                            //     postelementlist[
                                                            //             index]
                                                            //         .avatar,
                                                            //   ),
                                                            // ),

                                                            iscurrentpostistextonly
                                                                ? SizedBox(
                                                                    width:
                                                                        234.w,
                                                                  )
                                                                : Container(
                                                                    // color: Colors.red,
                                                                    width:
                                                                        234.w,
                                                                    height:
                                                                        37.h,
                                                                    child:
                                                                        SingleChildScrollView(
                                                                      child:
                                                                          Text(
                                                                        "${postelementlist[itemIndex].content}",
                                                                        maxLines:
                                                                            null,
                                                                        style: TextStyle(
                                                                            color: Colors
                                                                                .black54,
                                                                            fontFamily:
                                                                                'Poppins',
                                                                            fontSize:
                                                                                12.sp,
                                                                            fontWeight: FontWeight.w600),
                                                                      ),
                                                                    ),
                                                                  ),

                                                            SizedBox(
                                                              width: 16.w,
                                                            ),

                                                            GestureDetector(
                                                              onTap: () async {
                                                                caculatedpageindex =
                                                                    (itemIndex /
                                                                                10)
                                                                            .toInt() +
                                                                        1;
                                                                print("Caclualted page index from addlike" +
                                                                    caculatedpageindex
                                                                        .toString());

                                                                print("length of list before like" +
                                                                    postelementlist[
                                                                            itemIndex]
                                                                        .likes
                                                                        .length
                                                                        .toString());
                                                                await postaddlike(
                                                                    postid:
                                                                        postelementlist[itemIndex]
                                                                            .id,
                                                                    userid:
                                                                        uid);

                                                                setState(() {
                                                                  getpostdataforlike(
                                                                      index:
                                                                          itemIndex);
                                                                });

                                                                print("length of list after like" +
                                                                    postelementlist[
                                                                            itemIndex]
                                                                        .likes
                                                                        .length
                                                                        .toString());

                                                                final snackBar =
                                                                    SnackBar(
                                                                  behavior:
                                                                      SnackBarBehavior
                                                                          .floating,
                                                                  margin:
                                                                      EdgeInsets
                                                                          .only(),
                                                                  backgroundColor:
                                                                      Colors
                                                                          .black,
                                                                  duration:
                                                                      Duration(
                                                                          seconds:
                                                                              1),
                                                                  dismissDirection:
                                                                      DismissDirection
                                                                          .horizontal,
                                                                  content:
                                                                      Container(
                                                                    height: 30,
                                                                    child:
                                                                        const Text(
                                                                      'Post Liked Sucessfully.',
                                                                      style:
                                                                          TextStyle(
                                                                        fontFamily:
                                                                            'Poppins',
                                                                      ),
                                                                    ),
                                                                  ),
                                                                );

                                                                ScaffoldMessenger.of(
                                                                        context)
                                                                    .hideCurrentSnackBar();

                                                                ScaffoldMessenger.of(
                                                                        context)
                                                                    .showSnackBar(
                                                                        snackBar);

                                                                print("data");

                                                                print(uid);
                                                                print(
                                                                    itemIndex);

                                                                isCurrentUserLiked = postelementlist[
                                                                        itemIndex]
                                                                    .likes
                                                                    .any((like) =>
                                                                        like.user ==
                                                                        uid);

                                                                // return ; // Key1 value not found

                                                                // print(postlist[
                                                                //         index]
                                                                //     .likes.contains()
                                                                //     );

                                                                print(
                                                                    isCurrentUserLiked);

                                                                setState(() {
                                                                  currentpostid =
                                                                      postelementlist[
                                                                              itemIndex]
                                                                          .id;
                                                                });

                                                                // setState(() {
                                                                //   postlist[index].likes.length;
                                                                // });
                                                              },
                                                              child: Container(
                                                                height: 17.h,
                                                                width: 17.w,
                                                                child:
                                                                    ImageIcon(
                                                                        color: iscurrentindexpostalreadylikedbyuser
                                                                            ? Colors.blue
                                                                            : Colors.black,
                                                                        AssetImage(
                                                                          "assets/likes.png",
                                                                        )),
                                                              ),
                                                            ),

                                                            Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                      .only(
                                                                      left:
                                                                          8.0),
                                                              child: Text(
                                                                postelementlist[
                                                                        itemIndex]
                                                                    .likes
                                                                    .length
                                                                    .toString(),
                                                                style: TextStyle(
                                                                    fontFamily:
                                                                        'Poppins',
                                                                    fontSize:
                                                                        20,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w800),
                                                              ),
                                                            ),
                                                            //for debugging/////////

                                                            // Text(index
                                                            //     .toString()),
                                                            ///////////////////////
                                                            SizedBox(
                                                              width: 10.w,
                                                            ),
                                                            Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                      .all(8.0),
                                                              child:
                                                                  GestureDetector(
                                                                onTap: () {
                                                                  caculatedpageindex =
                                                                      (itemIndex / 10)
                                                                              .toInt() +
                                                                          1;

                                                                  print("Caclualted page index from comment" +
                                                                      caculatedpageindex
                                                                          .toString());
                                                                  showdownSheet(
                                                                      pagenumber:
                                                                          caculatedpageindex,
                                                                      postingid:
                                                                          postelementlist[itemIndex]
                                                                              .id,
                                                                      context:
                                                                          context,
                                                                      index1:
                                                                          itemIndex);
                                                                },
                                                                child:
                                                                    Container(
                                                                  height: 18.h,
                                                                  width: 18.w,
                                                                  child: ImageIcon(
                                                                      AssetImage(
                                                                          "assets/comment.png")),
                                                                ),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),

                                            // DATA PRINT

                                            // // Text(snapshot.data![index].avatar),
                                            // Text(
                                            //     "postid: ${postlist[index].id}"),
                                            // Text(
                                            //     "userId: ${postlist[index].userId}"),
                                            // Text(
                                            //     "avatar: ${postlist[index].avatar}"),
                                            // Text(
                                            //     "content: ${postlist[index].content}"),
                                            // Text(
                                            //     "isBLocked: ${postlist[index].isBlocked.toString()}"),
                                            // Text(
                                            //     "date: ${postlist[index].date.toString()}"),
                                            // Text(
                                            //     "userId: ${postlist[index].id}"),

                                            // Text(
                                            //     "Likes:  ${postlist[index].likes.length}"),

                                            //////////////////////////////////////
                                            // Text("uid $uid"),
                                            // islike
                                            //     ? ElevatedButton(
                                            //         onPressed: () async {
                                            //           await postaddlike(
                                            //               postid:
                                            //                   postlist[index]
                                            //                       .id,
                                            //               userid: uid);

                                            //           final snackBar = SnackBar(
                                            //             behavior:
                                            //                 SnackBarBehavior
                                            //                     .floating,
                                            //             margin:
                                            //                 EdgeInsets.only(),
                                            //             backgroundColor:
                                            //                 Colors.black,
                                            //             duration: Duration(
                                            //                 seconds: 1),
                                            //             dismissDirection:
                                            //                 DismissDirection
                                            //                     .horizontal,
                                            //             content: Container(
                                            //               height: 30,
                                            //               child: const Text(
                                            //                 'Post Liked Sucessfully.',
                                            //                 style: TextStyle(),
                                            //               ),
                                            //             ),
                                            //           );

                                            //           ScaffoldMessenger.of(
                                            //                   context)
                                            //               .hideCurrentSnackBar();

                                            //           ScaffoldMessenger.of(
                                            //                   context)
                                            //               .showSnackBar(
                                            //                   snackBar);

                                            //           setState(() {
                                            //             islike = false;
                                            //           });

                                            //           // setState(() {
                                            //           //   postlist[index].likes.length;
                                            //           // });
                                            //         },
                                            //         child: Text("add Like"))
                                            //     : ElevatedButton(
                                            //         onPressed: () async {
                                            //           await unlikepost(
                                            //               postid:
                                            //                   postlist[index]
                                            //                       .id,
                                            //               userid: uid);

                                            //           final snackBar = SnackBar(
                                            //             behavior:
                                            //                 SnackBarBehavior
                                            //                     .floating,
                                            //             margin:
                                            //                 EdgeInsets.only(),
                                            //             backgroundColor:
                                            //                 Colors.black,
                                            //             duration: Duration(
                                            //                 seconds: 1),
                                            //             dismissDirection:
                                            //                 DismissDirection
                                            //                     .horizontal,
                                            //             content: Container(
                                            //               height: 30,
                                            //               child: const Text(
                                            //                 'Post UnLiked Sucessfully.',
                                            //                 style: TextStyle(),
                                            //               ),
                                            //             ),
                                            //           );
                                            //           ScaffoldMessenger.of(
                                            //                   context)
                                            //               .hideCurrentSnackBar();

                                            //           ScaffoldMessenger.of(
                                            //                   context)
                                            //               .showSnackBar(
                                            //                   snackBar);

                                            //           setState(() {
                                            //             islike = true;
                                            //           });
                                            //         },
                                            //         child: Text("unlike post")),

                                            // Padding(
                                            //   padding: const EdgeInsets.all(12.0),
                                            //   child: Row(
                                            //     mainAxisAlignment:
                                            //         MainAxisAlignment.spaceBetween,
                                            //     children: [
                                            //       Padding(
                                            //         padding:
                                            //             const EdgeInsets.all(8.0),
                                            //         child: Row(
                                            //           children: [
                                            //             // isalreadyliked
                                            //             //     ?
                                            //             GestureDetector(
                                            //               onTap: () async {
                                            //                 print(
                                            //                     "length of list before like" +
                                            //                         postelementlist[
                                            //                                 index]
                                            //                             .likes
                                            //                             .length
                                            //                             .toString());
                                            //                 await postaddlike(
                                            //                     postid:
                                            //                         postelementlist[
                                            //                                 index]
                                            //                             .id,
                                            //                     userid: uid);

                                            //                 setState(() {
                                            //                   getpostdataforlike(
                                            //                       index: index);
                                            //                 });

                                            //                 print(
                                            //                     "length of list after like" +
                                            //                         postelementlist[
                                            //                                 index]
                                            //                             .likes
                                            //                             .length
                                            //                             .toString());

                                            //                 final snackBar = SnackBar(
                                            //                   behavior:
                                            //                       SnackBarBehavior
                                            //                           .floating,
                                            //                   margin:
                                            //                       EdgeInsets.only(),
                                            //                   backgroundColor:
                                            //                       Colors.black,
                                            //                   duration: Duration(
                                            //                       seconds: 1),
                                            //                   dismissDirection:
                                            //                       DismissDirection
                                            //                           .horizontal,
                                            //                   content: Container(
                                            //                     height: 30,
                                            //                     child: const Text(
                                            //                       'Post Liked Sucessfully.',
                                            //                       style: TextStyle(),
                                            //                     ),
                                            //                   ),
                                            //                 );

                                            //                 ScaffoldMessenger.of(
                                            //                         context)
                                            //                     .hideCurrentSnackBar();

                                            //                 ScaffoldMessenger.of(
                                            //                         context)
                                            //                     .showSnackBar(
                                            //                         snackBar);

                                            //                 print("data");

                                            //                 print(uid);
                                            //                 print(index);

                                            //                 isCurrentUserLiked =
                                            //                     postelementlist[index]
                                            //                         .likes
                                            //                         .any((like) =>
                                            //                             like.user ==
                                            //                             uid);

                                            //                 // return ; // Key1 value not found

                                            //                 // print(postlist[
                                            //                 //         index]
                                            //                 //     .likes.contains()
                                            //                 //     );

                                            //                 print(isCurrentUserLiked);

                                            //                 setState(() {
                                            //                   currentpostid =
                                            //                       postelementlist[
                                            //                               index]
                                            //                           .id;
                                            //                 });

                                            //                 // setState(() {
                                            //                 //   postlist[index].likes.length;
                                            //                 // });
                                            //               },
                                            //               child: Container(
                                            //                 height: 26,
                                            //                 width: 26,
                                            //                 child: ImageIcon(
                                            //                     color:
                                            //                         iscurrentindexpostalreadylikedbyuser
                                            //                             ? Colors.blue
                                            //                             : Colors
                                            //                                 .black,
                                            //                     AssetImage(
                                            //                       "assets/likes.png",
                                            //                     )),
                                            //               ),
                                            //             ),
                                            //             // SizedBox(
                                            //             //   width: 50,
                                            //             // ),
                                            //             // GestureDetector(
                                            //             //   onTap: () async {
                                            //             //     await unlikepost(
                                            //             //         postid:
                                            //             //             postlist[index]
                                            //             //                 .id,
                                            //             //         userid:
                                            //             //             uid);

                                            //             //     final snackBar =
                                            //             //         SnackBar(
                                            //             //       behavior:
                                            //             //           SnackBarBehavior
                                            //             //               .floating,
                                            //             //       margin:
                                            //             //           EdgeInsets
                                            //             //               .only(),
                                            //             //       backgroundColor:
                                            //             //           Colors
                                            //             //               .black,
                                            //             //       duration:
                                            //             //           Duration(
                                            //             //               seconds:
                                            //             //                   1),
                                            //             //       dismissDirection:
                                            //             //           DismissDirection
                                            //             //               .horizontal,
                                            //             //       content:
                                            //             //           Container(
                                            //             //         height: 30,
                                            //             //         child:
                                            //             //             const Text(
                                            //             //           'Likes Updated Sucessfully.',
                                            //             //           style:
                                            //             //               TextStyle(),
                                            //             //         ),
                                            //             //       ),
                                            //             //     );
                                            //             //     ScaffoldMessenger.of(
                                            //             //             context)
                                            //             //         .hideCurrentSnackBar();

                                            //             //     ScaffoldMessenger.of(
                                            //             //             context)
                                            //             //         .showSnackBar(
                                            //             //             snackBar);

                                            //             //     setState(() {
                                            //             //       islike = true;
                                            //             //     });
                                            //             //   },
                                            //             //   child: Container(
                                            //             //     height: 30,
                                            //             //     width: 30,
                                            //             //     child: ImageIcon(
                                            //             //         color: Colors.black,
                                            //             //         AssetImage(
                                            //             //           "assets/likes.png",
                                            //             //         )),
                                            //             //   ),
                                            //             // ),
                                            //             Padding(
                                            //               padding:
                                            //                   const EdgeInsets.only(
                                            //                       left: 8.0),
                                            //               child: Text(
                                            //                 postelementlist[index]
                                            //                     .likes
                                            //                     .length
                                            //                     .toString(),
                                            //                 style: TextStyle(
                                            //                     fontSize: 20,
                                            //                     fontWeight:
                                            //                         FontWeight.w800),
                                            //               ),
                                            //             ),

                                            //             Text(index.toString()),
                                            //           ],
                                            //         ),
                                            //       ),
                                            //       Padding(
                                            //         padding:
                                            //             const EdgeInsets.all(8.0),
                                            //         child: GestureDetector(
                                            //           onTap: () {
                                            //             showdownSheet(
                                            //                 pagenumber: page,
                                            //                 postingid:
                                            //                     postelementlist[index]
                                            //                         .id,
                                            //                 context: context,
                                            //                 index1: index);
                                            //           },
                                            //           child: Container(
                                            //             height: 26,
                                            //             width: 26,
                                            //             child: ImageIcon(AssetImage(
                                            //                 "assets/comment.png")),
                                            //           ),
                                            //         ),
                                            //       ),
                                            //     ],
                                            //   ),
                                            // ),

                                            // Padding(
                                            //   padding: const EdgeInsets.all(14.0),
                                            //   child: TextFormField(
                                            //     controller: commentcontroller,
                                            //     decoration: InputDecoration(
                                            //       focusedBorder: OutlineInputBorder(
                                            //         borderSide: BorderSide(
                                            //           width: 3,
                                            //           color: Color.fromRGBO(86, 103, 253, 1),
                                            //         ),
                                            //       ),
                                            //       enabledBorder: OutlineInputBorder(
                                            //         borderSide: BorderSide(
                                            //           width: 3,
                                            //           color: Colors.black,
                                            //         ), //<-- SEE HERE
                                            //       ),
                                            //       hintText: "Enter comment..",
                                            //       suffixIcon: IconButton(
                                            //         iconSize: 20,
                                            //         onPressed: () async {
                                            //           setState(() {
                                            //             isloading = true;
                                            //           });

                                            //           String userid = uid;
                                            //           String comment =
                                            //               commentcontroller.text;

                                            //           await addcommentpost(
                                            //               avatarphoto:
                                            //                   globalteacherdata
                                            //                       .userDetails[0]
                                            //                       .avatar,
                                            //               postid:
                                            //                   postelementlist[index]
                                            //                       .id,
                                            //               comment: comment,
                                            //               userid: userid);

                                            //           commentcontroller.text = "";

                                            //           setState(() {
                                            //             isloading = false;
                                            //           });

                                            //           final snackBar = SnackBar(
                                            //             behavior:
                                            //                 SnackBarBehavior.floating,
                                            //             margin: EdgeInsets.only(),
                                            //             backgroundColor: Colors.black,
                                            //             duration:
                                            //                 Duration(seconds: 1),
                                            //             dismissDirection:
                                            //                 DismissDirection
                                            //                     .horizontal,
                                            //             content: Container(
                                            //               height: 30,
                                            //               child: const Text(
                                            //                 'Comment added Sucessfully.',
                                            //                 style: TextStyle(),
                                            //               ),
                                            //             ),
                                            //           );

                                            //           ScaffoldMessenger.of(context)
                                            //               .hideCurrentSnackBar();

                                            //           ScaffoldMessenger.of(context)
                                            //               .showSnackBar(snackBar);
                                            //         },
                                            //         icon: isloading
                                            //             ? Container(
                                            //                 height: 20,
                                            //                 width: 20,
                                            //                 child:
                                            //                     CircularProgressIndicator(
                                            //                         color: Color
                                            //                             .fromRGBO(
                                            //                                 38,
                                            //                                 90,
                                            //                                 232,
                                            //                                 1)),
                                            //               )
                                            //             : ImageIcon(
                                            //                 AssetImage(
                                            //                     'assets/sent.png'),
                                            //                 color: Colors.black,
                                            //               ),
                                            //       ),
                                            //     ),
                                            //   ),
                                            // ),

                                            // ElevatedButton(
                                            //     onPressed: () async {
                                            //       String userid = uid;
                                            //       String comment =
                                            //           commentcontroller.text;

                                            //       await addcommentpost(
                                            //           postid:
                                            //               postlist[index].id,
                                            //           comment: comment,
                                            //           userid: userid);
                                            //     },
                                            //     child: Text("post comment")),

                                            // postlist[index].comments.isNotEmpty
                                            //     ? Container(
                                            //         height: 200,
                                            //         child: ListView.builder(
                                            //             itemCount:
                                            //                 commentlist.length,
                                            //             itemBuilder:
                                            //                 (context, ind) {
                                            //               return Column(
                                            //                 children: [
                                            //                   Row(
                                            //                     mainAxisAlignment:
                                            //                         MainAxisAlignment
                                            //                             .spaceBetween,
                                            //                     children: [
                                            //                       Text(commentlist[
                                            //                               ind]
                                            //                           .comment),
                                            //                       Text(commentlist[
                                            //                               ind]
                                            //                           .id),
                                            //                       TextButton(
                                            //                           onPressed:
                                            //                               () async {
                                            //                             // String
                                            //                             //     commentid =
                                            //                             //     ;
                                            //                             await deletecommentpost(
                                            //                                 postid:
                                            //                                     postlist[index].id,
                                            //                                 commentid: postlist[index].comments[ind].id,
                                            //                                 userid: postlist[index].comments[ind].user);

                                            //                             // print(index);
                                            //                           },
                                            //                           child:
                                            //                               Text(
                                            //                             "delete",
                                            //                             style: TextStyle(
                                            //                                 color:
                                            //                                     Colors.red),
                                            //                           ))
                                            //                     ],
                                            //                   ),
                                            //                 ],
                                            //               );
                                            //             }),
                                            //       )
                                            //     : Text("no comments"),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        }
                      }),
                ),
                //   } else {
                //     return Center(
                //       child: CircularProgressIndicator(),
                //     );
                //   }
                // }),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Future<List<Student>> getStudentdata() async {
  //   final response = await http
  //       .get(Uri.parse('https://easyed-backend.onrender.com/api/student'));
  //   var data = jsonDecode(response.body.toString());

  //   if (response.statusCode == 200) {
  //     for (Map<String, dynamic> index in data) {
  //       samplestudents.add(Student.fromJson(index));
  //     }
  //     return samplestudents;
  //   } else {
  //     return samplestudents;
  //   }
  // }

  void scrolllistener() {
    if (scrollcontroller.position.pixels ==
            scrollcontroller.position.maxScrollExtent &&
        page < postdata.totalPages) {
      page = page + 1;
      print("max extend scroll" + page.toString());
      setState(() {
        getpostdata();
      });
    } else if (scrollcontroller.position.pixels ==
            scrollcontroller.position.minScrollExtent &&
        page > 0) {
      // page = page - 1;
      print("max extend scroll" + page.toString());

      // setState(() {
      //   getpostdata();
      // });
    } else {
      print("Don't call");
    }
  }

  Future<void> refreshdata() async {
    await Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => ShowPostScreen()))
        .then((value) => onReturn());
  }

  Future addcommentpost(
      {required String avatarphoto,
      required String postid,
      required String comment,
      required String userid}) async {
    var response = await http.post(
      // Uri.https(
      //     'easyed-social-media-backend.onrender.com', '/comment/${postid}'),
      Uri.https('api.easyeduverse.tech', '/comment/${postid}'),
      headers: {'Content-Type': 'application/json'},
      // body: json.encode(sendData),
      body: json.encode(
          {"userId": userid, "comment": comment, "avatar": avatarphoto}),
    );

    var data = response.body;

    print(data);
  }

  Future deletecommentpost(
      {required String postid,
      required String commentid,
      required String userid}) async {
    print(commentid);
    print(postid);
    var response = await http.delete(
      // Uri.https('easyed-social-media-backend.onrender.com',
      //     '/comment/${postid}/${commentid}'),
      Uri.https('api.easyeduverse.tech', '/comment/${postid}/${commentid}'),
      headers: {'Content-Type': 'application/json'},
      // body: json.encode(sendData),
      body: json.encode({"userId": userid}),
    );

    var data = response.body;

    print(data);
  }

  Future unlikepost({required String postid, required String userid}) async {
    var response = await http.put(
      // Uri.https(
      //     'easyed-social-media-backend.onrender.com', '/unlike/${postid}'),
      Uri.https('api.easyeduverse.tech', '/unlike/${postid}'),
      headers: {'Content-Type': 'application/json'},
      // body: json.encode(sendData),
      body: json.encode({"userId": userid}),
    );

    var data = response.body;

    if (data.contains("msg")) {
      if (alreadynotlikedmessage ==
          jsonDecode(response.body.toString())["msg"]) {
        // print("object");
        isalreadyunliked = true;
        print("isalreadyunliked: " + isalreadyunliked.toString());
      }
    } else {
      isalreadyunliked = false;
    }

    print(data);
  }

  Future postaddlike({required String postid, required String userid}) async {
    var response = await http.put(
      // Uri.https('easyed-social-media-backend.onrender.com', '/like/${postid}'),
      Uri.https('api.easyeduverse.tech', '/like/${postid}'),
      headers: {'Content-Type': 'application/json'},
      // body: json.encode(sendData),
      body: json.encode({"userId": userid}),
    );

    var data = response.body;

    // print(jsonDecode(response.body.toString())["msg"]);
    if (data.contains("msg")) {
      if (alreadylikedmessage == jsonDecode(response.body.toString())["msg"]) {
        // print("object");
        isalreadyliked = true;
        print("isalreadyliked: " + isalreadyliked.toString());
      }
    } else {
      isalreadyliked = false;
    }

    print(data);
  }

  Future<Post> getpostdata() async {
    print("the getpost function calling  \n");
    final response = await http.get(
        // Uri.parse('https://easyed-social-media-backend.onrender.com/api/post'));
        Uri.parse('https://api.easyeduverse.tech/api/post?page=${page}'));

    print(page);
    var data = jsonDecode(response.body.toString());

    // print(data.toString());
    postdata.posts = [];
    if (response.statusCode == 200) {
      // for (Map<String, dynamic> index in data) {
      //   postlist.add(Post.fromJson(index));
      // }

      setState(() {
        postdata = Post.fromJson(data);

        postelementlist = postelementlist + postdata.posts;
      });

      print("the postelementlist length" + postelementlist.length.toString());
      print("the page number: " + page.toString());

      // print(sampleteachers.toString());
      // for (Map<String, dynamic> index in data) {
      //   sampleteachers.add(Teacher.fromJson(index));
      // }
      return postdata;
    } else {
      return postdata;
    }
  }

  Future<Post> getpostdataforlike({required int index}) async {
    print("the getpost function calling  \n");
    final response = await http.get(
        // Uri.parse('https://easyed-social-media-backend.onrender.com/api/post'));
        Uri.parse(
            'https://api.easyeduverse.tech/api/post?page=${caculatedpageindex}'));

    print(page);
    var data = jsonDecode(response.body.toString());

    // print(data.toString());
    postdata.posts = [];
    if (response.statusCode == 200) {
      // for (Map<String, dynamic> index in data) {
      //   postlist.add(Post.fromJson(index));
      // }
      int indexforpostdata = index;

      if (index > 9) {
        indexforpostdata = index % 10;
      }

      setState(() {
        postdata = Post.fromJson(data);

        postelementlist[index] = postdata.posts[indexforpostdata];
      });

      print("the postelementlist length" + postelementlist.length.toString());
      print("the page number: " + page.toString());

      // print(sampleteachers.toString());
      // for (Map<String, dynamic> index in data) {
      //   sampleteachers.add(Teacher.fromJson(index));
      // }
      return postdata;
    } else {
      return postdata;
    }
  }

  Stream<Post> getstreampostdata() async* {
    yield await getpostdata();
  }

  void showdownSheet({
    required BuildContext context,
    required int index1,
    required String postingid,
    required int pagenumber,
  }) {
    showModalBottomSheet(
      showDragHandle: true,
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
        top: Radius.circular(30),
      )),
      builder: (context) => DraggableScrollableSheet(
          initialChildSize: 0.8,
          maxChildSize: 0.9,
          minChildSize: 0.32,
          expand: false,
          builder: (context, scrollController) {
            return SingleChildScrollView(
              controller: scrollController,
              child: ModelSheetScreen(
                postingid: postingid,
                index1: index1 % 10,
                pagenumber: pagenumber,
              ),
            );
          }),
    );
  }
}
