import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:laundry/common/left_persistent_drawer.dart';
import 'package:laundry/common/rect_button.dart';
import 'package:laundry/cubits/orders/orders_filter_cubit.dart';
import 'package:laundry/helpers/flutter_utils.dart';
import 'package:laundry/pages/orders_histories/widgets/filters/declare.dart';
import 'package:laundry/pages/orders_histories/widgets/filters/filter_date.dart';
import 'package:laundry/pages/orders_histories/widgets/filters/filter_drawer.dart';
import 'package:laundry/pages/orders_histories/widgets/filters/filter_names.dart';
import 'package:laundry/pages/orders_histories/widgets/filters/filter_status.dart';
import 'package:laundry/styles/theme.dart';

class LeftFilterDrawer extends StatefulWidget {
  const LeftFilterDrawer({Key? key}) : super(key: key);

  @override
  _LeftFilterDrawerState createState() => _LeftFilterDrawerState();
}

class _LeftFilterDrawerState extends State<LeftFilterDrawer> {
  final padding = const EdgeInsets.all(10);

  int selectedFilterIndex = -1;

  List<FilterWidgetIcon> filters = [
    filterDateWidgetIcon,
    filterNamesWidgetIcon,
    filterStatusWidgetIcon,
  ];

  final filterWidgets = [
    const FilterDateWidget(),
    const FilterNameWidget(),
    const FilterStatusWidget(),
  ];

  Widget _filterBlocListener({Widget? child}) {
    return BlocListener<OrdersFilterCubit, OrdersFiltersState>(
      listener: (_ctx, state) {
        setState(() {
          filters = [
            filterDateWidgetIcon.modify(state.filterDate.hasValue),
            filterNamesWidgetIcon.modify(state.filterNames.hasValue),
            filterStatusWidgetIcon.modify(state.filterStatus.hasValue),
          ];
        });
      },
      child: child,
    );
  }

  void handleClearFilters() {
    setState(() => selectedFilterIndex = -1);
    context.read<OrdersFilterCubit>().clearFilters();
  }

  @override
  build(context) {
    return _filterBlocListener(
      child: LeftPersistentDrawer(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _title(),
            _filterActions(),
            FilterDrawer(
              child: selectedFilterIndex < 0 ||
                      selectedFilterIndex >= filterWidgets.length
                  ? null
                  : filterWidgets.elementAt(selectedFilterIndex),
            )
          ],
        ),
      ),
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

  Widget _filterActions() {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 7),
      scrollDirection: Axis.horizontal,
      child: Row(children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(0, 0, 10, 0),
          child: RectButton(
            elevation: 0,
            onPressed: handleClearFilters,
            size: const Size(50, 50),
            child: const Icon(Icons.delete_outline_rounded, size: 23),
          ),
        ),
        ..._filtersWidgets()
      ]),
    );
  }

  List<Widget> _filtersWidgets() => filters
      .asMap()
      .entries
      .map(
        (f) => _filterActionButton(
          icon: f.value.icon,
          active: f.value.isActive,
          selected: f.key == selectedFilterIndex,
          onPressed: () => setState(() => selectedFilterIndex = f.key),
        ),
      )
      .toList();

  Widget _filterActionButton({
    required IconData icon,
    required void Function() onPressed,
    bool active = false,
    bool selected = false,
  }) {
    final color =
        active ? colorScheme(context).primaryVariant : GlobalColor.dim;
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 0, 10, 0),
      child: RectButton(
        color: color,
        elevation: selected ? 4 : 0,
        onPressed: onPressed,
        size: const Size(50, 50),
        child: Icon(icon, size: 23),
      ),
    );
  }
}
