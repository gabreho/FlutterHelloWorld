class Video {
  String videoId;
  String videoTitle;

  Video(String videoId, String videoTitle) {
    this.videoId = videoId;
    this.videoTitle = videoTitle;
  }

  String getVideoUrl() => "https://static.chorus.ai/api/${this.videoId}.mp4";
  String getTranscriptUrl() => "https://static.chorus.ai/api/${this.videoId}.json";

  static Video initialVideo() {
    return new Video("4d79041e-f25f-421d-9e5f-3462459b9934", "Moment from meeting with Two Pillars");
  }
}