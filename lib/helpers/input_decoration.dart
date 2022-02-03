import 'package:flutter/material.dart';

InputDecoration inputDecoration({
  required BuildContext context,
  required String label,
}) =>
    InputDecoration(
      labelText: label,
      isDense: true,
      border: OutlineInputBorder(
        borderSide: BorderSide(
          color: Theme.of(context).colorScheme.primary,
        ),
      ),
    );
