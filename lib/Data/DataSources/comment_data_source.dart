import 'dart:convert';

import 'package:anonforum/Domain/Entities/Comment/comment.dart';
import 'package:anonforum/Domain/Entities/Comment/create_comment.dart';
import 'package:anonforum/Domain/Entities/UserAuth/user_like_and_dislike.dart';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';

class CommentsDataSource {
  Future<List<Comment>> fetchComment(int postID) async {
    late String url =
        'https://app.actualsolusi.com/bsi/anonforum/api/Comments/$postID';
    var response = await http.get(Uri.parse(url));
    var jsonData = jsonDecode(response.body);
    List<Comment> commentsList = [];
    if (response.statusCode == 200) {
      for (var comment in jsonData) {
        Comment data = Comment.fromJson(comment);
        commentsList.add(data);
      }
      return commentsList;
    } else {
      return commentsList;
    }
  }

  Future<List<UserLikeAndDislike>> fetchUserLikes(int commentId) async {
    late String url =
        'https://app.actualsolusi.com/bsi/anonforum/api/Comments/Like/$commentId';
    var response = await http.get(Uri.parse(url));
    var jsonData = jsonDecode(response.body);
    List<UserLikeAndDislike> userLikesList = [];
    if (response.statusCode == 200) {
      for (var userLike in jsonData) {
        UserLikeAndDislike data = UserLikeAndDislike.fromJson(userLike);
        userLikesList.add(data);
      }
      return userLikesList;
    } else {
      return userLikesList;
    }
  }

  Future<List<UserLikeAndDislike>> fetchUserDislikes(int commentId) async {
    late String url =
        'https://app.actualsolusi.com/bsi/anonforum/api/Comments/Dislike/$commentId';
    var response = await http.get(Uri.parse(url));
    var jsonData = jsonDecode(response.body);
    List<UserLikeAndDislike> userDislikesList = [];
    if (response.statusCode == 200) {
      for (var userDislike in jsonData) {
        UserLikeAndDislike data = UserLikeAndDislike.fromJson(userDislike);
        userDislikesList.add(data);
      }
      return userDislikesList;
    } else {
      return userDislikesList;
    }
  }

  Future<void> addComment(CreateComment createComment) async {
    var logger = Logger();
    const url = 'https://app.actualsolusi.com/bsi/anonforum/api/Comments';
    Map<String, dynamic> postData = {
      'PostID': createComment.postId.toString(),
      'UserID': createComment.userId.toString(),
      'CommentText': createComment.commentText
    };
    try {
      var response = await http.post(
        Uri.parse(url),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${createComment.token.trim()}'
        },
        body: jsonEncode(postData),
      );
      if (response.statusCode == 200) {
        // Request was successful
        logger.d("Comment Success");
      } else {
        // Request failed with an error status code
        logger.d(response.statusCode);
      }
    } catch (e) {
      logger.d("Error: $e");
      throw Exception(e);
    }
  }
  Future<void> editComment(int id, String token, String newComment) async {
    var logger = Logger();
    Map<String, dynamic> data = {
      'CommentID': id.toString(),
      'CommentText': newComment,
    };
    try {
      late String url =
          'https://app.actualsolusi.com/bsi/anonforum/api/Comments/$id';
      var response = await http.put(Uri.parse(url),
        headers: <String, String>{
          'Content-Type': 'application/x-www-form-urlencoded',
          'Authorization': 'Bearer ${token.trim()}'
        },
        body: jsonEncode(data)
      );
    } catch (e) {
      logger.d("Error: $e");
      throw Exception(e);
    }
  }
  Future<void> deleteComment(int id, String token) async {
    var logger = Logger();
    try {
      late String url =
          'https://app.actualsolusi.com/bsi/anonforum/api/Comments/$id';
      var response = await http.delete(Uri.parse(url),
        headers: <String, String>{
          'Content-Type': 'application/x-www-form-urlencoded',
          'Authorization': 'Bearer ${token.trim()}'
        },);
    } catch (e) {
      logger.d("Error: $e");
      throw Exception(e);
    }
  }
  Future<void> like(int commentId, int userId, int postId, String token) async {
    var logger = Logger();
    // Map<String, dynamic> postData = {
    //   'userID': userId.toString(),
    //   'postID': postId.toString(),
    // };
    // logger.d(token.trim());
    try {
      late String url = 'https://app.actualsolusi.com/bsi/anonforum/api/Comments/Like?commentID=$commentId&userID=$userId&postID=$postId';
      var response =
      await http.post(Uri.parse(url),
        headers: <String, String>{
          'Content-Type': 'application/x-www-form-urlencoded',
          'Authorization': 'Bearer ${token.trim()}'
        },
        // body: jsonEncode(postData),
      );
    } catch (e) {
      logger.d("Error: $e");
      throw Exception(e);
    }
  }
  Future<void> unlike(int commentId, int userId, int postId, String token) async {
    var logger = Logger();
    // Map<String, dynamic> postData = {
    //   'userID': userId,
    //   'postID': postId,
    // };
    try {
      late String url = 'https://app.actualsolusi.com/bsi/anonforum/api/Comments/Unlike?commentID=$commentId&userID=$userId&postID=$postId';
      var response =
      await http.post(Uri.parse(url),
        headers: <String, String>{
          'Content-Type': 'application/x-www-form-urlencoded',
          'Authorization': 'Bearer ${token.trim()}'
        },
        // body: postData,
      );
    } catch (e) {
      logger.d("Error: $e");
      throw Exception(e);
    }
  }
  Future<void> dislike(int commentId, int userId, int postId, String token) async {
    var logger = Logger();
    // Map<String, dynamic> postData = {
    //   'userID': userId,
    //   'postID': postId,
    // };
    try {
      late String url = 'https://app.actualsolusi.com/bsi/anonforum/api/Comments/Dislike?commentID=$commentId&userID=$userId&postID=$postId';
      var response =
      await http.post(Uri.parse(url),
        headers: <String, String>{
          'Content-Type': 'application/x-www-form-urlencoded',
          'Authorization': 'Bearer ${token.trim()}'
        },
        // body: postData,
      );
    } catch (e) {
      logger.d("Error: $e");
      throw Exception(e);
    }
  }
  Future<void> undislike(int commentId, int userId, int postId, String token) async {
    var logger = Logger();
    // Map<String, dynamic> postData = {
    //   'userID': userId,
    //   'postID': postId,
    // };
    try {
      late String url = 'https://app.actualsolusi.com/bsi/anonforum/api/Comments/Undislike?commentID=$commentId&userID=$userId&postID=$postId';
      var response =
      await http.post(Uri.parse(url),
        headers: <String, String>{
          'Content-Type': 'application/x-www-form-urlencoded',
          'Authorization': 'Bearer ${token.trim()}'
        },
        // body: postData,
      );
    } catch (e) {
      logger.d("Error: $e");
      throw Exception(e);
    }
  }
}
