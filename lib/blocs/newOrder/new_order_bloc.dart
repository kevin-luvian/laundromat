import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:laundry/cubits/right_drawer.dart';
import 'package:laundry/db/dao/new_order_caches/new_order_cache.dart';
import 'package:laundry/db/drift_db.dart';
import 'package:laundry/helpers/logger.dart';
import 'package:laundry/running_assets/dao_access.dart';

class NewOrderBloc extends Bloc<NewOrderEvent, NewOrderState> {
  final RightDrawerCubit _rCubit;
  final NewOrderCacheDao _newOrderCacheDao;

  NewOrderBloc(DriftDB db, this._rCubit)
      : _newOrderCacheDao = NewOrderCacheDao(db),
        super(InitialOrderState()) {
    on<OpenProductEvent>((event, emit) async {
      _rCubit.showDrawer(title: event.product.title);

      final productId = event.product.id;
      final addons = await productAddonDao.findAllByProductId(productId);
      final orderCache = await _newOrderCacheDao.findById(productId);
      if (orderCache != null) {
        final List<ProductAddon> selectedAddons =
            await _newOrderCacheDao.findSelectedAddons(productId);
        emit(OpenedProductState(
          event.product,
          addons,
          amount: orderCache.amount,
          selectedAddons: selectedAddons,
        ));
      } else {
        emit(OpenedProductState(event.product, addons));
      }
    });
    on<ModifyProductEvent>((event, emit) async {
      logger.i("product modified");
      final addonIds = event.addons.map((a) => a.id).toList(growable: false);
      final productId = event.product.id;
      final amount = event.amount;
      await _newOrderCacheDao.deleteById(productId);
      if (amount > 0) {
        final newOrder = NewOrderCache(id: productId, amount: amount);
        await _newOrderCacheDao.create(newOrder, addonIds);
      }
      _rCubit.closeDrawer();
    });
    on<ClearCachesEvent>((event, emit) async {
      await _newOrderCacheDao.deleteAll();
      emit(InitialOrderState());
    });
  }

  void deleteOrderCache(String id) {
    _newOrderCacheDao.deleteById(id);
  }
}

abstract class NewOrderEvent {}

class OpenProductEvent extends NewOrderEvent {
  OpenProductEvent(this.product);

  final Product product;
}

class ModifyProductEvent extends NewOrderEvent {
  ModifyProductEvent(this.product, this.addons, this.amount);

  final Product product;
  final List<ProductAddon> addons;
  final double amount;
}

class ClearCachesEvent extends NewOrderEvent {}

abstract class NewOrderState extends Equatable {
  @override
  get props => [];
}

class InitialOrderState extends NewOrderState {}

class OpenedProductState extends NewOrderState {
  OpenedProductState(this.product, this.addons,
      {double? amount, List<ProductAddon>? selectedAddons})
      : amount = amount ?? 1,
        selectedAddons = selectedAddons ?? [];

  final Product product;
  final List<ProductAddon> addons;
  final List<ProductAddon> selectedAddons;
  final double amount;

  @override
  get props => [product, addons, selectedAddons];
}
