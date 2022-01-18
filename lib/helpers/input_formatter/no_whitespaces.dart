import 'package:flutter/services.dart';

final TextInputFormatter noWhitespacesFormatter =
    FilteringTextInputFormatter.deny(RegExp(r"\s\b|\b\s"));
