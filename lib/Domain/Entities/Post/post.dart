import 'package:anonforum/Domain/Entities/Comment/comment.dart';
import 'package:anonforum/Domain/Entities/Post/post_category.dart';
import 'package:anonforum/Domain/Entities/UserAuth/user_auth.dart';
import 'package:anonforum/Domain/Entities/UserAuth/user_like_and_dislike.dart';
import 'package:equatable/equatable.dart';

class Post extends Equatable {
  Post({
    required this.postId,
    required this.title,
    required this.postText,
    required this.userId,
    required this.timeStamp,
    required this.image,
    required this.postCategoryId,
    required this.totalLikes,
    required this.totalDislikes,
    required this.postCategory,
    required this.user,
    required this.comments,
    required this.userLikes,
    required this.userDislikes
  });

  final int postId;
  final String title;
  final String postText;
  final int userId;
  final DateTime? timeStamp;
  final String image;
  final int postCategoryId;
  final int totalLikes;
  final int totalDislikes;
  final PostCategory? postCategory;
  final UserAuth? user;
  late List<UserLikeAndDislike> userLikes;
  late List<UserLikeAndDislike> userDislikes;
  late List<Comment> comments;

  factory Post.fromJson(Map<String, dynamic> json){
    return Post(
      postId: json["PostID"] ?? 0,
      title: json["Title"] ?? "",
      postText: json["PostText"] ?? "",
      userId: json["UserID"] ?? 0,
      timeStamp: DateTime.tryParse(json["TimeStamp"] ?? ""),
      image: json["Image"] ?? "",
      postCategoryId: json["PostCategoryID"] ?? 0,
      totalLikes: json["TotalLikes"] ?? 0,
      totalDislikes: json["TotalDislikes"] ?? 0,
      postCategory: json["PostCategory"] == null ? null : PostCategory.fromJson(json["PostCategory"]),
      user: json["User"] == null ? null : UserAuth.fromJson(json["User"]),
      comments: json["Comments"] == null ? [] : List<Comment>.from(json["Comments"].map((x) => Comment.fromJson(x))),
      userLikes: json["UserLikes"] == null ? [] : List<UserLikeAndDislike>.from(json["UserLikes"].map((x) => UserLikeAndDislike.fromJson(x))),
      userDislikes: json["UserDislikes"] == null ? [] : List<UserLikeAndDislike>.from(json["UserDislikes"].map((x) => UserLikeAndDislike.fromJson(x))),
    );
  }

  Map<String, dynamic> toJson() => {
    "PostID": postId,
    "Title": title,
    "PostText": postText,
    "UserID": userId,
    "TimeStamp": timeStamp?.toIso8601String(),
    "Image": image,
    "PostCategoryID": postCategoryId,
    "TotalLikes": totalLikes,
    "TotalDislikes": totalDislikes,
    "PostCategory": postCategory?.toJson(),
    "User": user?.toJson(),
    "Comments": comments.map((x) => x.toJson()).toList(),
    "UserLikes": userLikes.map((x) => x.toJson()).toList(),
    "UserDislikes": userDislikes.map((x) => x.toJson()).toList(),
  };

  @override
  String toString(){
    return "$postId, $title, $postText, $userId, $timeStamp, $image, $postCategoryId, $totalLikes, $totalDislikes, $postCategory, $user, $comments, $userLikes, $userDislikes ";
  }

  @override
  List<Object?> get props => [
    postId, title, postText, userId, timeStamp, image, postCategoryId, totalLikes, totalDislikes, postCategory, user, comments, userLikes, userDislikes ];
}