import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:laundry/cubits/customers/customers_filter_cubit.dart';
import 'package:laundry/cubits/right_drawer.dart';
import 'package:laundry/pages/customers_manager/widgets/customers_left_navigator.dart';

class CustomersManagerPage extends StatelessWidget {
  const CustomersManagerPage() : super(key: null);

  Widget _attachProviders({required Widget child}) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<RightDrawerCubit>(create: (_) => RightDrawerCubit()),
        BlocProvider<CustomersFilterCubit>(
            create: (_) => CustomersFilterCubit()),
      ],
      child: child,
    );
  }

  @override
  build(context) {
    return _attachProviders(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: const [CustomersLeftNavigator()],
      ),
    );
  }
}
