import 'package:anonforum/Application/Components/more_event_modal.dart';
import 'package:anonforum/Application/Pages/home_page.dart';
import 'package:anonforum/Application/Provider/comment_provider.dart';
import 'package:anonforum/Application/Provider/more_event_provider.dart';
import 'package:anonforum/Application/Provider/user_provider.dart';
import 'package:anonforum/Application/Components/comment_modal.dart';
import 'package:anonforum/Data/Repositories/Comment/comment_repository_impl.dart';
import 'package:anonforum/Data/Repositories/Post/post_repository_impl.dart';
import 'package:anonforum/Domain/UseCase/Comment/comment_use_case.dart';
import 'package:anonforum/Domain/UseCase/Comment/comment_use_case_impl.dart';
import 'package:anonforum/Domain/UseCase/Post/post_use_case.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:anonforum/Domain/UseCase/Post/post_use_case_impl.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatelessWidget {
  final PostUseCase _postUseCase = PostUseCaseImpl(PostRepositoryImpl());
  final CommentUseCase _commentUseCase =
  CommentUseCaseImpl(CommentRepositoryImpl());
  static const String postImageUrl =
      'https://app.actualsolusi.com/bsi/anonforum/api/Posts/image/';
  static const String userImageUrl =
      'https://app.actualsolusi.com/bsi/anonforum/api/UserAuth/image/';
  late String? search;

  HomeScreen({super.key, this.search});

  @override
  Widget build(BuildContext context) {
    UserDataProvider userDataProvider = Provider.of<UserDataProvider>(context);
    var userId = userDataProvider.userId;
    var token = userDataProvider.token;
    return FutureBuilder(
      future: (search == null)
          ? _postUseCase.fetchPostsAndComments()
          : _postUseCase.fetchPostsAndComments(search: search),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircularProgressIndicator(),
                Text("Loading..."),
              ],
            ),
          );
        } else if (snapshot.data!.isEmpty) {
          return const Center(
            child: Text('No data available'),
          );
        } else {
          return SingleChildScrollView(
            child: SizedBox(
              height: MediaQuery.of(context).size.height,
              child: ListView.builder(
                itemCount: snapshot.data!.length,
                itemBuilder: (context, index) {
                  final post = snapshot.data![index];
                  return Card(
                      margin: const EdgeInsets.symmetric(
                          vertical: 4, horizontal: 8),
                      child: Column(children: [
                        Container(
                            margin: const EdgeInsets.symmetric(
                                vertical: 16, horizontal: 16),
                            child: Row(
                              children: [
                                Row(
                                  children: [
                                    SizedBox(
                                        width: 30,
                                        height: 30,
                                        child: (post.user!.userImage.isNotEmpty)
                                            ? Image.network(userImageUrl +
                                            post.user!.userImage)
                                            : const Icon(Icons.account_box)),
                                    const SizedBox(width: 8),
                                    Text(post.user!.username),
                                  ],
                                ),
                                Consumer<MoreEventProvider>(
                                  builder: (context, provider, _) {
                                    return (post.user!.userId ==
                                        userDataProvider.userId)
                                        ? Expanded(
                                        flex: 1,
                                        child: Align(
                                            alignment:
                                            Alignment.centerRight,
                                            child: IconButton(
                                              icon: const Icon(
                                                  Icons.more_vert_sharp),
                                              onPressed: () {
                                                provider.toggleMoreEvent();
                                                if (provider.isPopUp) {
                                                  showDialog(
                                                      context: context,
                                                      builder: (context) =>
                                                          MoreEventModal(
                                                            postId:
                                                            post.postId,
                                                          ));
                                                }
                                              },
                                            )))
                                        : Container();
                                  },
                                )
                              ],
                            )),
                        Align(
                          alignment: Alignment.center,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 0, horizontal: 0),
                            child: Text(post.title,
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold)),
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.all(16),
                          alignment: Alignment.centerLeft,
                          child: Text(post.postText),
                        ),
                        Container(
                          margin: const EdgeInsets.all(16),
                          alignment: Alignment.centerLeft,
                          child: (post.image.isNotEmpty)
                              ? Image.network(postImageUrl + post.image)
                              : Container(),
                        ),
                        Container(
                          margin: const EdgeInsets.symmetric(
                              vertical: 16, horizontal: 8),
                          child: Row(
                            children: [
                              Row(
                                children: [
                                  (post.userLikes
                                      .any((e) => e.userId == userId!))
                                      ? IconButton(
                                    icon: const Icon(
                                        Icons.thumb_up_alt_sharp),
                                    onPressed: () {
                                      _postUseCase.unlike(
                                          userId!, post.postId, token!);
                                      Navigator.of(context)
                                          .pushReplacement(
                                        MaterialPageRoute(
                                            builder: (_) => HomePage()),
                                      );
                                    },
                                  )
                                      : IconButton(
                                    icon: const Icon(
                                        Icons.thumb_up_alt_outlined),
                                    onPressed: () {
                                      _postUseCase.like(
                                          userId!, post.postId, token!);
                                      Navigator.of(context)
                                          .pushReplacement(
                                        MaterialPageRoute(
                                            builder: (_) => HomePage()),
                                      );
                                    },
                                  ),
                                  const SizedBox(width: 8),
                                  Text(post.totalLikes.toString()),
                                  const SizedBox(width: 8),
                                  (post.userDislikes
                                      .any((e) => e.userId == userId))
                                      ? IconButton(
                                    icon: const Icon(
                                        Icons.thumb_down_alt_sharp),
                                    onPressed: () {
                                      _postUseCase.undislike(
                                          userId!, post.postId, token!);
                                      Navigator.of(context)
                                          .pushReplacement(
                                        MaterialPageRoute(
                                            builder: (_) => HomePage()),
                                      );
                                    },
                                  )
                                      : IconButton(
                                    icon: const Icon(
                                        Icons.thumb_down_alt_outlined),
                                    onPressed: () {
                                      _postUseCase.dislike(
                                          userId!, post.postId, token!);
                                      Navigator.of(context)
                                          .pushReplacement(
                                        MaterialPageRoute(
                                            builder: (_) => HomePage()),
                                      );
                                    },
                                  ),
                                  const SizedBox(width: 8),
                                  Text(post.totalDislikes.toString()),
                                  const SizedBox(width: 8),
                                  Consumer<CommentProvider>(
                                    builder: (context, commentProvider, _) {
                                      return IconButton(
                                        icon: const Icon(Icons.comment),
                                        onPressed: () {
                                          commentProvider.toggleComment();
                                          if (commentProvider.isComment) {
                                            showDialog(
                                              context: context,
                                              builder: (context) =>
                                                  CommentModal(
                                                      postId: post.postId),
                                            );
                                          }
                                        },
                                      );
                                    },
                                  ),
                                ],
                              ),
                              // Expanded(
                              //     child: )
                            ],
                          ),
                        ),
                        Container(
                            margin: const EdgeInsets.all(16),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Text("Category: ${post.postCategory!.name}"),
                                Expanded(
                                    child: Align(
                                        alignment: Alignment.centerRight,
                                        child: Text(
                                            "Posted on: ${DateFormat("EEEE, d MMM yyyy").format(post.timeStamp!)}"))),
                              ],
                            )),
                        (post.comments.isEmpty)
                            ? const Center(
                            heightFactor: 2,
                            child: Text('No comment available'))
                            : ExpansionTile(
                          onExpansionChanged: (bool expanded) =>
                              CommentProvider().toggleExpansion(),
                          title: const Text("Comments"),
                          initiallyExpanded: CommentProvider().isExpanded,
                          children: [
                            SingleChildScrollView(
                                padding: const EdgeInsets.all(4),
                                child: SizedBox(
                                    height: 150,
                                    child: ListView.builder(
                                        itemCount: post.comments.length,
                                        itemBuilder:
                                            (context, indexComment) {
                                          final comments =
                                          post.comments[indexComment];
                                          return Consumer<
                                              CommentProvider>(
                                            builder:
                                                (context, value, child) {
                                              return Column(children: [
                                                Container(
                                                    margin:
                                                    const EdgeInsets
                                                        .symmetric(
                                                        vertical: 16,
                                                        horizontal:
                                                        8),
                                                    child: Row(
                                                      children: [
                                                        Row(
                                                          children: [
                                                            SizedBox(
                                                                width: 30,
                                                                height:
                                                                30,
                                                                child: (comments
                                                                    .user!
                                                                    .userImage
                                                                    .isNotEmpty)
                                                                    ? Image.network(userImageUrl +
                                                                    comments.user!.userImage)
                                                                    : const Icon(Icons.account_box)),
                                                            const SizedBox(
                                                                width: 8),
                                                            Text(comments
                                                                .user!
                                                                .username),
                                                          ],
                                                        ),
                                                        Consumer<
                                                            MoreEventProvider>(
                                                          builder:
                                                              (context,
                                                              provider,
                                                              _) {
                                                            return (post.user!
                                                                .userId ==
                                                                userDataProvider
                                                                    .userId)
                                                                ? Expanded(
                                                                flex:
                                                                1,
                                                                child: Align(
                                                                    alignment: Alignment.centerRight,
                                                                    child: IconButton(
                                                                      icon: const Icon(Icons.more_vert_sharp),
                                                                      onPressed: () {
                                                                        provider.toggleMoreEvent();
                                                                        if (provider.isPopUp) {
                                                                          showDialog(
                                                                              context: context,
                                                                              builder: (context) => MoreEventModal(
                                                                                commentId: comments.commentId,
                                                                              ));
                                                                        }
                                                                      },
                                                                    )))
                                                                : Container();
                                                          },
                                                        )
                                                      ],
                                                    )),
                                                Container(
                                                  margin: const EdgeInsets
                                                      .all(8),
                                                  alignment: Alignment
                                                      .centerLeft,
                                                  child: Text(comments
                                                      .commentText),
                                                ),
                                                Container(
                                                    margin:
                                                    const EdgeInsets
                                                        .symmetric(
                                                        vertical: 16,
                                                        horizontal:
                                                        8),
                                                    child: Row(children: [
                                                      (comments.userLikes
                                                          .any((e) =>
                                                      e.userId ==
                                                          userId!))
                                                          ? IconButton(
                                                        icon: const Icon(
                                                            Icons
                                                                .thumb_up_alt_sharp),
                                                        onPressed:
                                                            () {
                                                          _commentUseCase.unlike(
                                                              comments
                                                                  .commentId,
                                                              userId!,
                                                              post.postId,
                                                              token!);
                                                          Navigator.of(
                                                              context)
                                                              .pushReplacement(
                                                            MaterialPageRoute(
                                                                builder: (_) =>
                                                                    HomePage()),
                                                          );
                                                        },
                                                      )
                                                          : IconButton(
                                                        icon: const Icon(
                                                            Icons
                                                                .thumb_up_alt_outlined),
                                                        onPressed:
                                                            () {
                                                          _commentUseCase.like(
                                                              comments
                                                                  .commentId,
                                                              userId!,
                                                              post.postId,
                                                              token!);
                                                          Navigator.of(
                                                              context)
                                                              .pushReplacement(
                                                            MaterialPageRoute(
                                                                builder: (_) =>
                                                                    HomePage()),
                                                          );
                                                        },
                                                      ),
                                                      const SizedBox(
                                                          width: 8),
                                                      Text(comments
                                                          .totalLikes
                                                          .toString()),
                                                      const SizedBox(
                                                          width: 8),
                                                      (comments
                                                          .userDislikes
                                                          .any((e) =>
                                                      e.userId ==
                                                          userId))
                                                          ? IconButton(
                                                        icon: const Icon(
                                                            Icons
                                                                .thumb_down_alt_sharp),
                                                        onPressed:
                                                            () {
                                                          _commentUseCase.undislike(
                                                              comments
                                                                  .commentId,
                                                              userId!,
                                                              post.postId,
                                                              token!);
                                                          Navigator.of(
                                                              context)
                                                              .pushReplacement(
                                                            MaterialPageRoute(
                                                                builder: (_) =>
                                                                    HomePage()),
                                                          );
                                                        },
                                                      )
                                                          : IconButton(
                                                        icon: const Icon(
                                                            Icons
                                                                .thumb_down_alt_outlined),
                                                        onPressed:
                                                            () {
                                                          _commentUseCase.dislike(
                                                              comments
                                                                  .commentId,
                                                              userId!,
                                                              post.postId,
                                                              token!);
                                                          Navigator.of(
                                                              context)
                                                              .pushReplacement(
                                                            MaterialPageRoute(
                                                                builder: (_) =>
                                                                    HomePage()),
                                                          );
                                                        },
                                                      ),
                                                      const SizedBox(
                                                          width: 8),
                                                      Text(comments
                                                          .totalDislikes
                                                          .toString()),
                                                    ]))
                                              ]);
                                            },
                                          );
                                        })))
                          ],
                        )
                      ]));
                },
              ),
            ),
          );
        }
      },
    );
  }
}