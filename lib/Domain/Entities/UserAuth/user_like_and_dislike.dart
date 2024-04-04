import 'package:anonforum/Domain/Entities/UserAuth/user_auth.dart';
import 'package:equatable/equatable.dart';

class UserLikeAndDislike extends Equatable {
  const UserLikeAndDislike({
    required this.postId,
    required this.userId,
    required this.user,
  });

  final int postId;
  final int userId;
  final UserAuth? user;

  factory UserLikeAndDislike.fromJson(Map<String, dynamic> json){
    return UserLikeAndDislike(
      postId: json["PostID"] ?? 0,
      userId: json["UserID"] ?? 0,
      user: json["User"] == null ? null : UserAuth.fromJson(json["User"]),
    );
  }

  Map<String, dynamic> toJson() => {
    "PostID": postId,
    "UserID": userId,
    "User": user?.toJson(),
  };

  @override
  String toString(){
    return "$postId, $userId, $user, ";
  }

  @override
  List<Object?> get props => [
    postId, userId, user, ];
}