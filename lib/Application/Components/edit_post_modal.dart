import 'package:anonforum/Application/Provider/add_post_provider.dart';
import 'package:anonforum/Application/Provider/ddl_category_provider.dart';
import 'package:anonforum/Application/Provider/image_provider.dart';
import 'package:anonforum/Application/Provider/user_provider.dart';
import 'package:anonforum/Application/Pages/home_page.dart';
import 'package:anonforum/Data/Repositories/Post/post_repository_impl.dart';
import 'package:anonforum/Domain/Entities/Post/create_post.dart';
import 'package:anonforum/Domain/Entities/Post/edit_post.dart';
import 'package:anonforum/Domain/Entities/Post/post_category.dart';
import 'package:anonforum/Domain/UseCase/Post/post_use_case.dart';
import 'package:anonforum/Domain/UseCase/Post/post_use_case_impl.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';

class EditPostModal extends StatelessWidget {
  static const String postImageUrl =
      'https://app.actualsolusi.com/bsi/anonforum/api/Posts/image/';
  late final TextEditingController _titleController = TextEditingController();
  late final TextEditingController _postTextController =
      TextEditingController();
  late int categoryId = 0;
  late int? userId = 0;
  late int? postId = 0;
  final PostUseCase _postUseCase = PostUseCaseImpl(PostRepositoryImpl());

  EditPostModal({super.key, required this.postId});

  var logger = Logger();

  @override
  Widget build(BuildContext context) {
    UserDataProvider userDataProvider = Provider.of<UserDataProvider>(context);
    var _postImage;
    return FutureBuilder(
      future: _postUseCase.getPostById(postId!),
      builder: (context, snapshot) {
        var post = snapshot.data!;
        _titleController.text = post.title;
        _postTextController.text = post.postText;
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        } else if (!snapshot.hasData) {
          return Container();
        } else {
          return Consumer<AddPostProvider>(
              builder: (context, provider, _) => AlertDialog(
                    title: const Center(child: Text('Edit Post')),
                    content: SizedBox(
                        height: 550,
                        width: 400,
                        child: Column(
                          children: [
                            TextField(
                              controller: _titleController,
                              decoration: const InputDecoration(
                                hintText: 'Enter your title',
                                contentPadding: EdgeInsets.all(8.0),
                              ),
                            ),
                            const SizedBox(
                              height: 16,
                            ),
                            TextField(
                              controller: _postTextController,
                              decoration: const InputDecoration(
                                hintText: 'Enter your post',
                                contentPadding: EdgeInsets.all(8.0),
                              ),
                            ),
                            const SizedBox(
                              height: 16,
                            ),
                            Consumer<DropdownCategoryProvider>(
                                builder: (context, dropdownProvider, _) {
                              return FutureBuilder<List<PostCategory>?>(
                                  future: _postUseCase.fetchCategory(),
                                  builder: (context, snapshot) {
                                    if (snapshot.connectionState ==
                                        ConnectionState.waiting) {
                                      return const CircularProgressIndicator(); // Show loading indicator while fetching data
                                    } else if (snapshot.hasError) {
                                      return Text('Error: ${snapshot.error}');
                                    } else {
                                      List<PostCategory> categories =
                                          snapshot.data ?? [];
                                      return DropdownButtonFormField<
                                          PostCategory>(
                                        value: dropdownProvider.selectedItem,
                                        onChanged: (newValue) {
                                          dropdownProvider
                                              .setSelectedItem(newValue!);
                                          categoryId = newValue.postCategoryId;
                                        },
                                        items: categories.map((item) {
                                          return DropdownMenuItem<PostCategory>(
                                            value: item,
                                            child: Text(item.name),
                                          );
                                        }).toList(),
                                        decoration: const InputDecoration(
                                          labelText: 'Select a category',
                                          contentPadding: EdgeInsets.symmetric(
                                              horizontal: 16.0, vertical: 8.0),
                                          border: OutlineInputBorder(),
                                        ),
                                      );
                                    }
                                  });
                            }),
                            Container(
                              height: 300,
                              width: 300,
                              margin: const EdgeInsets.all(16),
                              alignment: Alignment.centerLeft,
                              child: (post.image.isNotEmpty)
                                  ? Image.network(postImageUrl + post.image)
                                  : Container(),
                            ),
                            Consumer<ImageUploadProvider>(
                              builder: (context, provider, _) {
                                return ElevatedButton(
                                  onPressed: () async {
                                    _postImage = await _selectImage(context);
                                    provider.notifyListeners();
                                  },
                                  child: (_postImage == null)
                                      ? const Text('Select Image')
                                      : Text(_postImage!.name),
                                );
                              },
                            ),
                          ],
                        )),
                    actions: [
                      ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: const Text('Cancel'),
                      ),
                      ElevatedButton(
                        onPressed: () async {
                          var editPost = EditPost(
                              postId: postId!,
                              title: _titleController.text,
                              postText: _postTextController.text,
                              postCategoryId: categoryId,
                              token: userDataProvider.token!);
                          await _postUseCase.editPost(postId!, editPost);
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => HomePage(),
                            ),
                          );
                        },
                        child: const Text('Save'),
                      ),
                    ],
                  ));
        }
      },
    );
  }
  Future<XFile?> _selectImage(BuildContext context) async {
    XFile? imageFile =
    (await ImagePicker().pickImage(source: ImageSource.gallery));
    ImageUploadProvider().setImage(imageFile);
    return imageFile;
  }
}
