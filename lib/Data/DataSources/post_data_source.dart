import 'dart:convert';
import 'dart:io';

import 'package:anonforum/Domain/Entities/Post/create_post.dart';
import 'package:anonforum/Domain/Entities/Post/edit_post.dart';
import 'package:anonforum/Domain/Entities/Post/post.dart';
import 'package:anonforum/Domain/Entities/Post/post_category.dart';
import 'package:anonforum/Domain/Entities/UserAuth/user_like_and_dislike.dart';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';

class PostsDataSource {
  Future<List<Post>?> fetchPost({String? search}) async {
    var logger = Logger();
    try {
      const url = 'https://app.actualsolusi.com/bsi/anonforum/api/Posts';
      var response = await http.get(Uri.parse(url));
      var jsonData = jsonDecode(response.body);
      List<Post>? postsList = [];
      if (response.statusCode == 200) {
        for (var post in jsonData) {
          Post data = Post.fromJson(post);
          postsList.add(data);
        }
        logger.d(search);
        if (search != null) {
          return postsList
              .where((post) => post.title.toLowerCase().contains(search))
              .toList();
        }
        return postsList;
      } else {
        return postsList;
      }
    } catch (e) {
      logger.d("Error: $e");
      throw Exception(e);
    }
  }

  Future<Post> getPostById(int id) async {
    var logger = Logger();
    try {
      late String url =
          'https://app.actualsolusi.com/bsi/anonforum/api/Posts/$id';
      var response = await http.get(Uri.parse(url));
      var jsonData = jsonDecode(response.body);
      Post data = Post.fromJson(jsonData);
      logger.d("Get By ID");
      return data;
    } catch (e) {
      logger.d("Error: $e");
      throw Exception(e);
    }
  }

  Future<List<UserLikeAndDislike>> fetchUserLikes(int postID) async {
    late String url =
        'https://app.actualsolusi.com/bsi/anonforum/api/Posts/Like/$postID';
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

  Future<List<UserLikeAndDislike>> fetchUserDislikes(int postID) async {
    late String url =
        'https://app.actualsolusi.com/bsi/anonforum/api/Posts/Dislike/$postID';
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

  Future<List<PostCategory>?> fetchPostCategory() async {
    var logger = Logger();
    try {
      const url =
          'https://app.actualsolusi.com/bsi/anonforum/api/Posts/Category';
      var response = await http.get(Uri.parse(url));
      var jsonData = jsonDecode(response.body);
      List<PostCategory>? categoriesList = [];
      if (response.statusCode == 200) {
        for (var post in jsonData) {
          PostCategory data = PostCategory.fromJson(post);
          categoriesList.add(data);
        }
        return categoriesList;
      } else {
        return categoriesList;
      }
    } catch (e) {
      logger.d("Error: $e");
      throw Exception(e);
    }
  }

  Future<void> addPost(CreatePost createPost) async {
    var logger = Logger();
    const url = 'https://app.actualsolusi.com/bsi/anonforum/api/Posts';
    try {
      var request = http.MultipartRequest("POST", Uri.parse(url));
      request.headers.addAll({
        HttpHeaders.authorizationHeader: 'Bearer ${createPost.token.trim()}',
      });
      if (createPost.file != null) {
        var len = await createPost.file!.length();
        var image = http.MultipartFile(
          'ImageFilePost',
          createPost.file!.openRead(),
          len,
          filename: createPost.file!.name,
        );
        request.files.add(image);
      }
      request.fields['Title'] = createPost.title;
      request.fields['PostText'] = createPost.postText;
      request.fields['UserID'] = createPost.userId.toString();
      request.fields['PostCategoryID'] = createPost.postCategoryId.toString();
      logger.d(createPost.file!.name.toString());
      try {
        // Send the request
        var response = await request.send();

        // Check the response
        if (response.statusCode == 201) {
        } else {
        }
      } catch (e) {
        logger.d(e);
      }
    } catch (e) {
      logger.d("Error Data Source: $e");
      throw Exception(e);
    }
  }

  Future<void> editPost(int postId, EditPost editPost) async {
    var logger = Logger();
    try {
      late String url =
          'https://app.actualsolusi.com/bsi/anonforum/api/Posts/$postId';
      var request = http.MultipartRequest("PUT", Uri.parse(url));
      request.headers.addAll({
        HttpHeaders.authorizationHeader: 'Bearer ${editPost.token.trim()}',
      });
      if (editPost.file != null) {
        var len = await editPost.file!.length();
        var image = http.MultipartFile(
          'ImageFilePost',
          editPost.file!.openRead(),
          len,
          filename: editPost.file!.name,
        );
        request.files.add(image);
      }
      request.fields['Title'] = editPost.title;
      request.fields['PostText'] = editPost.postText;
      request.fields['PostID'] = postId.toString();
      request.fields['PostCategoryID'] = editPost.postCategoryId.toString();
      var response = await request.send();
      if (response.statusCode == 201) {
        // Request was successful
      } else {
        // Request failed with an error status code
      }
    } catch (e) {
      logger.d("Error: $e");
      throw Exception(e);
    }
  }

  Future<void> deletePost(int id, String token) async {
    var logger = Logger();
    try {
      late String url =
          'https://app.actualsolusi.com/bsi/anonforum/api/Posts/$id';
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

  Future<void> like(int userId, int postId, String token) async {
    var logger = Logger();
    try {
      late String url =
          'https://app.actualsolusi.com/bsi/anonforum/api/Posts/Like?userID=$userId&postID=$postId';
      var response = await http.post(
        Uri.parse(url),
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

  Future<void> unlike(int userId, int postId, String token) async {
    var logger = Logger();
    // Map<String, dynamic> postData = {
    //   'userID': userId,
    //   'postID': postId,
    // };
    try {
      late String url =
          'https://app.actualsolusi.com/bsi/anonforum/api/Posts/Unlike?userID=$userId&postID=$postId';
      var response = await http.post(
        Uri.parse(url),
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

  Future<void> dislike(int userId, int postId, String token) async {
    var logger = Logger();
    // Map<String, dynamic> postData = {
    //   'userID': userId,
    //   'postID': postId,
    // };
    try {
      late String url =
          'https://app.actualsolusi.com/bsi/anonforum/api/Posts/Dislike?userID=$userId&postID=$postId';
      var response = await http.post(
        Uri.parse(url),
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

  Future<void> undislike(int userId, int postId, String token) async {
    var logger = Logger();
    // Map<String, dynamic> postData = {
    //   'userID': userId,
    //   'postID': postId,
    // };
    try {
      late String url =
          'https://app.actualsolusi.com/bsi/anonforum/api/Posts/Undislike?userID=$userId&postID=$postId';
      var response = await http.post(
        Uri.parse(url),
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
