import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:laundry/blocs/newOrder/new_order_bloc.dart';
import 'package:laundry/blocs/products/productsViewBloc.dart';
import 'package:laundry/common/products/products_view.dart';
import 'package:laundry/common/rect_button.dart';
import 'package:laundry/db/drift_db.dart';
import 'package:laundry/running_assets/dao_access.dart';
import 'package:laundry/styles/theme.dart';

class ProductsViewSelector extends StatefulWidget {
  const ProductsViewSelector({Key? key}) : super(key: key);

  @override
  _ProductsViewSelectorState createState() => _ProductsViewSelectorState();
}

class _ProductsViewSelectorState extends State<ProductsViewSelector> {
  String? _selectedCategory;

  Widget _attachProviders({required Widget child}) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<ProductsBloc>(
            create: (_) => ProductsBloc(GetIt.I.get<DriftDB>())),
      ],
      child: child,
    );
  }

  @override
  Widget build(BuildContext context) {
    return _attachProviders(
      child: Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
                child: ProductsView(
                    onProductTap: (product) => context
                        .read<NewOrderBloc>()
                        .add(OpenProductEvent(product)))),
            _buildCategorySelector(),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildCategorySelector() {
    return StreamBuilder(
      stream: productDao.distinctCategories,
      builder: (_context, AsyncSnapshot<List<String>> snapshot) {
        final categories = snapshot.data ?? [];

        return SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
            child: Row(
              children: categories
                  .map((c) => _buildCategorySelectorBtn(_context, c))
                  .toList(),
            ),
          ),
        );
      },
    );
  }

  Widget _buildCategorySelectorBtn(BuildContext context, String category) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5),
      child: RectButton(
        size: const Size(0, 50),
        color: _selectedCategory != category ? GlobalColor.dim : null,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Text(category),
        ),
        onPressed: () {
          setState(() => _selectedCategory = category);
          context.read<ProductsBloc>().add(CategoryChangedEvent(category));
        },
      ),
    );
  }
}
