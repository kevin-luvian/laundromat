import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:laundry/hooks/use_user_role_checker.dart';

class RoleSettingCard extends SettingCard {
  const RoleSettingCard({
    required String title,
    required Widget child,
    required this.allowedRoles,
  }) : super(title: title, child: child);
  final List<String> allowedRoles;

  @override
  build(context) {
    final role = useUserRoleChecker();
    if (allowedRoles.contains(role.role)) {
      return super.build(context);
    }
    return Container();
  }
}

class SettingCard extends HookWidget {
  const SettingCard({
    required this.title,
    required this.child,
    this.hidden = false,
  }) : super(key: null);

  final String title;
  final Widget child;
  final bool hidden;

  @override
  Widget build(BuildContext context) {
    if (hidden) return Container();
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
