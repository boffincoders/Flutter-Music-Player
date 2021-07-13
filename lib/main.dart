import 'package:audio_manager/audio_manager.dart';
import 'package:audio_player/song_list.dart';
import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'package:percent_indicator/percent_indicator.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Boffin Audio',
      theme: ThemeData(
        primarySwatch: Colors.grey,
      ),
      debugShowCheckedModeBanner: false,
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage>
    with SingleTickerProviderStateMixin {
  bool isPlaying = false;
  Duration? _duration;
  Duration? _position;
  double _sliderValue = 0;
  PlayMode playMode = AudioManager.instance.playMode;

  AnimationController? _controller;

  final list = [
    {
      "title": "Believer",
      "desc": "Jessy - Astron",
      "url": "assets/songs/believer.mp3",
      "coverUrl": "assets/images/be.jpg"
    },
    {
      "title": "Cherry Baby",
      "desc": "Cristian Tarcea - Erin Danet, Cristian Tarcea",
      "url": "assets/songs/cherry.mp3",
      "coverUrl": "assets/images/ch.jpg"
    },
    {
      "title": "Our Streets",
      "desc": "Dj Kantik",
      "url": "assets/songs/stress.mp3",
      "coverUrl": "assets/images/our.jpg"
    },
    {
      "title": "Dessert",
      "desc": "Dawin",
      "url": "assets/songs/dessert.mp3",
      "coverUrl": "assets/images/des.jpg"
    },
    {
      "title": "Lost in Love",
      "desc": "Akcent Music - Adrian Sina, Ackym, Tamy ",
      "url": "assets/songs/love.mp3",
      "coverUrl": "assets/images/lost.jpg"
    },
  ];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setupAudio();
    _controller =
        AnimationController(vsync: this, duration: Duration(seconds: 10))
          ..repeat();
  }

  @override
  void dispose() {
    AudioManager.instance.release();
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Audio Player",
            style: TextStyle(fontSize: 20.0, color: Colors.white)),
        centerTitle: true,
        flexibleSpace: Container(
            decoration: BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.topRight,
              colors: [
                Color(0xffA56169),
                Color(0xff83565A),
              ]),
        )),
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        padding: EdgeInsets.all(15.0),
        decoration: BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.topRight,
              colors: [
                Color(0xffA56169),
                Color(0xff83565A).withOpacity(.7),
              ]),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Container(
                height: 200.0,
                padding: EdgeInsets.all(10.0),
                child: playerHeader(),
                decoration: BoxDecoration(
                    gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.topRight,
                        colors: [
                          Color(0xff332e3f),
                          Color(0xff372c38),
                        ]),
                    borderRadius: BorderRadius.circular(20.0))),
            SizedBox(
              height: 20.0,
            ),
            Expanded(
              child: Container(
                padding: EdgeInsets.all(10.0),
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                decoration:
                    BoxDecoration(borderRadius: BorderRadius.circular(20.0)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Playlist (${list.length})",
                        style: TextStyle(fontSize: 20.0, color: Colors.white)),
                    SizedBox(
                      height: 10.0,
                    ),
                    Expanded(child: SongList(list)),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
      // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  double getAngle() {
    var value = _controller?.value ?? 0;
    return value * 2 * math.pi;
  }

  Widget playerHeader() => Row(
        children: [
          CircularPercentIndicator(
              radius: 130.0,
              percent: _sliderValue,
              progressColor: Color(0xffA56169),
              center: AnimatedBuilder(
                animation: _controller!,
                builder: (_, child) {
                  return Transform.rotate(
                    angle: getAngle(),
                    child: child,
                  );
                },
                child: ClipRRect(
                    borderRadius: BorderRadius.circular(60.0),
                    child: Image.asset(
                      AudioManager.instance.info?.coverUrl ??
                          "assets/images/disc.png",
                      width: 120.0,
                      height: 120.0,
                      fit: BoxFit.cover,
                    )),
              )),
          SizedBox(
            width: 5.0,
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  AudioManager.instance.info?.title ?? "Song Name",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 18.0, color: Colors.white),
                ),
                SizedBox(
                  height: 5.0,
                ),
                Text(
                  AudioManager.instance.info?.desc ?? "Artist Name",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16.0, color: Colors.white),
                ),
                SizedBox(
                  height: 10.0,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    CircleAvatar(
                      child: Center(
                        child: IconButton(
                            icon: Icon(
                              Icons.skip_previous,
                              color: Colors.white,
                            ),
                            onPressed: () {
                              AudioManager.instance.previous();
                            }),
                      ),
                      backgroundColor: Colors.cyan.withOpacity(0.3),
                    ),
                    Container(
                      width: 40.0,
                      height: 40.0,
                      decoration: BoxDecoration(
                          gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.topRight,
                              colors: [
                                Color(0xffA56169),
                                Color(0xff83565A),
                              ]),
                          borderRadius: BorderRadius.circular(20.0)),
                      child: Center(
                        child: IconButton(
                          onPressed: () async {
                            AudioManager.instance.playOrPause();
                          },
                          padding: const EdgeInsets.all(0.0),
                          icon: Icon(
                            AudioManager.instance.isPlaying
                                ? Icons.pause
                                : Icons.play_arrow,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    CircleAvatar(
                      backgroundColor: Colors.cyan.withOpacity(0.3),
                      child: Center(
                        child: IconButton(
                            icon: Icon(
                              Icons.skip_next,
                              color: Colors.white,
                            ),
                            onPressed: () {
                              AudioManager.instance.next();
                            }),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 10.0,
                ),
                _duration != null
                    ? Text(
                        _formatDuration(_duration!, _position!),
                        style: TextStyle(fontSize: 16.0, color: Colors.white),
                      )
                    : SizedBox(),
              ],
            ),
          )
        ],
      );

  String _formatDuration(Duration ds, Duration p) {
    if (ds == null || p == null) return "--:--";
    var d = ds - p;
    int minute = d.inMinutes;
    int second = (d.inSeconds > 60) ? (d.inSeconds % 60) : d.inSeconds;
    String format = ((minute < 10) ? "0$minute" : "$minute") +
        ":" +
        ((second < 10) ? "0$second" : "$second");
    print(p.inSeconds);
    print(ds.inSeconds);
    _sliderValue = (p.inSeconds / ds.inSeconds);
    return "Time Left: $format";
  }

  void setupAudio() {
    List<AudioInfo> _list = [];
    list.forEach((item) => _list.add(AudioInfo(item["url"]!,
        title: item["title"]!,
        desc: item["desc"]!,
        coverUrl: item["coverUrl"]!)));

    AudioManager.instance.audioList = _list;
    AudioManager.instance.intercepter = true;
    AudioManager.instance.play(auto: true);

    AudioManager.instance.onEvents((events, args) {
      switch (events) {
        case AudioManagerEvents.start:
          print(
              "start load data callback, curIndex is ${AudioManager.instance.curIndex}");
          _position = AudioManager.instance.position;
          _duration = AudioManager.instance.duration;
          setState(() {});
          break;
        case AudioManagerEvents.ready:
          print("ready to play");
          _position = AudioManager.instance.position;
          _duration = AudioManager.instance.duration;
          setState(() {});

          break;
        case AudioManagerEvents.seekComplete:
          _position = AudioManager.instance.position;
          setState(() {});
          print("seek event is completed. position is [$args]/ms");
          break;
        case AudioManagerEvents.buffering:
          print("buffering $args");
          break;
        case AudioManagerEvents.playstatus:
          isPlaying = AudioManager.instance.isPlaying;
          setState(() {});
          break;
        case AudioManagerEvents.timeupdate:
          _position = AudioManager.instance.position;
          setState(() {});
          AudioManager.instance.updateLrc(args["position"].toString());
          break;
        case AudioManagerEvents.error:
          setState(() {});
          break;
        case AudioManagerEvents.ended:
          AudioManager.instance.next();
          break;
        case AudioManagerEvents.volumeChange:
          setState(() {});
          break;
        default:
          break;
      }
    });
  }
}
