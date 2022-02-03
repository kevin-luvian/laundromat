import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';

class CheckoutDrawer extends StatefulWidget {
  final Widget child;

  const CheckoutDrawer({Key? key, required this.child}) : super(key: key);

  @override
  _CheckoutDrawerState createState() => _CheckoutDrawerState();
}

class _CheckoutDrawerState extends State<CheckoutDrawer>
    with SingleTickerProviderStateMixin {
  late StreamSubscription<bool> _keyboardSubscription;
  late AnimationController _controller;
  late final Animation<double> _animation;
  bool show = true;

  @override
  initState() {
    KeyboardVisibilityController _kvc = KeyboardVisibilityController();
    _keyboardSubscription = _kvc.onChange.listen((isVisible) {
      if (isVisible) close();
    });

    _controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    )..forward();
    _animation = Tween(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(parent: _controller, curve: Curves.fastOutSlowIn));
    super.initState();
  }

  @override
  void dispose() {
    _keyboardSubscription.cancel();
    _controller.dispose();
    super.dispose();
  }

  open() {
    setState(() {
      show = true;
      _controller.forward();
    });
  }

  close() {
    setState(() {
      show = false;
      _controller.reverse();
    });
  }

  toggle() {
    if (show) {
      close();
    } else {
      open();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          decoration: const BoxDecoration(
            border: Border(
              top: BorderSide(
                color: Colors.black12,
                width: 1.7,
              ),
            ),
          ),
          child: TextButton(
            onPressed: toggle,
            style: TextButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.surface,
              primary: Theme.of(context).colorScheme.onSurface,
              minimumSize: Size.fromHeight(show ? 35 : 40),
              shape:
                  const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
            ),
            child: RotationTransition(
              turns: Tween(begin: 0.0, end: 0.5).animate(_controller),
              child: const Icon(
                Icons.keyboard_arrow_up,
                color: Color.fromRGBO(0, 0, 0, 0.5),
              ),
            ),
          ),
        ),
        SizeTransition(
          sizeFactor: _animation,
          axis: Axis.vertical,
          axisAlignment: -1,
          child: widget.child,
        ),
      ],
    );
  }
}
