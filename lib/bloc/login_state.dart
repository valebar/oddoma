part of 'login_bloc.dart';

abstract class LoginState extends Equatable {
  const LoginState();
}

class LoginInitial extends LoginState {
  @override
  List<Object> get props => [];

  @override
  String toString() => 'LoginEventEmail';
}

class LoginStateLoading extends LoginState {
  @override
  List<Object> get props => [];

  @override
  String toString() => 'LoginEventLoading';
}

/// Stanje, ko se registracija ponesreči. Rezultat
/// je failure [String]
class LoginStateFailed extends LoginState {
  final User user;
  final String failure;

  @override
  List<Object> get props => [failure, user];

  LoginStateFailed(this.user, this.failure);

  @override
  String toString() => 'LoginEventFailed';
}

/// Stanje, ko je uporabnik uspešno registriran.
/// User [User] vsebuje id, email, firstName,
/// lastName, town, postcode in phoneNumber.
class LoginStateSuccess extends LoginState {
  final User user;

  LoginStateSuccess(this.user);

  @override
  List<Object> get props => [user];

  @override
  String toString() => 'LoginEventSuccess';
}
