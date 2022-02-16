import 'package:drift/drift.dart';

const roleSuperAdmin = "SUPER_ADMIN";
const roleAdmin = "ADMIN";
const roleStaff = "STAFF";

enum Role { superAdmin, admin, staff }

const allRoles = [roleSuperAdmin, roleAdmin, roleStaff];
const adminSelectableRoles = [roleAdmin, roleStaff];

String roleToString(Role role) {
  switch (role) {
    case Role.superAdmin:
      return roleSuperAdmin;
    case Role.admin:
      return roleAdmin;
    case Role.staff:
      return roleStaff;
  }
}

String userRoleToString(String role) => role.toLowerCase().split("_").join(" ");

@DataClassName("User")
class Users extends Table {
  TextColumn get id => text().customConstraint("UNIQUE")();

  TextColumn get name => text().customConstraint("UNIQUE")();

  TextColumn get pin => text().withLength(min: 4, max: 4)();

  TextColumn get password => text()();

  TextColumn get role => text()();

  BoolColumn get active => boolean().withDefault(const Constant(true))();

  DateTimeColumn get lastLogin => dateTime().nullable()();
}
