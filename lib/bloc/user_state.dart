part of 'user_bloc.dart';

abstract class UserState extends Equatable {
  const UserState();
}

class UserInitial extends UserState {
  @override
  List<Object> get props => [];
}

class UserStateLoading extends UserState {
  @override
  List<Object> get props => [];

  @override
  String toString() {
    return "UserStateLoading";
  }
}

class UserStateSuccess extends UserState {
  final User user;

  UserStateSuccess(this.user);

  @override
  List<Object> get props => [user];

  @override
  String toString() {
    return "UserStateSuccess";
  }
}

class UserStateFailure extends UserState {
  final String failure;

  UserStateFailure(this.failure);

  @override
  List<Object> get props => [];

  @override
  String toString() {
    return "UserStateFailure: $failure";
  }
}

class UserStateUpdateSuccess extends UserState {
  final User user;

  UserStateUpdateSuccess(this.user);

  @override
  List<Object> get props => [user];

  @override
  String toString() {
    return "UserStateUpdateSuccess";
  }
}

class UserStateUpdateFailure extends UserState {
  final String failure;

  UserStateUpdateFailure(this.failure);

  @override
  List<Object> get props => [];

  @override
  String toString() {
    return "UserStateUpdateFailure: $failure";
  }
}
