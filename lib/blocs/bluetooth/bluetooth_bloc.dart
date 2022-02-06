import 'dart:async';

import 'package:blue_thermal_printer/blue_thermal_printer.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:laundry/db/dao/new_order_caches/new_order_cache.dart';
import 'package:laundry/db/drift_db.dart';
import 'package:laundry/print_handlers/print_orders.dart';

class BluetoothBloc extends Bloc<BluetoothEvent, BluetoothState> {
  BlueThermalPrinter bluetooth = BlueThermalPrinter.instance;
  BluetoothDevice? device;
  final NewOrderCacheDao _nocDao;

  BluetoothBloc(DriftDB db)
      : _nocDao = NewOrderCacheDao(db),
        super(InitialBluetoothState()) {
    bluetooth.onStateChanged().listen((_state) {
      switch (_state) {
        case BlueThermalPrinter.STATE_ON:
          bluetooth.isConnected
              .then((val) => add(_ConnectionChangedEvent(val ?? false)));
          break;
        case BlueThermalPrinter.CONNECTED:
          add(_ConnectionChangedEvent(true));
          break;
        default:
          add(_ConnectionChangedEvent(false));
      }
    });

    on<PrintEvent>((_, _e) async {
      final orders = await _nocDao.allOrderDetails();
      printOrders(bluetooth, orders);
    });
    on<_ConnectionChangedEvent>(
      (event, emit) => emit(BluetoothConnectionState(event.conn)),
    );
    on<ConnectEvent>((event, emit) async {
      emit(LoadingState());

      final conn = await connect(event.device);
      if (conn.runtimeType == bool) {
        final isConnected = conn as bool;
        if (isConnected) device = event.device;
      }
    });
    on<DisconnectEvent>((event, emit) async {
      emit(LoadingState());
      final disconnected = await disconnect();
      if (disconnected) device = null;
    });
  }

  Future<List<BluetoothDevice>> get devices async {
    List<BluetoothDevice> devices = [];

    try {
      devices = await bluetooth.getBondedDevices();
    } on PlatformException {
      return [];
    }
    return devices;
  }

  Future<bool> disconnect() async {
    final isConnected = await bluetooth.isConnected;
    if (isConnected ?? false) {
      await bluetooth.disconnect();
      return true;
    }
    return false;
  }

  Future<dynamic> connect(BluetoothDevice device) async {
    final isDisconnected = await disconnect();
    if (isDisconnected) return false;
    try {
      return await bluetooth.connect(device);
    } on PlatformException {
      return false;
    } catch (_) {
      return false;
    }
  }

  Future<bool> get currentConnection async =>
      await bluetooth.isConnected ?? false;
}

abstract class BluetoothEvent {}

class PrintEvent extends BluetoothEvent {}

class _ConnectionChangedEvent extends BluetoothEvent {
  final bool conn;

  _ConnectionChangedEvent(this.conn);
}

class ConnectEvent extends BluetoothEvent {
  BluetoothDevice device;

  ConnectEvent(this.device);
}

class DisconnectEvent extends BluetoothEvent {}

abstract class BluetoothState extends Equatable {
  @override
  get props => [];
}

class BluetoothConnectionState extends BluetoothState {
  final bool conn;

  BluetoothConnectionState(this.conn);

  @override
  get props => [conn];
}

class InitialBluetoothState extends BluetoothState {}

class LoadingState extends BluetoothState {}
