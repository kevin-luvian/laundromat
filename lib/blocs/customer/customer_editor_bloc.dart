import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:laundry/db/dao/customer/customer.dart';
import 'package:laundry/db/dao/session/session.dart';
import 'package:laundry/db/drift_db.dart';
import 'package:laundry/db/event_db.dart';
import 'package:laundry/event_source/commands/customer_command.dart';

const createUserIndex = 1;
const updateUserIndex = 2;

class CustomerEditorBloc
    extends Bloc<CreateCustomerEvent, CustomerEditorState> {
  final SessionDao _sessionDao;
  final CustomerCommand _command;

  CustomerEditorBloc(DriftDB db, EventDB edb)
      : _sessionDao = SessionDao(db),
        _command = CustomerCommand(edb, CustomerDao(db)),
        super(InitialState()) {
    on<CreateCustomerEvent>((event, emit) async {
      final currentUserId = await _sessionDao.currentUserId;
      final isCreated =
          (await _command.create(currentUserId, event.phone, event.name)) !=
              null;
      if (isCreated) {
        emit(SuccessState());
      } else {
        emit(FailedState());
      }
    });
  }
}

abstract class CustomerEditorState {}

class InitialState extends CustomerEditorState {}

class SuccessState extends CustomerEditorState {}

class FailedState extends CustomerEditorState {}

abstract class CustomerEditorEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class CreateCustomerEvent extends CustomerEditorEvent {
  final String name;
  final String phone;

  CreateCustomerEvent(this.name, this.phone);
}
