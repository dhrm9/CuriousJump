import 'dart:async';

import 'package:android_component/game/components/collision_block.dart';
import 'package:android_component/game/components/player.dart';
import 'package:android_component/game/components/saw.dart';
import 'package:android_component/quiz/quiz.dart';
import 'package:flame/components.dart';
import 'package:flame_tiled/flame_tiled.dart';

class Level extends World {
  late TiledComponent level;

  final String levelName;
  final Player player;
  late Quiz quiz;
  final int correctOption = 1;
  List<CollisionBlock> collisionBlocks = [];

  Level({required this.levelName, required this.player});

  @override
  FutureOr<void> onLoad() async {
    // quiz = QuizReader.readJson("filePath")
    level = await TiledComponent.load('$levelName.tmx', Vector2.all(16));

    add(level);

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

    return super.onLoad();
  }

  int cnt = 0;
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
            bool isCorrect = false;
            if (cnt == correctOption) {
              isCorrect = true;
            }
            cnt++;
            final saw = Saw(
              isVertical: isVertical,
              offNeg: offsetN,
              isCorrect: isCorrect,
              position: Vector2(spawnPoint.x, spawnPoint.y),
              size: Vector2(spawnPoint.width, spawnPoint.height),
            );
            add(saw);
          default:
        }
      }
    }
  }
}
