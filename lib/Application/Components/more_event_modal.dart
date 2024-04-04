import 'package:anonforum/Application/Components/comment_modal.dart';
import 'package:anonforum/Application/Components/delete_modal.dart';
import 'package:anonforum/Application/Components/edit_post_modal.dart';
import 'package:anonforum/Application/Provider/more_event_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MoreEventModal extends StatelessWidget {
  late int? postId = 0;
  late int? commentId = 0;

  MoreEventModal({super.key, this.postId, this.commentId});

  @override
  Widget build(BuildContext context) {
    return Consumer<MoreEventProvider>(builder: (context, provider, _) => Dialog(
      child: Container(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextButton(
                onPressed: () {
                  if(postId != null){
                  Navigator.pop(context);
                  provider.toggleMoreEvent();
                  provider.toggleEditModal();
                  if (provider.isEdit) {
                    showDialog(
                        context: context,
                        builder: (context) =>
                            EditPostModal(postId: postId,));
                  }}
                  if (commentId != null) {
                    Navigator.pop(context);
                    provider.toggleMoreEvent();
                    provider.toggleEditModal();
                    if (provider.isEdit) {
                      showDialog(
                          context: context,
                          builder: (context) =>
                              CommentModal(commentId: commentId,));
                    }
                  }
                },
                child: const Text("Edit")),
            const SizedBox(height: 16.0),
            TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  provider.toggleMoreEvent();
                  provider.toggleDeleteModal();
                  if (provider.isDelete) {
                    showDialog(
                        context: context,
                        builder: (context) =>
                            DeleteModal(postId: postId,));
                  }
                },
                child: const Text("Delete")),
            const SizedBox(height: 16.0,),
            TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  provider.toggleMoreEvent();
                },
                child: const Text("Cancel"))
          ],
        ),
      ),
    ));
  }
}