import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:laundry/helpers/flutter_utils.dart';

class RectButton extends StatelessWidget {
  const RectButton({
    Key? key,
    bool? disabled,
    Size? size,
    EdgeInsets? padding,
    this.elevation,
    this.color,
    this.onPressed,
    required this.child,
  })  : disabled = disabled ?? false,
        size = size ?? const Size.fromHeight(45),
        padding = padding ?? EdgeInsets.zero,
        super(key: key);

  final bool disabled;
  final Size size;
  final EdgeInsets padding;
  final Color? color;
  final double? elevation;
  final void Function()? onPressed;
  final Widget child;

  @override
  build(context) {
    Color _color = color ?? colorScheme(context).secondary;

    return ElevatedButton(
      onPressed: disabled ? null : onPressed,
      style: ElevatedButton.styleFrom(
        elevation: elevation,
        padding: padding,
        primary: _color,
        minimumSize: size,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(10)),
        ),
      ),
      child: child,
    );
  }
}
