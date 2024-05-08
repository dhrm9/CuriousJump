import 'package:android_component/game/components/utils.dart';
import 'package:android_component/game/curious_jump.dart';
import 'package:android_component/models/player_data.dart';
import 'package:android_component/quiz/quiz.dart';
import 'package:flame/game.dart';
import 'package:flutter/widgets.dart';

class GameScreen extends StatelessWidget {
  final bool isSoundOn;
  final QuizLevel quizLevel;
  final QuizType quizType;
  final PlayerData playerData;
  const GameScreen({
    super.key,
    this.isSoundOn = true,
    required this.quizLevel,
    required this.quizType,
    required this.playerData,
  });

  @override
  Widget build(BuildContext context) {
    return GameWidget<CuriousJump>(
      game: CuriousJump(
        isSoundOn: isSoundOn,
        quizLevel: quizLevel,
        quizType: quizType,
        playerData: playerData,
      ),
      overlayBuilderMap: const {
        'PauseButton': pauseButtonBuilder,
        'PauseMenu': pauseMenuBuilder,
        'GameOverMenu': gameOverMenuBuilder,
        'SureButton': sureButtonBuilder,
      },
    );
  }
}
