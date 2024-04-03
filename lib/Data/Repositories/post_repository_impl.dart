import 'package:anonforum/Data/DataSources/comment_data_source.dart';
import 'package:anonforum/Data/DataSources/post_data_source.dart';
import 'package:anonforum/Data/Repositories/post_repository.dart';
import 'package:anonforum/Domain/Entities/comment.dart';
import 'package:anonforum/Domain/Entities/create_post.dart';
import 'package:anonforum/Domain/Entities/post.dart';
import 'package:anonforum/Domain/Entities/post_category.dart';
import 'package:anonforum/Domain/Entities/user_like_and_dislike.dart';
import 'package:logger/logger.dart';

class PostRepositoryImpl implements PostRepository {
  final PostsDataSource _dataSource = PostsDataSource();
  var logger = Logger();

  @override
  Future<List<Post>> fetchPostsAndComments({String? search}) async {
    try {
      var posts = await _dataSource.fetchPost();
      if (search != null) {
        posts = await _dataSource.fetchPost(search: search);
      }
      for (var post in posts!) {
        List<Comment> comments = await CommentsDataSource().fetchComment(post.postId);
        List<UserLikeAndDislike> userLikes = await _dataSource.fetchUserLikes(post.postId);
        List<UserLikeAndDislike> userDislikes = await _dataSource.fetchUserDislikes(post.postId);
        post.userLikes = userLikes;
        post.userDislikes = userDislikes;
        post.comments = comments;
        for (var comment in comments) {
          List<UserLikeAndDislike> userLikes = await CommentsDataSource().fetchUserLikes(comment.commentId);
          List<UserLikeAndDislike> userDislikes = await CommentsDataSource().fetchUserDislikes(comment.commentId);
          comment.userLikes = userLikes;
          comment.userDislikes = userDislikes;
        }
      }
      return posts;
    } catch (e) {
      logger.d("Error: $e");
      throw Exception(e);
    }
  }
  @override
  Future<List<PostCategory>?> fetchPostCategory() async {
    try {
      return await _dataSource.fetchPostCategory();
    } catch (e) {
      logger.d("Error: $e");
      throw Exception(e);
    }
  }
  @override
  Future<void> addPost(CreatePost createPost) async {
    logger.d(createPost);
    try{
      await _dataSource.addPost(createPost);
    } catch (e) {
      logger.d("Error Repository: $e");
      throw Exception(e);
    }
  }
  @override
  Future<void> like(int userId, int postId, String token) async {
    try{
      await _dataSource.like(userId, postId, token);
    } catch (e) {
      logger.d("Error Repository: $e");
      logger.d(userId is String);
      logger.d(postId is String);
      throw Exception(e);
    }
  }
  @override
  Future<void> unlike(int userId, int postId, String token) async {
    try{
      await _dataSource.unlike(userId, postId, token);
    } catch (e) {
      logger.d("Error Repository: $e");
      throw Exception(e);
    }
  }
  @override
  Future<void> dislike(int userId, int postId, String token) async {
    try{
      await _dataSource.dislike(userId, postId, token);
    } catch (e) {
      logger.d("Error Repository: $e");
      throw Exception(e);
    }
  }
  @override
  Future<void> undislike(int userId, int postId, String token) async {
    try{
      await _dataSource.undislike(userId, postId, token);
    } catch (e) {
      logger.d("Error Repository: $e");
      throw Exception(e);
    }
  }
}
