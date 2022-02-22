import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:laundry/common/right_drawer.dart';
import 'package:laundry/cubits/orders/order_drawer_cubit.dart';
import 'package:laundry/cubits/orders/orders_cubit.dart';
import 'package:laundry/cubits/orders/orders_filter_cubit.dart';
import 'package:laundry/cubits/right_drawer.dart';
import 'package:laundry/pages/orders_histories/widgets/left_filter_drawer.dart';
import 'package:laundry/pages/orders_histories/widgets/orders_view.dart';
import 'package:laundry/pages/orders_histories/widgets/right_drawer/order_right_drawer.dart';
import 'package:laundry/running_assets/dao_access.dart';
import 'package:laundry/running_assets/db_access.dart';

class OrdersHistories extends StatelessWidget {
  const OrdersHistories() : super(key: null);

  Widget _attachProviders({required Widget child}) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<RightDrawerCubit>(create: (_) => RightDrawerCubit()),
        BlocProvider<OrderDrawerCubit>(
            create: (_ctx) =>
                OrderDrawerCubit(ordersDao, _ctx.read<RightDrawerCubit>())),
        BlocProvider<OrdersFilterCubit>(create: (_) => OrdersFilterCubit()),
        BlocProvider<OrdersCubit>(
          create: (_ctx) =>
              OrdersCubit(eventDB, driftDB, _ctx.read<OrdersFilterCubit>())
                ..setup(),
        ),
      ],
      child: child,
    );
  }

  Widget _rightDrawer({required BuildContext context, required Widget child}) {
    return RightDrawer(
      content: OrderDetailRightDrawerContent(context),
      child: child,
    );
  }

  @override
  build(context) {
    return _attachProviders(
      child: _rightDrawer(
        context: context,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: const [
            LeftFilterDrawer(),
            OrdersView(),
          ],
        ),
      ),
    );
  }
}
