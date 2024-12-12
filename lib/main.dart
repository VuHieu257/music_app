import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:just_audio/just_audio.dart';
import 'package:music_app/pages/layout/bottom_navigation_bar/bottom_navigation_bar.dart';
import 'package:music_app/pages/screens/musicplayerscreen/provider.dart';
import 'package:music_app/pages/screens/sign_In/sign_in.dart';
import 'package:music_app/themeprovider.dart';
import 'package:provider/provider.dart';
import 'dart:io';
import 'package:flutter/foundation.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  options: kIsWeb ||Platform.isAndroid?
  await Firebase.initializeApp(
    // name:"b-idea-b5e02",
      options: const FirebaseOptions(
          apiKey: 'AIzaSyCNbo2_xo8CEgU-c39RlIjyWQnj7HGDqNg',
          appId: '1:641383178154:android:cae2793a4aeaeb042215d3',
          messagingSenderId: '641383178154',
          projectId: 'academy-app-400f3',
          storageBucket: "academy-app-400f3.appspot.com"
      )) :
  await Firebase.initializeApp();
  runApp(
    MultiProvider(providers: [
      ChangeNotifierProvider(create: (_) => ThemeProvider(),),
      ChangeNotifierProvider(create: (_) => MusicPlayerProvider(),),
      ],  child: const MyApp(),),
  );
}
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
        builder: (context, themeProvider, child) {
          return MaterialApp(
            title: 'Flutter Demo',
            theme: themeProvider.themeData,
            debugShowCheckedModeBanner: false,
            home: const BottomNavigaBar(), // Màn hình chính của bạn
            // home: const SignIn(),
            // home: const IntroductionAnimationScreen(),
    );
        });
  }
}

class MP3Player extends StatefulWidget {
  const MP3Player({super.key});

  @override
  _MP3PlayerState createState() => _MP3PlayerState();
}

class _MP3PlayerState extends State<MP3Player> {
  AudioPlayer audioPlayer = AudioPlayer();
  FlutterTts flutterTts = FlutterTts();
  bool isPlaying = false;

  // Lời bài hát tương ứng
  final String lyrics = "Đây là lời bài hát...";

  @override
  void initState() {
    super.initState();
  }

  Future<void> playMusic() async {
    // await audioPlayer.setUrl(url); // Thay đổi đường dẫn đến file MP3 của bạn
    setState(() {
      isPlaying = true;
    });
    await flutterTts.speak(lyrics); // Đọc lời bài hát
  }

  Future<void> stopMusic() async {
    await audioPlayer.stop();
    setState(() {
      isPlaying = false;
    });
    await flutterTts.stop(); // Dừng đọc lời bài hát
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('MP3 Player'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              lyrics,
              style: TextStyle(fontSize: 24),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: isPlaying ? stopMusic : playMusic,
              child: Text(isPlaying ? 'Dừng' : 'Phát'),
            ),
          ],
        ),
      ),
    );
  }
}


