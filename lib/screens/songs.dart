import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:musicapp/models/song_model.dart';
import 'package:musicapp/repository/songsclient.dart';

import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

import 'package:musicapp/screens/player.dart';

class Songs extends StatefulWidget {
  const Songs({Key? key}) : super(key: key);

  @override
  _SongsState createState() => _SongsState();
}

class _SongsState extends State<Songs> {
  AudioPlayer audioPlayer = AudioPlayer();
  List<SongModel> songs = [];
  List<Widget> widgets = [];
  bool isPlaying = false;
  bool isAllOk = false;
  TextEditingController tc = TextEditingController();
  String searchQuery = " ";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    songs = _getSongs();
  }

  //songs = _getSongs();

  List<SongModel> _getSongs({String singerName = "snoop dogg"}) {
    Future<http.Response> future = SongClient.getSongsBySingerName(singerName);
    // Success Result / Success Response (JSON String)
    future.then((value) {
      if (value.statusCode == 200) {
        print("all okay");
        isAllOk = true;
      }
      print(" Data is ${value.body.runtimeType}"); // string
      var obj = convert.jsonDecode(value.body); // string to object
      print("Result is ${obj['results']}");
      List<dynamic> list = obj['results'];
      songs = convertObjectIntoSongObjects(list);
      //print(obj['results'][3]['previewUrl']);
      //print(obj.runtimeType);
    }).
        // Fail Response (Network Error)
        catchError((err) => print("Error is $err"));
    return songs;
  }

  List<SongModel> convertObjectIntoSongObjects(List list) {
    // Convert object into song list
    songs = list.map((singleObject) {
      SongModel song = SongModel.fromMap(singleObject);
      return song;
    }).toList();
    widgets = printAllSongs();
    setState(() {});
    return songs;
  }

  _playPause(SongModel song) async {
    if (isPlaying) {
      await audioPlayer.pause();
    } else {
      int ch = await audioPlayer.play(song.audioURL!);
      print("CH $ch");
    }
    isPlaying = !isPlaying;
    song.isPlaying = isPlaying;

    setState(() {});
    print("######### IsPlaying $isPlaying ");
  }

  List<Widget> printAllSongs() {
    return songs.map((SongModel song) {
      print("IsPlaying $isPlaying");
      return ListTile(
        leading: InkWell(
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(builder: (_) {
                return Player(songs, songs.indexOf(song));
              }));
            },
            child: Image.network(song.imageURL!)),
        title: Text(
          song.trackName!,
          style: const TextStyle(color: Colors.white),
        ),
        subtitle:
            Text(song.artistName!, style: const TextStyle(color: Colors.white)),
        trailing: IconButton(
          onPressed: () {
            _playPause(song);
          },
          icon: Icon(
            (song.isPlaying ? Icons.pause : Icons.play_arrow),
            color: Colors.black,
            size: 30,
          ),
        ),
      );
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.cyanAccent,
      body: Visibility(
        visible: isAllOk,
        child: ListView.builder(
          itemBuilder: (_, int index) {
            return ListTile(
              leading: InkWell(
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(builder: (_) {
                      return Player(songs, index);
                    }));
                  },
                  child: Image.network(songs[index].imageURL!)),
              title: InkWell(
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(builder: (_) {
                    return Player(songs, index);
                  }));
                },
                child: InkWell(
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(builder: (_) {
                      return Player(songs, index);
                    }));
                  },
                  child: Text(
                    songs[index].trackName!,
                    style: const TextStyle(color: Colors.black),
                  ),
                ),
              ),
              subtitle: Text(songs[index].artistName!,
                  style: const TextStyle(color: Colors.black)),
              trailing: IconButton(
                onPressed: () {
                  _playPause(songs[index]);
                },
                icon: Icon(
                  (songs[index].isPlaying ? Icons.pause : Icons.play_arrow),
                  color: Colors.yellow,
                  size: 30,
                ),
              ),
            );
          },
          itemCount: songs.length,
        ),
        replacement: const Center(child: CircularProgressIndicator()),
      ),
      //body: SingleChildScrollView(child: Column(children: printAllSongs())),
      appBar: AppBar(
        elevation: 10,
        backgroundColor: Colors.cyanAccent,
        title: TextField(
            controller: tc,
            style: const TextStyle(
              fontSize: 20,
              color: Colors.black,
            ),
            onEditingComplete: () {
              searchQuery = tc.text;
              _getSongs(singerName: searchQuery);
              print(searchQuery);
              //setState(() {});
            },
            decoration: const InputDecoration(
                hintText: 'Search Artist by Name',
                hintStyle: TextStyle(color: Colors.black),
                fillColor: Colors.cyanAccent,
                filled: true,
                border: InputBorder.none,
                // OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                prefixIcon: Icon(
                  Icons.search,
                  color: Colors.black,
                ))),
      ),
    );
  }
}
