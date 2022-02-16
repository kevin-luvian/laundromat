import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:laundry/helpers/flutter_utils.dart';
import 'package:laundry/hooks/use_content_drawer.dart';
import 'package:laundry/hooks/use_keyboard_listener.dart';

class FilterDrawer extends HookWidget {
  FilterDrawer({Widget? child})
      : child = child ?? Container(),
        shouldShow = child != null,
        super(key: null);

  final bool shouldShow;
  final Widget child;

  @override
  build(context) {
    final drawer = useContentDrawer();
    useKeyboardListener((visible) => visible ? drawer.close() : drawer.open());

    useEffect(() {
      shouldShow ? drawer.open() : drawer.close();
    }, [child]);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (shouldShow)
          SizeTransition(
              sizeFactor: drawer.tween, axis: Axis.vertical, child: _content()),
        Container(
          margin: EdgeInsets.zero,
          padding: EdgeInsets.zero,
          height: drawer.show.value ? 55 : 40,
          decoration: const BoxDecoration(
            border: Border(bottom: BorderSide(color: Colors.black12)),
          ),
          child: TextButton(
            onPressed: shouldShow ? drawer.toggle : () {},
            style: TextButton.styleFrom(
              backgroundColor: colorScheme(context).surface,
              primary: colorScheme(context).onSurface,
              minimumSize: Size.infinite,
              shape:
                  const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
            ),
            child: RotationTransition(
              turns: Tween(begin: 0.0, end: 0.5).animate(drawer.animation),
              child: const Icon(Icons.keyboard_arrow_down,
                  color: Color.fromRGBO(0, 0, 0, 0.5)),
            ),
          ),
        )
      ],
    );
  }

  Widget _content() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [const SizedBox(height: 10), child, const SizedBox(height: 10)],
    );
  }
}
