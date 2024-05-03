import 'package:android_component/audio/audio_manager.dart';
import 'package:android_component/screens/main_menu.dart';
import 'package:flame/flame.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Flame.device.fullScreen();
  await Flame.device.setLandscape();
  AudioManager.instance.init(['Bgm.wav' , 'Click.wav' , 'Correct.wav' , 'Hit.wav' , 'Jump.wav' , 'Wrong.wav']);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pixel Adventure',
      theme: ThemeData(
        fontFamily: 'Minecraftia',
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: const MainMenu(),
    );
  }
}