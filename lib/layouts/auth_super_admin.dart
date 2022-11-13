import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:laundry/blocs/navigation/bloc.dart';
import 'package:laundry/common/button_navigation.dart';
import 'package:laundry/helpers/flutter_utils.dart';
import 'package:laundry/hooks/use_bluetooth_connection.dart';
import 'package:laundry/hooks/use_nav_animation.dart';
import 'package:laundry/l10n/access_locale.dart';
import 'package:laundry/pages/customers_manager/customers_manager_page.dart';
import 'package:laundry/pages/new_order/new_order_page.dart';
import 'package:laundry/pages/orders_histories/orders_histories.dart';
import 'package:laundry/pages/products_manager/products_manager_page.dart';
import 'package:laundry/pages/settings/settings_page.dart';
import 'package:laundry/pages/users_manager/users_manager.dart';
import 'package:laundry/providers/nav_button_provider.dart';
import 'package:laundry/running_assets/asset_access.dart';
import 'package:laundry/styles/theme.dart';
import 'package:provider/provider.dart';

class AuthSuperAdminLayout extends StatefulHookWidget {
  const AuthSuperAdminLayout({Key? key}) : super(key: key);

  @override
  State<AuthSuperAdminLayout> createState() => _AuthSuperAdminLayoutState();
}

class _AuthSuperAdminLayoutState extends State<AuthSuperAdminLayout> {
  final List<Widget> _tabs = [
    const NewOrderPage(),
    const OrdersHistories(),
    const ProductsManagerPage(),
    const CustomersManagerPage(),
    const UsersManagerPage(),
    const SettingsPage(),
  ];

  List<ButtonNavigation> buttonNavigationList() => [
        ButtonNavigation(
            index: 0,
            icon: Icons.receipt_long,
            desc: l10n(context)?.new_order ?? "New Order"),
        ButtonNavigation(
            index: 1,
            icon: Icons.menu_book_outlined,
            desc: l10n(context)?.orders ?? "Orders"),
        ButtonNavigation(
            index: 2,
            icon: Icons.book,
            desc: l10n(context)?.products ?? "Products"),
        ButtonNavigation(
            index: 3,
            icon: Icons.people_outline_rounded,
            desc: capitalizeFirstLetter(l10n(context)?.customers)),
        ButtonNavigation(
            index: 4,
            icon: Icons.supervised_user_circle_rounded,
            desc: capitalizeFirstLetter(l10n(context)?.users) ?? "Users"),
        ButtonNavigation(
            index: 5,
            icon: Icons.settings_outlined,
            desc: l10n(context)?.settings ?? "Settings"),
      ];

  Widget _tabBarView({
    required AnimationController animation,
    required int tabIndex,
  }) {
    return FadeTransition(opacity: animation, child: _tabs.elementAt(tabIndex));
  }

  @override
  build(context) {
    final navAnim = useNavAnimation(_tabs.length);
    final _conn = useBlueConnection(bluetoothBloc);
    return Scaffold(
      body: Row(
        children: [
          _buildLeftBar(
              (i) => setState(() {
                    navAnim.controller.animateTo(i);
                  }),
              _conn.value),
          Expanded(child: _tabs.elementAt(navAnim.controller.index)),
        ],
      ),
    );
  }

  Widget _buildLeftBar(void Function(int) onClick, bool _conn) {
    final color = colorScheme(context).primary;
    return Container(
      height: double.infinity,
      width: 80,
      decoration: BoxDecoration(color: color),
      child: ChangeNotifierProvider(
        create: (context) => NavButtonProvider(),
        child: SingleChildScrollView(
          child: SizedBox(
            height: screenSize(context).height,
            child: Column(
              children: [
                _buildBtnNav(onClick),
                const Spacer(),
                bluetoothConnectionBox(_conn),
                const SizedBox(height: 15),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Container bluetoothConnectionBox(bool _conn) {
    final color = _conn ? Colors.lightGreenAccent : GlobalColor.dim;
    return Container(
      width: 30,
      height: 30,
      decoration: BoxDecoration(
        color: color,
        borderRadius: const BorderRadius.all(Radius.circular(7)),
      ),
    );
  }

  Widget _buildBtnNav(void Function(int) onClick) {
    return BlocProvider(
      create: (_) => NavigationBloc()..add(NavigationChangeEvent(index: 0)),
      child: BlocListener<NavigationBloc, int>(
        listener: (_, idx) => setState(() {
          onClick(idx);
        }),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: buttonNavigationList(),
        ),
      ),
    );
  }
}
