import 'package:anonforum/Application/Provider/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ThemeNotifier extends StatelessWidget {
  final Widget child;

  const ThemeNotifier({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ThemeProvider(),
      child: child,
    );
  }

  static ThemeProvider of(BuildContext context) =>
      Provider.of<ThemeProvider>(context, listen: false);
}
