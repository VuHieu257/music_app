import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:music_app/pages/screens/sign_In/sign_in.dart';
import 'package:music_app/themeprovider.dart';
import 'package:provider/provider.dart';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'music_player.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  options: kIsWeb ||Platform.isAndroid?
  await Firebase.initializeApp(
    // name:"b-idea-b5e02",
      options: const FirebaseOptions(
          apiKey: 'AIzaSyCEb8jbsXZPmRXtaEbai3qvEzxH5iPVDrU',
          appId: '1:50895062845:android:e70bc79e1d967de47fe754',
          messagingSenderId: '50895062845',
          projectId: 'music-app-9016e',
          storageBucket: "music-app-9016e.appspot.com"
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
            // home: const BottomNavigaBar(), // Màn hình chính của bạn
            home: const SignIn(),
            // home: const IntroductionAnimationScreen(),
    );
        });
  }
}

