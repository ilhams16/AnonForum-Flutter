import 'package:anonforum/Domain/Entities/UserAuth/create_user.dart';
import 'package:anonforum/Domain/Entities/UserAuth/user_auth.dart';
import 'package:anonforum/Domain/Entities/UserAuth/user_login.dart';

abstract class UserUseCase {
  Future<UserLogin> login(String username, String password);
  Future<UserAuth> getUserById(int id);
  Future<void> register(CreateUser createUser);
}