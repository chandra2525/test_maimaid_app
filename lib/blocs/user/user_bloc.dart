import 'dart:convert';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:test_maimaid_app/blocs/user/user_event.dart';
import 'package:test_maimaid_app/blocs/user/user_state.dart';
import 'package:test_maimaid_app/models/user.dart';
import 'package:test_maimaid_app/repositories/user_repository.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  final UserRepository userRepository;
  final ScrollController scrollController = ScrollController();

  RefreshController refreshController =
      RefreshController(initialRefresh: false);
  RefreshController refreshControllerSelected =
      RefreshController(initialRefresh: false);
  int _currentPage = 1;

  UserBloc({required this.userRepository}) : super(UserInitial()) {
    scrollController.addListener(onScroll);
    on<FetchUsers>(_onFetchUsers);
    on<CreateUser>(_onCreateUser);
    on<DeleteUser>(_onDeleteUser);
    on<FetchUserDetail>(_onFetchUserDetail);
    on<UpdateUser>(_onUpdateUser);
    on<SelectUser>(_onSelectUser);
  }

  Future<void> _onFetchUsers(FetchUsers event, Emitter<UserState> emit) async {
    try {
      if (state is UserInitial || event.page == 1) {
        emit(UserLoading());
      }

      final response = await userRepository.fetchUsers(event.page);
      final currentState = state;
      if (currentState is UserLoaded) {
        emit(currentState.copyWith(
          users: List.from(currentState.users)..addAll(response.data),
          page: event.page,
        ));
      } else {
        emit(UserLoaded(users: response.data, page: event.page));
      }
    } catch (_) {
      emit(UserError(message: 'Failed to load users'));
    }
  }

  Future<void> _onCreateUser(CreateUser event, Emitter<UserState> emit) async {
    emit(UserCreateLoading());
    try {
      final response = await userRepository.createUser(event.name, event.job);
      emit(UserCreateSuccess(name: response['name'], job: response['job']));
    } catch (error) {
      emit(UserCreateFailure(error: error.toString()));
    }
  }

  Future<void> _onDeleteUser(DeleteUser event, Emitter<UserState> emit) async {
    // emit(UserDeleteLoading());
    try {
      await userRepository.deleteUser(event.userId);
      final currentState = state;
      if (currentState is UserLoaded) {
        final updatedUsers = currentState.users
            .where((user) => user.id != event.userId)
            .toList();
        emit(currentState.copyWith(users: updatedUsers));
      }
      // emit(UserDeleteSuccess(userId: event.userId));
    } catch (error) {
      emit(UserDeleteFailure(error: error.toString()));
    }
  }

  Future<void> _onFetchUserDetail(
      FetchUserDetail event, Emitter<UserState> emit) async {
    try {
      emit(UserLoading());
      final user = await userRepository.fetchUserDetail(event.userId);
      emit(UserDetailLoaded(user: user));
    } catch (error) {
      emit(UserError(message: 'Failed to fetch user detail'));
    }
  }

  Future<void> _onUpdateUser(UpdateUser event, Emitter<UserState> emit) async {
    emit(UserUpdateLoading());
    try {
      // final updatedUser =
      //     await userRepository.updateUser(event.userId, event.name, event.job);
      // emit(UserUpdateSuccess(user: updatedUser));

      final response =
          await userRepository.updateUser(event.id, event.name, event.job);
      emit(UserUpdateSuccess(
        id: response['id'] ?? 1,
        name: response['name'],
        job: response['job'],
      ));
    } catch (error) {
      emit(UserUpdateFailure(error: error.toString()));
      print(error.toString());
    }
  }

  Future<void> _onSelectUser(SelectUser event, Emitter<UserState> emit) async {
    final currentState = state;
    if (currentState is UserLoaded) {
      final updatedSelectedUsers = List<User>.from(currentState.selectedUsers);
      if (updatedSelectedUsers.contains(event.user)) {
        updatedSelectedUsers.remove(event.user);
      } else {
        updatedSelectedUsers.add(event.user);
      }
      await _saveSelectedUsersToLocalStorage(updatedSelectedUsers);
      emit(currentState.copyWith(selectedUsers: updatedSelectedUsers));
    }
  }

  Future<void> _saveSelectedUsersToLocalStorage(
      List<User> selectedUsers) async {
    final prefs = await SharedPreferences.getInstance();
    final selectedUsersJson =
        json.encode(selectedUsers.map((user) => user.toJson()).toList());
    await prefs.setString('selected_users', selectedUsersJson);
  }

  Future<List<User>> _loadSelectedUsersFromLocalStorage() async {
    final prefs = await SharedPreferences.getInstance();
    final selectedUsersJson = prefs.getString('selected_users');
    if (selectedUsersJson != null) {
      final List<dynamic> selectedUsersMap = json.decode(selectedUsersJson);
      return selectedUsersMap.map((userMap) => User.fromJson(userMap)).toList();
    }
    return [];
  }

  void onScroll() {
    // if (scrollController.position.pixels ==
    //     scrollController.position.maxScrollExtent) {
    add(FetchUsers(page: ++_currentPage));

    refreshController.loadComplete();
    refreshControllerSelected.loadComplete();
    // }
  }

  // @override
  // Future<void> close() {
  //   scrollController.dispose();
  //   return super.close();
  // }
}
