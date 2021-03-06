import 'package:flame/components/mixins/tapable.dart';
import 'package:flame/game.dart';
import 'package:flutter/gestures.dart';

import 'background.dart';
import 'views/gameOver/gameOverView.dart';
import 'views/initial/initialView.dart';
import 'views/running/controller.dart';

enum View { initial, running, gameOver }
enum DragDirection { left, right }

class ValentineGame extends BaseGame with HasTapableComponents {
  Background background;
  InitialView initialView;
  Controller controller;
  GameOverView gameOverView;
  DragDirection dragDirection;
  View currentView;

  ValentineGame() {
    currentView = View.initial;
    background = Background();
    initialView = InitialView(this);
    this..add(background)..add(initialView);
  }

  void start() {
    if (initialView != null) components.remove(initialView);
    if (controller != null) components.remove(controller);
    if (gameOverView != null) components.remove(gameOverView);

    currentView = View.running;

    controller = Controller(this);
    this.add(controller);
  }

  void gameOver() {
    // duplicate
    if (initialView != null) components.remove(initialView);
    if (controller != null) components.remove(controller);
    if (gameOverView != null) components.remove(gameOverView);

    currentView = View.gameOver;

    gameOverView = GameOverView(this);
    this.add(gameOverView);
  }

  GestureDragUpdateCallback onHorizontalDragUpdate(DragUpdateDetails d) {
    _updateDragDirection(d);
  }

  void _updateDragDirection(DragUpdateDetails d) {
    if (d.primaryDelta > 0) {
      dragDirection = DragDirection.right;
    } else if (d.primaryDelta < 0) {
      dragDirection = DragDirection.left;
    } else {
      dragDirection = null;
    }
  }

  GestureDragEndCallback onHorizontalDragEnd(DragEndDetails d) {
    if (dragDirection != null && controller?.avatar != null)
      controller.avatar.handleHorizontalDragEnd(dragDirection);
  }

  @override
  void onTapUp(int pointerId, TapUpDetails d) {
    super.onTapUp(pointerId, d);
    if (currentView == View.running && controller?.avatar != null)
      controller.avatar.handleTapUp();
  }

  @override
  bool debugMode() {
    return false;
  }
}
