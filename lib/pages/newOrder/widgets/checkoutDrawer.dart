import 'package:flutter/material.dart';

class CheckoutDrawer extends StatefulWidget {
  final Widget child;

  const CheckoutDrawer({Key? key, required this.child}) : super(key: key);

  @override
  _CheckoutDrawerState createState() => _CheckoutDrawerState();
}

class _CheckoutDrawerState extends State<CheckoutDrawer>
    with SingleTickerProviderStateMixin {
  late AnimationController _animation;
  bool show = true;

  @override
  initState() {
    _animation = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _animation.forward();

    super.initState();
  }

  @override
  void dispose() {
    _animation.dispose();
    super.dispose();
  }

  toggle() {
    setState(() {
      show = !show;
      if (show) {
        _animation.forward();
      } else {
        _animation.reverse();
      }
    });
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
              turns: Tween(begin: 0.0, end: 0.5).animate(_animation),
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
