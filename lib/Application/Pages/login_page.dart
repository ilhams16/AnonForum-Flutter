import 'package:anonforum/Application/Pages/home_page.dart';
import 'package:anonforum/Application/Pages/register_page.dart';
import 'package:anonforum/Application/Provider/form_validator_provider.dart';
import 'package:anonforum/Application/Provider/theme_provider.dart';
import 'package:anonforum/Data/Repositories/UserAuth/user_repository_impl.dart';
import 'package:anonforum/Domain/Session/session_manager.dart';
import 'package:anonforum/Domain/UseCase/UserAuth/user_use_case.dart';
import 'package:anonforum/Domain/UseCase/UserAuth/user_use_case_impl.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatelessWidget {
  late final TextEditingController _usernameController =
      TextEditingController();
  late final TextEditingController _passwordController =
      TextEditingController();
  final UserUseCase _userUseCase = UserUseCaseImpl(UserRepositoryImpl());

  LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title: const Text("AnonForum"),
            centerTitle: true,
            actions: <Widget>[
              IconButton(
                icon: (Provider.of<ThemeProvider>(context).currentTheme ==
                        ThemeData.light())
                    ? const Icon(Icons.dark_mode)
                    : const Icon(Icons.light_mode),
                onPressed: () {
                  Provider.of<ThemeProvider>(context, listen: false)
                      .toggleTheme();
                },
              ),
              IconButton(
                  icon: const Icon(Icons.account_circle), onPressed: () {}),
            ]),
        drawerScrimColor: Colors.transparent,
        drawer: Drawer(
          elevation: 0,
          child: ListView(
            padding: EdgeInsets.zero,
            children: <Widget>[
              const SizedBox(
                  height: 80,
                  child: DrawerHeader(
                    decoration: BoxDecoration(
                      color: Colors.black12,
                    ),
                    child: Text(
                      'Menu',
                      style: TextStyle(
                        fontSize: 24,
                      ),
                    ),
                  )),
              ListTile(
                title: const Text('Home'),
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => HomePage(),
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
              // Add more list tiles for additional menu items
            ],
          ),
        ),
        body: Container(
          margin: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                "LOGIN",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _usernameController,
                onChanged: (value) => Provider.of<LoginValidator>(context, listen: false).setUsername(value),
                decoration: const InputDecoration(
                  labelText: "Username",
                  hintText: "Enter your username",
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _passwordController,
                onChanged: (value) => Provider.of<LoginValidator>(context, listen: false).setPassword(value),
                decoration: const InputDecoration(
                  labelText: "Password",
                  hintText: "Enter your password",
                  border: OutlineInputBorder(),
                ),
                obscureText: true,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  try {
                    final formValid = Provider.of<LoginValidator>(context, listen: false).validateForm();
                    if (formValid) {
                      var userLogin = await _userUseCase.login(
                          _usernameController.text, _passwordController.text);
                      await SessionManager.setLoggedIn(true);
                      await SessionManager.setUser(userLogin);
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(builder: (_) => HomePage()),
                      );
                    }

                  } catch (e) {
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(builder: (_) => LoginPage()),
                    );
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        backgroundColor: Colors.red,
                        content: Text(e.toString())));
                  }
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text("Login"),
              ),
              Consumer<LoginValidator>(
                builder: (context, loginValidator, child) {
                  if (loginValidator.errorMessage != null) {
                    return Text(
                      loginValidator.errorMessage!,
                      style: TextStyle(color: Colors.red),
                    );
                  }
                  return SizedBox(); // Return an empty SizedBox if there's no error message to avoid layout issues
                },
              ),
              const SizedBox(height: 20),
              const Text("Don't have an account?"),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => RegisterPage(),
                      ));
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text("Register"),
              ),
            ],
          ),
        ));
  }
}
