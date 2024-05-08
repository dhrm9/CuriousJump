import 'package:android_component/audio/audio_manager.dart';
import 'package:android_component/firebase_options.dart';
import 'package:android_component/models/player_data.dart';
import 'package:android_component/screens/start_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flame/flame.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await Hive.initFlutter();
  Hive.registerAdapter(PlayerDataAdapter());
  await Hive.openBox<PlayerData>('playerData');

  await Flame.device.fullScreen();
  await Flame.device.setLandscape();
  AudioManager.instance.init([
    'Bgm.wav',
    'Click.wav',
    'Correct.wav',
    'Hit.wav',
    'Jump.wav',
    'Wrong.wav'
  ]);

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
      home: const StartScreen(),
    );
  }
}
