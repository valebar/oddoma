part of 'login_bloc.dart';

abstract class LoginEvent extends Equatable {
  const LoginEvent();
}

/// Event, ki se zažene, ko želimo registrirati
/// uporabnika z emailom. User [user] mora vsebovati
/// email in password.
class LoginEventEmail extends LoginEvent {
  final User user;

  @override
  List<Object> get props => [user];

  LoginEventEmail(this.user);

  @override
  String toString() => 'LoginEventEmail';
}
