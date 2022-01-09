import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:laundry/blocs/auth/event.dart';
import 'package:laundry/blocs/auth/state.dart';
import 'package:laundry/db/dao/user/user.dart';
import 'package:laundry/db/drift_db.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final UserDao _userDao;

  AuthBloc(DriftDB _db)
      : _userDao = UserDao(_db),
        super(UnAuthenticated()) {
    on<Login>((evt, emit) async {
      emit(Authenticating());
      final user = await _userDao.authenticate(evt.name, evt.password);
      if (user == null) {
        emit(AuthenticationFailed());
      } else {
        emit(Authenticated(user));
      }
    });

    on<Logout>((_, emit) {
      emit(UnAuthenticated());
    });
  }
}
