import 'dart:convert';

import 'package:anonforum/Domain/Entities/UserAuth/create_user.dart';
import 'package:anonforum/Domain/Entities/UserAuth/login.dart';
import 'package:anonforum/Domain/Entities/UserAuth/user_auth.dart';
import 'package:anonforum/Domain/Entities/UserAuth/user_login.dart';
import 'package:logger/logger.dart';
import 'package:http/http.dart' as http;

class UsersDataSource {
  Future<UserLogin> login(String username, String password) async {
    var logger = Logger();
    try {
      const url =
          'https://app.actualsolusi.com/bsi/anonforum/api/UserAuth/login';
      var login = Login(username: username, password: password);
      var response = await http.post(
        Uri.parse(url),
        headers: <String, String>{
          'Content-Type': 'application/json',
        },
        body: jsonEncode(login.toJson()),
      );
      var jsonData = jsonDecode(response.body);
      logger.d(jsonData.toString());
      UserLogin userLogin;
      if (response.statusCode == 200) {
        userLogin = UserLogin.fromJson(jsonData);
        logger.d("User passed");
        return userLogin;
      } else {
        throw "Invalid user";
      }
    } catch (e) {
      throw Exception("Invalid username or password");
    }
  }

  Future<UserAuth> getUserById(int id) async {
    var logger = Logger();
    try {
      var url =
          'https://app.actualsolusi.com/bsi/anonforum/api/UserAuth/$id';
      var response = await http.get(Uri.parse(url));
      var jsonData = jsonDecode(response.body);
      if (response.statusCode == 200) {
        var user = UserAuth.fromJson(jsonData);
        return user;
      } else {
        throw "Error connection";
      }
    } catch (e) {
      logger.d("Error: $e");
      throw Exception(e);
    }
  }

  Future<void> register(CreateUser createUser) async {
    var logger = Logger();
    const url = 'https://app.actualsolusi.com/bsi/anonforum/api/UserAuth';
    try {
      var request = http.MultipartRequest("POST", Uri.parse(url));
      if (createUser.file != null) {
        var len = await createUser.file!.length();
        var image = http.MultipartFile(
          'File',
          createUser.file!.openRead(),
          len,
          filename: createUser.file!.name,
        );
        request.files.add(image);
      }
      logger.d(createUser);
      request.fields['Username'] = createUser.username;
      request.fields['Email'] = createUser.email;
      request.fields['Nickname'] = createUser.nickname;
      request.fields['Password'] = createUser.password;
      request.fields['ConfirmPassword'] = createUser.confirmPassword;
      try {
        // Send the request
        var response = await request.send();

        // Check the response
        if (response.statusCode == 201) {
        } else {
        }
      } catch (e) {
        logger.d(e);
      }
    } catch (e) {
      logger.d("Error: $e");
      throw Exception(e);
    }
  }
}
