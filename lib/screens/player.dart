import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:musicapp/models/song_model.dart';

class Player extends StatefulWidget {
  List<SongModel> songModel;
  int pos;
  Player(this.songModel, this.pos);

  @override
  _PlayerState createState() => _PlayerState();
}

class _PlayerState extends State<Player> {
  AudioPlayer _audioPlayer = AudioPlayer();
  bool isPlay = false;
  bool end = false;
  bool begin = false;

  bool shuffle = false;
  late Duration _duration = Duration(seconds: 0);
  late Duration _position = Duration(seconds: 0); // null
  int elapsed = 0;
  String message = "";
  List<SongModel> songs = [];
  int count = 1;

  _registerEvents() {
    // Total Audio Time
    _audioPlayer.onDurationChanged.listen((Duration d) {
      print('Max duration: $d');
      setState(() => _duration = d);
    });

    // Current Time
    _audioPlayer.onAudioPositionChanged.listen((Duration p) {
      setState(() => _position = p);
    });
    // Status of the Song.
    _audioPlayer.onPlayerStateChanged.listen((PlayerState s) {
      print('Current player state: $s');
      setState(() => message = s.name);
    });
    // Song Finish
    _audioPlayer.onPlayerCompletion.listen((event) {
      setState(() {
        message = "Song Finish";
        isPlay = false;
        _position = _duration;
      });
    });
    // _timer() {
    //   if (_position.inSeconds > 15) {
    //     return elapsed++;
    //   }
    // }
  }

