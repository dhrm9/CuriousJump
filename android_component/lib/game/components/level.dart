import 'dart:async';

import 'package:android_component/game/components/collision_block.dart';
import 'package:android_component/game/components/platforms.dart';
import 'package:android_component/game/components/player.dart';
import 'package:android_component/game/components/saw.dart';
import 'package:android_component/game/components/utils.dart';
import 'package:android_component/game/pixel_adventure.dart';
import 'package:android_component/quiz/question.dart';
import 'package:android_component/quiz/quiz.dart';
import 'package:android_component/quiz/quiz_reader.dart';
import 'package:flame/components.dart';
import 'package:flame_tiled/flame_tiled.dart';

class Level extends World with HasGameRef<PixelAdventure>{
  late TiledComponent level;

  final String levelName;
  final Player player;
  late Quiz quiz;
  int questionNumber = 0;
  late TextBoxComponent questionText;
  List<TextBoxComponent> options = [];
  List<CollisionBlock> collisionBlocks = [];
  List<Platform> platforms = [];
  List<Saw> saws = [];

  Level({required this.levelName, required this.player});

  @override
  FutureOr<void> onLoad() async {
    quiz = await QuizReader.readJson("assets/quiz/quiz.json");

    level = await TiledComponent.load('$levelName.tmx', Vector2.all(16));

    add(level);

    _addTextComponents();
    _spawnEntities();

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
    game.overlays.add('PauseButton');
    reload();
    return super.onLoad();
  }

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

  void reload() {
    Question question = quiz.questions[questionNumber];
    questionText.textRenderer = questionTextFontStyle;
    questionText.text = question.text;

    final optionList = question.options;

    for (int i = 0; i < optionList.length; i++) {
      options[i].text = optionList[i];
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

    Future.delayed(const Duration(milliseconds: 10000), () {
      player.dontMove();
      for (Saw saw in saws) {
        saw.move();
      }
      questionNumber += 1;
      questionNumber %= quiz.questions.length;
      Future.delayed(const Duration(milliseconds: 3000), () {
        if (player.onCorrectPlatform) {
          questionText.textRenderer = correctAnswerFontStyle;
          questionText.text = "Correct Answer";
        } else {
          questionText.textRenderer = wrongAnswerFontStyle;
          questionText.text = "Wrong Answer";
        }
        Future.delayed(const Duration(milliseconds: 2000), () => reload());
      });
    });
  }

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
            final option = TextBoxComponent(
              text: "",
              textRenderer: optionTextFontStyle,
              position: Vector2(text.x, text.y),
              size: Vector2(text.width, text.height),
              align: Anchor.center,
              boxConfig: TextBoxConfig(maxWidth: text.width),
            );
            add(option);
            options.add(option);
            break;
          default:
        }
      }
    }
  }
  
  
}
