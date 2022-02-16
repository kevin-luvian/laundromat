import 'package:flutter_hooks/flutter_hooks.dart';

_LockRunner useSingleLock() {
  final lock = useState(true);

  return _LockRunner(() {
    if (lock.value) {
      lock.value = false;
      return false;
    }
    return true;
  });
}

class _LockRunner {
  final bool Function() _validate;

  _LockRunner(this._validate);

  void run(void Function() toRun) {
    if (_validate()) {
      toRun();
    }
  }
}
