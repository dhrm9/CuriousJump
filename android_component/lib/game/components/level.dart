// Importing necessary libraries
import 'dart:async';
import 'dart:math';

import 'package:android_component/audio/audio_manager.dart';
import 'package:android_component/database/database.dart';
import 'package:android_component/game/components/collision_block.dart';
import 'package:android_component/game/components/platforms.dart';
import 'package:android_component/game/components/player.dart';
import 'package:android_component/game/components/saw.dart';
import 'package:android_component/game/components/utils.dart';
import 'package:android_component/game/curious_jump.dart';
import 'package:android_component/models/question.dart';
import 'package:android_component/models/quiz.dart';
import 'package:flame/components.dart';
import 'package:flame_tiled/flame_tiled.dart';

// Define a class called Level which extends World and has a reference to the game
class Level extends World with HasGameRef<CuriousJump> {
  late TiledComponent level; // The tiled level component

  // Attributes
  final String levelName; // Name of the level
  final Player player; // Player object
  late Quiz quiz; // Quiz object
  int questionNumber = 0; // Number of the current question
  late List<int> questionIndexSet; // Set of indices of questions
  late TextBoxComponent questionText; // Text component for displaying questions
  late TextBoxComponent timerText; // Text component for displaying timer
  List<Component> options = []; // List of options for the quiz
  List<CollisionBlock> collisionBlocks = []; // List of collision blocks in the level
  List<Platform> platforms = []; // List of platforms in the level
  List<Saw> saws = []; // List of saws in the level
  late Timer timer; // Timer for the quiz
  final int allowedTime; // Allowed time for answering each question
  bool changeQuestion = false; // Flag to indicate whether to change the question
  bool loadingNewLevel = false; // Flag to indicate whether a new level is loading
  double remainingTime = 0; // Remaining time for the current question
  Random random = Random(); // Random number generator
  QuizType quizType; // Type of quiz
  QuizLevel quizLevel; // Level of the quiz

  // Constructor
  Level({
    required this.levelName,
    required this.player,
    required this.allowedTime,
    required this.quizType,
    required this.quizLevel
  });

  // Method called when the level is loaded
  @override
  FutureOr<void> onLoad() async {
    // Load quiz data from Firestore based on quiz type and level
    quiz = await Database.fetchQuizFromFirestore(Quiz.parseQuizType(quizType), Quiz.parseQuizLevel(quizLevel));

    // Generate a set of indices for questions
    questionIndexSet = List.generate(quiz.questions.length, (index) => index);

    // Load the tiled level
    level = await TiledComponent.load('$levelName.tmx', Vector2.all(16));
    add(level);

    // Add text components for displaying questions and timer
    _addTextComponents();

    // Spawn entities such as player and saws
    _spawnEntities();

    // Load collision blocks from the tiled level
    _loadCollisionBlocks();

    // Add overlays for pause button and sure button
    game.overlays.add('PauseButton');
    game.overlays.add('SureButton');

    // Start background music
    AudioManager.instance.startBgm('Bgm.wav');

    // Start the quiz
    reload();
    return super.onLoad();
  }

  // Method called to update the level
  @override
  void update(double dt) {
    super.update(dt);
    timer.update(dt);
    remainingTime = allowedTime - timer.progress * allowedTime;
    timerText.text = remainingTime.toStringAsFixed(1);
    
    // Check if the timer has finished and if a new level or question change is loading
    if (timer.finished && (!loadingNewLevel || !changeQuestion)) {
      loadingNewLevel = true;
      player.dontMove();

      // Move saws and check if a question change is required
      for (Saw saw in saws) {
        saw.move();
        if (saw.reachedTop) {
          changeQuestion = true;
        }
      }

      // If a question change is required, handle it
      if (changeQuestion) {
        if (player.onCorrectPlatform) {
          AudioManager.instance.playSfx('Correct.wav');
          questionText.textRenderer = correctAnswerFontStyle;
          questionText.text = "Correct Answer";
          game.correctAnswer += 1;
        } else {
          AudioManager.instance.playSfx('Wrong.wav');
          questionText.textRenderer = wrongAnswerFontStyle;
          questionText.text = "Wrong Answer";
          game.wrongAnswer += 1;
        }
        questionNumber += 1;
        questionNumber %= quiz.questions.length;
        Future.delayed(const Duration(milliseconds: 2000), () => reload());
      }
    }
  }

  // Method to set the remaining time
  void setRemainingTime(double newRem){
    remainingTime = newRem;
  }

