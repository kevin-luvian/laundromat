import 'package:flutter/widgets.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class ContentDrawer {
  final AnimationController animation;
  final Animation<double> tween;
  final show = useState(false);

  ContentDrawer(this.animation, this.tween);

  void open() {
    show.value = true;
    animation.forward();
  }

  void close() {
    show.value = false;
    animation.reverse();
  }

  void toggle() => show.value ? close() : open();
}

ContentDrawer useContentDrawer() {
  final animation = useAnimationController(
      duration: const Duration(milliseconds: 300), initialValue: 0);
  final tween = Tween(begin: 0.0, end: 1.0)
      .animate(CurvedAnimation(parent: animation, curve: Curves.fastOutSlowIn));

  return ContentDrawer(animation, tween);
}
