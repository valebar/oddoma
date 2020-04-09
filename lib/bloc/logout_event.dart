part of 'logout_bloc.dart';

abstract class LogoutEvent extends Equatable {
  const LogoutEvent();
}

/// Event, ki se zažene, ko želimo registrirati
/// uporabnika z emailom. User [user] mora vsebovati
/// email in password.
class LogoutEventConfirm extends LogoutEvent {

  @override
  List<Object> get props => [];

  LogoutEventConfirm();

  @override
  String toString() => 'LogoutEventConfirm';
}
