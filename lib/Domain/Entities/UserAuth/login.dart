import 'package:equatable/equatable.dart';

class Login extends Equatable {
  const Login({
    required this.username,
    required this.password
  });

  final String username;
  final String password;

  factory Login.fromJson(Map<String, dynamic> json){
    return Login(
      username: json["UsernameOrEmail"] ?? "",
      password: json["Password"] ?? "",
    );
  }

  Map<String, dynamic> toJson() => {
    "UsernameOrEmail": username,
    "Password": password,
  };

  @override
  String toString(){
    return "$username, $password";
  }

  @override
  List<Object?> get props => [
    username, password];
}