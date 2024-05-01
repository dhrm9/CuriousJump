import 'dart:async';

import 'package:android_component/game/components/collision_block.dart';
import 'package:android_component/game/components/platforms.dart';
import 'package:android_component/game/components/player_hitbox.dart';
import 'package:android_component/game/components/saw.dart';
import 'package:android_component/game/components/utils.dart';
import 'package:android_component/game/pixel_adventure.dart';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flutter/services.dart';

enum PlayerState { idle, running, jumping, falling, hit, appearing }

class Player extends SpriteAnimationGroupComponent
    with HasGameRef<PixelAdventure>, CollisionCallbacks, KeyboardHandler {
  String mainCharacter;
  // ignore: use_super_parameters
  Player({
    position,
    this.mainCharacter = 'Ninja Frog',
  }) : super(position: position);

  late final SpriteAnimation _idleAnimation;
  late final SpriteAnimation _runningAnimation;
  late final SpriteAnimation _jumpingAnimation;
  late final SpriteAnimation _fallingAnimation;
  late final SpriteAnimation _hitAnimation;
  late final SpriteAnimation _appearingAnimation;
  final double stepTime = 0.05;

  final double gravity = 9.8;
  final double jumpForce = 260;
  final double terminalVelocity = 300;
  double horizontalMovement = 0;
  double moveSpeed = 100;
  Vector2 startingPos = Vector2.zero();

  Vector2 velocity = Vector2.zero();
  bool isOnGround = false;
  bool hasJumped = false;
  bool gotHit = false;
  bool onCorrectPlatform = false;
  bool canMove = true;

  List<CollisionBlock> collisionBlocks = [];
  PlayerHitbox hitbox = PlayerHitbox(
    offsetX: 10,
    offsetY: 4,
    width: 14,
    height: 28,
  );

  final double fixedDeltaTime = 1.0 / 60;
  double accumulatedTime = 0;

  @override
  FutureOr<void> onLoad() {
    _loadAnimation();
    // debugMode = true;
    startingPos = Vector2(position.x, position.y);
    add(RectangleHitbox(
      position: Vector2(hitbox.offsetX, hitbox.offsetY),
      size: Vector2(hitbox.width, hitbox.height),
    ));
    return super.onLoad();
  }

  @override
  void update(double dt) {
    accumulatedTime += dt;

    while (accumulatedTime >= fixedDeltaTime) {
      if (!gotHit) {
        if (canMove) {
          _updatePlayerState();
          _updatePlayerMovement(fixedDeltaTime);
        }
        _checkHorizontalCollisions();
        _applyGravity(fixedDeltaTime);
        _checkVerticalCollision();
      }
      accumulatedTime -= fixedDeltaTime;
    }

    super.update(dt);
  }

  @override
  bool onKeyEvent(KeyEvent event, Set<LogicalKeyboardKey> keysPressed) {
    horizontalMovement = 0;
    final isLeftKeyPressed = keysPressed.contains(LogicalKeyboardKey.keyA) ||
        keysPressed.contains(LogicalKeyboardKey.arrowLeft);
    final isRightKeyPressed = keysPressed.contains(LogicalKeyboardKey.keyD) ||
        keysPressed.contains(LogicalKeyboardKey.arrowRight);

    horizontalMovement += isLeftKeyPressed ? -1 : 0;
    horizontalMovement += isRightKeyPressed ? 1 : 0;
    return super.onKeyEvent(event, keysPressed);
  }

  void _loadAnimation() {
    //loading the animation from the spritesheet
    _idleAnimation = _getSpriteAnimation('Idle', 11);
    _runningAnimation = _getSpriteAnimation('Run', 12);
    _jumpingAnimation = _getSpriteAnimation('Jump', 1);
    _fallingAnimation = _getSpriteAnimation('Fall', 1);
    _hitAnimation = _getSpriteAnimation('Hit', 7);
    _appearingAnimation = _getSpecialSpriteAnimation('Appearing', 7);
    //mapping the animations with the player state
    animations = {
      PlayerState.idle: _idleAnimation,
      PlayerState.running: _runningAnimation,
      PlayerState.falling: _fallingAnimation,
      PlayerState.jumping: _jumpingAnimation,
      PlayerState.hit: _hitAnimation,
      PlayerState.appearing: _appearingAnimation,
    };

    //setting up the current animation
    current = PlayerState.running;
  }

  SpriteAnimation _getSpriteAnimation(String state, int amount) {
    return SpriteAnimation.fromFrameData(
        game.images
            .fromCache('Main Characters/$mainCharacter/$state (32x32).png'),
        SpriteAnimationData.sequenced(
          amount: amount,
          stepTime: stepTime,
          textureSize: Vector2.all(32),
        ));
  }

  SpriteAnimation _getSpecialSpriteAnimation(String state, int amount) {
    return SpriteAnimation.fromFrameData(
        game.images.fromCache('Main Characters/$state (96x96).png'),
        SpriteAnimationData.sequenced(
          amount: amount,
          stepTime: stepTime,
          textureSize: Vector2.all(96),
        ));
  }

  void _updatePlayerMovement(double dt) {
    if (hasJumped && isOnGround) _playerJump(dt);
    velocity.x = horizontalMovement * moveSpeed;
    position.x += velocity.x * dt;
  }

  void _updatePlayerState() {
    PlayerState playerState = PlayerState.idle;

    if (velocity.x < 0 && scale.x > 0) {
      flipHorizontallyAroundCenter();
    } else if (velocity.x > 0 && scale.x < 0) {
      flipHorizontallyAroundCenter();
    }

    if (velocity.x > 0 || velocity.x < 0) {
      playerState = PlayerState.running;
    }

    if (velocity.y > gravity) playerState = PlayerState.falling;

    if (velocity.y < 0) playerState = PlayerState.jumping;

    current = playerState;
  }

  void _checkHorizontalCollisions() {
    for (final block in collisionBlocks) {
      if (!block.isPlatform) {
        if (checkCollision(this, block)) {
          if (velocity.x > 0) {
            velocity.x = 0;
            position.x = block.x - hitbox.offsetX - hitbox.width;
            break;
          }

          if (velocity.x < 0) {
            velocity.x = 0;
            position.x = block.x + block.width + hitbox.width + hitbox.offsetX;
            break;
          }
        }
      }
    }
  }

  @override
  void onCollisionStart(
      Set<Vector2> intersectionPoints, PositionComponent other) {
    if (other is Saw) {
      _respawn();
    }
    if (other is Platform) {
      print("Collision");
      if (other.isCorrect) {
        onCorrectPlatform = true;
      } else {
        onCorrectPlatform = false;
      }
    }
    super.onCollisionStart(intersectionPoints, other);
  }

  void _applyGravity(double dt) {
    velocity.y += gravity;
    velocity.y = velocity.y.clamp(-jumpForce, terminalVelocity);
    position.y += velocity.y * dt;
  }

  void _checkVerticalCollision() {
    for (final block in collisionBlocks) {
      if (!block.isPlatform) {
        if (checkCollision(this, block)) {
          if (velocity.y > 0) {
            velocity.y = 0;
            position.y = block.y - hitbox.height - hitbox.offsetY;
            isOnGround = true;
            break;
          }

          if (velocity.y < 0) {
            velocity.y = 0;
            position.y = block.y + block.height - hitbox.offsetY;
            // isOnGround = true;
            break;
          }
        }
      }
    }
  }

  void _playerJump(double dt) {
    velocity.y = -jumpForce;
    position.y += velocity.y * dt;
    isOnGround = false;
    hasJumped = false;
  }

  void _respawn() {
    // print('hit');
    const hitDuration = Duration(milliseconds: 350);
    const appearingDuration = Duration(milliseconds: 350);
    const cantMove = Duration(milliseconds: 400);
    gotHit = true;
    current = PlayerState.hit;
    Future.delayed(hitDuration, () {
      scale.x = 1;
      position = startingPos - Vector2.all(32);
      current = PlayerState.appearing;
      Future.delayed(appearingDuration, () {
        velocity = Vector2.zero();
        position = startingPos;
        _updatePlayerState();
        Future.delayed(cantMove, () => gotHit = false);
      });
    });
  }

  bool isPlayerOnCorrectPlatform() {
    return onCorrectPlatform;
  }

  void reset() {
    canMove = true;
    _respawn();
  }

  void dontMove() {
    canMove = false;
  }
}
