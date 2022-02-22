abstract class AuthEvent {}

class CheckAuth extends AuthEvent {}

class Logout extends AuthEvent {}

class Login extends AuthEvent {
  final String name;
  final String password;

  Login(this.name, this.password);
}

class RePIN extends AuthEvent {
  final String pin;

  RePIN(this.pin) : assert(pin.length == 4);
}
