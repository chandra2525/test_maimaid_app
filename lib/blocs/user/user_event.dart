import 'package:equatable/equatable.dart';
import 'package:test_maimaid_app/models/user.dart';

abstract class UserEvent extends Equatable {
  const UserEvent();

  @override
  List<Object> get props => [];
}

class FetchUsers extends UserEvent {
  final int page;

  const FetchUsers({required this.page});

  @override
  List<Object> get props => [page];
}

class CreateUser extends UserEvent {
  final String name;
  final String job;

  const CreateUser({required this.name, required this.job});

  @override
  List<Object> get props => [name, job];
}

class DeleteUser extends UserEvent {
  final int userId;

  const DeleteUser({required this.userId});

  @override
  List<Object> get props => [userId];
}

class FetchUserDetail extends UserEvent {
  final int userId;

  const FetchUserDetail({required this.userId});

  @override
  List<Object> get props => [userId];
}

class UpdateUser extends UserEvent {
  final int id;
  final String name;
  final String job;

  const UpdateUser({required this.id, required this.name, required this.job});

  @override
  List<Object> get props => [id, name, job];
}

class SelectUser extends UserEvent {
  final User user;

  const SelectUser({required this.user});

  @override
  List<Object> get props => [user];
}
