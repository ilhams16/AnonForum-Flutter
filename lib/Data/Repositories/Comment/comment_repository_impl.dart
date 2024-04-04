import 'package:anonforum/Data/DataSources/comment_data_source.dart';
import 'package:anonforum/Data/Repositories/Comment/comment_repository.dart';
import 'package:anonforum/Domain/Entities/Comment/create_comment.dart';
import 'package:logger/logger.dart';

class CommentRepositoryImpl implements CommentRepository {
  final CommentsDataSource _dataSource = CommentsDataSource();
  var logger = Logger();

  @override
  Future<void> addComment(CreateComment createComment) async {
    logger.d(createComment);
    try {
      await _dataSource.addComment(createComment);
    } catch (e) {
      logger.d("Error Repository: $e");
      throw Exception(e);
    }
  }
  @override
  Future<void> editComment(int id, String token, String newComment) async {
    try{
      await _dataSource.editComment(id, token, newComment);
    } catch (e) {
      logger.d("Error Repository: $e");
      throw Exception(e);
    }
  }
  @override
  Future<void> deleteComment(int id, String token) async {
    try{
      await _dataSource.deleteComment(id, token);
    } catch (e) {
      logger.d("Error Repository: $e");
      throw Exception(e);
    }
  }

  @override
  Future<void> like(int commentId, int userId, int postId, String token) async {
    try {
      await _dataSource.like(commentId, userId, postId, token);
    } catch (e) {
      logger.d("Error Repository: $e");
      logger.d(userId is String);
      logger.d(postId is String);
      throw Exception(e);
    }
  }

  @override
  Future<void> unlike(
      int commentId, int userId, int postId, String token) async {
    try {
      await _dataSource.unlike(commentId, userId, postId, token);
    } catch (e) {
      logger.d("Error Repository: $e");
      throw Exception(e);
    }
  }

  @override
  Future<void> dislike(
      int commentId, int userId, int postId, String token) async {
    try {
      await _dataSource.dislike(commentId, userId, postId, token);
    } catch (e) {
      logger.d("Error Repository: $e");
      throw Exception(e);
    }
  }

  @override
  Future<void> undislike(
      int commentId, int userId, int postId, String token) async {
    try {
      await _dataSource.undislike(commentId, userId, postId, token);
    } catch (e) {
      logger.d("Error Repository: $e");
      throw Exception(e);
    }
  }
}
