import 'package:equatable/equatable.dart';
import 'package:laundry/db/drift_db.dart';
import 'package:laundry/db/tables/users.dart';

abstract class AuthState extends Equatable {}

class UnAuthenticated extends AuthState {
  @override
  List<Object?> get props => [];
}

class AuthenticatingPin extends AuthState {
  final String pin;

  AuthenticatingPin(this.pin);

  @override
  List<Object?> get props => [pin];
}

class AuthenticatingPinFailed extends AuthState {
  final String pin;

  AuthenticatingPinFailed(this.pin);

  @override
  List<Object?> get props => [pin];
}

class Authenticating extends AuthState {
  @override
  List<Object?> get props => [];
}

class AuthenticationFailed extends AuthState {
  @override
  List<Object?> get props => [];
}

class Authenticated extends AuthState {
  Authenticated(this.user);

  final User user;

  bool get isAdmin {
    return user.role == roleAdmin;
  }

  bool get isStaff {
    return user.role == roleStaff;
  }

  bool get isSuperAdmin {
    return user.role == roleSuperAdmin;
  }

  @override
  List<Object?> get props => [user];
}
