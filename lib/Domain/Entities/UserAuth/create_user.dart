import 'package:equatable/equatable.dart';
import 'package:image_picker/image_picker.dart';

class CreateUser extends Equatable {
  CreateUser({
    required this.username,
    required this.email,
    required this.nickname,
    required this.password,
    required this.confirmPassword,
    this.file
  });

  final String username;
  final String email;
  final String nickname;
  final String password;
  final String confirmPassword;
  late XFile? file;

  factory CreateUser.fromJson(Map<String, dynamic> json){
    return CreateUser(
      username: json["Username"] ?? "",
      email: json["Email"] ?? "",
      nickname: json["Nickname"] ?? "",
      password: json["Password"],
      confirmPassword: json["ConfirmPassword"],
      file: json["File"] ?? "",
    );
  }

  Map<String, dynamic> toJson() => {
    "Username": username,
    "Email": email,
    "Nickname": nickname,
    "Password": password,
    "ConfirmPassword": confirmPassword,
    "File": file,
  };

  @override
  String toString(){
    return "$username, $email, $nickname, $password, $confirmPassword, $file ";
  }

  @override
  List<Object?> get props => [
    username, email, nickname, password, confirmPassword, file ];
}

