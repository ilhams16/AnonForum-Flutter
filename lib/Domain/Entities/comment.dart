import 'package:anonforum/Domain/Entities/user_auth.dart';
import 'package:anonforum/Domain/Entities/user_like_and_dislike.dart';
import 'package:equatable/equatable.dart';

class Comment extends Equatable {
  Comment({
    required this.commentId,
    required this.postId,
    required this.userId,
    required this.commentText,
    required this.timeStamp,
    required this.totalLikes,
    required this.totalDislikes,
    required this.user,
    required this.userLikes,
    required this.userDislikes
  });

  final int commentId;
  final int postId;
  final int userId;
  final String commentText;
  final DateTime? timeStamp;
  final int totalLikes;
  final int totalDislikes;
  final UserAuth? user;
  late List<UserLikeAndDislike> userLikes;
  late List<UserLikeAndDislike> userDislikes;

  factory Comment.fromJson(Map<String, dynamic> json){
    return Comment(
      commentId: json["CommentID"] ?? 0,
      postId: json["PostID"] ?? 0,
      userId: json["UserID"] ?? 0,
      commentText: json["CommentText"] ?? "",
      timeStamp: DateTime.tryParse(json["TimeStamp"] ?? ""),
      totalLikes: json["TotalLikes"] ?? 0,
      totalDislikes: json["TotalDislikes"] ?? 0,
      user: json["User"] == null ? null : UserAuth.fromJson(json["User"]),
      userLikes: json["UserLikes"] == null ? [] : List<UserLikeAndDislike>.from(json["UserLikes"].map((x) => UserLikeAndDislike.fromJson(x))),
      userDislikes: json["UserDislikes"] == null ? [] : List<UserLikeAndDislike>.from(json["UserDislikes"].map((x) => UserLikeAndDislike.fromJson(x))),
    );
  }

  Map<String, dynamic> toJson() => {
    "CommentID": commentId,
    "PostID": postId,
    "UserID": userId,
    "CommentText": commentText,
    "TimeStamp": timeStamp?.toIso8601String(),
    "TotalLikes": totalLikes,
    "TotalDislikes": totalDislikes,
    "User": user?.toJson(),
    "UserLikes": userLikes.map((x) => x.toJson()).toList(),
    "UserDislikes": userDislikes.map((x) => x.toJson()).toList(),
  };

  @override
  String toString(){
    return "$commentId, $postId, $userId, $commentText, $timeStamp, $totalLikes, $totalDislikes, $user, $userLikes, $userDislikes ";
  }

  @override
  List<Object?> get props => [
    commentId, postId, userId, commentText, timeStamp, totalLikes, totalDislikes, user, userLikes, userDislikes ];
}