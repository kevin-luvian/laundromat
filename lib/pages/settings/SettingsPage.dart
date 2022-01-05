import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:laundry/pages/settings/widgets/LanguageSetting.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({Key? key}) : super(key: key);

  // AppLocalizations.of(context)?.checkout
  @override
  Widget build(BuildContext context) {
    List<Widget> clist = List.generate(
        20,
        (_) => _buildSettingCard(
            context: context,
            title: AppLocalizations.of(context)?.select_language ?? "Select Language",
            child: const LanguageSetting()));
    return ListView.separated(
      padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 120.0),
      separatorBuilder: (context, index) => const SizedBox(height: 10.0),
      itemCount: clist.length,
      itemBuilder: (context, index) => clist[index],
    );
  }

  Widget _buildSettingCard({
    required BuildContext context,
    required String title,
    required Widget child,
  }) {
    return SizedBox(
      width: double.infinity,
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  color: Theme.of(context).colorScheme.primary,
                  fontSize: 17,
                ),
              ),
              const SizedBox(height: 10),
              child,
            ],
          ),
        ),
      ),
    );
  }
}
