import 'dart:async';

import 'package:android_component/audio/audio_manager.dart';
import 'package:android_component/game/components/jump_button.dart';
import 'package:android_component/game/components/level.dart';
import 'package:android_component/game/components/player.dart';
import 'package:android_component/models/player_data.dart';
import 'package:android_component/quiz/quiz.dart';
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flutter/cupertino.dart';

class CuriousJump extends FlameGame
    with
        // Adding necessary mixins
        HasKeyboardHandlerComponents,
        HasCollisionDetection,
        DragCallbacks {
  
  // Background color for the game
  @override
  Color backgroundColor() => const Color(0xFF201e30);

  // Camera component for game view
  late final CameraComponent cam;

  // State variables
  bool showControls = true;
  int correctAnswer = 0;
  int wrongAnswer = 0;
  bool isSoundOn;
  QuizLevel quizLevel;
  QuizType quizType;
  PlayerData playerData;
  late Level world1;

  // Constructor for CuriousJump class
  CuriousJump({
    required this.isSoundOn,
    required this.quizLevel,
    required this.quizType,
    required this.playerData,
  });

  // Player object
  Player player = Player(mainCharacter: 'Mask Dude');
  late JoystickComponent joystick;

  // Method called when game is loaded
  @override
  FutureOr<void> onLoad() async {
    // Load images asynchronously
    await images.loadAllImages();

    // Set audio sound based on user preference
    AudioManager.instance.setSound(isSoundOn);

    // Initialize game level
    world1 = Level(
      player: player,
      levelName: 'level1',
      allowedTime: 10,
      quizType: quizType,
      quizLevel: quizLevel
    );

    // Initialize camera with fixed resolution
    cam = CameraComponent.withFixedResolution(
      world: world1,
      width: 640,
      height: 360,
    );

    cam.viewfinder.anchor = Anchor.topLeft;

    // Add camera and world components
    await addAll([cam, world1]);

    // Add joystick and jump button if showControls is true
    addJoystick();
    add(JumpButton());

    return super.onLoad();
  }

  // Method called for game updates
  @override
  void update(double dt) {
    updateJoystick();
    super.update(dt);
  }

  // Method to add joystick component
  void addJoystick() {
    joystick = JoystickComponent(
      knob: SpriteComponent(
        priority: 13,
        sprite: Sprite(
          images.fromCache('HUD/knob.png'),
        ),
      ),
      background: SpriteComponent(
        sprite: Sprite(
          images.fromCache('HUD/joystick.png'),
        ),
      ),
      margin: const EdgeInsets.only(left: 32, bottom: 32),
    );
    add(joystick);
  }

  // Method to update joystick direction
  void updateJoystick() {
    switch (joystick.direction) {
      case JoystickDirection.left:
      case JoystickDirection.upLeft:
      case JoystickDirection.downLeft:
        player.horizontalMovement = -1;
        break;
      case JoystickDirection.right:
      case JoystickDirection.upRight:
      case JoystickDirection.downRight:
        player.horizontalMovement = 1;
        break;
      default:
        player.horizontalMovement = 0;
        break;
    }
  }
}
