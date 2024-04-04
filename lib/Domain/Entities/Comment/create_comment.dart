import 'package:equatable/equatable.dart';

class CreateComment extends Equatable {
  const CreateComment({
    required this.postId,
    required this.userId,
    required this.commentText,
    required this.token
  });

  final int postId;
  final int userId;
  final String commentText;
  final String token;

  factory CreateComment.fromJson(Map<String, dynamic> json){
    return CreateComment(
      postId: json["PostID"] ?? 0,
      userId: json["UserID"] ?? 0,
      commentText: json["CommentText"] ?? "",
      token: json["Token"] ?? "",
    );
  }

  Map<String, dynamic> toJson() => {
    "PostID": postId,
    "UserID": userId,
    "CommentText": commentText,
    "Token": token,
  };

  @override
  String toString(){
    return "$postId, $userId, $commentText, $token ";
  }

  @override
  List<Object?> get props => [
    postId, userId, commentText, token ];
}
