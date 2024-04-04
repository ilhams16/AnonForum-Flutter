import 'package:equatable/equatable.dart';

class PostCategory extends Equatable {
  const PostCategory({
    required this.postCategoryId,
    required this.name,
  });

  final int postCategoryId;
  final String name;

  factory PostCategory.fromJson(Map<String, dynamic> json){
    return PostCategory(
      postCategoryId: json["PostCategoryID"] ?? 0,
      name: json["Name"] ?? "",
    );
  }

  Map<String, dynamic> toJson() => {
    "PostCategoryID": postCategoryId,
    "Name": name,
  };

  @override
  String toString(){
    return "$postCategoryId, $name, ";
  }

  @override
  List<Object?> get props => [
    postCategoryId, name, ];

}
