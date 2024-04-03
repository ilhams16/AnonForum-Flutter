import 'package:anonforum/Application/Provider/bottom_navbar_provider.dart';
import 'package:anonforum/Application/Provider/comment_provider.dart';
import 'package:anonforum/Application/Provider/user_provider.dart';
import 'package:anonforum/Application/Pages/account_page.dart';
import 'package:anonforum/Application/Pages/login_page.dart';
import 'package:anonforum/Application/Pages/register_page.dart';
import 'package:anonforum/Application/Components/comment_modal.dart';
import 'package:anonforum/Application/Components/add_post_widget.dart';
import 'package:anonforum/Application/Components/search_modal.dart';
import 'package:anonforum/Application/Provider/search_provider.dart';
import 'package:anonforum/Application/Provider/theme_provider.dart';
import 'package:anonforum/Data/Repositories/comment_repository_impl.dart';
import 'package:anonforum/Data/Repositories/post_repository_impl.dart';
import 'package:anonforum/Domain/Entities/user_login.dart';
import 'package:anonforum/Domain/Session/session_manager.dart';
import 'package:anonforum/Domain/UseCase/comment_use_case.dart';
import 'package:anonforum/Domain/UseCase/comment_use_case_impl.dart';
import 'package:anonforum/Domain/UseCase/post_use_case.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:anonforum/Domain/UseCase/post_use_case_impl.dart';
import 'package:provider/provider.dart';

class HomePage extends StatelessWidget {
  static const String postImageUrl =
      'https://app.actualsolusi.com/bsi/anonforum/api/Posts/image/';
  static const String userImageUrl =
      'https://app.actualsolusi.com/bsi/anonforum/api/UserAuth/image/';
  late String? search;

  HomePage({super.key, this.search});

  @override
  Widget build(BuildContext context) {
    UserDataProvider userDataProvider = Provider.of<UserDataProvider>(context);
    var userId = userDataProvider.userId;
    return Scaffold(
      appBar: AppBar(
          title: const Text("AnonForum"),
          centerTitle: true,
          actions: <Widget>[
            Consumer<SearchProvider>(
              builder: (context, searchProvider, _) {
                return IconButton(
                  icon: const Icon(Icons.search),
                  onPressed: () {
                    searchProvider.toggleSearch();
                    if (searchProvider.isSearching) {
                      showDialog(
                        context: context,
                        builder: (context) => SearchModal(),
                      );
                    }
                  },
                );
              },
            ),
            IconButton(
              icon: (Provider.of<ThemeProvider>(context).currentTheme ==
                      ThemeData.light())
                  ? const Icon(Icons.dark_mode)
                  : const Icon(Icons.light_mode),
              onPressed: () {
                Provider.of<ThemeProvider>(context, listen: false)
                    .toggleTheme();
              },
            )
          ]),
      drawerScrimColor: Colors.transparent,
      drawer: Drawer(
        width: 250,
        elevation: 0,
        child: FutureBuilder<bool>(
          future: SessionManager.isLoggedIn(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const CircularProgressIndicator();
            } else {
              final isLoggedIn = snapshot.data ?? false;
              return isLoggedIn
                  ? ListView(padding: EdgeInsets.zero, children: <Widget>[
                      DrawerHeader(
                          decoration: const BoxDecoration(
                            color: Colors.black12,
                          ),
                          child: FutureBuilder<UserLogin>(
                            future: SessionManager.isUser(),
                            builder: (context, snapshot) {
                              userId = snapshot.data!.userId;
                              return Column(
                                children: [
                                  Row(
                                    children: [
                                      SizedBox(
                                        width: 100,
                                        height: 100,
                                        child: ClipOval(
                                          child: (snapshot
                                                  .data!.userImage.isNotEmpty)
                                              ? Image.network(
                                                  userImageUrl +
                                                      snapshot.data!.userImage,
                                                  width: 100,
                                                  height: 100,
                                                  fit: BoxFit.cover,
                                                )
                                              : const Icon(Icons.account_box),
                                        ),
                                      ),
                                      Expanded(
                                          child: Center(
                                        child: Text(snapshot.data!.username,
                                            style: const TextStyle(
                                                fontSize: 24,
                                                fontWeight: FontWeight.bold)),
                                      ))
                                    ],
                                  ),
                                ],
                              );
                            },
                          )),
                      ListTile(
                        title: const Text('Logout'),
                        onTap: () async {
                          await SessionManager.setLoggedIn(false);
                          await SessionManager.setUser(null);
                          Navigator.of(context).pushReplacement(
                            MaterialPageRoute(builder: (_) => HomePage()),
                          );
                        },
                      ),
                    ])
                  : ListView(padding: EdgeInsets.zero, children: <Widget>[
                      const DrawerHeader(
                        decoration: BoxDecoration(
                          color: Colors.black12,
                        ),
                        child: Text(
                          'Menu',
                          style: TextStyle(
                            fontSize: 24,
                          ),
                        ),
                      ),
                      ListTile(
                        title: const Text('Login'),
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => LoginPage(),
                              ));
                        },
                      ),
                      ListTile(
                        title: const Text('Register'),
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => RegisterPage(),
                              ));
                        },
                      ),
                    ]);
            }
          },
        ),
      ),
      body: _getPage(context),
      floatingActionButton: (userId != 0)
          ? AddPostButton(
              userId: userId,
            )
          : null,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: Provider.of<BottomNavBarProvider>(context).currentIndex,
        onTap: (index) {
          Provider.of<BottomNavBarProvider>(context, listen: false)
              .updateIndex(index);
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_box_rounded),
            label: 'Account',
          ),
        ],
      ),
    );
  }

  Widget _getPage(BuildContext context) {
    UserDataProvider userDataProvider = Provider.of<UserDataProvider>(context);
    var userId = userDataProvider.userId;
    switch (Provider.of<BottomNavBarProvider>(context).currentIndex) {
      case 0:
        return HomeScreen(
          search: search,
        );
      case 1:
        return AccountPage(userId: userId!);
      default:
        return Container();
    }
  }
}

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
                          margin: EdgeInsets.all(16),
                            child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Text("Category: ${post.postCategory!.name}"),
                            Expanded(child:
                                Align(alignment: Alignment.centerRight,
                                    child:Text(
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
