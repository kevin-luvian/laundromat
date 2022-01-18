import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:laundry/cubits/right_drawer.dart';

enum ProductDrawerIndex { create, update }

class ProductDrawerCubit extends Cubit<ProductDrawerIndex> {
  RightDrawerCubit rdc;

  ProductDrawerCubit({required this.rdc}) : super(ProductDrawerIndex.create);

  openDrawer(ProductDrawerIndex i) {
    emit(i);
    rdc.showDrawer();
  }
}
