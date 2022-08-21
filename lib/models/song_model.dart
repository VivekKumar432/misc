class SongModel {
  String? artistName;
  String? audioURL;
  String? imageURL;
  String? trackName;
  bool isPlaying = false;

  // Param Constructor (UnNamed)
  SongModel({this.artistName, this.audioURL, this.imageURL, this.trackName});

// Named Constructor
  factory SongModel.fromMap(Map<String, dynamic> map) {
    return SongModel(
      artistName: map['artistName'],
      audioURL: map['previewUrl'],
      trackName: map['collectionName'],
      imageURL: map['artworkUrl100'],
    );
    // get obj and fill the song values
  }
}
