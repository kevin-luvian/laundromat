import 'package:flutter/material.dart';
import 'package:laundry/helpers/flutter_utils.dart';
import 'package:laundry/l10n/access_locale.dart';
import 'package:laundry/pages/settings/widgets/drift_viewer.dart';
import 'package:laundry/pages/settings/widgets/language_setting.dart';
import 'package:laundry/pages/settings/widgets/logout_setting.dart';
import 'package:laundry/pages/settings/widgets/printer_setting.dart';
import 'package:laundry/pages/settings/widgets/setting_card.dart';
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
      SettingCard(
          title: capitalizeFirstLetter(l10n(context)?.theme),
          child: const ThemeSetting()),
      const SettingCard(title: "Logout", child: LogoutSetting()),
      driftViewerCard,
    ];
    return ListView.separated(
      padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 120.0),
      separatorBuilder: (context, index) => const SizedBox(height: 10.0),
      itemCount: clist.length,
      itemBuilder: (context, index) => clist[index],
    );
  }
}
