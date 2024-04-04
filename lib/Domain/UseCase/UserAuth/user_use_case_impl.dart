import 'package:anonforum/Data/Repositories/UserAuth/user_repository.dart';
import 'package:anonforum/Domain/Entities/UserAuth/create_user.dart';
import 'package:anonforum/Domain/Entities/UserAuth/user_auth.dart';
import 'package:anonforum/Domain/Entities/UserAuth/user_login.dart';
import 'package:anonforum/Domain/UseCase/UserAuth/user_use_case.dart';

class UserUseCaseImpl implements UserUseCase {
  final UserRepository _repository;

  UserUseCaseImpl(this._repository);

  @override
  Future<UserLogin> login(String username, String password) async {
    return await _repository.login(username,password);
  }
  @override
  Future<UserAuth> getUserById(int id) async {
    return await _repository.getUserById(id);
  }

  @override
  Future<void> register(CreateUser createUser) async {
    return await _repository.register(createUser);
  }
}