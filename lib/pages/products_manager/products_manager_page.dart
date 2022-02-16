import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:laundry/blocs/products/product_editor_bloc.dart';
import 'package:laundry/blocs/products/products_view_bloc.dart';
import 'package:laundry/common/products/products_view.dart';
import 'package:laundry/common/right_drawer.dart';
import 'package:laundry/cubits/right_drawer.dart';
import 'package:laundry/db/drift_db.dart';
import 'package:laundry/db/event_db.dart';
import 'package:laundry/pages/products_manager/widgets/create_update_product_form.dart';
import 'package:laundry/pages/products_manager/widgets/product_left_navigator.dart';

class ProductsManagerPage extends StatelessWidget {
  const ProductsManagerPage({Key? key}) : super(key: key);

  Widget _attachProviders({required Widget child}) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<RightDrawerCubit>(create: (_) => RightDrawerCubit()),
        BlocProvider<ProductEditorBloc>(
          create: (_ctx) => ProductEditorBloc(
            GetIt.I.get<DriftDB>(),
            GetIt.I.get<EventDB>(),
            _ctx.read<RightDrawerCubit>(),
          ),
        ),
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
        context: context,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const ProductLeftNavigator(),
            BlocBuilder<ProductEditorBloc, ProductEditorState>(
              builder: (_ctx, _) => Expanded(
                child: ProductsView(
                  onProductTap: (product) {
                    _ctx
                        .read<ProductEditorBloc>()
                        .add(InitiateUpdateProductEvent(product));
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDrawer({required BuildContext context, required Widget child}) {
    return BlocBuilder<RightDrawerCubit, RightDrawerState>(
      builder: (_, _state) {
        final label = _state.index == createProductIndex
            ? "Create Product"
            : "Update Product";
        return RightDrawer(
          content: RightDrawerContent(
            label: label,
            child: CreateUpdateProductForm(
              deleteConfirmation: (dialog) =>
                  showDialog<void>(context: context, builder: (_) => dialog),
            ),
          ),
          child: child,
        );
      },
    );
  }
}
