import 'package:flutter/material.dart';
import 'package:laundry/helpers/flutter_utils.dart';

class RectButton extends StatelessWidget {
  const RectButton({
    Key? key,
    this.color,
    this.size,
    this.onPressed,
    required this.child,
  }) : super(key: key);

  final Size? size;
  final Color? color;
  final Function? onPressed;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final _onPressed = onPressed ?? () {};
    final _color = color ?? colorScheme(context).secondary;
    final _size = size ?? const Size.fromHeight(45);

    return ElevatedButton(
      onPressed: () => _onPressed(),
      style: ElevatedButton.styleFrom(
        primary: _color,
        minimumSize: _size,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(10)),
        ),
      ),
      child: child,
    );
  }
}
