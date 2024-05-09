import 'package:android_component/audio/audio_manager.dart';
import 'package:android_component/database/firebase_options.dart';
import 'package:android_component/models/player_data.dart';
import 'package:android_component/screens/start_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flame/flame.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';

void main() async {
  // Ensure Flutter bindings are initialized
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Initialize Hive for local storage
  await Hive.initFlutter();
  Hive.registerAdapter(PlayerDataAdapter());
  await Hive.openBox<PlayerData>('playerData');

  // Set up Flame for game development
  await Flame.device.fullScreen();
  await Flame.device.setLandscape();

  // Initialize audio manager and load game sounds
  AudioManager.instance.init([
    'Bgm.wav',
    'Click.wav',
    'Correct.wav',
    'Hit.wav',
    'Jump.wav',
    'Wrong.wav'
  ]);

  // Run the Flutter app
  runApp(const MyApp());
}

// Main application widget
class MyApp extends StatelessWidget {
  const MyApp({Key? key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Curious Jump',
      theme: ThemeData(
        fontFamily: 'Minecraftia',
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: const StartScreen(),
    );
  }
}
