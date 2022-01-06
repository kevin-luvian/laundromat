import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:laundry/blocs/navigation/bloc.dart';
import 'package:laundry/common/btnNav.dart';
import 'package:laundry/pages/newOrder/newOrderPage.dart';
import 'package:laundry/pages/settings/SettingsPage.dart';
import 'package:laundry/providers/navButtonProvider.dart';
import 'package:provider/provider.dart';

class AuthStaffLayout extends StatefulWidget {
  const AuthStaffLayout({Key? key}) : super(key: key);

  @override
  State<AuthStaffLayout> createState() => _AuthStaffLayoutState();
}

class _AuthStaffLayoutState extends State<AuthStaffLayout>
    with TickerProviderStateMixin {
  late TabController _controller;
  late AnimationController _animation;

  final List<Widget> _tabs = [
    const NewOrderPage(),
    const Center(child: Text('Do you like trains?')),
    const SettingsPage(),
  ];

  @override
  void initState() {
    super.initState();
    _animation = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    );
    _animation.forward();

    _controller = TabController(length: _tabs.length, vsync: this);
    _controller.addListener(() {
      if (_controller.indexIsChanging) {
        setState(() {
          _animation.forward(from: 0.5);
        });
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _animation.dispose();
    super.dispose();
  }

  _tabBarView() {
    return FadeTransition(
      opacity: _animation,
      child: _tabs[_controller.index],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          Container(
            width: 80,
            decoration:
                BoxDecoration(color: Theme.of(context).colorScheme.primary),
            constraints: const BoxConstraints(minWidth: 20),
            child: ChangeNotifierProvider(
              create: (context) => NavButtonProvider(),
              child: _buildBtnNav(context),
            ),
          ),
          Expanded(child: _tabBarView()),
        ],
      ),
    );
  }

  Widget _buildBtnNav(BuildContext context) {
    return BlocProvider(
      create: (_) => NavigationBloc()..add(NavigationChangeEvent(index: 0)),
      child: BlocListener<NavigationBloc, int>(
        listener: (_, idx) => _controller.animateTo(idx),
        child: Column(
          children: [
            ButtonNavigation(
                index: 0,
                icon: Icons.receipt_long,
                desc: AppLocalizations.of(context)?.new_orders ?? "New Orders"),
            ButtonNavigation(
                index: 1,
                icon: Icons.menu_book_outlined,
                desc: AppLocalizations.of(context)?.orders ?? "Orders"),
            ButtonNavigation(
                index: 2,
                icon: Icons.settings_outlined,
                desc: AppLocalizations.of(context)?.settings ?? "Settings"),
          ],
        ),
      ),
    );
  }
}
