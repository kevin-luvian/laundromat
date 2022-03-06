import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:laundry/db/dao/session/session.dart';
import 'package:laundry/db/dao/user/user.dart';
import 'package:laundry/db/drift_db.dart';

class UsersViewBloc extends Bloc<UsersViewEvent, UsersViewState> {
  final UserDao _dao;
  final SessionDao _sessionDao;

  UsersViewBloc(DriftDB db)
      : _dao = UserDao(db),
        _sessionDao = SessionDao(db),
        super(InitialUsersState()) {
    on<FindActiveUserEvent>((_, emit) async {
      emit(StreamUsersState(await _dao.activeUsers()));
    });
    on<FindInactiveUserEvent>(
      (_, emit) async => emit(StreamUsersState(await _dao.inactiveUsers())),
    );
    on<FindDeletedUserEvent>((_, emit) {});
  }
}

class UsersViewState {}

class InitialUsersState extends UsersViewState {}

class StreamUsersState extends UsersViewState {
  final Stream<List<User>> stream;

  StreamUsersState(this.stream);
}

abstract class UsersViewEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class FindActiveUserEvent extends UsersViewEvent {}

class FindInactiveUserEvent extends UsersViewEvent {}

class FindDeletedUserEvent extends UsersViewEvent {}
