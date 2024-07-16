import 'dart:io';
import 'dart:typed_data';
import 'package:chatdo/setup.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';

class StorageServices {
  StorageServices();

  final ImagePicker imagePicker = ImagePicker();
  final FilePicker filePicker = FilePicker.platform;
  final FirebaseStorage firebaseStorage = FirebaseStorage.instance;

  Future<File?> pickImageFromGallery() async {
    try {
      final XFile? imageFile =
          await imagePicker.pickImage(source: ImageSource.gallery);
      if (imageFile != null) {
        return File(imageFile.path);
      } else {
        return null;
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<PlatformFile?> pickFile() async {
    try {
      final FilePickerResult? fileResult = await filePicker.pickFiles(
        allowedExtensions: ['pdf', 'docx', 'doc'],
        withData: true,
        type: FileType.custom,
      );
      if (fileResult != null) {
        //something was picked
        final PlatformFile pickedFile = fileResult.files.first;
        return pickedFile;
      } else {
        //user cancelled
        return null;
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<String?> uploadUserPfp(
      {required File file, required String currentUserId}) async {
    try {
      final String mainPath = "Users/$currentUserId";
      final String imageName = file.path.split('/').elementAt(7).trim();
      final Reference pfpRef = firebaseStorage.ref(mainPath).child(imageName);
      final UploadTask uploadTask = pfpRef.putFile(file);

      return uploadTask.then((task) async {
        if (task.state == TaskState.success) {
          return await pfpRef.getDownloadURL();
        } else {
          return null;
        }
      });
    } catch (e) {
      rethrow;
    }
  }

  Future<String?> uploadImageInChat({
    required String uid1,
    required String uid2,
    required File imageFile,
  }) {
    try {
      final String chatId = generateChatId(uid1: uid1, uid2: uid2);
      final String mainPath = "Chats/$chatId/Images";
      final String imageName = imageFile.path.split('/').elementAt(7).trim();
      final Reference imageRef = firebaseStorage.ref(mainPath).child(imageName);
      final UploadTask task = imageRef.putFile(imageFile);

      return task.then((value) async {
        if (value.state == TaskState.success) {
          return await imageRef.getDownloadURL();
        } else {
          return null;
        }
      });
    } catch (e) {
      rethrow;
    }
  }

  Future<String?> uploadFileInChat({
    required String uid1,
    required String uid2,
    required PlatformFile imageFile,
  }) {
    try {
      final String chatId = generateChatId(uid1: uid1, uid2: uid2);
      final String mainPath = "Chats/$chatId/Files";
      final Uint8List imageData = imageFile.bytes!;
      final Reference imageRef = firebaseStorage.ref(mainPath).child(imageFile.name);
      final UploadTask task = imageRef.putData(imageData);

      return task.then((value) async {
        if (value.state == TaskState.success) {
          return await imageRef.getDownloadURL();
        } else {
          return null;
        }
      });
    } catch (e) {
      rethrow;
    }
  }
}
