import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:laundry/common/dismiss_keyboard.dart';
import 'package:laundry/cubits/right_drawer.dart';

class RightDrawerContent {
  const RightDrawerContent({
    required this.child,
    required this.label,
    double? width,
  }) : width = width ?? 400;

  final Widget child;
  final double width;
  final String label;
}

class RightDrawer extends StatefulWidget {
  const RightDrawer({Key? key, required this.child, required this.content})
      : super(key: key);

  final RightDrawerContent content;
  final Widget child;

  @override
  _RightDrawerState createState() => _RightDrawerState();
}

class _RightDrawerState extends State<RightDrawer>
    with SingleTickerProviderStateMixin {
  static const Duration _animationDuration = Duration(milliseconds: 500);
  late final AnimationController _controller;
  late final Animation<double> _animation;

  bool _clearBarrier = true;
  bool _show = false;
  int currIndex = 0;

  void openDrawer() {
    setState(() {
      _show = true;
      _clearBarrier = false;
      _controller.forward();
    });
  }

  void closeDrawer() {
    setState(() {
      _show = false;
      _controller.reverse();
    });
  }

  void emitCloseDrawer(BuildContext context) {
    BlocProvider.of<RightDrawerCubit>(context).closeDrawer();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  void initState() {
    _controller = AnimationController(
      duration: _animationDuration,
      vsync: this,
    );
    _animation = Tween(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(parent: _controller, curve: Curves.fastOutSlowIn));

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final maxHeight = MediaQuery.of(context).size.height;
    final surfaceColor = Theme.of(context).colorScheme.surface;

    return BlocListener<RightDrawerCubit, RightDrawerState>(
      listener: (_ctx, _state) {
        currIndex = _state.index;
        if (_state.show) {
          openDrawer();
        } else {
          closeDrawer();
        }
      },
      child: Align(
        alignment: Alignment.center,
        child: Stack(
          fit: StackFit.expand,
          children: <Widget>[
            widget.child,
            !_clearBarrier ? _modalBarrier(context) : Container(),
            Positioned(
              right: 0,
              child: SizeTransition(
                sizeFactor: _animation,
                axis: Axis.horizontal,
                axisAlignment: -1,
                child: Container(
                  width: widget.content.width,
                  height: maxHeight,
                  color: surfaceColor,
                  child: _buildContent(context),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContent(BuildContext context) {
    final icon = _show ? Icons.arrow_right : Icons.arrow_left;
    const splashColor = Color.fromRGBO(0, 0, 0, .05);
    final onSurfaceColor = Theme.of(context).colorScheme.onSurface;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            SizedBox(
              width: 50,
              child: TextButton(
                onPressed: () => emitCloseDrawer(context),
                style: ButtonStyle(
                  overlayColor:
                      MaterialStateColor.resolveWith((_) => splashColor),
                  alignment: Alignment.topLeft,
                ),
                child: Icon(icon, color: onSurfaceColor, size: 30),
              ),
            ),
            const SizedBox(width: 10),
            Text(
              widget.content.label,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
            ),
          ],
        ),
        Expanded(child: widget.content.child),
      ],
    );
  }

  Widget _modalBarrier(BuildContext context) {
    return Positioned.fill(
      child: GestureDetector(
        onTap: () {
          final currentFocus = FocusScope.of(context);
          if (!currentFocus.hasPrimaryFocus &&
              currentFocus.focusedChild != null) {
            unFocusInput(context);
          } else {
            emitCloseDrawer(context);
          }
        },
        child: AnimatedOpacity(
          opacity: _show ? 0.2 : 0,
          duration: _animationDuration,
          child: Container(color: Colors.black),
          onEnd: () {
            setState(() => _clearBarrier = true);
          },
        ),
      ),
    );
  }
}
