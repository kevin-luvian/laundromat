import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:laundry/common/left_persistent_drawer.dart';
import 'package:laundry/cubits/orders/orders_filter_cubit.dart';
import 'package:laundry/helpers/flutter_utils.dart';
import 'package:laundry/pkg/filters/declare.dart';
import 'package:laundry/pages/orders_histories/widgets/filters/filter_date.dart';
import 'package:laundry/pages/orders_histories/widgets/filters/filter_names.dart';
import 'package:laundry/pages/orders_histories/widgets/filters/filter_status.dart';

class LeftFilterDrawer extends StatefulWidget {
  const LeftFilterDrawer({Key? key}) : super(key: key);

  @override
  _LeftFilterDrawerState createState() => _LeftFilterDrawerState();
}

class _LeftFilterDrawerState extends State<LeftFilterDrawer> {
  final padding = const EdgeInsets.all(10);

  @override
  build(context) {
    return LeftPersistentDrawer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _title(),
          _filterDrawerWidget(context),
        ],
      ),
    );
  }

  Widget _filterDrawerWidget(BuildContext context) {
    return FilterDrawerWidget(
      filters: const [
        FilterDateWidget(),
        FilterNameWidget(),
        FilterStatusWidget(),
      ],
      filterIcons: [
        filterDateWidgetIcon,
        filterNamesWidgetIcon,
        filterStatusWidgetIcon,
      ],
      blocListener: ({
        Widget? child,
        required void Function(List<FilterWidgetIcon>) callback,
      }) {
        return BlocListener<OrdersFilterCubit, OrdersFiltersState>(
          listener: (_ctx, state) {
            callback([
              filterDateWidgetIcon.modify(state.filterDate.hasValue),
              filterNamesWidgetIcon.modify(state.filterNames.hasValue),
              filterStatusWidgetIcon.modify(state.filterStatus.hasValue),
            ]);
          },
          child: child,
        );
      },
      onClearFilters: () => context.read<OrdersFilterCubit>().clearFilters(),
    );
  }

  Widget _title() {
    return Container(
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: Colors.black12,
            width: 1.5,
          ),
        ),
      ),
      child: Padding(
        padding: EdgeInsets.fromLTRB(
          padding.left,
          padding.top,
          padding.right,
          7,
        ),
        child: Text(
          "Filter",
          style: TextStyle(
            color: colorScheme(context).secondary,
            fontWeight: FontWeight.w900,
            fontSize: 17,
          ),
        ),
      ),
    );
  }
}
