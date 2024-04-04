import 'package:anonforum/Application/Pages/Screen/home_screen.dart';
import 'package:anonforum/Application/Provider/bottom_navbar_provider.dart';
import 'package:anonforum/Application/Provider/user_provider.dart';
import 'package:anonforum/Application/Pages/Screen/account_screen.dart';
import 'package:anonforum/Application/Pages/login_page.dart';
import 'package:anonforum/Application/Pages/register_page.dart';
import 'package:anonforum/Application/Components/add_post_widget.dart';
import 'package:anonforum/Application/Components/search_modal.dart';
import 'package:anonforum/Application/Provider/search_provider.dart';
import 'package:anonforum/Application/Provider/theme_provider.dart';
import 'package:anonforum/Domain/Entities/UserAuth/user_login.dart';
import 'package:anonforum/Domain/Session/session_manager.dart';
import 'package:flutter/material.dart';
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
        return AccountScreen(userId: userId!);
      default:
        return Container();
    }
  }
}


