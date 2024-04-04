import 'package:anonforum/Application/Components/more_event_modal.dart';
import 'package:anonforum/Application/Pages/home_page.dart';
import 'package:anonforum/Application/Provider/more_event_provider.dart';
import 'package:anonforum/Application/Provider/user_provider.dart';
import 'package:anonforum/Data/Repositories/Comment/comment_repository_impl.dart';
import 'package:anonforum/Data/Repositories/Post/post_repository_impl.dart';
import 'package:anonforum/Domain/UseCase/Comment/comment_use_case.dart';
import 'package:anonforum/Domain/UseCase/Comment/comment_use_case_impl.dart';
import 'package:anonforum/Domain/UseCase/Post/post_use_case.dart';
import 'package:anonforum/Domain/UseCase/Post/post_use_case_impl.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DeleteModal extends StatelessWidget {
  late int? postId = 0;
  late int? commentId = 0;
  final PostUseCase _postUseCase = PostUseCaseImpl(PostRepositoryImpl());
  final CommentUseCase _commentUseCase =
  CommentUseCaseImpl(CommentRepositoryImpl());

  DeleteModal({super.key, this.postId, this.commentId});

  @override
  Widget build(BuildContext context) {
    UserDataProvider userDataProvider = Provider.of<UserDataProvider>(context);
    return Consumer<MoreEventProvider>(
        builder: (context, provider, _) => Dialog(
              elevation: 5,
              child: Container(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Center(
                      child: (postId != 0) ? const Text("Delete Post", style: TextStyle(fontWeight: FontWeight.bold),) : const Text("Are you sure to delete?", style: TextStyle(fontWeight: FontWeight.bold)),
                    ),
                    const Center(
                      child: Text("Are you sure to delete?"),
                    ),
                    const SizedBox(height: 16.0),
                    Row(mainAxisAlignment: MainAxisAlignment.end, children: [
                      TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                            provider.toggleMoreEvent();
                            if (provider.isPopUp) {
                              showDialog(
                                  context: context,
                                  builder: (context) => MoreEventModal(
                                        postId: postId,
                                      ));
                            }
                          },
                          child: const Text("Cancel")),
                      const SizedBox(
                        width: 16.0,
                      ),
                      TextButton(
                          onPressed: () async {
                            if (postId != 0) {
                              await _postUseCase.deletePost(
                                  postId!, userDataProvider.token!);
                            }
                            if (commentId != 0) {
                              await _commentUseCase.deleteComment(commentId!, userDataProvider.token!);
                            }
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => HomePage(),
                              ),
                            );
                          },
                          child: const Text("Delete"))
                    ])
                  ],
                ),
              ),
            ));
  }
}
