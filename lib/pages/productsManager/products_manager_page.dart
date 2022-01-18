import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:laundry/common/right_drawer.dart';
import 'package:laundry/cubits/product_drawer.dart';
import 'package:laundry/cubits/right_drawer.dart';
import 'package:laundry/pages/productsManager/widgets/create_product_form.dart';
import 'package:laundry/pages/productsManager/widgets/product_left_navigator.dart';

class ProductsManagerPage extends StatelessWidget {
  const ProductsManagerPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<RightDrawerCubit>(create: (_) => RightDrawerCubit()),
        BlocProvider<ProductDrawerCubit>(
          create: (ctx) => ProductDrawerCubit(
            rdc: BlocProvider.of<RightDrawerCubit>(ctx),
          ),
        ),
      ],
      child: _buildDrawer(
        child: Row(
          children: [
            const ProductLeftNavigator(),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text("products.dart"),
                TextButton(
                  onPressed: () {},
                  child: const Text("content"),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDrawer({required Widget child}) {
    return BlocBuilder<ProductDrawerCubit, ProductDrawerIndex>(
      builder: (_, _state) {
        late RightDrawerContent content;
        if (_state == ProductDrawerIndex.update) {
          content = RightDrawerContent(
            label: "Update Product",
            child: _buildAddProduct(),
          );
        } else {
          content = const RightDrawerContent(
            label: "Create Product",
            child: CreateProductForm(),
          );
        }
        return RightDrawer(child: child, content: content);
      },
    );
  }

  RightDrawerContent whichDrawer(int index) {
    return RightDrawerContent(
      label: "Create Product",
      child: _buildAddProduct(),
    );
  }

  static Widget _buildAddProduct() {
    return const Padding(
      padding: EdgeInsets.all(10),
      child: Text("check"),
    );
  }
}
