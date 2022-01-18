import 'package:drift/drift.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:laundry/blocs/auth/event.dart';
import 'package:laundry/blocs/auth/state.dart';
import 'package:laundry/db/dao/session/session.dart';
import 'package:laundry/db/dao/user/user.dart';
import 'package:laundry/db/drift_db.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final UserDao _userDao;
  final SessionDao _sessionDao;

  AuthBloc(DriftDB _db)
      : _userDao = UserDao(_db),
        _sessionDao = SessionDao(_db),
        super(Authenticating()) {
    on<CheckAuth>((_, emit) async {
      emit(Authenticating());
      final session = await _sessionDao.find();
      if (session.staffId.isEmpty) {
        emit(UnAuthenticated());
      } else {
        final user = await _userDao.findUser(session.staffId);
        if (user == null) {
          await logoutStaff();
          emit(UnAuthenticated());
        } else {
          emit(Authenticated(user));
        }
      }
    });

    on<Login>((evt, emit) async {
      emit(Authenticating());
      final user = await _userDao.authenticate(evt.name, evt.password);
      await Future.delayed(const Duration(milliseconds: 500));
      if (user == null) {
        emit(AuthenticationFailed());
      } else {
        await _sessionDao.mutate(SessionsCompanion(staffId: Value(user.id)));
        emit(Authenticated(user));
      }
    });

    on<Logout>((_, emit) async {
      emit(Authenticating());
      logoutStaff();
      await Future.delayed(const Duration(milliseconds: 500));
      emit(UnAuthenticated());
    });
  }

  logoutStaff() async {
    await _sessionDao.mutate(const SessionsCompanion(staffId: Value("")));
  }
}
