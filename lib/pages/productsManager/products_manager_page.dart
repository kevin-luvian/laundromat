import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:laundry/blocs/products/bloc.dart';
import 'package:laundry/common/right_drawer.dart';
import 'package:laundry/cubits/right_drawer.dart';
import 'package:laundry/db/drift_db.dart';
import 'package:laundry/pages/productsManager/widgets/create_product_form.dart';
import 'package:laundry/pages/productsManager/widgets/product_left_navigator.dart';
import 'package:laundry/pages/productsManager/widgets/products_view.dart';

class ProductsManagerPage extends StatelessWidget {
  const ProductsManagerPage({Key? key}) : super(key: key);

  Widget _attachProviders({required Widget child}) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<RightDrawerCubit>(create: (_) => RightDrawerCubit()),
        BlocProvider<ProductsBloc>(
            create: (_) => ProductsBloc(GetIt.I.get<DriftDB>())),
      ],
      child: child,
    );
  }

  @override
  Widget build(BuildContext context) {
    return _attachProviders(
      child: _buildDrawer(
        child: Row(
          children: const [
            ProductLeftNavigator(),
            Expanded(child: ProductsView()),
          ],
        ),
      ),
    );
  }

  Widget _buildDrawer({required Widget child}) {
    return BlocBuilder<RightDrawerCubit, RightDrawerState>(
      builder: (_, _state) {
        late RightDrawerContent content;
        if (_state.index == CREATE_PRODUCT_INDEX) {
          content = const RightDrawerContent(
            label: "Create Product",
            child: CreateProductForm(),
          );
        } else {
          content = RightDrawerContent(
            label: "Update Product",
            child: _buildUpdateProduct(),
          );
        }
        return RightDrawer(child: child, content: content);
      },
    );
  }

  static Widget _buildUpdateProduct() {
    return const Padding(
      padding: EdgeInsets.all(10),
      child: Text("check"),
    );
  }
}
