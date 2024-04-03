import 'package:equatable/equatable.dart';

class UserLogin extends Equatable {
  const UserLogin({
    required this.username,
    required this.token,
    required this.userId,
    required this.userImage
  });

  final String username;
  final int userId;
  final String token;
  final String userImage;

  factory UserLogin.fromJson(Map<String, dynamic> json){
    return UserLogin(
      username: json["Username"] ?? "",
      token: json["Token"] ?? "",
      userId: json["UserID"] ?? "",
      userImage: json["UserImage"] ?? "",
    );
  }

  Map<String, dynamic> toJson() => {
    "Username": username,
    "UserID": userId,
    "Token": token,
    "UserImage": userImage
  };

  @override
  String toString(){
    return "$username, $userId, $token, $userId, $userImage";
  }

  @override
  List<Object?> get props => [
    username, userId, token, userId, userImage];
}