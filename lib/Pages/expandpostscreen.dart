import 'package:cached_network_image/cached_network_image.dart';
import 'package:easyed/video_player_item.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:insta_image_viewer/insta_image_viewer.dart';

class ExpandPOstS extends StatefulWidget {
  final bool iscurrentindexpostisavideo;
  final String decriptions;
  final String imageurl;
  final bool iscurrentposttextonly;
  final int index;
  const ExpandPOstS(
      {super.key,
      required this.decriptions,
      required this.imageurl,
      required this.iscurrentindexpostisavideo,
      required this.index,
      required this.iscurrentposttextonly});

  @override
  State<ExpandPOstS> createState() => _ExpandPOstSState();
}

class _ExpandPOstSState extends State<ExpandPOstS> {
  @override
  Widget build(BuildContext context) {
    double deviceheight = MediaQuery.of(context).size.height;
    double appbarheight = 45;

    double devicewidth = MediaQuery.of(context).size.width;
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // SizedBox(
            //   height: 200,
            // ),
            // Text(widget.iscurrentindexpostisavideo.toString() +
            //     widget.index.toString()),

            widget.iscurrentposttextonly
                ? SizedBox()
                : Container(
                    width: devicewidth,
                    height: 300.h,
                    child: widget.iscurrentindexpostisavideo
                        ? VideoPlayerItem(
                            videoUrl: widget.imageurl,
                          )
                        : InstaImageViewer(
                            disableSwipeToDismiss: true,
                            child: CachedNetworkImage(
                              imageUrl: widget.imageurl,
                              fit: BoxFit.fitWidth,
                              placeholder: (context, url) => Container(
                                  // color: Colors.red,
                                  height: 300,
                                  width: 600,
                                  child: Center(
                                      child: CircularProgressIndicator(
                                    color: Color.fromRGBO(38, 90, 232, 1),
                                  ))),
                              errorWidget: (context, url, error) =>
                                  const Icon(Icons.error),
                              fadeOutDuration: const Duration(seconds: 1),
                              fadeInDuration: const Duration(seconds: 3),
                            ),
                          ),
                  ),

            Row(
              children: [
                Padding(
                  padding: widget.iscurrentposttextonly
                      ? EdgeInsets.only(
                          top: 24.0.h,
                          bottom: 14.0.h,
                          left: 14.0.w,
                          right: 14.0.w)
                      : EdgeInsets.only(
                          top: 14.0.h,
                          bottom: 14.0.h,
                          left: 14.0.w,
                          right: 14.0.w),
                  child: Container(
                    height: widget.iscurrentposttextonly
                        ? deviceheight * 0.884
                        : deviceheight * 0.518,
                    // color: Colors.red,
                    width: devicewidth * 0.9,
                    child: SingleChildScrollView(
                      child: Text(
//                         '''Lorem ipsum dolor sit amet, consectetur adipiscing elit. Morbi faucibus elementum turpis, id lobortis nunc euismod ac. Sed quis eros non arcu vestibulum pharetra fermentum sed lacus. Donec at quam dignissim, tincidunt sem vel, luctus quam. Vestibulum blandit faucibus ligula, nec luctus massa blandit id. Maecenas sed tempor sem, non ultricies tellus. Nam a nunc orci. Integer libero mauris, molestie nec maximus id, viverra quis nisi. Sed quis laoreet sem. Curabitur id est non tellus iaculis tempus at vel nisi. Curabitur pulvinar et leo non facilisis. Etiam tristique enim vitae magna gravida, sed elementum felis rhoncus. Suspendisse ultrices est odio, non consequat nisl porta ac. Duis condimentum, leo id lobortis luctus, ante metus auctor felis, ut cursus dui odio a tellus. Donec eu tempor massa.

// In hac habitasse platea dictumst. Vivamus laoreet accumsan augue, vel maximus nisi venenatis cursus. Morbi varius semper sem vitae vehicula. Curabitur commodo, nisi ut vestibulum tempor, mi sapien suscipit lacus, vel cursus urna purus at neque. Proin a congue quam. Donec non auctor mauris, a venenatis erat. Pellentesque in commodo est. In porttitor risus et dui lacinia, et accumsan felis dictum. Proin magna purus, aliquet nec consectetur sed, rhoncus imperdiet ligula. Quisque a mauris interdum, aliquet augue ac, ultrices nisi. Integer metus erat, convallis non gravida eget, finibus eget elit.

// Aliquam eu tempus turpis. Donec ornare arcu sit amet nunc gravida, non bibendum ante gravida. Praesent nec ante sem. Suspendisse sagittis sodales magna, vitae consequat velit porttitor quis. Proin quis lectus augue. Maecenas ut leo ac enim euismod viverra sed sit amet nisi. Aliquam eu tincidunt dui, eget posuere risus. Sed laoreet id leo vitae lacinia. Nullam porta elit in ex tincidunt consequat. Aenean gravida tristique tortor ac venenatis. Suspendisse sollicitudin consectetur velit eu cursus. Mauris at risus diam. Sed ornare hendrerit felis vitae ullamcorper. Aenean porta neque in tellus pretium, vitae luctus massa imperdiet. Aliquam odio dui, elementum eu quam in, pretium varius ipsum.

// Suspendisse sed pellentesque ligula. Vestibulum et iaculis erat. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia curae; Donec ut enim sem. Aliquam erat volutpat. Morbi vitae tellus urna. Sed fringilla lectus auctor, gravida augue consequat, condimentum leo. Vivamus id commodo elit. In semper lobortis orci. Mauris a placerat erat. Nulla sodales est eu magna varius auctor. Morbi fermentum elit nec diam tristique tincidunt. In hac habitasse platea dictumst. Proin nisl mauris, euismod vitae nisi ac, lobortis fermentum lacus. Morbi sollicitudin odio at hendrerit eleifend.

// Vivamus ultrices nisi id tristique imperdiet. Mauris volutpat venenatis risus. Nullam venenatis, dolor sit amet luctus faucibus, velit nunc laoreet arcu, ut maximus turpis libero convallis orci. Proin sit amet justo sit amet ipsum ullamcorper ultricies quis non tortor. Fusce feugiat fringilla magna, sit amet ornare leo congue a. Etiam sollicitudin urna quam, sed ullamcorper sapien dictum quis. Curabitur posuere non lorem ut tincidunt. Donec at nisl ut mauris lacinia porta. Aliquam erat volutpat. Fusce dictum, quam sed feugiat semper, mi magna imperdiet felis, in ullamcorper leo felis et erat. Nunc lacinia nunc ut enim consequat sagittis.''',
                        widget.decriptions,
                        maxLines: null,
                        style: TextStyle(
                            color: Colors.black54,
                            fontFamily: 'Poppins',
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w600),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
