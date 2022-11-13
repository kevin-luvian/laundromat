import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:laundry/cubits/orders/orders_filter_cubit.dart';
import 'package:laundry/helpers/input_decoration.dart';
import 'package:laundry/hooks/use_customer_name_filter.dart';
import 'package:laundry/pkg/filters/declare.dart';

final filterNamesWidgetIcon =
    FilterWidgetIcon(Icons.perm_identity_rounded, false);

class FilterNameWidget extends HookWidget {
  const FilterNameWidget({Key? key}) : super(key: key);

  @override
  build(context) {
    final cubit = context.read<OrdersFilterCubit>();
    final customerName = useDoubleTextControllerHook(
      initial: cubit.customerName,
      onChange: (name) => cubit.modifyNames(customerName: name),
    );
    final staffName = useDoubleTextControllerHook(
      initial: cubit.staffName,
      onChange: (name) => cubit.modifyNames(staffName: name),
    );

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Column(
        children: [
          TextFormField(
            onTap: () => showDialog<void>(
              context: context,
              builder: (_) => SearchCustomerNameForm(staffName.tempCtr),
            ).then((_) => staffName.notifyTextChange()),
            controller: staffName.textCtr,
            readOnly: true,
            decoration: inputDecoration(context, "staff name"),
          ),
          const SizedBox(height: 15),
          TextFormField(
            onTap: () => showDialog<void>(
              context: context,
              builder: (_) => SearchCustomerNameForm(customerName.tempCtr),
            ).then((_) => customerName.notifyTextChange()),
            controller: customerName.textCtr,
            readOnly: true,
            decoration: inputDecoration(context, "customer name"),
          ),
        ],
      ),
    );
  }
}

class SearchCustomerNameForm extends StatelessWidget {
  const SearchCustomerNameForm(this.textCtr) : super(key: null);

  final TextEditingController textCtr;

  @override
  build(context) {
    return AlertDialog(
      title: const Text(
        'Search Customer Name',
        style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
      ),
      content: SizedBox(
        width: 350,
        child: TextFormField(
          controller: textCtr,
          keyboardType: TextInputType.text,
          decoration: inputDecoration(context, "name"),
          autofocus: true,
        ),
      ),
    );
  }
}
