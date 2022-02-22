import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:laundry/cubits/orders/orders_cubit.dart';
import 'package:laundry/hooks/use_scroll_controller.dart';
import 'package:laundry/pages/orders_histories/widgets/order_view_flat.dart';

class OrdersView extends HookWidget {
  const OrdersView() : super(key: null);

  @override
  build(context) {
    final cubit = context.read<OrdersCubit>();
    final _state = useStream(cubit.stream);
    final orders = _state.data;

    final controller = useScrollListener(onMaxScroll: () async {
      if (orders?.noMoreData ?? false) return;
      cubit.loadMore(10);
    });

    if (orders == null || (orders.isEmpty && !orders.noMoreData)) {
      return Expanded(child: Center(child: _loadingView()));
    }
    return Expanded(
      child: ListView.separated(
        shrinkWrap: true,
        controller: controller,
        itemCount: orders.length + 1,
        itemBuilder: (_ctx, i) {
          if (i >= orders.length) {
            return orders.noMoreData ? _noMoreData() : _loadingView();
          }
          return OrderViewFlat.fromOrderDetail(orders.elementAt(i));
        },
        separatorBuilder: (_ctx, i) =>
            const SizedBox(height: 2, child: Divider()),
      ),
    );
  }

  Widget _loadingView() {
    return const Center(
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 15),
        child: CircularProgressIndicator(),
      ),
    );
  }

  Widget _noMoreData() {
    return const Center(
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 15),
        child: Text("no more data"),
      ),
    );
  }
}
