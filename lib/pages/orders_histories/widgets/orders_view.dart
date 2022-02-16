import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:laundry/cubits/orders/orders_cubit.dart';
import 'package:laundry/db/aggregates/order_details.dart';
import 'package:laundry/helpers/flutter_utils.dart';
import 'package:laundry/helpers/utils.dart';
import 'package:laundry/l10n/access_locale.dart';

class OrdersView extends StatefulWidget {
  const OrdersView({Key? key}) : super(key: key);

  @override
  _OrdersViewState createState() => _OrdersViewState();
}

class _OrdersViewState extends State<OrdersView> {
  bool allLoaded = false;
  final _scrollController = ScrollController();

  @override
  void initState() {
    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
          _scrollController.position.maxScrollExtent * 0.9) {
        handleLoadMore();
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void handleLoadMore() async {
    if (allLoaded) return;
    await waitMilliseconds(200);
    context.read<OrdersCubit>().loadMore(10);
  }

  @override
  build(context) {
    return BlocConsumer<OrdersCubit, OrdersState>(
      listener: (_ctx, state) => setState(() => allLoaded = state.noMoreData),
      builder: (_ctx, state) => Expanded(
        child: ListView.separated(
          shrinkWrap: true,
          controller: _scrollController,
          itemCount: state.length + 1,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          itemBuilder: (_ctx, i) {
            if (i >= state.length) {
              return allLoaded ? _noMoreData() : _loadingView();
            }
            return OrderCard.fromOrderDetail(state.elementAt(i));
          },
          separatorBuilder: (_ctx, i) => const SizedBox(height: 3),
        ),
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

class OrderCard extends StatelessWidget {
  factory OrderCard.fromOrderDetail(OrderDetail detail) {
    return OrderCard(
      title: detail.streamId,
      date: detail.createDate,
      customer: detail.customer?.name,
    );
  }

  const OrderCard({
    required this.title,
    required this.date,
    String? customer,
  })  : customer = customer ?? "-",
        super(key: null);

  final String title;
  final DateTime date;
  final String customer;

  @override
  build(context) {
    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
      child: InkWell(
        borderRadius: BorderRadius.circular(5),
        onTap: () {},
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 15,
                  color: colorScheme(context).onSurface,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 5),
              _infoBar(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _infoBar(BuildContext context) {
    final color = colorScheme(context).onSurface;
    return Row(
      children: [
        _infoItem(Icons.calendar_today_rounded,
            dateToStringLocale(date, l10n(context)), color),
        const SizedBox(width: 7),
        _infoItem(Icons.account_circle, customer, color),
      ],
    );
  }

  Row _infoItem(IconData icon, String text, Color color) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Icon(icon, size: 14, color: color),
        const SizedBox(width: 5),
        Text(text, style: TextStyle(color: color)),
      ],
    );
  }
}
