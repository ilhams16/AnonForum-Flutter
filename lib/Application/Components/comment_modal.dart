import 'package:anonforum/Application/Provider/comment_provider.dart';
import 'package:anonforum/Application/Provider/user_provider.dart';
import 'package:anonforum/Application/Pages/home_page.dart';
import 'package:anonforum/Data/Repositories/comment_repository_impl.dart';
import 'package:anonforum/Domain/Entities/create_comment.dart';
import 'package:anonforum/Domain/UseCase/comment_use_case.dart';
import 'package:anonforum/Domain/UseCase/comment_use_case_impl.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CommentModal extends StatelessWidget {
  final int? postId;
  final CommentUseCase _commentUseCase = CommentUseCaseImpl(CommentRepositoryImpl());
  CommentModal({Key? key, this.postId}) : super(key: key);

  final TextEditingController _commentController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    UserDataProvider userDataProvider = Provider.of<UserDataProvider>(context);
    return Dialog(
      child: Container(
        padding: const EdgeInsets.all(16.0),
        color: Colors.white, // Set the background color of the dialog content
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(userDataProvider.userId.toString()),
            Text(postId.toString()),
            Text(userDataProvider.token!),
            TextField(
              onChanged: (value) {
                Provider.of<CommentProvider>(context, listen: false)
                    .setComment(value);
              },
              controller: _commentController,
              decoration: InputDecoration(
                hintText: 'Comment...',
                contentPadding: const EdgeInsets.all(12.0),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                  borderSide: const BorderSide(color: Colors.grey),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                  borderSide: const BorderSide(color: Colors.blue),
                ),
              ),
            ),
            const SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () {
                _commentUseCase.addComment(CreateComment(
                    postId: postId!,
                    userId: userDataProvider.userId!,
                    commentText: _commentController.text,
                    token: userDataProvider.token!));
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => HomePage(),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                    vertical: 14.0, horizontal: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
              child: const Text(
                "Comment",
                style: TextStyle(fontSize: 16.0),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
