import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:laundry/blocs/account/event.dart';
import 'package:laundry/blocs/account/state.dart';

class AccountBloc extends Bloc<AccountEvent, AccountState> {
  AccountBloc() : super(AccountEmptyState()) {
    on<UserChangedEvent>((event, emit) =>
        emit(AccountFilledState(username: event.user.username)));
    on<ClearEvent>((event, emit) => emit(AccountEmptyState()));
  }
}
