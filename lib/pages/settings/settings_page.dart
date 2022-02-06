import 'package:flutter/material.dart';
import 'package:laundry/l10n/access_locale.dart';
import 'package:laundry/pages/settings/widgets/drift_viewer.dart';
import 'package:laundry/pages/settings/widgets/language_setting.dart';
import 'package:laundry/pages/settings/widgets/logout_setting.dart';
import 'package:laundry/pages/settings/widgets/printer_setting.dart';
import 'package:laundry/pages/settings/widgets/theme_setting.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  Widget build(context) {
    List<Widget> clist = [
      const SettingCard(title: "Printer", child: PrinterSetting()),
      SettingCard(
        title: l10n(context)?.select_language ?? "Select Language",
        child: const LanguageSetting(),
      ),
      const SettingCard(title: "Theme", child: ThemeSetting()),
      const SettingCard(title: "Logout", child: LogoutSetting()),
      const SettingCard(
        title: "View And Access Drift DB",
        child: DriftViewer(),
      ),
    ];
    return ListView.separated(
      padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 120.0),
      separatorBuilder: (context, index) => const SizedBox(height: 10.0),
      itemCount: clist.length,
      itemBuilder: (context, index) => clist[index],
    );
  }
}

class SettingCard extends StatelessWidget {
  const SettingCard({required this.title, required this.child, Key? key})
      : super(key: key);

  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
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
