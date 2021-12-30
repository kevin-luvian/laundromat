abstract class AccountState {}

class AccountEmptyState extends AccountState {}

class AccountFilledState extends AccountState {
  String username;

  AccountFilledState({required this.username});
}
