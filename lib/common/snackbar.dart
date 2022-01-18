import 'package:flutter/material.dart';

void showToast({
  required BuildContext context,
  required String text,
  Duration? duration,
}) {
  final scaffold = ScaffoldMessenger.of(context);
  scaffold.showSnackBar(
    SnackBar(
      content: Text(text),
      duration: duration ?? const Duration(seconds: 4),
      action: SnackBarAction(
        label: 'UNDO',
        onPressed: scaffold.hideCurrentSnackBar,
      ),
    ),
  );
}
