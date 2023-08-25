import 'package:flutter/material.dart';
import 'package:easyed/video_player_item.dart';

class VideoPlayerScreen extends StatefulWidget {
  final String videourl;
  const VideoPlayerScreen({super.key, required this.videourl});

  @override
  State<VideoPlayerScreen> createState() => _VideoPlayerScreenState();
}

class _VideoPlayerScreenState extends State<VideoPlayerScreen> {
  @override
  Widget build(BuildContext context) {
    return VideoPlayerItem(
      videoUrl: widget.videourl,
    );
  }
}
