import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:laundry/db/dao/product/product.dart';
import 'package:laundry/db/drift_db.dart';

class ProductsBloc extends Bloc<CategoryChangedEvent, ProductsState> {
  final ProductDao _dao;

  ProductsBloc(DriftDB db)
      : _dao = ProductDao(db),
        super(EmptyProductsState()) {
    on<CategoryChangedEvent>((event, emit) {
      final stream = _dao.findAllByCategoryAsStream(event.category);
      emit(StreamedProducts(stream));
    });
  }
}

class ProductsState {}

class EmptyProductsState extends ProductsState {
  EmptyProductsState();
}

class StreamedProducts extends ProductsState {
  final Stream<List<Product>> stream;

  StreamedProducts(this.stream);
}

abstract class ProductsEvent extends Equatable {}

class CategoryChangedEvent extends ProductsEvent {
  final String category;

  CategoryChangedEvent(this.category);

  @override
  List<Object?> get props => [category];
}
