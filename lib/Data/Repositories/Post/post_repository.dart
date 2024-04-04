import 'package:anonforum/Domain/Entities/Post/create_post.dart';
import 'package:anonforum/Domain/Entities/Post/edit_post.dart';
import 'package:anonforum/Domain/Entities/Post/post.dart';
import 'package:anonforum/Domain/Entities/Post/post_category.dart';

abstract class PostRepository {
  Future<List<Post>> fetchPostsAndComments({String? search});
  Future<Post> getPostById(int id);
  Future<void> addPost(CreatePost createPost);
  Future<void> editPost(int postId, EditPost editPost);
  Future<void> deletePost(int id, String token);
  Future<void> like(int userId, int postId, String token);
  Future<void> unlike(int userId, int postId, String token);
  Future<void> dislike(int userId, int postId, String token);
  Future<void> undislike(int userId, int postId, String token);
  Future<List<PostCategory>?> fetchPostCategory();

}