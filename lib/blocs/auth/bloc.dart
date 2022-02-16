import 'package:drift/drift.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:laundry/blocs/auth/event.dart';
import 'package:laundry/blocs/auth/state.dart';
import 'package:laundry/db/dao/session/session.dart';
import 'package:laundry/db/dao/user/user.dart';
import 'package:laundry/db/drift_db.dart';
import 'package:laundry/db/event_db.dart';
import 'package:laundry/event_source/commands/user_command.dart';
import 'package:laundry/helpers/utils.dart';

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
      if (user == null) {
        emit(AuthenticationFailed());
      } else {
        await _userCommand.login(user.id);
        await _sessionDao.mutate(SessionsCompanion(staffId: Value(user.id)));
        emit(Authenticated(user));
      }
    });

    on<Logout>((_, emit) async {
      emit(Authenticating());
      logoutStaff();
      await waitMilliseconds(500);
      emit(UnAuthenticated());
    });
  }

  Future<void> logoutStaff() async {
    await _sessionDao.mutate(const SessionsCompanion(staffId: Value("")));
  }
}
