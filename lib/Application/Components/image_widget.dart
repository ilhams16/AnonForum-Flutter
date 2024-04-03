import 'package:anonforum/Application/Provider/image_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ImageProvider extends StatelessWidget {
  final Widget child;

  const ImageProvider({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ImageUploadProvider(),
      child: child,
    );
  }

  static ImageUploadProvider of(BuildContext context) =>
      Provider.of<ImageUploadProvider>(context, listen: false);
}