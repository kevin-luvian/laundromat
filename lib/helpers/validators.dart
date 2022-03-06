import 'package:flutter/cupertino.dart';
import 'package:laundry/helpers/utils.dart';
import 'package:laundry/l10n/access_locale.dart';

String? notEmptyText(BuildContext context, String? value) {
  if (cnord(value?.isEmpty, false)) {
    return l10n(context)?.please_enter_some_text;
  }
  return null;
}
