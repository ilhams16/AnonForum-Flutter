import 'package:anonforum/Data/Repositories/UserAuth/user_repository_impl.dart';
import 'package:anonforum/Domain/UseCase/UserAuth/user_use_case.dart';
import 'package:anonforum/Domain/UseCase/UserAuth/user_use_case_impl.dart';
import 'package:flutter/material.dart';

class AccountScreen extends StatelessWidget {
  late int userId = 0;
  static const String userImageUrl =
      'https://app.actualsolusi.com/bsi/anonforum/api/UserAuth/image/';
  final UserUseCase _userUseCase = UserUseCaseImpl(UserRepositoryImpl());

  AccountScreen({super.key, required this.userId});

  @override
  Widget build(BuildContext context) {
    if (userId != 0) {
      return Scaffold(
          appBar: AppBar(
            title: const Text("Account"),
          ),
          body: FutureBuilder(
            future: _userUseCase.getUserById(userId),
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
              } else if (snapshot.data == null) {
                return const Center(
                  child: Text('No data available'),
                );
              } else {
                return Card(
                    child: Center(
                  child: Column(
                    children: [
                      Container(
                          margin: const EdgeInsets.all(24),
                          child: SizedBox(
                            width: 200,
                            height: 200,
                            child: ClipOval(
                              child: (snapshot.data!.userImage.isNotEmpty)
                                  ? Image.network(
                                      userImageUrl + snapshot.data!.userImage,
                                      width: 200,
                                      height: 200,
                                      fit: BoxFit.cover,
                                    )
                                  : const Icon(Icons.account_box),
                            ),
                          )),
                      Column(
                        children: [
                          Container(
                            margin: const EdgeInsets.all(8),
                            child: const Text(
                              "Username",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 20),
                            ),
                          ),
                          Center(
                            child: Text(snapshot.data!.username.trim()),
                          )
                        ],
                      ),
                      Column(
                        children: [
                          Container(
                            margin: const EdgeInsets.all(8),
                            child: const Text(
                              "Email",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 20),
                            ),
                          ),
                          Center(
                                                      child: Text(snapshot.data!.email.trim()),
                                                    )
                        ],
                      ),
                      Column(
                        children: [
                          Container(
                            margin: const EdgeInsets.all(8),
                            child: const Text(
                              "Nickname",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 20),
                            ),
                          ),
                          Center(
                                                      child: Text(snapshot.data!.nickname.trim()),
                                                    )
                        ],
                      ),
                    ],
                  ),
                ));
              }
            },
          ));
    } else {
      return const Center(
        child: Text("You must login"),
      );
    }
  }
}
