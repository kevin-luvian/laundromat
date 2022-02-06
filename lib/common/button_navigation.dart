import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:laundry/blocs/navigation/bloc.dart';

class ButtonNavigation extends StatefulWidget {
  final int index;
  final IconData icon;
  final String desc;

  const ButtonNavigation({
    Key? key,
    required this.index,
    required this.icon,
    required this.desc,
  }) : super(key: key);

  @override
  _ButtonNavigationState createState() => _ButtonNavigationState();
}

class _ButtonNavigationState extends State<ButtonNavigation>
    with SingleTickerProviderStateMixin {
  late final AnimationController _animation = AnimationController(
      duration: const Duration(milliseconds: 300), vsync: this)
    ..reverse();

  @override
  void dispose() {
    _animation.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<NavigationBloc, int>(
      listener: (_, idx) {
        if (widget.index == idx) {
          _animation.forward();
        } else {
          _animation.reverse();
        }
      },
      builder: (_, idx) {
        var color = Colors.white70;
        if (widget.index == idx) {
          color = Colors.white;
        }

        return SizedBox(
          width: double.infinity,
          child: MaterialButton(
            onPressed: () {
              context
                  .read<NavigationBloc>()
                  .add(NavigationChangeEvent(index: widget.index));
            },
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Column(
                children: [
                  Icon(widget.icon, color: color, size: 35),
                  const SizedBox(height: 5),
                  SizeTransition(
                    sizeFactor: _animation,
                    axis: Axis.vertical,
                    axisAlignment: -1,
                    child: Center(
                      child: Text(
                        widget.desc,
                        textAlign: TextAlign.center,
                        style: TextStyle(color: color, fontSize: 10),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
