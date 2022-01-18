import 'package:flutter/material.dart';

class LeftPersistentDrawer extends StatelessWidget {
  const LeftPersistentDrawer({Key? key, required this.child}) : super(key: key);

  final Widget child;
  final double width = 300;

  @override
  Widget build(BuildContext context) {
    final surfaceColor = Theme.of(context).colorScheme.surface;
    return Container(
      child: SizedBox(
        width: width,
        height: double.infinity,
        child: child,
      ),
      decoration: BoxDecoration(
        color: surfaceColor,
        boxShadow: const [
          BoxShadow(
            color: Color.fromRGBO(0, 0, 0, .05),
            offset: Offset(6, 0),
            blurRadius: 6,
            spreadRadius: 0,
          )
        ],
      ),
    );
  }
}
