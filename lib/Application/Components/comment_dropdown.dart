import 'package:anonforum/Application/Provider/comment_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CommentExpansion extends StatelessWidget {
  final Widget child;

  const CommentExpansion({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => CommentProvider(),
      child: child,
    );
  }

  static CommentProvider of(BuildContext context) =>
      Provider.of<CommentProvider>(context, listen: false);
}
