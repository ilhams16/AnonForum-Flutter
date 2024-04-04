import 'package:anonforum/Application/Pages/Screen/splah_screen.dart';
import 'package:anonforum/Application/Provider/add_post_provider.dart';
import 'package:anonforum/Application/Provider/bottom_navbar_provider.dart';
import 'package:anonforum/Application/Provider/ddl_category_provider.dart';
import 'package:anonforum/Application/Provider/form_validator_provider.dart';
import 'package:anonforum/Application/Provider/image_provider.dart';
import 'package:anonforum/Application/Provider/comment_provider.dart';
import 'package:anonforum/Application/Provider/more_event_provider.dart';
import 'package:anonforum/Application/Provider/search_provider.dart';
import 'package:anonforum/Application/Provider/theme_provider.dart';
import 'package:anonforum/Application/Provider/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'Application/Pages/home_page.dart';

void main() async {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(create: (_) => CommentProvider()),
        ChangeNotifierProvider(create: (_) => ImageUploadProvider()),
        ChangeNotifierProvider(create: (_) => SearchProvider()),
        ChangeNotifierProvider(create: (_) => AddPostProvider()),
        ChangeNotifierProvider(create: (_) => DropdownCategoryProvider()),
        ChangeNotifierProvider(create: (_) => UserDataProvider()),
        ChangeNotifierProvider(create: (_) => BottomNavBarProvider()),
        ChangeNotifierProvider(create: (_) => MoreEventProvider()),
        ChangeNotifierProvider(create: (_) => RegisterValidator()),
        ChangeNotifierProvider(create: (_) => LoginValidator()),

        // Add more providers as needed
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      title: 'AnonForum',
      theme: Provider.of<ThemeProvider>(context).currentTheme,
      home: SplashScreen(),
    );
  }
}
