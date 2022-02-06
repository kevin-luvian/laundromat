import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:laundry/cubits/session.dart';
import 'package:laundry/db/dao/session/session.dart';
import 'package:laundry/db/drift_db.dart';
import 'package:laundry/styles/theme.dart';

class LanguageSetting extends StatelessWidget {
  const LanguageSetting({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SessionCubit, Session?>(
      builder: (_, session) => Row(
        children: [
          _buildLanguageButton(
            context: context,
            text: "Indonesia",
            isActive: session?.lang == "id",
            onPressed: () {
              context.read<SessionCubit>().setLocale(LocaleChoice.id);
            },
          ),
          const SizedBox(width: 10),
          _buildLanguageButton(
            context: context,
            text: "English",
            isActive: session?.lang == "en",
            onPressed: () {
              context.read<SessionCubit>().setLocale(LocaleChoice.en);
            },
          ),
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
