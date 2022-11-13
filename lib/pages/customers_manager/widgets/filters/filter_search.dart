import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:laundry/cubits/customers/customers_filter_cubit.dart';
import 'package:laundry/helpers/input_decoration.dart';
import 'package:laundry/hooks/use_customer_name_filter.dart';
import 'package:laundry/pkg/filters/declare.dart';

final filterSearchWidgetIcon =
    FilterWidgetIcon(Icons.perm_identity_rounded, false);

class FilterSearchWidget extends HookWidget {
  const FilterSearchWidget({Key? key}) : super(key: key);

  @override
  build(context) {
    final cubit = context.read<CustomersFilterCubit>();
    final nameHook = useDoubleTextControllerHook(
      initial: cubit.searchName,
      onChange: (name) => cubit.modifySearch(name, null),
    );
    final nameDecor = inputDecoration(context, "name");

    final phoneHook = useDoubleTextControllerHook(
      initial: cubit.searchPhone,
      onChange: (phone) => cubit.modifySearch(null, phone),
    );
    final phoneDecor = inputDecoration(context, "phone");

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Column(
        children: [
          TextFormField(
            onTap: () => showDialog<void>(
              context: context,
              builder: (_) => SearchTextForm(
                nameHook.tempCtr,
                nameDecor,
              ),
            ).then((_) => nameHook.notifyTextChange()),
            controller: nameHook.textCtr,
            readOnly: true,
            decoration: nameDecor,
          ),
          const SizedBox(height: 15),
          TextFormField(
            onTap: () => showDialog<void>(
              context: context,
              builder: (_) => SearchTextForm(
                phoneHook.tempCtr,
                phoneDecor,
              ),
            ).then((_) => phoneHook.notifyTextChange()),
            controller: phoneHook.textCtr,
            readOnly: true,
            decoration: phoneDecor,
          ),
        ],
      ),
    );
  }
}

class SearchTextForm extends StatelessWidget {
  const SearchTextForm(this.textCtr, this.decoration) : super(key: null);

  final TextEditingController textCtr;
  final InputDecoration decoration;

  @override
  build(context) {
    return AlertDialog(
      title: const Text(
        'Search',
        style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
      ),
      content: SizedBox(
        width: 350,
        child: TextFormField(
          controller: textCtr,
          keyboardType: TextInputType.text,
          decoration: decoration,
          autofocus: true,
        ),
      ),
    );
  }
}
