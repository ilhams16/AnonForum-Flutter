import 'package:anonforum/Domain/Entities/role.dart';
import 'package:equatable/equatable.dart';

class UserAuth extends Equatable {
  const UserAuth({
    required this.userId,
    required this.username,
    required this.email,
    required this.nickname,
    required this.userImage,
    required this.roles,
  });

  final int userId;
  final String username;
  final String email;
  final String nickname;
  final String userImage;
  final List<Role> roles;

  factory UserAuth.fromJson(Map<String, dynamic> json){
    return UserAuth(
      userId: json["UserID"] ?? 0,
      username: json["Username"] ?? "",
      email: json["Email"] ?? "",
      nickname: json["Nickname"] ?? "",
      userImage: json["UserImage"] ?? "",
      roles: json["Roles"] == null ? [] : List<Role>.from(json["Roles"]!.map((x) => Role.fromJson(x))),
    );
  }

  Map<String, dynamic> toJson() => {
    "UserID": userId,
    "Username": username,
    "Email": email,
    "Nickname": nickname,
    "UserImage": userImage,
    "Roles": roles.map((x) => x.toJson()).toList(),
  };

  @override
  String toString(){
    return "$userId, $username, $email, $nickname, $userImage, $roles, ";
  }

  @override
  List<Object?> get props => [
    userId, username, email, nickname, userImage, roles, ];
}

