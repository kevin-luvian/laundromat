import 'package:flutter/widgets.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

ScrollController useScrollListener({
  void Function()? onMaxScroll,
}) =>
    use(_ScrollControllerHook(onMaxScroll ?? () {}));

class _ScrollControllerHook extends Hook<ScrollController> {
  const _ScrollControllerHook(this.onMaxScroll);

  final void Function() onMaxScroll;

  @override
  createState() => _ScrollControllerHookState();
}

class _ScrollControllerHookState
    extends HookState<ScrollController, _ScrollControllerHook> {
  final _scrollController = ScrollController();

  @override
  void initHook() {
    super.initHook();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
          _scrollController.position.maxScrollExtent * 0.9) {
        hook.onMaxScroll();
      }
    });
  }

  @override
  build(context) => _scrollController;

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }
}
