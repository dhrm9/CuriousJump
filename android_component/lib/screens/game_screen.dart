import 'package:android_component/game/components/utils.dart';
import 'package:android_component/game/pixel_adventure.dart';
import 'package:flame/game.dart';
import 'package:flutter/widgets.dart';

class GameScreen extends StatelessWidget {
  final bool isSoundOn;
  const GameScreen({super.key , this.isSoundOn = true});

  @override
  Widget build(BuildContext context) {
    return GameWidget<PixelAdventure>(
      game: PixelAdventure(isSoundOn: isSoundOn),
      overlayBuilderMap: const {
        'PauseButton': pauseButtonBuilder,
        'PauseMenu': pauseMenuBuilder,
        'GameOverMenu': gameOverMenuBuilder,
      },
    );
  }
}