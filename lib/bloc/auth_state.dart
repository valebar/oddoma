part of 'auth_bloc.dart';

abstract class AuthState extends Equatable {
  const AuthState();
}

class AuthInitial extends AuthState {
  @override
  List<Object> get props => [];

  @override
  String toString() => 'AuthInitial';
}

/// State, ki se pojavi kot rezultat
/// nalaganja.
class AuthStateLoading extends AuthState {
  @override
  List<Object> get props => [];

  @override
  String toString() => 'AuthStateLoading';
}

/// Stanje, če je [AuthEventCheck] uspešen.
/// Rezultat je user - [FirebaseUser].
class AuthStateCheckSuccess extends AuthState {
  final User user;

  @override
  List<Object> get props => [];

  AuthStateCheckSuccess(this.user);

  @override
  String toString() => 'AuthStateCheckSuccess';
}

/// Stanje, če je [AuthEventCheck] neuspešen.
/// Rezultat je failure - [String]
class AuthStateCheckFailed extends AuthState {
  final String failure;

  @override
  List<Object> get props => [failure];

  AuthStateCheckFailed(this.failure);

  @override
  String toString() => 'AuthStateCheckFailed';
}

class AuthStateEmailVerified extends AuthState {
  @override
  List<Object> get props => [];

  @override
  String toString() => 'AuthStateEmailVerified';
}

class AuthStateEmailNotVerified extends AuthState {
  @override
  List<Object> get props => [];

  @override
  String toString() => 'AuthStateEmailNotVerified';
}

class AuthStateForgotEmailSuccess extends AuthState {
  @override
  List<Object> get props => [];

  @override
  String toString() => 'AuthStateForgotEmailSuccess';
}

class AuthStateForgotEmailLoading extends AuthState {
  @override
  List<Object> get props => [];

  @override
  String toString() => 'AuthStateForgotEmailLoading';
}

class AuthStateForgotEmailFailure extends AuthState {
  @override
  List<Object> get props => [];

  @override
  String toString() => 'AuthStateForgotEmailFailure';
}
