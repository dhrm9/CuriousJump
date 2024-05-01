import 'dart:async';

import 'package:android_component/game/pixel_adventure.dart';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';

class Saw extends SpriteAnimationComponent with HasGameRef<PixelAdventure> {
  // ignore: use_super_parameters

  final bool isVertical;
  final double offNeg;
  bool isCorrect;
  final Vector2 startPos;
  bool isMoving = false;

  // ignore: use_super_parameters
  Saw({
    this.isVertical = true,
    this.isCorrect = false,
    this.offNeg = 0,
    position,
    size,
  })  : startPos = position,
        super(
          position: position,
          size: size,
        );

  final double sawSpeed = 0.08;
  final double moveSpeed = 50;
  final double tileSize = 16;
  double moveDirection = -1;
  double rangeNeg = 0;
  double rangePos = 0;

  @override
  FutureOr<void> onLoad() {
    priority = -1;
    add(CircleHitbox());

    if (isVertical) {
      rangeNeg = position.y - offNeg * tileSize;
    }

    animation = SpriteAnimation.fromFrameData(
      game.images.fromCache('Traps/Saw/On (38x38).png'),
      SpriteAnimationData.sequenced(
        amount: 8,
        stepTime: sawSpeed,
        textureSize: Vector2.all(38),
      ),
    );

    return super.onLoad();
  }

  @override
  void update(double dt) {
    if (isVertical && !isCorrect && isMoving) {
      _moveVertically(dt);
    }
    super.update(dt);
  }

  void _moveVertically(double dt) {
    if (position.y <= rangeNeg) {
      moveDirection = 0;
    }
    position.y += moveDirection * moveSpeed * dt;
  }

  void move() {
    isMoving = true;
  }

  void reset(bool isCorrect) {
    this.isCorrect = isCorrect;
    position = startPos;
    isMoving = false;
    moveDirection = -1;
  }
}
