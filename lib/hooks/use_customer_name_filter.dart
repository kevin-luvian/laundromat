import 'package:flutter/cupertino.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

CustomerNameControllers useDoubleTextControllerHook({
  String? initial,
  required void Function(String text) onChange,
}) =>
    use(_DoubleTextControllerHook(initial ?? "", onChange));

class CustomerNameControllers {
  final TextEditingController _textCtr;
  final TextEditingController _tempTextCtr;
  final void Function(String name) callback;

  CustomerNameControllers(this._textCtr, this._tempTextCtr,
      {required this.callback});

  TextEditingController get textCtr {
    return _textCtr;
  }

  TextEditingController get tempCtr {
    _tempTextCtr.text = _textCtr.text;
    return _tempTextCtr;
  }

  void setName(String name) => textCtr.text = name;

  void notifyTextChange() {
    callback(_tempTextCtr.text);
    _textCtr.text = _tempTextCtr.text;
  }
}

class _DoubleTextControllerHook extends Hook<CustomerNameControllers> {
  const _DoubleTextControllerHook(this.initialText, this.onChange);

  final String initialText;
  final void Function(String text) onChange;

  @override
  createState() => _CustomerNameHookState();
}

class _CustomerNameHookState
    extends HookState<CustomerNameControllers, _DoubleTextControllerHook> {
  late final TextEditingController textCtr;
  late final TextEditingController tempTextCtr;

  @override
  void initHook() {
    textCtr = TextEditingController(text: hook.initialText);
    tempTextCtr = TextEditingController(text: "");
    super.initHook();
  }

  @override
  build(context) =>
      CustomerNameControllers(textCtr, tempTextCtr, callback: hook.onChange);

  @override
  void dispose() {
    textCtr.dispose();
    tempTextCtr.dispose();
    super.dispose();
  }
}
