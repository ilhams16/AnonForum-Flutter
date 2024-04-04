import 'package:equatable/equatable.dart';
import 'package:image_picker/image_picker.dart';

class EditPost extends Equatable {
  EditPost(
      {
        required this.postId,
        required this.title,
        required this.postText,
        required this.postCategoryId,
        required this.token,
        this.file
      });

  final int postId;
  final String title;
  final String postText;
  final int postCategoryId;
  final String token;
  late XFile? file;

  factory EditPost.fromJson(Map<String, dynamic> json) {
    return EditPost(
      postId: json["PostID"] ?? "",
      title: json["Title"] ?? "",
      postText: json["PostText"] ?? "",
      postCategoryId: json["PostCategoryID"] ?? 0,
      token: json["Token"] ?? "",
      file: json["File"]
    );
  }

  Map<String, dynamic> toJson() => {
    "PostID": postId,
    "Title": title,
    "PostText": postText,
    "PostCategoryID": postCategoryId,
    "File": file
  };

  @override
  String toString() {
    return "$postId, $title, $postText, $postCategoryId, $token ";
  }

  @override
  List<Object?> get props => [postId, title, postText, postCategoryId, token];
}
