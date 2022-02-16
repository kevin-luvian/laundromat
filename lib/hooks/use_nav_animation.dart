import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

NavAnimationState useNavAnimation(int length) {
  final controller = useTabController(initialLength: length);
  final animation =
      useAnimationController(duration: const Duration(seconds: 1));

  useEffect(() {
    animation.forward();
    controller.addListener(() {
      animation.forward(from: 0.5);
    });
  }, []);

  return NavAnimationState(controller, animation);
}

class NavAnimationState {
  final TabController controller;
  final AnimationController animation;

  const NavAnimationState(this.controller, this.animation);
}
