import 'package:equatable/equatable.dart';
import 'package:laundry/db/drift_db.dart';
import 'package:laundry/db/tables/users.dart';

abstract class AuthState extends Equatable {}

class UnAuthenticated extends AuthState {
  @override
  List<Object?> get props => [];
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

  @override
  List<Object?> get props => [user];
}
