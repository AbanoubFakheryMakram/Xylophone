import 'dart:io';

import 'package:flutter/material.dart';
import 'package:audioplayer/audioplayer.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';

void main() {
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]).then((_) {
    runApp(
      MaterialApp(
        title: 'Xylophone',
        debugShowCheckedModeBanner: false,
        home: MyHomePage(),
      ),
    );
  });
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  AudioPlayer player;

  @override
  void initState() {
    super.initState();
    player = AudioPlayer();
  }

  Future playSound(String soundName) async {
    await player.pause();
    await player.stop();
    final file = File('${(await getTemporaryDirectory()).path}/$soundName');
    await file.writeAsBytes((await loadAsset(soundName)).buffer.asUint8List());
    await player.play(file.path, isLocal: true);
  }

  Future loadAsset(String soundName) async {
    return await rootBundle.load('assets/$soundName');
  }

  Future stopSound() async {
    if (player.state == AudioPlayerState.PLAYING ||
        player.state == AudioPlayerState.PAUSED) {
      await player.stop();
    }
  }

  Future pauseSound() async {
    if (player.state == AudioPlayerState.PLAYING) {
      await player.pause();
    }
  }

  @override
  void dispose() {
    stopSound();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              getPiece(Colors.red, 'note1.wav'),
              getPiece(Colors.orange, 'note2.wav'),
              getPiece(Colors.yellow, 'note3.wav'),
              getPiece(Colors.green, 'note4.wav'),
              getPiece(Colors.teal, 'note5.wav'),
              getPiece(Colors.blue, 'note6.wav'),
              getPiece(Colors.purple, 'note7.wav'),
            ],
          ),
        ),
      ),
    );
  }

  Widget getPiece(color, soundName) {
    return Expanded(
        child: FlatButton(
      color: color,
      onPressed: () {
        playSound('$soundName');
      },
    ));
  }
}
