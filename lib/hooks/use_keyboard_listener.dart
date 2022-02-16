import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';

void useKeyboardListener(void Function(bool) callback) =>
    use(_KeyboardListener(callback));

class _KeyboardListener extends Hook<void> {
  const _KeyboardListener(this.callback);

  final void Function(bool) callback;

  @override
  createState() => _KeyboardListenerState();
}

class _KeyboardListenerState extends HookState<void, _KeyboardListener> {
  late StreamSubscription<bool> _keyboardSubscription;

  @override
  void initHook() {
    super.initHook();
    KeyboardVisibilityController _kvc = KeyboardVisibilityController();
    _keyboardSubscription = _kvc.onChange.listen(hook.callback);
  }

  @override
  void build(BuildContext context) {}

  @override
  void dispose() {
    _keyboardSubscription.cancel();
    super.dispose();
  }
}
