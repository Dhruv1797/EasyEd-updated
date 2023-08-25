// import 'package:cached_video_player/cached_video_player.dart';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:chewie/chewie.dart';
import 'package:video_player/video_player.dart';

class VideoPlayerFileItem extends StatefulWidget {
  final File? videofile;
  const VideoPlayerFileItem({
    Key? key,
    this.videofile,
  }) : super(key: key);

  @override
  State<VideoPlayerFileItem> createState() => _VideoPlayerFileItemState();
}

class _VideoPlayerFileItemState extends State<VideoPlayerFileItem> {
  late VideoPlayerController videoPlayerController;

  late ChewieController chewieController;

  // late CachedVideoPlayerController videoPlayerController;
  bool isPlay = false;

  @override
  void initState() {
    super.initState();

    videoPlayerController = VideoPlayerController.file(
      widget.videofile!,
    )..initialize().then((value) {
        videoPlayerController.setVolume(1);
      });
    // videoPlayerController = CachedVideoPlayerController.network(widget.videoUrl)
    //   ..initialize().then((value) {
    //     videoPlayerController.setVolume(1);
    //   });

    chewieController = ChewieController(
      placeholder: Container(
          color: Colors.black,
          height: 300,
          width: 400,
          child: Center(
              child: CircularProgressIndicator(
            color: Color.fromRGBO(208, 56, 193, 1),
          ))),

      draggableProgressBar: true,

      videoPlayerController: videoPlayerController,
      // autoPlay: true,
      // looping: true,
    );
  }

  @override
  void dispose() {
    videoPlayerController.dispose();
    chewieController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 300,
      width: 400,
      child: Stack(
        children: [
          Chewie(controller: chewieController),
          Align(
            alignment: Alignment.center,
            child: TextButton(
              child: SizedBox(
                height: 0.001,
                width: 0.001,
              ),
              onPressed: () {
                if (isPlay) {
                  videoPlayerController.pause();
                } else {
                  videoPlayerController.play();
                }

                setState(() {
                  isPlay = !isPlay;
                });
              },
              // icon: Icon(
              //   isPlay ? Icons.pause_circle : Icons.play_circle,
              // ),
            ),
          ),
        ],
      ),
    );
  }
}
