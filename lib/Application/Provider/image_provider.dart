import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';

class ImageUploadProvider extends ChangeNotifier {
  XFile? _imageFile;

  XFile? get imageFile => _imageFile;

  void setImage(XFile? imageFile) {
    _imageFile = imageFile;
    notifyListeners();
  }
}
