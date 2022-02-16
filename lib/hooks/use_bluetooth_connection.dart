import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:laundry/blocs/bluetooth/bluetooth_bloc.dart';

ValueNotifier<bool> useBlueConnection(BluetoothBloc bluetoothBloc) {
  final _conn = useState(false);

  useEffect(() {
    bluetoothBloc.currentConnection.then((value) => _conn.value = value);
  }, []);

  final mStream = useStream(bluetoothBloc.stream);
  useEffect(() {
    final _state = mStream.data;
    if (_state == null) return;
    switch (_state.runtimeType) {
      case BluetoothConnectionState:
        _conn.value = (_state as BluetoothConnectionState).conn;
        break;
      default:
        _conn.value = false;
    }
  }, [mStream]);

  return _conn;
}
