import 'package:anonforum/Application/Provider/add_post.dart';
import 'package:anonforum/Application/Provider/ddl_category.dart';
import 'package:anonforum/Application/Provider/image_provider.dart';
import 'package:anonforum/Application/Provider/user_provider.dart';
import 'package:anonforum/Application/Pages/home_page.dart';
import 'package:anonforum/Data/Repositories/post_repository_impl.dart';
import 'package:anonforum/Domain/Entities/create_post.dart';
import 'package:anonforum/Domain/Entities/post_category.dart';
import 'package:anonforum/Domain/UseCase/post_use_case.dart';
import 'package:anonforum/Domain/UseCase/post_use_case_impl.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';

class AddPostButton extends StatelessWidget {
  late final TextEditingController _titleController = TextEditingController();
  late final TextEditingController _postTextController =
      TextEditingController();
  late int categoryId = 0;
  late int? userId = 0;
  final PostUseCase _postUseCase = PostUseCaseImpl(PostRepositoryImpl());

  // XFile? _postImage;
  var logger = Logger();

  AddPostButton({super.key, this.userId});

  @override
  Widget build(BuildContext context) {
    UserDataProvider userDataProvider = Provider.of<UserDataProvider>(context);
    var _postImage;
    return Consumer<AddPostProvider>(
        builder: (context, formFieldVisibility, _) => CircleAvatar(
          radius: 30,
              child: IconButton(
                iconSize: 30,
                onPressed: () {
                  showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: const Center(child: Text('Add New Post')),
                          content: SizedBox(
                            height: 250,
                              width: 400,
                              child:Column(
                            children: [
                              TextField(
                                controller: _titleController,
                                decoration: const InputDecoration(
                                  hintText: 'Enter your title',
                                  contentPadding: EdgeInsets.all(8.0),
                                ),
                              ),
                              const SizedBox(height: 16,),
                              TextField(
                                controller: _postTextController,
                                decoration: const InputDecoration(
                                  hintText: 'Enter your post',
                                  contentPadding: EdgeInsets.all(8.0),
                                ),
                              ),
                              const SizedBox(height: 16,),
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
                                            categoryId =
                                                newValue.postCategoryId;
                                          },
                                          items: categories.map((item) {
                                            return DropdownMenuItem<
                                                PostCategory>(
                                              value: item,
                                              child: Text(item.name),
                                            );
                                          }).toList(),
                                          decoration: const InputDecoration(
                                            labelText: 'Select a category',
                                            contentPadding:
                                                EdgeInsets.symmetric(
                                                    horizontal: 16.0,
                                                    vertical: 8.0),
                                            border: OutlineInputBorder(),
                                          ),
                                        );
                                      }
                                    });
                              }),
                              const SizedBox(height: 16,),
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
                                var newPost = CreatePost(
                                    title: _titleController.text,
                                    postText: _postTextController.text,
                                    userId: userId!,
                                    postCategoryId: categoryId,
                                    token: userDataProvider.token!,
                                    file: _postImage);
                                await _postUseCase.addPost(newPost);
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => HomePage(),
                                  ),
                                );
                              },
                              child: const Text('Post'),
                            ),
                          ],
                        );
                      });
                },
                icon: const Icon(Icons.add),
              ),
            ));
  }

  Future<XFile?> _selectImage(BuildContext context) async {
    XFile? imageFile =
        (await ImagePicker().pickImage(source: ImageSource.gallery));
    ImageUploadProvider().setImage(imageFile);
    return imageFile;
  }
}
