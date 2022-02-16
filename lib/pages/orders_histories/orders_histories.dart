import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:laundry/cubits/orders/orders_cubit.dart';
import 'package:laundry/cubits/orders/orders_filter_cubit.dart';
import 'package:laundry/pages/orders_histories/widgets/left_filter_drawer.dart';
import 'package:laundry/pages/orders_histories/widgets/orders_view.dart';
import 'package:laundry/running_assets/db_access.dart';

class OrdersHistories extends StatelessWidget {
  const OrdersHistories() : super(key: null);

  Widget _attachProviders({required Widget child}) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<OrdersFilterCubit>(create: (_) => OrdersFilterCubit()),
        BlocProvider<OrdersCubit>(
          create: (_ctx) =>
              OrdersCubit(eventDB, _ctx.read<OrdersFilterCubit>())..setup(),
        ),
      ],
      child: child,
    );
  }

  @override
  build(context) {
    return _attachProviders(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: const [
          LeftFilterDrawer(),
          OrdersView(),
        ],
      ),
    );
  }
}
