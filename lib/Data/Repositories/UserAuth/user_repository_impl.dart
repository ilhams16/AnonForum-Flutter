import 'package:anonforum/Data/DataSources/user_data_source.dart';
import 'package:anonforum/Data/Repositories/UserAuth/user_repository.dart';
import 'package:anonforum/Domain/Entities/UserAuth/create_user.dart';
import 'package:anonforum/Domain/Entities/UserAuth/user_auth.dart';
import 'package:anonforum/Domain/Entities/UserAuth/user_login.dart';
import 'package:logger/logger.dart';

class UserRepositoryImpl implements UserRepository{
  final UsersDataSource _dataSource = UsersDataSource();
  var logger = Logger();
  @override
  Future<UserLogin> login(String username, String password) async {
    try{
      var userWithToken = await _dataSource.login(username, password);
      var user = await _dataSource.getUserById(userWithToken.userId);
      var userLogin = UserLogin(
          username: username,
          token: userWithToken.token,
          userId: userWithToken.userId,
          userImage: user.userImage);
      return userLogin;
    } catch (e) {
      logger.d("Error: $e");
      throw Exception(e);
    }
  }

  @override
  Future<UserAuth> getUserById(int id) async {
    try{
      var user = await _dataSource.getUserById(id);
      return user;
    } catch (e) {
      logger.d("Error: $e");
      throw Exception(e);
    }
  }

  @override
  Future<void> register(CreateUser createUser) async {
    try{
      await _dataSource.register(createUser);
    } catch (e) {
      logger.d("Error: $e");
      throw Exception(e);
    }
  }
}