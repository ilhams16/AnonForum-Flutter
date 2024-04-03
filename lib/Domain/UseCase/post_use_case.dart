import 'package:anonforum/Domain/Entities/create_post.dart';
import 'package:anonforum/Domain/Entities/post.dart';
import 'package:anonforum/Domain/Entities/post_category.dart';

abstract class PostUseCase {
  Future<List<Post>> fetchPostsAndComments({String? search});
  Future<void> addPost(CreatePost createPost);
  Future<List<PostCategory>?> fetchCategory();
  Future<void> like(int userId, int postId, String token);
  Future<void> unlike(int userId, int postId, String token);
  Future<void> dislike(int userId, int postId, String token);
  Future<void> undislike(int userId, int postId, String token);
}