  // Method to spawn entities such as player and saws
  void _spawnEntities() {
    final spawnPointLayer = level.tileMap.getLayer<ObjectGroup>('SpawnPoints');

    if (spawnPointLayer != null) {
      for (final spawnPoint in spawnPointLayer.objects) {
        switch (spawnPoint.class_) {
          case 'Player':
            player.position = Vector2(spawnPoint.x, spawnPoint.y);
            add(player);
            break;
          case 'Saw':
            final isVertical = spawnPoint.properties.getValue('isVertical');
            final offsetN = spawnPoint.properties.getValue('offsetN');
            final saw = Saw(
              isVertical: isVertical,
              offNeg: offsetN,
              position: Vector2(spawnPoint.x, spawnPoint.y),
              size: Vector2(spawnPoint.width, spawnPoint.height),
            );
            saws.add(saw);
            add(saw);
          default:
        }
      }
    }
  }

  // Method to reload the level or start a new question
  void reload() {
    if (questionIndexSet.isEmpty) {
      game.pauseEngine();
      game.overlays.add('GameOverMenu');
    } else {
      int randomIndex = random.nextInt(questionIndexSet.length);

      questionNumber = questionIndexSet[randomIndex];
      questionIndexSet.removeAt(randomIndex);

      Question question = quiz.questions[questionNumber];
      questionText.textRenderer = questionTextFontStyle;
      questionText.text = question.text;

      final optionList = question.options;

      for (int i = 0; i < optionList.length; i++) {
        if (quizType == QuizType.fruits) {
          (options[i] as SpriteComponent).sprite =
              Sprite(game.images.fromCache('Fruits/${optionList[i]}.png'));
        } else if (quizType == QuizType.animal) {
          (options[i] as SpriteComponent).sprite =
              Sprite(game.images.fromCache('Animals/${optionList[i]}.png'));
        } else if (quizType == QuizType.vegetables) {
          (options[i] as SpriteComponent).sprite =
              Sprite(game.images.fromCache('Vegetables/${optionList[i]}.png'));
        } else {
          (options[i] as TextBoxComponent).text = optionList[i];
        }
      }

      player.reset();

      for (int i = 0; i < saws.length; i++) {
        if (i == question.correctAnswer) {
          saws[i].reset(true);
          platforms[i].reset(true);
        } else {
          saws[i].reset(false);
          platforms[i].reset(false);
        }
      }
      timer = Timer(allowedTime.toDouble());
      changeQuestion = false;
      loadingNewLevel = false;
    }
  }

  // Method to add text components for displaying questions and timer
  void _addTextComponents() {
    final textLayer = level.tileMap.getLayer<ObjectGroup>('Texts');
    if (textLayer != null) {
      for (final text in textLayer.objects) {
        switch (text.class_) {
          case 'Question':
            questionText = TextBoxComponent(
              text: "",
              textRenderer: questionTextFontStyle,
              position: Vector2(text.x, text.y),
              size: Vector2(text.width, text.height),
              align: Anchor.center,
              boxConfig: TextBoxConfig(maxWidth: text.width),
            );
            add(questionText);
            break;
          case 'Options':
            dynamic option;
            if (quizType == QuizType.fruits ||
                quizType == QuizType.animal ||
                quizType == QuizType.vegetables) {
              option = SpriteComponent.fromImage(
                game.images.fromCache('Fruits/Apple.png'),
                position: Vector2(text.x, text.y),
              );
            } else {
              option = TextBoxComponent(
                text: "",
                textRenderer: optionTextFontStyle,
                position: Vector2(text.x, text.y),
                size: Vector2(text.width, text.height),
                align: Anchor.center,
                boxConfig: TextBoxConfig(maxWidth: text.width),
              );
            }

            add(option);
            options.add(option);
            break;
          case 'Timer':
            timerText = TextBoxComponent(
              text: "",
              textRenderer: questionTextFontStyle,
              position: Vector2(text.x, text.y),
              size: Vector2(text.width, text.height),
              align: Anchor.center,
              boxConfig: TextBoxConfig(maxWidth: text.width),
            );
            add(timerText);
          default:
        }
      }
    }
  }

  // Method to load collision blocks from the tiled level
  void _loadCollisionBlocks() {
    final collisionLayer = level.tileMap.getLayer<ObjectGroup>('Collisions');

    if (collisionLayer != null) {
      for (final collision in collisionLayer.objects) {
        switch (collision.class_) {
          case 'Platform':
            break;
          case 'CheckPoint':
            final platform = Platform(
                position: Vector2(collision.x, collision.y),
                size: Vector2(collision.width, collision.height));
            add(platform);
            platforms.add(platform);
            break;
          default:
            final block = CollisionBlock(
              position: Vector2(collision.x, collision.y),
              size: Vector2(collision.width, collision.height),
            );
            add(block);
            collisionBlocks.add(block);
            break;
        }
      }
    }
    player.collisionBlocks = collisionBlocks;
  }
}