  _timer(elap) {
    if (elap > 10 * count) {
      //elapsed++;
      count++;
      return true;
    } else {
      return false;
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _registerEvents();
  }

  @override
  Widget build(BuildContext context) {
    Size deviceSize = MediaQuery.of(context).size;
    return Scaffold(
      //
      //backgroundColor: Colors.cyanAccent,
      // appBar: AppBar(
      //   backgroundColor: Colors.transparent,
      //   elevation: 0,
      // ),
      body: Column(children: [
        Container(
          child: Column(children: [
            const SizedBox(height: 25),
            _backButton(context),
            _circleImage(),
          ]),
          decoration: const BoxDecoration(
            //image: DecorationImage(image: NetworkImage(widget.songModel[widget.pos].imageURL)),

            gradient: LinearGradient(
                colors: [Colors.cyanAccent, Colors.blueAccent],
                begin: Alignment.centerLeft,
                end: Alignment.centerRight),
          ),
          height: deviceSize.height / 2,
        ),
        Expanded(
          child: Container(
              padding: EdgeInsets.all(20),
              height: 200,
              child: Column(
                children: [
                  const Text(
                    "Now Playing...",
                    style: TextStyle(
                      fontSize: 20,
                      color: Color.fromARGB(255, 40, 208, 231),
                    ),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  Text(
                    widget.songModel[widget.pos].trackName!,
                    style: const TextStyle(
                      fontSize: 25,
                      color: Color.fromARGB(255, 34, 162, 162),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Divider(
                    thickness: 1.5,
                    height: 8,
                    color: Color.fromARGB(255, 194, 228, 228),
                  ),
                  Row(children: [
                    const Text(
                      "Singer :",
                      style: TextStyle(
                        fontSize: 25,
                        color: Color.fromARGB(255, 6, 142, 160),
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Expanded(
                      flex: 1,
                      child: Container(
                        child: Text(
                          widget.songModel[widget.pos].artistName!,
                          style: TextStyle(
                              fontSize: 25,
                              color: Color.fromARGB(255, 33, 148, 161)),
                        ),
                      ),
                    ),
                  ]),
                ],
              )),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: EdgeInsets.all(5),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(elapsed.toString() +
                    (_timer(_position.inSeconds)
                        ? count.toString()
                        : elapsed.toString()) +
                    // ((_position.inSeconds > 15) ? (elapsed++) : elapsed)
                    //     .toString() +
                    ":" +
                    ((_position.inSeconds > 9)
                        ? _position.inSeconds.toString()
                        : elapsed.toString() + _position.inSeconds.toString())),
              ),
              Expanded(flex: 1, child: seekBar()),
              Container(
                padding: EdgeInsets.all(5),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(elapsed.toString() +
                    elapsed.toString() +
                    ":" +
                    (_duration.inSeconds).toInt().toString()),
              )
            ],
          ),
        ),
        _audioControls(),
        SizedBox(height: 20),
        Text(
          message,
          style: TextStyle(fontSize: 20),
        )
      ]),
    );
  }

  Container _audioControls() {
    return Container(
      width: 300,
      height: 80,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          IconButton(
              splashColor: Colors.cyanAccent,
              iconSize: 50,
              padding: EdgeInsets.zero,
              onPressed: () {
                end = false;
                if (widget.pos > 0) {
                  widget.pos = widget.pos - 1;
                  _audioPlayer.play(widget.songModel[widget.pos].audioURL!);
                  if (isPlay) {
                  } else {
                    isPlay = !isPlay;
                  }
                  setState(() {});
                }
                if (widget.pos == 0) {
                  null;
                  begin = true;
                }

                setState(() {});
              },
              icon: Icon(
                begin ? Icons.fast_rewind : Icons.fast_rewind,
                color: begin ? Colors.cyanAccent.shade100 : Colors.cyanAccent,
                //color: Colors.red,
              )),
          IconButton(
              splashColor: Colors.cyanAccent,
              iconSize: 80,
              padding: EdgeInsets.zero,
              onPressed: () async {
                if (isPlay) {
                  await _audioPlayer.pause();
                } else {
                  await _audioPlayer
                      .play(widget.songModel[widget.pos].audioURL!);
                }
                isPlay = !isPlay;
                setState(() {});
              },
              //alignment: Alignment.center,
              icon: Icon(
                isPlay ? Icons.pause_circle_filled : Icons.play_circle_fill,
                color: Colors.cyanAccent,
                //size: 80,
              )),
          IconButton(
              splashColor: Colors.cyanAccent,
              iconSize: 50,
              padding: EdgeInsets.zero,
              onPressed: () {
                begin = false;
                if (widget.pos < widget.songModel.length - 1) {
                  widget.pos = widget.pos + 1;
                  _audioPlayer.play(widget.songModel[widget.pos].audioURL!);
                  if (isPlay) {
                  } else {
                    isPlay = !isPlay;
                  }
                  setState(() {});
                }
                if (widget.pos == widget.songModel.length - 1) {
                  null;
                  end = true;
                }
              },
              icon: Icon(
                end ? Icons.fast_forward : Icons.fast_forward,
                color: end ? Colors.cyanAccent.shade100 : Colors.cyanAccent,
              ))
        ],
      ),
    );
  }

  CircleAvatar _circleImage() {
    return CircleAvatar(
      maxRadius: 150,
      backgroundImage: NetworkImage(widget.songModel[widget.pos].imageURL!),
    );
  }

  Row _backButton(BuildContext context) {
    return Row(
      children: [
        IconButton(
          onPressed: () {
            Navigator.of(context).pop();
            _audioPlayer.pause();
          },
          icon: const Icon(
            Icons.arrow_back,
            size: 30,
          ),
          color: Colors.black,
        ),
        const SizedBox(
          height: 40,
          width: 100,
        ),
      ],
    );
  }

  Slider seekBar() {
    return Slider(
      value: (_position != null &&
              _duration != null &&
              _position.inMilliseconds < _duration.inMilliseconds)
          ? _position.inMilliseconds / _duration.inMilliseconds
          : 0.0,
      onChanged: (double currentValue) {
        print("Current Value $currentValue");
        if (_position != null) {
          int poistion = (currentValue * _duration.inMilliseconds).toInt();
          print("Pos $poistion");
          _audioPlayer.seek(Duration(milliseconds: poistion.round()));
        }
      },
      thumbColor: Colors.cyan.shade300,
      activeColor: Colors.cyanAccent,
      inactiveColor: Colors.cyan.shade200,
    );
  }
}
