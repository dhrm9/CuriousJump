import 'package:android_component/game/components/utils.dart';
import 'package:android_component/game/pixel_adventure.dart';
import 'package:flame/flame.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Flame.device.fullScreen();
  await Flame.device.setLandscape();

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
      home: const MyHomePage(title: 'Pixel Adventure'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  final String title;
  const MyHomePage({super.key, required this.title});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late FlameGame game;

  @override
  void initState() {
    super.initState();
    game = PixelAdventure();
  }

  @override
  Widget build(BuildContext context) {
    return GameWidget<PixelAdventure>(
      game: PixelAdventure(),
      overlayBuilderMap: const {
        'PauseButton': pauseButtonBuilder,
        'PauseMenu': pauseMenuBuilder,
        'GameOverMenu': gameOverMenuBuilder,
      },
    );
  }
}
