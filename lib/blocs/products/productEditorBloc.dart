import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:laundry/cubits/right_drawer.dart';
import 'package:laundry/db/dao/product/product.dart';
import 'package:laundry/db/dao/product/product_addon.dart';
import 'package:laundry/db/drift_db.dart';
import 'package:laundry/db/event_db.dart';
import 'package:laundry/event_source/commands/product_addon_command.dart';
import 'package:laundry/event_source/commands/product_command.dart';
import 'package:laundry/helpers/utils.dart';

const CREATE_PRODUCT_INDEX = 1;
const UPDATE_PRODUCT_INDEX = 2;

class Addon {
  Addon(this.title, this.price, {this.id});

  Addon.fromProductAddon(ProductAddon addon)
      : title = addon.title,
        price = addon.price,
        id = addon.id;

  final String? id;
  final String title;
  final int price;
}

class ProductEditorBloc extends Bloc<ProductEditorEvent, ProductEditorState> {
  final RightDrawerCubit _rCubit;
  final ProductDao _dao;
  final ProductAddonDao _addonDao;
  final ProductCommand _command;
  final ProductAddonCommand _addonCommand;

  ProductEditorBloc(DriftDB db, EventDB edb, this._rCubit)
      : _dao = ProductDao(db),
        _addonDao = ProductAddonDao(db),
        _command = ProductCommand(edb),
        _addonCommand = ProductAddonCommand(edb),
        super(ClearProductState()) {
    on<ClearProductEvent>((_, emit) => emit(ClearProductState()));
    on<InitiateCreateProductEvent>((_, emit) {
      _rCubit.showDrawer(index: CREATE_PRODUCT_INDEX);
      emit(InitiateCreateProductState());
    });
    on<InitiateUpdateProductEvent>((event, emit) {
      emit(InitiateUpdateProductState(event.product));
      _rCubit.showDrawer(index: UPDATE_PRODUCT_INDEX);
    });
    on<CreateProductEvent>((event, emit) async {
      try {
        await _createProduct(event);
        _rCubit.closeDrawer();
        emit(SuccessState());
      } catch (err) {
        emit(ErrorState());
      }
    });
    on<UpdateProductEvent>((event, emit) async {
      try {
        await _updateProduct(event);
        _rCubit.closeDrawer();
        emit(SuccessState());
      } catch (err) {
        emit(ErrorState());
      }
    });
    on<DeleteProductEvent>((event, emit) async {
      await _command.delete(streamId: event.id);
      emit(SuccessState());
      _rCubit.closeDrawer();
    });
  }

  Future<void> _createProduct(CreateProductEvent event) async {
    final productId = await _command.create(
      category: event.category,
      title: event.title,
      price: event.price,
      unit: event.unit,
    );
    final List<Future> futures = [];
    if (event.imagePath != null) {
      futures.add(_dao.updateImageSync(productId, event.imagePath!));
    }
    for (final addon in event.addons) {
      futures.add(_addonCommand.create(
          productId: productId, title: addon.title, price: addon.price));
    }
    await Future.wait(futures);
  }

  Future<void> _updateProduct(UpdateProductEvent event) async {
    final productId = event.id;
    final prevAddonIds =
        (await _addonDao.findAllByProductId(productId)).map((a) => a.id);

    final List<Future> futures = [];
    futures.add(_command.update(
      streamId: productId,
      category: event.category,
      title: event.title,
      price: event.price,
      unit: event.unit,
    ));
    final addonIds = event.addons.map((a) => a.id).where((a) => a != null);
    final addonsToDelete = prevAddonIds.where((id) => !addonIds.contains(id));
    for (final id in addonsToDelete) {
      futures.add(_addonCommand.remove(id));
    }

    event.addons.where((a) => a.id == null).forEach((addon) {
      futures.add(_addonCommand.create(
          productId: productId, title: addon.title, price: addon.price));
    });

    if (event.imagePath != null) {
      futures.add(_dao.updateImageSync(productId, event.imagePath!));
    }
    await Future.wait(futures);
  }
}

abstract class ProductEditorState {}

class ClearProductState extends ProductEditorState {}

class InitiateCreateProductState extends ProductEditorState {}

class InitiateUpdateProductState extends ProductEditorState {
  Product product;

  InitiateUpdateProductState(this.product);
}

class LoadingState extends ProductEditorState {
  LoadingState();
}

class SuccessState extends ProductEditorState {
  SuccessState();
}

class ErrorState extends ProductEditorState {
  ErrorState();
}

abstract class ProductEditorEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class ClearProductEvent extends ProductEditorEvent {}

class InitiateCreateProductEvent extends ProductEditorEvent {}

class InitiateUpdateProductEvent extends ProductEditorEvent {
  final Product product;

  InitiateUpdateProductEvent(this.product);

  @override
  List<Object?> get props => [product];
}

class CreateProductEvent extends ProductEditorEvent {
  final String category;
  final String title;
  final int price;
  final String unit;
  final String? imagePath;
  final List<Addon> addons;

  CreateProductEvent({
    required this.category,
    required this.title,
    required this.price,
    required this.unit,
    required this.addons,
    this.imagePath,
  });

  @override
  List<Object?> get props => [category, title, price, unit, addons, imagePath];
}

class UpdateProductEvent extends ProductEditorEvent {
  final String id;
  final String? category;
  final String? title;
  final int? price;
  final String? unit;
  final String? imagePath;
  final List<Addon> addons;

  UpdateProductEvent({
    required Product prevProduct,
    required String category,
    required String title,
    required int price,
    required String unit,
    required this.addons,
    this.imagePath,
  })  : id = prevProduct.id,
        category = toUpdate(category, prevProduct.category),
        title = toUpdate(title, prevProduct.title),
        price = toUpdate(price, prevProduct.price),
        unit = toUpdate(unit, prevProduct.unit);

  @override
  List<Object?> get props =>
      [id, category, title, price, unit, addons, imagePath];
}

class DeleteProductEvent extends ProductEditorEvent {
  final String id;

  DeleteProductEvent(Product prevProduct) : id = prevProduct.id;

  @override
  List<Object?> get props => [id];
}
