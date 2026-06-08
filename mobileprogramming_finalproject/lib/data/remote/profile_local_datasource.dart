import 'dart:io';
import 'package:image_picker/image_picker.dart';

class ProfileLocalDataSource {
  final ImagePicker _picker = ImagePicker();

  Future<File> pickImageFromGallery() async {
    final XFile? pickedFile = await _picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 70,
    );

    if (pickedFile != null) {
      return File(pickedFile.path);
    }
    throw Exception("No image selected");
  }
}
