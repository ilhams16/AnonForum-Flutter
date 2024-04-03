import 'package:equatable/equatable.dart';
import 'package:image_picker/image_picker.dart';

class CreatePost extends Equatable {
  CreatePost(
      {required this.title,
      required this.postText,
      required this.userId,
      required this.postCategoryId,
      required this.token,
      this.file
      });

  final String title;
  final String postText;
  final int userId;
  final int postCategoryId;
  final String token;
  late XFile? file;

  factory CreatePost.fromJson(Map<String, dynamic> json) {
    return CreatePost(
      title: json["Title"] ?? "",
      postText: json["PostText"] ?? "",
      userId: json["UserID"] ?? 0,
      postCategoryId: json["PostCategoryID"] ?? 0,
      token: json["Token"] ?? "",
      file: json["File"] ?? "",
    );
  }

  Map<String, dynamic> toJson() => {
        "Title": title,
        "PostText": postText,
        "UserID": userId,
        "PostCategoryID": postCategoryId,
        "Token": token,
        "File": file,
      };

  @override
  String toString() {
    return "$title, $postText, $userId, $postCategoryId, $token, $file ";
  }

  @override
  List<Object?> get props => [title, postText, userId, postCategoryId, token, file];
}
