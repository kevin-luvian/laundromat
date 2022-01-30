import 'package:laundry/helpers/utils.dart';

String? notEmptyText(String? value) {
  if (cnord(value?.isEmpty, false)) {
    return 'please enter some text';
  }
  return null;
}
