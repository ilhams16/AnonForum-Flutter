import 'package:anonforum/Application/Pages/home_page.dart';
import 'package:anonforum/Application/Pages/login_page.dart';
import 'package:anonforum/Application/Provider/form_validator_provider.dart';
import 'package:anonforum/Application/Provider/image_provider.dart';
import 'package:anonforum/Application/Provider/theme_provider.dart';
import 'package:anonforum/Data/Repositories/UserAuth/user_repository_impl.dart';
import 'package:anonforum/Domain/Entities/UserAuth/create_user.dart';
import 'package:anonforum/Domain/UseCase/UserAuth/user_use_case.dart';
import 'package:anonforum/Domain/UseCase/UserAuth/user_use_case_impl.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class RegisterPage extends StatelessWidget {
  late final TextEditingController _usernameController =
      TextEditingController();
  late final TextEditingController _emailController = TextEditingController();
  late final TextEditingController _nicknameController =
      TextEditingController();
  late final TextEditingController _passwordController =
      TextEditingController();
  late final TextEditingController _confirmPasswordController =
      TextEditingController();
  late XFile? _userImage = null;
  final UserUseCase _userUseCase = UserUseCaseImpl(UserRepositoryImpl());

  RegisterPage({super.key});

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
                title: const Text('Login'),
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => LoginPage(),
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
                "REGISTER",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _usernameController,
                onChanged: (value) => Provider.of<RegisterValidator>(context, listen: false).setPassword(value),
                decoration: const InputDecoration(
                  labelText: "Username",
                  hintText: "Enter your username",
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _emailController,
                onChanged: (value) => Provider.of<RegisterValidator>(context, listen: false).setEmail(value),
                decoration: const InputDecoration(
                  labelText: "Email",
                  hintText: "Enter your email",
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _nicknameController,
                onChanged: (value) => Provider.of<RegisterValidator>(context, listen: false).setNickname(value),
                decoration: const InputDecoration(
                  labelText: "Nickname",
                  hintText: "Enter your nickname",
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _passwordController,
                onChanged: (value) => Provider.of<RegisterValidator>(context, listen: false).setPassword(value),
                decoration: const InputDecoration(
                  labelText: "Password",
                  hintText: "Enter your password",
                  border: OutlineInputBorder(),
                ),
                obscureText: true,
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _confirmPasswordController,
                onChanged: (value) => Provider.of<RegisterValidator>(context, listen: false).setConfirmPassword(value),
                decoration: const InputDecoration(
                  labelText: "Confirm Password",
                  hintText: "Enter your confirm password",
                  border: OutlineInputBorder(),
                ),
                obscureText: true,
              ),
              const SizedBox(height: 10),
              Consumer<ImageUploadProvider>(
                builder: (context, provider, _) {
                  return ElevatedButton(
                    onPressed: () async {
                      _userImage = await _selectImage(context);
                      provider.notifyListeners();
                    },
                    child: (_userImage == null)
                        ? const Text('Select Image')
                        : Text(_userImage!.name),
                  );
                },
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  try {
                    final formValid =
                        Provider.of<RegisterValidator>(context, listen: false)
                            .validateForm();
                    if (formValid) {
                      var newUser = CreateUser(
                          username: _usernameController.text,
                          email: _emailController.text,
                          nickname: _nicknameController.text,
                          password: _passwordController.text,
                          confirmPassword: _confirmPasswordController.text,
                          file: _userImage);
                      await _userUseCase.register(newUser);
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => LoginPage(),
                          ));
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                          backgroundColor: Colors.green,
                          content: Text("Register success, please login")));
                    }
                  } catch (e) {
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
                child: const Text("Register"),
              ),
              Consumer<RegisterValidator>(
                builder: (context, registerValidator, child) {
                  if (registerValidator.errorMessage != null) {
                    return Text(
                      registerValidator.errorMessage!,
                      style: const TextStyle(color: Colors.red),
                    );
                  }
                  return const SizedBox(); // Return an empty SizedBox if there's no error message to avoid layout issues
                },
              ),
              const SizedBox(height: 20),
              const Text("Have an account?"),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => LoginPage(),
                      ));
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text("Login"),
              ),
            ],
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
