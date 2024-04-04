import 'package:anonforum/Domain/Entities/Comment/create_comment.dart';

abstract class CommentUseCase {
  Future<void> addComment(CreateComment createComment);
  Future<void> editComment(int id,String token, String newComment);
  Future<void> deleteComment(int id, String token);
  Future<void> like(int commentId,int userId, int postId, String token);
  Future<void> unlike(int commentId,int userId, int postId, String token);
  Future<void> dislike(int commentId,int userId, int postId, String token);
  Future<void> undislike(int commentId,int userId, int postId, String token);
}