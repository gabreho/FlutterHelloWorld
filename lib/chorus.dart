import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:video_transcript_viewer/globals.dart';
import 'package:video_transcript_viewer/models/video.dart';
import 'package:video_transcript_viewer/transcript_list_view.dart';
import 'package:video_transcript_viewer/video_transcript_view.dart';

class ChorusState extends State<Chorus> {
  Video _video;
  double _videoPosition = 0.0;

  @override
  void initState() {
    super.initState();
    _video = Video.initialVideo();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: Strings.appName,
        theme: ThemeData(primaryColor: Colors.green),
        home: Scaffold(
          backgroundColor: Color.fromARGB(255, 247, 247, 247),
          body: Column(children: <Widget>[
            Expanded(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(35, 123, 35, 0),
                child: Container(
                  color: Colors.white,
                  child: Column(
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          Expanded(
                            child: Center(
                                child: Padding(
                              padding: const EdgeInsets.fromLTRB(18, 42, 18, 9),
                              child: Text(_video.videoTitle),
                            )),
                          )
                        ],
                      ),
                      Container(
                          child: VideoWidget(
                              video: _video,
                              onPositionChanged: (position) {
                                setState(() {
                                  _videoPosition = position;
                                });
                              })),
                      Expanded(
                          child: Container(
                        child: Container(
                          alignment: Alignment(-1.0, 0.0),
                          child: Column(
                            children: <Widget>[
                              TranscriptListView(
                                video: _video,
                                position: _videoPosition,
                              ),
                            ],
                          ),
                        ),
                      )),
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 103, bottom: 14),
              child: SvgPicture.asset('assets/images/chorus-logo.svg'),
            ),
            Container(
              color: ChorusColors.mainColor,
              height: 5,
            )
          ]),
        ));
  }
}

class Chorus extends StatefulWidget {
  @override
  createState() => ChorusState();
}
