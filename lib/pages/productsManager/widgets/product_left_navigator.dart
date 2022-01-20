import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:laundry/common/left_persistent_drawer.dart';
import 'package:laundry/common/rect_button.dart';
import 'package:laundry/cubits/right_drawer.dart';
import 'package:laundry/l10n/access_locale.dart';
import 'package:laundry/pages/productsManager/widgets/animated_category_list.dart';
import 'package:laundry/pages/productsManager/widgets/create_product_form.dart';

class ProductLeftNavigator extends StatefulWidget {
  const ProductLeftNavigator({Key? key}) : super(key: key);

  @override
  _ProductLeftNavigatorState createState() => _ProductLeftNavigatorState();
}

class _ProductLeftNavigatorState extends State<ProductLeftNavigator> {
  final EdgeInsets _padding = const EdgeInsets.all(10);
  final double _contentGap = 7.0;

  @override
  Widget build(BuildContext context) {
    return LeftPersistentDrawer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildHeader(context),
          _buildCategorySelector(),
          _createProductButton(context),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(color: Colors.black12, width: 1.5),
        ),
      ),
      child: Padding(
        padding:
            EdgeInsets.fromLTRB(_padding.left, _padding.top, _padding.right, 7),
        child: Text(
          l10n(context)?.products ?? "Products",
          style: TextStyle(
            color: Theme.of(context).colorScheme.primary,
            fontWeight: FontWeight.w900,
            fontSize: 17,
          ),
        ),
      ),
    );
  }

  Widget _buildCategorySelector() {
    return const Flexible(
      fit: FlexFit.loose,
      child: AnimatedCategoryList(),
    );
  }

  Widget _createProductButton(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(
        _padding.left,
        _contentGap,
        _padding.right,
        _padding.bottom,
      ),
      child: RectButton(
        onPressed: () =>
            context.read<RightDrawerCubit>().showDrawer(CREATE_PRODUCT_INDEX),
        child: const Icon(Icons.add, size: 30),
      ),
    );
  }
}
