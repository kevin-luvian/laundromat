import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:laundry/cubits/session.dart';
import 'package:laundry/db/dao/session/session.dart';
import 'package:laundry/db/drift_db.dart';
import 'package:laundry/styles/theme.dart';

class ThemeSetting extends StatelessWidget {
  const ThemeSetting({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SessionCubit, Session?>(
      builder: (_, session) => Row(
        children: [
          _buildThemeButton(
              context: context,
              text: "Crimson",
              isActive: session?.theme == ThemeChoice.crimson.name,
              onPressed: () {
                context.read<SessionCubit>().setTheme(ThemeChoice.crimson);
              }),
          const SizedBox(width: 10),
          _buildThemeButton(
              context: context,
              text: "Ocean",
              isActive: session?.theme == ThemeChoice.ocean.name,
              onPressed: () {
                context.read<SessionCubit>().setTheme(ThemeChoice.ocean);
              })
        ],
      ),
    );
  }

  Widget _buildThemeButton({
    required BuildContext context,
    required String text,
    required bool isActive,
    required void Function() onPressed,
  }) {
    return Flexible(
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          primary: isActive ? Theme.of(context).primaryColor : GlobalColor.dim,
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
