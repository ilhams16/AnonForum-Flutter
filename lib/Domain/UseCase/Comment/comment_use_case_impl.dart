import 'package:anonforum/Data/Repositories/comment_repository.dart';
import 'package:anonforum/Domain/Entities/create_comment.dart';
import 'package:anonforum/Domain/UseCase/comment_use_case.dart';

class CommentUseCaseImpl implements CommentUseCase {
  final CommentRepository _repository;

  CommentUseCaseImpl(this._repository);

  @override
  Future<void> addComment(CreateComment createComment) async {
    return await _repository.addComment(createComment);
  }
  @override
  Future<void> editComment(int id,String token, String newComment) async {
    return await _repository.editComment(id, token, newComment);
  }
  @override
  Future<void> deleteComment(int id,String token) async {
    return await _repository.deleteComment(id, token);
  }
  @override
  Future<void> like(int commentId,int userId, int postId, String token) async {
    return await _repository.like(commentId,userId, postId, token);
  }
  @override
  Future<void> unlike(int commentId,int userId, int postId, String token) async {
    return await _repository.like(commentId,userId, postId, token);
  }
  @override
  Future<void> dislike(int commentId,int userId, int postId, String token) async {
    return await _repository.dislike(commentId,userId, postId, token);
  }
  @override
  Future<void> undislike(int commentId,int userId, int postId, String token) async {
    return await _repository.dislike(commentId,userId, postId, token);
  }
}