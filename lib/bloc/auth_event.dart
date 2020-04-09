part of 'auth_bloc.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();
}

/// Event za preverbo, če imamo uporabnika
/// v store. Če je vse ok, je odgovor
/// [AuthStateCheckSuccess], drugače
/// [AuthStateCheckFailure].
class AuthEventCheck extends AuthEvent {
  @override
  List<Object> get props => [];

  @override
  String toString() => 'AuthEventCheck';
}

class AuthEventCheckEmailVerification extends AuthEvent {
  @override
  List<Object> get props => [];

  @override
  String toString() => 'AuthEventCheckEmailVerification';
}

class AuthEventForgotEmail extends AuthEvent {
  final String email;

  AuthEventForgotEmail(this.email);

  @override
  List<Object> get props => [email];

  @override
  String toString() => 'AuthEventForgotEmail';
}
