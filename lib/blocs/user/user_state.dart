import 'package:equatable/equatable.dart';
import 'package:test_maimaid_app/models/user.dart';

abstract class UserState extends Equatable {
  const UserState();

  @override
  List<Object> get props => [];
}

class UserInitial extends UserState {}

class UserLoading extends UserState {}

class UserLoaded extends UserState {
  final List<User> users;
  final int page;
  final List<User> selectedUsers;

  const UserLoaded({
    required this.users,
    required this.page,
    this.selectedUsers = const [],
  });

  UserLoaded copyWith(
      {List<User>? users, int? page, List<User>? selectedUsers}) {
    return UserLoaded(
      users: users ?? this.users,
      page: page ?? this.page,
      selectedUsers: selectedUsers ?? this.selectedUsers,
    );
  }

  @override
  List<Object> get props => [users, page, selectedUsers];
}

class UserError extends UserState {
  final String message;

  const UserError({required this.message});

  @override
  List<Object> get props => [message];
}

class UserCreateLoading extends UserState {}

class UserCreateSuccess extends UserState {
  final String name;
  final String job;

  const UserCreateSuccess({required this.name, required this.job});

  @override
  List<Object> get props => [name, job];
}

class UserCreateFailure extends UserState {
  final String error;

  const UserCreateFailure({required this.error});

  @override
  List<Object> get props => [error];
}

class UserDeleteLoading extends UserState {}

class UserDeleteSuccess extends UserState {
  final int userId;

  const UserDeleteSuccess({required this.userId});

  @override
  List<Object> get props => [userId];
}

class UserDeleteFailure extends UserState {
  final String error;

  const UserDeleteFailure({required this.error});

  @override
  List<Object> get props => [error];
}

class UserDetailLoaded extends UserState {
  final User user;

  const UserDetailLoaded({required this.user});

  @override
  List<Object> get props => [user];
}

// class UserUpdateSuccess extends UserState {
//   final User user;

//   const UserUpdateSuccess({required this.user});

//   @override
//   List<Object> get props => [user];
// }

class UserUpdateLoading extends UserState {}

class UserUpdateSuccess extends UserState {
  final int id;
  final String name;
  final String job;

  const UserUpdateSuccess(
      {required this.id, required this.name, required this.job});

  @override
  List<Object> get props => [id, name, job];
}

class UserUpdateFailure extends UserState {
  final String error;

  const UserUpdateFailure({required this.error});

  @override
  List<Object> get props => [error];
}
