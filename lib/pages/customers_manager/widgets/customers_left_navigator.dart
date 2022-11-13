import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:laundry/common/left_persistent_drawer.dart';
import 'package:laundry/common/rect_button.dart';
import 'package:laundry/helpers/flutter_utils.dart';
import 'package:laundry/l10n/access_locale.dart';
import 'package:laundry/pages/customers_manager/widgets/filters/filter_search.dart';
import 'package:laundry/pkg/filters/declare.dart';

import '../../../cubits/customers/customers_filter_cubit.dart';
import 'filters/filter_date.dart';

class CustomersLeftNavigator extends StatefulWidget {
  const CustomersLeftNavigator({Key? key}) : super(key: key);

  @override
  _CustomersLeftNavigatorState createState() => _CustomersLeftNavigatorState();
}

class _CustomersLeftNavigatorState extends State<CustomersLeftNavigator> {
  final EdgeInsets _padding = const EdgeInsets.all(10);
  final double _contentGap = 7.0;

  @override
  Widget build(BuildContext context) {
    return LeftPersistentDrawer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildHeader(context),
          _filterDrawerWidget(context),
          Expanded(child: Container()),
          _createCustomerButton(context)
        ],
      ),
    );
  }

  Widget _filterDrawerWidget(BuildContext context) {
    return FilterDrawerWidget(
      filters: const [FilterDateWidget(), FilterSearchWidget()],
      filterIcons: [filterDateWidgetIcon, filterSearchWidgetIcon],
      onClearFilters: () => context.read<CustomersFilterCubit>().clearFilters(),
      blocListener: ({
        Widget? child,
        required void Function(List<FilterWidgetIcon>) callback,
      }) {
        return BlocListener<CustomersFilterCubit, CustomersFiltersState>(
          listener: (_, state) {
            callback([
              filterDateWidgetIcon.modify(state.filterDate.hasValue),
              filterSearchWidgetIcon.modify(state.filterSearch.hasValue),
            ]);
          },
          child: child,
        );
      },
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
          capitalizeFirstLetter(l10n(context)?.customers),
          style: TextStyle(
            color: Theme.of(context).colorScheme.primary,
            fontWeight: FontWeight.w900,
            fontSize: 17,
          ),
        ),
      ),
    );
  }

  Widget _createCustomerButton(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(
        _padding.left,
        _contentGap,
        _padding.right,
        _padding.bottom,
      ),
      child: RectButton(
        onPressed: () {},
        child: const Icon(Icons.add, size: 20),
      ),
    );
  }
}
