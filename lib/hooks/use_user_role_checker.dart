import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:laundry/db/tables/users.dart';
import 'package:laundry/running_assets/dao_access.dart';

_UserRoleState useUserRoleChecker() {
  final role = useState(roleStaff);

  useEffect(() {
    sessionDao.currentUser.then((user) => role.value = user?.role ?? roleStaff);
  }, []);

  return _UserRoleState(role.value);
}

class _UserRoleState {
  final String role;

  _UserRoleState(this.role);

  bool get isSuperAdmin => role == roleSuperAdmin;

  bool get isAdmin => role == roleAdmin;

  bool get isStaff => role == roleStaff;
}
