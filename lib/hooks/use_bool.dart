import 'package:flutter/cupertino.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

_BoolHook useBool(bool initial) => _BoolHook(useState(initial));

class _BoolHook {
  final ValueNotifier<bool> _value;

  _BoolHook(this._value);

  bool get value => _value.value;

  void toggle() => _value.value = !_value.value;

  void set(bool val) => _value.value = val;
}
