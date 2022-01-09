import 'dart:ui' as dui;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:laundry/cubits/locale.dart';
import 'package:laundry/styles/theme.dart';

class LanguageSetting extends StatelessWidget {
  const LanguageSetting({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LocaleCubit, dui.Locale>(
      builder: (_, locale) => Row(
        children: [
          _buildLanguageButton(
              context: context,
              text: "Indonesia",
              isActive: locale.languageCode == "id",
              onPressed: () {
                context.read<LocaleCubit>().setLocale(const dui.Locale("id"));
              }),
          const SizedBox(width: 10),
          _buildLanguageButton(
              context: context,
              text: "English",
              isActive: locale.languageCode == "en",
              onPressed: () {
                context.read<LocaleCubit>().setLocale(const dui.Locale("en"));
              })
        ],
      ),
    );
  }

  Widget _buildLanguageButton({
    required BuildContext context,
    required String text,
    required bool isActive,
    required void Function() onPressed,
  }) {
    return Flexible(
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          primary: isActive
              ? Theme.of(context).colorScheme.primary
              : GlobalColor.dim,
          minimumSize: const Size.fromHeight(150.0),
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(7)),
          ),
        ),
        child: Text(text),
      ),
    );
  }
}
