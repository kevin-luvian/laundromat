import 'package:flutter/material.dart';

boxInputDecoration({required BuildContext context, required String label}) =>
    InputDecoration(
      labelText: label,
      border: OutlineInputBorder(
        borderSide: BorderSide(
          color: Theme.of(context).colorScheme.primary,
        ),
      ),
    );
