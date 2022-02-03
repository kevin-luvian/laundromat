import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:laundry/blocs/newOrder/newOrderBloc.dart';
import 'package:laundry/common/right_drawer.dart';
import 'package:laundry/cubits/right_drawer.dart';
import 'package:laundry/pages/newOrder/widgets/checkout/checkout.dart';
import 'package:laundry/pages/newOrder/widgets/product_details.dart';
import 'package:laundry/pages/newOrder/widgets/products_view_selector.dart';

class NewOrderPage extends StatelessWidget {
  const NewOrderPage({Key? key}) : super(key: key);

  Widget _attachProviders({required Widget child}) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<RightDrawerCubit>(create: (_) => RightDrawerCubit()),
        BlocProvider<NewOrderBloc>(
          create: (_ctx) => NewOrderBloc(_ctx.read<RightDrawerCubit>()),
        ),
      ],
      child: child,
    );
  }

  Widget _buildDrawer({required BuildContext context, required Widget child}) {
    return BlocBuilder<RightDrawerCubit, RightDrawerState>(
      builder: (_, _s) {
        final label = _s.title ?? "Product Details";
        return RightDrawer(
          content: RightDrawerContent(
            label: label,
            child: const ProductDetails(),
          ),
          child: child,
        );
      },
    );
  }

  @override
  Widget build(context) {
    return _attachProviders(
      child: _buildDrawer(
        context: context,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: const [
            Checkout(width: 250, padding: EdgeInsets.all(10)),
            ProductsViewSelector(),
          ],
        ),
      ),
    );
  }
}
