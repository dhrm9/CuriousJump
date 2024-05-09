import 'dart:async';

import 'package:android_component/audio/audio_manager.dart';
import 'package:android_component/game/components/collision_block.dart';
import 'package:android_component/game/components/platforms.dart';
import 'package:android_component/game/components/player_hitbox.dart';
import 'package:android_component/game/components/saw.dart';
import 'package:android_component/game/components/utils.dart';
import 'package:android_component/game/curious_jump.dart';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flutter/services.dart';

// Enum to represent different states of the player
enum PlayerState { idle, running, jumping, falling, hit, appearing }

// Player class with SpriteAnimationGroupComponent, CollisionCallbacks, and KeyboardHandler
class Player extends SpriteAnimationGroupComponent
    with HasGameRef<CuriousJump>, CollisionCallbacks, KeyboardHandler {
  // Variables to hold various player attributes
  String mainCharacter;
  late final SpriteAnimation _idleAnimation;
  late final SpriteAnimation _runningAnimation;
  late final SpriteAnimation _jumpingAnimation;
  late final SpriteAnimation _fallingAnimation;
  late final SpriteAnimation _hitAnimation;
  late final SpriteAnimation _appearingAnimation;
  final double stepTime = 0.05;
  final double gravity = 9.8;
  final double jumpForce = 300;
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

  // Time variables for updating and animation
  final double fixedDeltaTime = 1.0 / 60;
  double accumulatedTime = 0;

  // Constructor
  Player({
    position,
    this.mainCharacter = 'Ninja Frog',
  }) : super(position: position);

  // Method called when the player is loaded
  @override
  FutureOr<void> onLoad() {
    _loadAnimation();
    startingPos = Vector2(position.x, position.y);
    add(RectangleHitbox(
      position: Vector2(hitbox.offsetX, hitbox.offsetY),
      size: Vector2(hitbox.width, hitbox.height),
    ));
    return super.onLoad();
  }

  // Method to update player state and movement
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
        if (isOnGround == true) onCorrectPlatform = false;
      }
      accumulatedTime -= fixedDeltaTime;
    }

    super.update(dt);
  }

  // Keyboard event handler
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

  // Load player animations
  void _loadAnimation() {
    _idleAnimation = _getSpriteAnimation('Idle', 11);
    _runningAnimation = _getSpriteAnimation('Run', 12);
    _jumpingAnimation = _getSpriteAnimation('Jump', 1);
    _fallingAnimation = _getSpriteAnimation('Fall', 1);
    _hitAnimation = _getSpriteAnimation('Hit', 7);
    _appearingAnimation = _getSpecialSpriteAnimation('Appearing', 7);

    animations = {
      PlayerState.idle: _idleAnimation,
      PlayerState.running: _runningAnimation,
      PlayerState.falling: _fallingAnimation,
      PlayerState.jumping: _jumpingAnimation,
      PlayerState.hit: _hitAnimation,
      PlayerState.appearing: _appearingAnimation,
    };

    current = PlayerState.running;
  }

  // Get sprite animation from the spritesheet
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

  // Get special sprite animation
  SpriteAnimation _getSpecialSpriteAnimation(String state, int amount) {
    return SpriteAnimation.fromFrameData(
        game.images.fromCache('Main Characters/$state (96x96).png'),
        SpriteAnimationData.sequenced(
          amount: amount,
          stepTime: stepTime,
          textureSize: Vector2.all(96),
        ));
  }

  // Update player movement based on input and state
  void _updatePlayerMovement(double dt) {
    if (hasJumped && isOnGround) _playerJump(dt);
    velocity.x = horizontalMovement * moveSpeed;
    position.x += velocity.x * dt;
  }

  // Update player state based on velocity
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

  // Check horizontal collisions with blocks
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

  // Handle collisions with other components
  @override
  void onCollision(Set<Vector2> intersectionPoints, PositionComponent other) {
    if (other is Platform) {
      if (other.isCorrect) {
        onCorrectPlatform = true;
      } else {
        onCorrectPlatform = false;
      }
    }
    if (other is Saw) {
      AudioManager.instance.playSfx('Hit.wav');
      _respawn();
    }
    super.onCollision(intersectionPoints, other);
  }

  // Apply gravity to the player
  void _applyGravity(double dt) {
    velocity.y += gravity;
    velocity.y = velocity.y.clamp(-jumpForce, terminalVelocity);
    position.y += velocity.y * dt;
  }

  // Check vertical collisions with blocks
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
            break;
          }
        }
      }
    }
  }

  // Make the player jump
  void _playerJump(double dt) {
    AudioManager.instance.playSfx('Jump.wav');
    velocity.y = -jumpForce;
    position.y += velocity.y * dt;
    isOnGround = false;
    hasJumped = false;
  }

  // Respawn the player after getting hit
  void _respawn() {
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

  // Check if player is on a correct platform
  bool isPlayerOnCorrectPlatform() {
    return onCorrectPlatform;
  }

  // Reset player state
  void reset() {
    canMove = true;
    _respawn();
  }

  // Prevent player from moving
  void dontMove() {
    canMove = false;
  }
}
