part of 'user_bloc.dart';

abstract class UserEvent extends Equatable {
  const UserEvent();
}

class UserEventGetUser extends UserEvent {
  final User user;

  UserEventGetUser(this.user);

  @override
  List<Object> get props => [user];

  @override
  String toString() {
    return 'UserEventCheckUser';
  }
}

class UserEventCreateUser extends UserEvent {
  final User user;

  UserEventCreateUser(this.user);

  @override
  List<Object> get props => [user];

  @override
  String toString() => 'UserEventCreateUser';
}

class UserEventUpdateUser extends UserEvent {
  final User user;

  UserEventUpdateUser(this.user);

  @override
  List<Object> get props => [user];

  @override
  String toString() => 'UserEventUpdateUser';
}
