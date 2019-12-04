import 'dart:ui';

import 'package:video_transcript_viewer/globals.dart';

class TranscriptSnippet {
  String snippet;   // the words they spoke
  String speaker;   // This is the name of the speaker 
  double time;      // Time in the call when utterance happened.

  TranscriptSnippet(String snippet, String speaker, double time) {
    this.snippet = snippet;
    this.speaker = speaker;
    this.time = time;
  }

  Color getColor() {
    return this.speaker == "Cust" ? ChorusColors.customerColor : ChorusColors.repColor;
  }
}