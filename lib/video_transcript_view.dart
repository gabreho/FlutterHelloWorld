import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:video_transcript_viewer/globals.dart';

import 'models/video.dart';
import 'play_button_widget.dart';

class VideoWidgetState extends State<VideoWidget> {
  Future<void> _initializeVideoPlayerFuture;

  VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.network(
        widget.video.getVideoUrl());

    _controller.addListener(() {
      setState(() {});
      if (widget.onPositionChanged != null && _controller.value.isPlaying) {
        widget.onPositionChanged(_controller.value.position.inMilliseconds / 1000.0);
      }
    });

    _initializeVideoPlayerFuture = _controller.initialize();

    _initializeVideoPlayerFuture.then((_) {
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: <Widget>[
      Center(
          child: Padding(
              padding: const EdgeInsets.fromLTRB(35, 0, 35, 0),
              child: GestureDetector(
                onTap: () {
                  _controller.value.isPlaying
                      ? _controller.pause()
                      : _controller.play();
                  setState(() {});
                },
                child: Stack(
                  alignment: Alignment.center,
                  children: <Widget>[
                    // FutureBuilder(
                    //   future: _initializeVideoPlayerFuture,
                    //   builder: (context, snapshot) {
                    //     if (snapshot.connectionState == ConnectionState.done) {
                    //       return AspectRatio(
                    //         aspectRatio: 16.0/9.0,//_controller.value.aspectRatio,
                    //         child: VideoPlayer(_controller),
                    //       );
                    //     } else {
                    //       return Center(child: CircularProgressIndicator());
                    //     }
                    //   },
                    // ),

                    AspectRatio(
                      aspectRatio: _controller.value.initialized ? Constants.defaultAspectRatio : _controller.value.aspectRatio,
                      child: _controller.value.initialized ? VideoPlayer(_controller) : Container(child: Center(child: CircularProgressIndicator()), color: ChorusColors.bakcgroundColor),
                    ),

                    _controller.value.initialized && !_controller.value.isPlaying ? Center(child: PlayButton()) : Container(),
                  ],
                ),
              ))),
    ]);
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }
}

class VideoWidget extends StatefulWidget {

  final Video video;
  final ValueChanged<double> onPositionChanged;

  VideoWidget({this.video, this.onPositionChanged});

  @override
  createState() => VideoWidgetState();
}
