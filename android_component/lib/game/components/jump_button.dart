// Importing necessary libraries
import 'dart:async';

import 'package:android_component/game/curious_jump.dart';
import 'package:flame/components.dart';
import 'package:flame/events.dart';

// Defining a class called JumpButton which extends SpriteComponent and implements TapCallbacks
class JumpButton extends SpriteComponent with HasGameRef<CuriousJump>, TapCallbacks {
  
  // Constructor
  JumpButton();

  // Constants for button margin and size
  final margin = 32;
  final buttonSize = 64;

  // This method is called when the component is loaded
  @override
  FutureOr<void> onLoad() {
    // Loading the sprite for the jump button
    sprite = Sprite(game.images.fromCache('Menu/Buttons/Jump.png'));
    
    // Setting the position of the jump button on the screen
    position = Vector2(
      game.size.x - margin - buttonSize,
      game.size.y - margin - buttonSize,
    );

    // Setting the priority of the jump button
    priority = 10;
    return super.onLoad();
  }

  // This method is called when a tap down event occurs (when the user taps on the screen)
  @override
  void onTapDown(TapDownEvent event) {
    // Setting a flag in the game that the player has jumped
    game.player.hasJumped = true;
    super.onTapDown(event);
  }

  // This method is called when a tap up event occurs (when the user stops tapping on the screen)
  @override
  void onTapUp(TapUpEvent event) {
    // Resetting the flag in the game that the player has jumped
    game.player.hasJumped = false;
    super.onTapUp(event);
  }
}
