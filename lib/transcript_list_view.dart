import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:video_transcript_viewer/globals.dart';
import 'package:video_transcript_viewer/models/transcript_snippet.dart';
import 'package:video_transcript_viewer/models/video.dart';
import 'package:http/http.dart' as http;

class TranscriptListViewState extends State<TranscriptListView> {
  var _allTranscriptSnippets = <TranscriptSnippet>[];

  var _currentSnippets = 0;

  ScrollController _scrollController = new ScrollController();
  @override
  void initState() {
    super.initState();
    _loadData();
  }

  void _loadData() async {
    String dataURL = widget.video.getTranscriptUrl();
    http.Response response = await http.get(dataURL);
    setState(() {
      final transcriptsJSON = json.decode(response.body);

      for (var transcriptJSON in transcriptsJSON) {
        final transcript = TranscriptSnippet(transcriptJSON["snippet"],
            transcriptJSON["speaker"], transcriptJSON["time"]);

        _allTranscriptSnippets.add(transcript);
      }
      _allTranscriptSnippets.sort((a, b) => a.time.compareTo(b.time));
    });
  }

  bool _isSameSpeakerThanPrev(int i) {
    if (i == 0) {
      return false;
    }
    TranscriptSnippet transcript = _allTranscriptSnippets[i];
    TranscriptSnippet prevTranscript = _allTranscriptSnippets[i - 1];
    return transcript.speaker == prevTranscript.speaker;
  }

  Widget _buildRow(int i) {
    TranscriptSnippet transcript = _allTranscriptSnippets[i];
    Color indicatorColor = transcript.getColor();
    bool isSameSpeakerThanPrev = _isSameSpeakerThanPrev(i);
    bool isLastSnippet = i == _currentSnippets - 1;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Row(
          children: <Widget>[
            Column(
              children: <Widget>[
                !isLastSnippet
                    ? Container(
                        width: 24,
                        height: 24,
                        margin: EdgeInsets.only(left: 12.0))
                    : Container(
                        margin: EdgeInsets.only(left: 12.0),
                        width: 24,
                        height: 24,
                        decoration: BoxDecoration(
                          color: indicatorColor.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: indicatorColor),
                        ),
                      ),
              ],
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(13, 0, 13, 7),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    isSameSpeakerThanPrev
                        ? Container()
                        : Padding(
                            padding: const EdgeInsets.only(bottom: 9),
                            child: Text(transcript.speaker),
                          ),
                    Container(
                      margin: EdgeInsets.fromLTRB(0, 0, 0, 0),
                      decoration: new BoxDecoration(
                          borderRadius: new BorderRadius.all(
                            new Radius.circular(8.0),
                          ),
                          color: ChorusColors.bakcgroundColor),
                      padding: new EdgeInsets.fromLTRB(10.0, 13.0, 9.0, 10.0),
                      child: Text(transcript.snippet +
                          " Lorem ipsuon balbal abrfaug haorfh aiuefh aef fa"),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  void _scrollToBottom() {
    _scrollController.animateTo(_scrollController.position.maxScrollExtent,
        duration: Duration(milliseconds: 500), curve: Curves.easeOut);
  }

  @override
  Widget build(BuildContext context) {
    var newCount = _allTranscriptSnippets
        .where((t) => t.time < widget.position)
        .toList()
        .length;
    if (newCount != _currentSnippets) {
      _currentSnippets = newCount;

      WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToBottom());
    }

    var expanded = Expanded(
      child: Container(
        child: ListView.builder(
            controller: _scrollController,
            itemCount: _currentSnippets,
            itemBuilder: (BuildContext context, int pos) {
              return _buildRow(pos);
            }),
      ),
    );
    return expanded;
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }
}

class TranscriptListView extends StatefulWidget {
  final Video video;
  final double position;

  TranscriptListView({Key key, @required this.video, @required this.position})
      : super(key: key);

  @override
  TranscriptListViewState createState() => TranscriptListViewState();
}
