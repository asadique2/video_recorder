import 'dart:io';

import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class VideoPreviewPage extends StatefulWidget {
  final String videoPath;

  const VideoPreviewPage({required this.videoPath});

  @override
  _VideoPreviewPageState createState() => _VideoPreviewPageState();
}

class _VideoPreviewPageState extends State<VideoPreviewPage> {
  late VideoPlayerController _controller;
  IconData _playbackIcon = Icons.play_arrow;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.file(File(widget.videoPath))
      ..initialize().then((_) {
        setState(() {});
      });

    _controller.addListener(() {
      if (_controller.value.position >= _controller.value.duration) {
        setState(() {
          _playbackIcon = Icons.replay;
        });
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Video Preview'),
      ),
      body: Center(
        child: _controller.value.isInitialized
            ? AspectRatio(
                aspectRatio: _controller.value.aspectRatio,
                child: VideoPlayer(_controller),
              )
            : const CircularProgressIndicator(),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.grey.withOpacity(.5),
        onPressed: () {
          if (_controller.value.position >= _controller.value.duration) {
            _controller.seekTo(Duration.zero);
          }
          setState(() {
            _controller.value.isPlaying
                ? _controller.pause()
                : _controller.play();
            _playbackIcon = _controller.value.isPlaying
                ? Icons.pause
                : (_controller.value.position >= _controller.value.duration)
                    ? Icons.replay
                    : Icons.play_arrow;
          });
        },
        child: Icon(
          _playbackIcon,
        ),
      ),
    );
  }
}
