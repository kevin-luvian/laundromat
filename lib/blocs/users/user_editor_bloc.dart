import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:laundry/cubits/right_drawer.dart';
import 'package:laundry/db/dao/session/session.dart';
import 'package:laundry/db/drift_db.dart';
import 'package:laundry/db/event_db.dart';
import 'package:laundry/db/tables/users.dart';
import 'package:laundry/event_source/commands/user_command.dart';
import 'package:laundry/helpers/utils.dart';

const createUserIndex = 1;
const updateUserIndex = 2;

class UserEditorBloc extends Bloc<UserEditorEvent, UserEditorState> {
  final RightDrawerCubit _rCubit;
  final SessionDao _sessionDao;
  final UserCommand _command;

  UserEditorBloc(DriftDB db, EventDB edb, this._rCubit)
      : _sessionDao = SessionDao(db),
        _command = UserCommand(edb),
        super(InitialState()) {
    on<OpenCreateUserEvent>((_, emit) {
      _rCubit.showDrawer(index: createUserIndex);
      emit(OpenCreateUserState());
    });
    on<OpenUpdateUserEvent>((event, emit) async {
      final currentUserId = await _sessionDao.currentUserId;
      _rCubit.showDrawer(index: updateUserIndex);
      emit(OpenUpdateUserState(event.user, currentUserId));
    });
    on<CreateUserEvent>((event, emit) async {
      final currentUserId = (await _sessionDao.find()).staffId;
      await _command.create(
        createdBy: currentUserId,
        name: event.name,
        password: event.password,
        role: event.role,
        pin: event.pin,
      );
      _rCubit.closeDrawer();
      emit(SuccessState());
    });
    on<UpdateUserEvent>((event, emit) async {
      final currentUserId = (await _sessionDao.find()).staffId;
      if (event.shouldUpdate) {
        await _command.update(
          streamId: event.id,
          updatedBy: currentUserId,
          name: event.name,
          password: event.password,
          role: event.role,
          pin: event.pin,
        );
      }
      if (event.active != null) {
        if (event.active!) {
          await _command.reactivate(event.id, currentUserId);
        } else {
          await _command.deactivate(event.id, currentUserId);
        }
      }
      _rCubit.closeDrawer();
      emit(SuccessState());
    });
  }
}

abstract class UserEditorState {}

class InitialState extends UserEditorState {}

class SuccessState extends UserEditorState {}

class OpenCreateUserState extends UserEditorState {}

class OpenUpdateUserState extends UserEditorState {
  final User user;
  final String currentUserId;

  OpenUpdateUserState(this.user, this.currentUserId);
}

abstract class UserEditorEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class OpenCreateUserEvent extends UserEditorEvent {}

class OpenUpdateUserEvent extends UserEditorEvent {
  final User user;

  OpenUpdateUserEvent(this.user);
}

class CreateUserEvent extends UserEditorEvent {
  final String name;
  final String password;
  final String role;
  final String pin;

  CreateUserEvent(this.name, this.password, this.role, this.pin)
      : assert(allRoles.contains(role)),
        assert(int.tryParse(pin) != null),
        assert(pin.length == 4);
}

class UpdateUserEvent extends UserEditorEvent {
  final String id;
  final String? name;
  final String? password;
  final String? role;
  final String? pin;
  final bool? active;

  // unit = toUpdate(unit, prevProduct.unit);
  UpdateUserEvent(
    User user, {
    required this.id,
    required bool active,
    String? name,
    String? password,
    String? role,
    String? pin,
  })  : assert(role == null || allRoles.contains(role)),
        name = toUpdate(name, user.name),
        password = password?.trim() == "" ? null : password,
        role = toUpdate(role, user.role),
        pin = toUpdate(pin, user.pin),
        active = toUpdate(active, user.active);

  bool get shouldUpdate =>
      name != null || password != null || role != null || pin != null;
}
