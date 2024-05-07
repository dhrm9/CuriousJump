import 'package:android_component/audio/audio_manager.dart';
import 'package:android_component/game/curious_jump.dart';
import 'package:android_component/screens/main_menu.dart';
import 'package:flame/components.dart';
import 'package:flutter/material.dart';

bool checkCollision(player, block) {
  final hitbox = player.hitbox;
  final playerX = player.position.x + hitbox.offsetX;
  final playerY = player.position.y + hitbox.offsetY;
  final playerWidth = hitbox.width;
  final playerHeight = hitbox.height;

  final blockX = block.x;
  final blockY = block.y;
  final blockWidth = block.width;
  final blockHeight = block.height;

  final fixedX = player.scale.x < 0
      ? playerX - (hitbox.offsetX * 2) - playerWidth
      : playerX;
  final fixedY = block.isPlatform ? playerY + playerHeight : playerY;

  return (fixedY < blockY + blockHeight &&
      fixedY + playerHeight > blockY &&
      fixedX < blockX + blockWidth &&
      fixedX + playerWidth > blockX);
}

final questionTextFontStyle = TextPaint(
  style: const TextStyle(
    fontFamily: 'Minecraftia',
    fontSize: 18,
    color: Colors.white,
  ),
);

final optionTextFontStyle = TextPaint(
  style: const TextStyle(
    fontFamily: 'Minecraftia',
    fontSize: 18,
    color: Colors.white,
  ),
);

final wrongAnswerFontStyle = TextPaint(
  style: const TextStyle(
    fontFamily: 'Minecraftia',
    fontSize: 30,
    color: Colors.red,
  ),
);

final correctAnswerFontStyle = TextPaint(
  style: const TextStyle(
    fontFamily: 'Minecraftia',
    fontSize: 30,
    color: Colors.green,
  ),
);

Widget pauseButtonBuilder(BuildContext context, CuriousJump game) {
  return IconButton(
    onPressed: () {
      AudioManager.instance.pauseBgm();
      game.pauseEngine();
      game.overlays.add('PauseMenu');
    },
    icon: Image.asset('assets/images/Menu/Buttons/Pause.png'),
  );
}

Widget sureButtonBuilder(BuildContext context, CuriousJump game) {
  return Positioned(
    top: 10,
    right: 10,
    child: IconButton(
      onPressed: () {
        // game.world1.setRemainingTime(0);
        game.world1.timer = Timer(0);
      },
      icon: Image.asset('assets/images/Menu/Buttons/Sure.png'),
    ),
  );
}

Widget pauseMenuBuilder(BuildContext context, CuriousJump game) {
  return Center(
    child: Card(
      color: Colors.black.withOpacity(0.8),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            "Paused",
            style: TextStyle(
              fontSize: 30.0,
              color: Colors.white,
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    onPressed: () {
                      AudioManager.instance.resumeBgm();
                      game.overlays.remove('PauseMenu');
                      game.resumeEngine();
                    },
                    icon: Image.asset('assets/images/Menu/Buttons/PlayN.png'),
                  ),
                  const Text(
                    "Resume",
                    style: TextStyle(
                      fontSize: 16.0,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    onPressed: () {
                      game.overlays.remove('PauseMenu');
                      game.overlays.add('GameOverMenu');
                    },
                    icon: Image.asset('assets/images/Menu/Buttons/Cross.png'),
                  ),
                  const Text(
                    "End",
                    style: TextStyle(
                      fontSize: 16.0,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    ),
  );
}

Widget gameOverMenuBuilder(BuildContext context, CuriousJump game) {
  return Center(
    child: Card(
      color: Colors.black.withOpacity(0.8),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            "Game Over",
            style: TextStyle(
              fontSize: 30.0,
              color: Colors.white,
            ),
          ),
          Text(
            "Correct Answer: ${game.correctAnswer}",
            style: const TextStyle(
              fontSize: 30.0,
              color: Colors.green,
            ),
          ),
          Text(
            "Wrong Answer: ${game.wrongAnswer}",
            style: const TextStyle(
              fontSize: 30.0,
              color: Colors.red,
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                onPressed: () {
                  game.overlays.remove('GameOverMenu');
                  AudioManager.instance.stopBgm();
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(
                      builder: (context) => const MainMenu(),
                    ),
                  );
                },
                icon: Image.asset('assets/images/Menu/Buttons/Home.png'),
              ),
            ],
          ),
        ],
      ),
    ),
  );
}
