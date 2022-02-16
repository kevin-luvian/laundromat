import 'package:flutter/material.dart';

InputDecoration inputDecoration(BuildContext context, String label) =>
    InputDecoration(
      labelText: label,
      isDense: true,
      border: OutlineInputBorder(
          borderSide: BorderSide(color: Theme.of(context).colorScheme.primary)),
    );
