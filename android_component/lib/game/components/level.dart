import 'dart:async';

import 'package:android_component/game/components/collision_block.dart';
import 'package:android_component/game/components/player.dart';
import 'package:android_component/game/components/saw.dart';
import 'package:android_component/quiz/quiz.dart';
import 'package:android_component/quiz/quiz_reader.dart';
import 'package:flame/components.dart';
import 'package:flame_tiled/flame_tiled.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';

class Level extends World {
  late TiledComponent level;

  final String levelName;
  final Player player;
  late Quiz quiz;
  int questionNumber = 0;
  late TextComponent questionText;
  List<CollisionBlock> collisionBlocks = [];
  List<Saw> saws = [];

  Level({required this.levelName, required this.player});

  final fontStyle = TextPaint(style: const TextStyle(fontSize: 30  , color: Colors.white));

  @override
  FutureOr<void> onLoad() async {
    quiz = await QuizReader.readJson("assets/quiz/quiz.json");

    level = await TiledComponent.load('$levelName.tmx', Vector2.all(16));

    add(level);

    questionText = TextComponent(text:"" , textRenderer: fontStyle , position: Vector2(100 ,100));
    add(questionText);
    _spawnEntities();

    final collisionLayer = level.tileMap.getLayer<ObjectGroup>('Collisions');

    if (collisionLayer != null) {
      for (final collision in collisionLayer.objects) {
        switch (collision.class_) {
          case 'Platform':
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

  void reload(){
    questionText.text = quiz.questions[questionNumber].text;
    player.reset();

    for(Saw saw in saws){
      saw.reset(false);
    }

    Future.delayed(const Duration(milliseconds: 10000) ,() {
      for(Saw saw in saws){
        saw.move();
      }
      questionNumber += 1;
      questionNumber %= quiz.questions.length;
      Future.delayed(const Duration(milliseconds: 1000 ) , (){
        reload();
      });
    });
  }
}
