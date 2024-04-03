import 'package:anonforum/Data/Repositories/post_repository.dart';
import 'package:anonforum/Domain/Entities/create_post.dart';
import 'package:anonforum/Domain/Entities/post.dart';
import 'package:anonforum/Domain/Entities/post_category.dart';
import 'package:anonforum/Domain/UseCase/post_use_case.dart';

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
  Future<List<PostCategory>?> fetchCategory() async {
    return await _repository.fetchPostCategory();
  }
  @override
  Future<void> addPost(CreatePost createPost) async {
    return await _repository.addPost(createPost);
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
