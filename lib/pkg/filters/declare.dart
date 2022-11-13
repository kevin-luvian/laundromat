import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:laundry/helpers/flutter_utils.dart';
import 'package:laundry/hooks/use_content_drawer.dart';
import 'package:laundry/hooks/use_keyboard_listener.dart';
import 'package:laundry/styles/theme.dart';
import 'package:laundry/common/rect_button.dart';

class FilterWidgetIcon {
  final IconData icon;
  final bool isActive;

  FilterWidgetIcon(this.icon, this.isActive);

  FilterWidgetIcon modify(bool value) => FilterWidgetIcon(icon, value);
}

class FilterDrawerWidget extends StatefulWidget {
  final List<HookWidget> filters;
  final List<FilterWidgetIcon> filterIcons;
  final Function onClearFilters;
  final Widget Function({
    Widget? child,
   required void Function(List<FilterWidgetIcon>) callback,
  }) blocListener;

  const FilterDrawerWidget({
    Key? key,
    required this.filters,
    required this.filterIcons,
    required this.onClearFilters,
    required this.blocListener,
  }) : super(key: key);

  @override
  _FilterDrawerWidgetState createState() => _FilterDrawerWidgetState();
}

class _FilterDrawerWidgetState extends State<FilterDrawerWidget> {
  int selectedFilterIndex = -1;
  late List<FilterWidgetIcon> mFilterIcons;

  @override
  void initState() {
    mFilterIcons = widget.filterIcons;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var isIndexValid =
        selectedFilterIndex < 0 || selectedFilterIndex >= widget.filters.length;

    return widget.blocListener(
      callback: (icons) {
        setState(() {
          mFilterIcons = icons;
        });
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 7),
            scrollDirection: Axis.horizontal,
            child: Row(children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 0, 10, 0),
                child: RectButton(
                  elevation: 0,
                  onPressed: () {
                    setState(() => selectedFilterIndex = -1);
                    widget.onClearFilters();
                  },
                  size: const Size(50, 50),
                  child: const Icon(Icons.delete_outline_rounded, size: 23),
                ),
              ),
              ..._filtersWidgets()
            ]),
          ),
          FilterDrawer(
            child: isIndexValid
                ? null
                : widget.filters.elementAt(selectedFilterIndex),
          )
        ],
      ),
    );
  }

  List<Widget> _filtersWidgets() => mFilterIcons.asMap().entries.map((f) {
        return _filterActionButton(
          icon: f.value.icon,
          active: f.value.isActive,
          selected: f.key == selectedFilterIndex,
          onPressed: () => setState(() => selectedFilterIndex = f.key),
        );
      }).toList();

  Widget _filterActionButton({
    required IconData icon,
    required void Function() onPressed,
    bool active = false,
    bool selected = false,
  }) {
    final color =
        active ? colorScheme(context).primaryVariant : GlobalColor.dim;
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 0, 10, 0),
      child: RectButton(
        color: color,
        elevation: selected ? 4 : 0,
        onPressed: onPressed,
        size: const Size(50, 50),
        child: Icon(icon, size: 23),
      ),
    );
  }
}

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
