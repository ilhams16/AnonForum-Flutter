import 'package:anonforum/Data/Repositories/Post/post_repository.dart';
import 'package:anonforum/Domain/Entities/Post/create_post.dart';
import 'package:anonforum/Domain/Entities/Post/edit_post.dart';
import 'package:anonforum/Domain/Entities/Post/post.dart';
import 'package:anonforum/Domain/Entities/Post/post_category.dart';
import 'package:anonforum/Domain/UseCase/Post/post_use_case.dart';

class PostUseCaseImpl implements PostUseCase {
  final PostRepository _repository;

  PostUseCaseImpl(this._repository);

  @override
  Future<List<Post>> fetchPostsAndComments({String? search}) async {
    return (search == null)
        ? await _repository.fetchPostsAndComments()
        : await _repository.fetchPostsAndComments(search: search);
  }
  @override
  Future<Post> getPostById(int id) async {
    return _repository.getPostById(id);
  }
  @override
  Future<List<PostCategory>?> fetchCategory() async {
    return await _repository.fetchPostCategory();
  }
  @override
  Future<void> addPost(CreatePost createPost) async {
    return await _repository.addPost(createPost);
  }
  @override
  Future<void> editPost(int postId,EditPost editPost) async {
    return await _repository.editPost(postId, editPost);
  }
  @override
  Future<void> deletePost(int id,String token) async {
    return await _repository.deletePost(id, token);
  }
  @override
  Future<void> like(int userId, int postId, String token) async {
    return await _repository.like(userId, postId, token);
  }
  @override
  Future<void> unlike(int userId, int postId, String token) async {
    return await _repository.like(userId, postId, token);
  }
  @override
  Future<void> dislike(int userId, int postId, String token) async {
    return await _repository.dislike(userId, postId, token);
  }
  @override
  Future<void> undislike(int userId, int postId, String token) async {
    return await _repository.dislike(userId, postId, token);
  }
}
