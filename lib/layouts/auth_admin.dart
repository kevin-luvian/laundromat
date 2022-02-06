import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:laundry/blocs/bluetooth/bluetooth_bloc.dart';
import 'package:laundry/blocs/navigation/bloc.dart';
import 'package:laundry/common/button_navigation.dart';
import 'package:laundry/helpers/flutter_utils.dart';
import 'package:laundry/l10n/access_locale.dart';
import 'package:laundry/pages/newOrder/new_order_page.dart';
import 'package:laundry/pages/productsManager/products_manager_page.dart';
import 'package:laundry/pages/settings/settings_page.dart';
import 'package:laundry/providers/navButtonProvider.dart';
import 'package:laundry/running_assets/asset_access.dart';
import 'package:laundry/styles/theme.dart';
import 'package:provider/provider.dart';

class AuthAdminLayout extends StatefulWidget {
  const AuthAdminLayout({Key? key}) : super(key: key);

  @override
  State<AuthAdminLayout> createState() => _AuthAdminLayoutState();
}

class _AuthAdminLayoutState extends State<AuthAdminLayout>
    with TickerProviderStateMixin {
  late TabController _controller;
  late AnimationController _animation;
  bool _conn = false;

  final List<Widget> _tabs = [
    const NewOrderPage(),
    const Center(child: Text('Do you like trains?')),
    const ProductsManagerPage(),
    const SettingsPage(),
  ];

  @override
  void initState() {
    bluetoothBloc.currentConnection.then((val) => setState(() => _conn = val));
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
    super.initState();
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

  Widget _addBloc({Widget? child}) {
    return BlocListener<BluetoothBloc, BluetoothState>(
      bloc: bluetoothBloc,
      listener: (_ctx, _state) {
        setState(() {
          switch (_state.runtimeType) {
            case BluetoothConnectionState:
              _conn = (_state as BluetoothConnectionState).conn;
              break;
            default:
              _conn = false;
          }
        });
      },
      child: child,
    );
  }

  @override
  Widget build(BuildContext context) {
    return _addBloc(
      child: Scaffold(
        body: Row(
          children: [
            _buildLeftBar(),
            Expanded(child: _tabBarView()),
          ],
        ),
      ),
    );
  }

  Widget _buildLeftBar() {
    final color = colorScheme(context).primary;
    return Container(
      height: double.infinity,
      width: 80,
      decoration: BoxDecoration(color: color),
      child: ChangeNotifierProvider(
        create: (context) => NavButtonProvider(),
        child: Column(
          children: [
            SingleChildScrollView(
              child: _buildBtnNav(),
            ),
            const Spacer(),
            bluetoothConnectionBox(),
            const SizedBox(height: 15),
          ],
        ),
      ),
    );
  }

  Container bluetoothConnectionBox() {
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

  Widget _buildBtnNav() {
    return BlocProvider(
      create: (_) => NavigationBloc()..add(NavigationChangeEvent(index: 0)),
      child: BlocListener<NavigationBloc, int>(
        listener: (_, idx) => _controller.animateTo(idx),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
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
                icon: Icons.settings_outlined,
                desc: l10n(context)?.settings ?? "Settings"),
          ],
        ),
      ),
    );
  }
}
