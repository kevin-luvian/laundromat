import 'dart:async';

import 'package:blue_thermal_printer/blue_thermal_printer.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:laundry/db/aggregates/order_details.dart';
import 'package:laundry/db/dao/new_order_caches/new_order_cache.dart';
import 'package:laundry/db/drift_db.dart';
import 'package:laundry/helpers/logger.dart';
import 'package:laundry/print_handlers/print_orders.dart';
import 'package:laundry/running_assets/dao_access.dart';

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
      try {
        final mDevice = device;
        if (mDevice != null) {
          final orderId = await ordersDao.generateOrderId(DateTime.now());
          final orders = await _nocDao.allOrderDetails();
          final staff = await sessionDao.currentUser;
          final customer = await _nocDao.currentCustomer;
          await print(
            OrderDetail(
              streamId: '',
              orderId: orderId,
              orders: orders,
              user: staff!,
              createDate: DateTime.now(),
              customer: customer,
              removedDate: null,
            ),
          );
        }
      } catch (_) {}
    });
    on<PrintHistoryEvent>((event, _) async {
      try {
        final mDevice = device;
        if (mDevice != null) {
          await print(event.detail);
        }
      } catch (_) {}
    });
    on<_ConnectionChangedEvent>(
      (event, emit) => emit(BluetoothConnectionState(event.conn)),
    );
    on<ConnectEvent>((event, emit) async {
      emit(LoadingState());

      try {
        device = event.device;
        await connect(event.device);
      } catch (_) {
        emit(BluetoothConnectionState(false));
      }
    });
    on<DisconnectEvent>((event, emit) async {
      emit(LoadingState());
      final isDisconnected = await disconnect();
      if (isDisconnected) {
        device = null;
      }
    });
  }

  Future<void> print(OrderDetail detail) async {
    try {
      final mDevice = device;
      if (mDevice != null) {
        await printOrders(
          bluetooth,
          mDevice,
          orderId: detail.orderId,
          orders: detail.orders,
          staff: detail.user,
          customer: detail.customer,
          date: detail.createDate,
        );
      }
    } catch (err) {
      logger.e(err);
    }
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

class PrintHistoryEvent extends BluetoothEvent {
  final OrderDetail detail;

  PrintHistoryEvent(this.detail);
}

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
