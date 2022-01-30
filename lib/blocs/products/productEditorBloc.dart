import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:laundry/cubits/right_drawer.dart';
import 'package:laundry/db/dao/product/product.dart';
import 'package:laundry/db/drift_db.dart';
import 'package:laundry/db/event_db.dart';
import 'package:laundry/event_source/commands/product_command.dart';
import 'package:laundry/helpers/utils.dart';

const CREATE_PRODUCT_INDEX = 1;
const UPDATE_PRODUCT_INDEX = 2;

class ProductEditorBloc extends Bloc<ProductEditorEvent, ProductEditorState> {
  final RightDrawerCubit _rCubit;
  final ProductDao _dao;
  final ProductCommand _command;

  ProductEditorBloc(DriftDB db, EventDB edb, this._rCubit)
      : _dao = ProductDao(db),
        _command = ProductCommand(edb),
        super(ProductEditorState()) {
    on<ClearProductEvent>((_, emit) => emit(ClearProductState()));
    on<InitiateCreateProductEvent>((_, emit) {
      _rCubit.showDrawer(CREATE_PRODUCT_INDEX);
      emit(InitiateCreateProductState());
    });
    on<InitiateUpdateProductEvent>((event, emit) {
      emit(InitiateUpdateProductState(event.product));
      _rCubit.showDrawer(UPDATE_PRODUCT_INDEX);
    });
    on<CreateProductEvent>((event, emit) async {
      try {
        await _createProduct(event);
        emit(SuccessState());
        _rCubit.closeDrawer(CREATE_PRODUCT_INDEX);
      } catch (err) {
        emit(ErrorState());
      }
    });
    on<UpdateProductEvent>((event, emit) async {
      try {
        await _updateProduct(event);
        emit(SuccessState());
        _rCubit.closeDrawer(UPDATE_PRODUCT_INDEX);
      } catch (err) {
        emit(ErrorState());
      }
    });
    on<DeleteProductEvent>((event, emit) async {
      final isDeleted = await _dao.deleteById(event.id);
      if (isDeleted) {
        emit(SuccessState());
        _rCubit.closeDrawer(UPDATE_PRODUCT_INDEX);
      } else {
        emit(ErrorState());
      }
    });
  }

  Future<void> _createProduct(CreateProductEvent event) async {
    final productId = await _command.create(
      category: event.category,
      title: event.title,
      price: event.price,
      unit: event.unit,
    );
    if (event.imagePath != null) {
      await _dao.updateImageSync(productId, event.imagePath!);
    }
  }

  Future<void> _updateProduct(UpdateProductEvent event) async {
    await _command.update(
      streamId: event.id,
      category: event.category,
      title: event.title,
      price: event.price,
      unit: event.unit,
    );
    if (event.imagePath != null) {
      await _dao.updateImageSync(event.id, event.imagePath!);
    }
  }
}

class ProductEditorState {}

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

  CreateProductEvent({
    required this.category,
    required this.title,
    required this.price,
    required this.unit,
    this.imagePath,
  });

  @override
  List<Object?> get props => [category, title, price, unit, imagePath];
}

class UpdateProductEvent extends ProductEditorEvent {
  final String id;
  final String? category;
  final String? title;
  final int? price;
  final String? unit;
  final String? imagePath;

  UpdateProductEvent({
    required Product prevProduct,
    required String category,
    required String title,
    required int price,
    required String unit,
    this.imagePath,
  })  : id = prevProduct.id,
        category = toUpdate(category, prevProduct.category),
        title = toUpdate(title, prevProduct.title),
        price = toUpdate(price, prevProduct.price),
        unit = toUpdate(unit, prevProduct.unit);

  @override
  List<Object?> get props => [id, category, title, price, unit, imagePath];
}

class DeleteProductEvent extends ProductEditorEvent {
  final String id;

  DeleteProductEvent(Product prevProduct) : id = prevProduct.id;

  @override
  List<Object?> get props => [id];
}
