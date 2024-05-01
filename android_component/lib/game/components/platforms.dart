import 'dart:async';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';

class Platform extends PositionComponent {
  // ignore: use_super_parameters
  Platform({
    position,
    size,
  }) : super(
          position: position,
          size: size,
        );

  bool isCorrect = false;

  @override
  FutureOr<void> onLoad() {
    debugMode = true;
    add(RectangleHitbox(
        position: position, size: size, collisionType: CollisionType.passive));
    return super.onLoad();
  }

  void reset(bool isCorrect) {
    this.isCorrect = isCorrect;
  }
}
