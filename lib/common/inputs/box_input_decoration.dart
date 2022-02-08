import 'package:flutter/material.dart';

InputDecoration boxInputDecoration({
  required BuildContext context,
  required String label,
}) =>
    InputDecoration(
      labelText: label,
      border: OutlineInputBorder(
        borderSide: BorderSide(
          color: Theme.of(context).colorScheme.primary,
        ),
      ),
    );
