part of 'logout_bloc.dart';

abstract class LogoutState extends Equatable {
  const LogoutState();
}

class LogoutInitial extends LogoutState {
  @override
  List<Object> get props => [];

  @override
  String toString() => 'LogoutEventEmail';
}

class LogoutStateLoading extends LogoutState {
  @override
  List<Object> get props => [];

  @override
  String toString() => 'LogoutEventLoading';
}

/// Stanje, ko se registracija ponesreči. Rezultat
/// je failure [String]
class LogoutStateFailed extends LogoutState {
  final String failure;

  @override
  List<Object> get props => [failure];

  LogoutStateFailed(this.failure);

  @override
  String toString() => 'LogoutEventFailed';
}

/// Stanje, ko je uporabnik uspešno registriran.
/// User [User] vsebuje id, email, firstName,
/// lastName, town, postcode in phoneNumber.
class LogoutStateSuccess extends LogoutState {
  LogoutStateSuccess();

  @override
  List<Object> get props => [];

  @override
  String toString() => 'LogoutEventSuccess';
}
