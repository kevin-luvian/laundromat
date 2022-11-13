class FilterData {
  DateTime date;
  String name;
  String phone;

  FilterData({
    required this.date,
    required this.name,
    required this.phone,
  });
}

abstract class Filter {
  const Filter(this.hasValue);

  bool valid(FilterData data);

  final bool hasValue;
}
