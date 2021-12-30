import 'package:laundry/models/user.dart';

abstract class AccountEvent {}

class UserChangedEvent extends AccountEvent {
  final UserModel user;

  UserChangedEvent({required this.user});
}

class ClearEvent extends AccountEvent {}
