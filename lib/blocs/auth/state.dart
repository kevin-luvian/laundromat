import 'package:equatable/equatable.dart';
import 'package:laundry/db/drift_db.dart';

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
  final User user;

  Authenticated(this.user);

  @override
  List<Object?> get props => [user];
}
