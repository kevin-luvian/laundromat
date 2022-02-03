import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:laundry/cubits/right_drawer.dart';
import 'package:laundry/db/drift_db.dart';
import 'package:laundry/running_assets/dao_access.dart';

class NewOrderBloc extends Bloc<NewOrderEvent, NewOrderState> {
  final RightDrawerCubit _rCubit;

  NewOrderBloc(this._rCubit) : super(InitialOrderState()) {
    on<OpenProductEvent>((event, emit) async {
      _rCubit.showDrawer(title: event.product.title);

      final addons = await productAddonDao.findAllByProductId(event.product.id);
      emit(OpenedProductState(event.product, addons));
    });
    on<ModifyProductEvent>((event, emit) {
      _rCubit.closeDrawer();
    });
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
  final int amount;
}

abstract class NewOrderState extends Equatable {
  @override
  get props => [];
}

class InitialOrderState extends NewOrderState {}

class OpenedProductState extends NewOrderState {
  OpenedProductState(this.product, this.addons);

  final Product product;
  final List<ProductAddon> addons;

  @override
  get props => [product, addons];
}
