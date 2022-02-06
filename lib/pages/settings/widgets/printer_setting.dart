import 'package:blue_thermal_printer/blue_thermal_printer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:laundry/blocs/bluetooth/bluetooth_bloc.dart';
import 'package:laundry/common/rect_button.dart';
import 'package:laundry/helpers/flutter_utils.dart';
import 'package:laundry/running_assets/asset_access.dart';
import 'package:laundry/styles/theme.dart';

class PrinterSetting extends StatefulWidget {
  const PrinterSetting({Key? key}) : super(key: key);

  @override
  _PrinterSettingState createState() => _PrinterSettingState();
}

class _PrinterSettingState extends State<PrinterSetting> {
  bool _pressed = false;
  bool _connected = false;
  List<BluetoothDevice> _devices = [];
  BluetoothDevice? device;

  @override
  void initState() {
    bluetoothBloc.currentConnection
        .then((val) => setState(() => _connected = val));
    setDevices();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void setDevices() async {
    final devices = await bluetoothBloc.devices;
    setState(() {
      _devices = devices;
      device = bluetoothBloc.device;
    });
  }

  void connectBluetooth() {
    if (_pressed) return;
    final mDevice = device;
    if (mDevice != null) {
      bluetoothBloc.add(ConnectEvent(mDevice));
    }
  }

  void disconnectBluetooth() {
    if (_pressed) return;
    bluetoothBloc.add(DisconnectEvent());
  }

  void changeDevice(BluetoothDevice? d) {
    setState(() => device = d);
  }

  Widget _addBloc({Widget? child}) {
    return BlocListener<BluetoothBloc, BluetoothState>(
      bloc: bluetoothBloc,
      listener: (_ctx, _state) {
        setState(() {
          final type = _state.runtimeType;
          if (type == LoadingState) {
            _pressed = true;
          } else {
            _pressed = false;
          }
          if (type == BluetoothConnectionState) {
            _connected = (_state as BluetoothConnectionState).conn;
          }
        });
      },
      child: child,
    );
  }

  @override
  Widget build(context) {
    return _addBloc(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: 15),
          _buildBluetoothSelector(),
        ],
      ),
    );
  }

  Widget _buildBluetoothSelector() {
    const spacer = SizedBox(width: 7);
    return Row(
      children: [
        _buildRefreshDevicesButton(),
        Expanded(child: _buildDropdownButton()),
        spacer,
        _buildConnectionButton(),
      ],
    );
  }

  Widget _buildRefreshDevicesButton() {
    final surface = colorScheme(context).surface;
    final onSurface = colorScheme(context).onSurface;
    return TextButton(
      style: TextButton.styleFrom(
        backgroundColor: surface,
        primary: onSurface,
        minimumSize: const Size(60, 47),
        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
      ),
      onPressed: setDevices,
      child: const Icon(Icons.sync),
    );
  }

  Widget _buildDropdownButton() {
    return DecoratedBox(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey, width: 1),
        borderRadius: BorderRadius.circular(7),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: DropdownButton<BluetoothDevice>(
          underline: Container(),
          isExpanded: true,
          items: _getDeviceItems(),
          onChanged: changeDevice,
          value: device,
        ),
      ),
    );
  }

  RectButton _buildConnectionButton() {
    return RectButton(
      color: _pressed ? GlobalColor.dim : null,
      onPressed: _connected ? disconnectBluetooth : connectBluetooth,
      size: const Size(150, 47),
      child: Text(_connected ? "disconnect" : "connect"),
    );
  }

  List<DropdownMenuItem<BluetoothDevice>> _getDeviceItems() {
    List<DropdownMenuItem<BluetoothDevice>> items = [];
    if (_devices.isEmpty) {
      items.add(const DropdownMenuItem(
        child: Text('NONE'),
        value: null,
      ));
    } else {
      for (final device in _devices) {
        items.add(DropdownMenuItem(
          child: Text(device.name ?? "-"),
          value: device,
        ));
      }
    }
    return items;
  }
}
