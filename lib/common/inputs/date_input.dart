import 'package:flutter/material.dart';
import 'package:laundry/common/inputs/m_date_picker_dialog.dart';
import 'package:laundry/common/rect_button.dart';
import 'package:laundry/helpers/flutter_utils.dart';
import 'package:laundry/l10n/access_locale.dart';
import 'package:laundry/styles/theme.dart';

DateTime getInitialDate(
  DateTime? currDate,
  DateTime? firstDate,
  DateTime? lastDate,
) {
  final now = currDate ?? DateTime.now();
  if (firstDate == null && lastDate == null) {
    return now;
  } else if (firstDate != null && now.isBefore(firstDate)) {
    return firstDate;
  } else if (lastDate != null && now.isAfter(lastDate)) {
    return lastDate;
  } else {
    return now;
  }
}

class DateInput extends StatelessWidget {
  DateInput({
    Key? key,
    this.date,
    this.onChange,
    DateTime? firstDate,
    DateTime? lastDate,
  })  : firstDate = firstDate ?? DateTime(1970, 8),
        lastDate = lastDate ?? DateTime(2101),
        initialDate = getInitialDate(date, firstDate, lastDate),
        super(key: key);

  final DateTime? date;
  final DateTime initialDate;
  final DateTime firstDate;
  final DateTime lastDate;
  final void Function(DateTime? date)? onChange;

  Future<void> _selectDate(BuildContext context) async {
    if (onChange == null) return;
    bool cancelled = false;
    final _date = date;
    final DateTime? picked = await mShowDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: firstDate,
      lastDate: lastDate,
      cancelText: "CLEAR",
      onCancel: () => cancelled = true,
    );
    if (onChange != null) {
      if (cancelled) {
        onChange!(null);
      } else if (picked != null && picked != _date) {
        onChange!(picked);
      }
    }
  }

  @override
  build(context) {
    return RectButton(
      color: date == null ? GlobalColor.dim : null,
      onPressed: () => _selectDate(context),
      padding: const EdgeInsets.symmetric(vertical: 15),
      child: Text(dateToString(date, context),
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
    );
  }

  String dateToString(DateTime? date, BuildContext context) {
    if (date == null) return "-- / ---- / ----";
    return "${date.day} / ${monthToString(date.month, l10n(context))} / ${date.year}";
  }
}
