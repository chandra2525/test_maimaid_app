import 'package:dio/dio.dart';
import 'package:test_maimaid_app/models/user.dart';
import 'package:test_maimaid_app/models/user_response.dart';

class UserRepository {
  final Dio _dio = Dio();

  Future<UserResponse> fetchUsers(int page, {int perPage = 10}) async {
    try {
      final response = await _dio.get(
        'https://reqres.in/api/users',
        queryParameters: {'page': page, 'per_page': perPage},
      );
      return UserResponse.fromJson(response.data);
    } catch (error) {
      throw Exception('Failed to load users');
    }
  }

  Future<Map<String, dynamic>> createUser(String name, String job) async {
    try {
      final response = await _dio.post(
        'https://reqres.in/api/users',
        data: {'name': name, 'job': job},
      );
      print("Data hasil tambah : ${response.data}");
      return response.data;
    } catch (error) {
      throw Exception('Failed to create user');
    }
  }

  Future<void> deleteUser(int userId) async {
    try {
      await _dio.delete('https://reqres.in/api/users/$userId');
    } catch (error) {
      throw Exception('Failed to delete user');
    }
  }

  Future<User> fetchUserDetail(int userId) async {
    try {
      final response = await _dio.get('https://reqres.in/api/users/$userId');
      return User.fromJson(response.data['data']);
    } catch (error) {
      throw Exception('Failed to fetch user detail');
    }
  }

  // Future<User> updateUser(int userId, String name, String job) async {

  Future<Map<String, dynamic>> updateUser(
      int userId, String name, String job) async {
    try {
      final response = await _dio.patch(
        'https://reqres.in/api/users/$userId',
        data: {'name': name, 'job': job},
      );
      print("Data hasil update : ${response.data}");
      // return User.fromJson(response.data);
      return response.data;
    } catch (error) {
      throw Exception('Failed to update user');
    }
  }
}
