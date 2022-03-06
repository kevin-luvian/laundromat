import 'package:drift/drift.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:laundry/blocs/auth/event.dart';
import 'package:laundry/blocs/auth/state.dart';
import 'package:laundry/db/dao/session/session.dart';
import 'package:laundry/db/dao/user/user.dart';
import 'package:laundry/db/drift_db.dart';
import 'package:laundry/db/event_db.dart';
import 'package:laundry/event_source/commands/user_command.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final UserCommand _userCommand;
  final UserDao _userDao;
  final SessionDao _sessionDao;

  AuthBloc(DriftDB db, EventDB edb)
      : _userCommand = UserCommand(edb),
        _userDao = UserDao(db),
        _sessionDao = SessionDao(db),
        super(Authenticating()) {
    on<CheckAuth>((_, emit) async {
      emit(Authenticating());
      final session = await _sessionDao.find();
      if (session.staffId.isEmpty) {
        emit(UnAuthenticated());
      } else if (DateTime.now().difference(session.loggedInDate).inHours >=
          24) {
        logout(emit);
      } else {
        final user = await _userDao.findUser(session.staffId);
        if (user == null) {
          logout(emit);
        } else {
          emit(AuthenticatingPin(user.pin));
        }
      }
    });

    on<RePIN>((evt, emit) async {
      emit(Authenticating());
      final user = await _sessionDao.currentUser;
      if (user == null) {
        emit(UnAuthenticated());
      } else if (user.pin == evt.pin) {
        await _userCommand.login(user.id);
        emit(Authenticated(user));
      } else {
        emit(AuthenticatingPinFailed(user.pin));
      }
    });

    on<Login>((evt, emit) async {
      emit(Authenticating());
      final user = await _userDao.authenticate(evt.name, evt.password);
      if (user == null) {
        emit(AuthenticationFailed());
      } else {
        await _userCommand.login(user.id);
        await _sessionDao.mutate(SessionsCompanion(
            staffId: Value(user.id), loggedInDate: Value(DateTime.now())));
        emit(Authenticated(user));
      }
    });

    on<Logout>((_, emit) => logout(emit));
  }

  Future<void> logout(Emitter<AuthState> emit) async {
    await _sessionDao.mutate(const SessionsCompanion(staffId: Value("")));
    emit(UnAuthenticated());
  }
}
