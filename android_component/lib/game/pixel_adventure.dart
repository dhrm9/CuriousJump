import 'dart:async';

import 'package:android_component/audio/audio_manager.dart';
import 'package:android_component/game/components/jump_button.dart';
import 'package:android_component/game/components/level.dart';
import 'package:android_component/game/components/player.dart';
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flutter/cupertino.dart';

class PixelAdventure extends FlameGame
    with HasKeyboardHandlerComponents, HasCollisionDetection, DragCallbacks {
  @override
  Color backgroundColor() => const Color(0xFF201e30);

  late final CameraComponent cam;
  bool showControls = true;
  int correctAnswer = 0;
  int wrongAnswer = 0;
  bool isSoundOn;

  PixelAdventure({required this.isSoundOn});

  Player player = Player(mainCharacter: 'Mask Dude');
  late JoystickComponent joystick;

  @override
  FutureOr<void> onLoad() async {
    await images.loadAllImages();
    AudioManager.instance.setSound(isSoundOn);

    final world1 = Level(
      player: player,
      levelName: 'level1',
      allowedTime: 10,
    );

    cam = CameraComponent.withFixedResolution(
        world: world1, width: 640, height: 360);

    cam.viewfinder.anchor = Anchor.topLeft;

    await addAll([cam, world1]);

    // if (showControls) {
    addJoystick();
    add(JumpButton());
    // }
    return super.onLoad();
  }

  @override
  void update(double dt) {
    updateJoystick();
    super.update(dt);
  }

  void addJoystick() {
    joystick = JoystickComponent(
      knob: SpriteComponent(
        sprite: Sprite(
          images.fromCache('HUD/knob.png'),
        ),
      ),
      background: SpriteComponent(
        sprite: Sprite(
          images.fromCache('HUD/joystick.png'),
        ),
      ),
      margin: const EdgeInsets.only(left: 4, bottom: 32),
    );
    add(joystick);
  }

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
