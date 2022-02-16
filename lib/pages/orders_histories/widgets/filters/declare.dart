import 'package:flutter/widgets.dart';

abstract class FilterWidget {
  final IconData icon;
  final Widget widget;

  const FilterWidget({required this.icon, required this.widget});
}

class FilterWidgetIcon {
  final IconData icon;
  final bool isActive;

  FilterWidgetIcon(this.icon, this.isActive);

  FilterWidgetIcon modify(bool value) => FilterWidgetIcon(icon, value);
}
