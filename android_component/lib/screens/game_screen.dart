import 'package:android_component/game/components/utils.dart';
import 'package:android_component/game/curious_jump.dart';
import 'package:android_component/models/player_data.dart';
import 'package:android_component/models/quiz.dart';
import 'package:flame/game.dart';
import 'package:flutter/widgets.dart';

// Widget for displaying the game screen
class GameScreen extends StatelessWidget {
  final bool isSoundOn; // Flag to indicate whether sound is enabled
  final QuizLevel quizLevel; // Level of the quiz
  final QuizType quizType; // Type of the quiz
  final PlayerData playerData; // Player data
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
      // Instantiate the game widget with CuriousJump game
      game: CuriousJump(
        isSoundOn: isSoundOn,
        quizLevel: quizLevel,
        quizType: quizType,
        playerData: playerData,
      ),
      // Map of overlay builders for displaying various UI components
      overlayBuilderMap: const {
        'PauseButton': pauseButtonBuilder, // Builder for pause button
        'PauseMenu': pauseMenuBuilder, // Builder for pause menu
        'GameOverMenu': gameOverMenuBuilder, // Builder for game over menu
        'SureButton': sureButtonBuilder, // Builder for sure button
      },
    );
  }
}
