import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

class AvatarUploadService {
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final ImagePicker _picker = ImagePicker();

  // The method now handles multiple images
  Future<void> pickAndUploadAvatars() async {
    try {
      // 1. Pick multiple images from the device gallery
      final List<XFile> imageFiles = await _picker.pickMultiImage();

      if (imageFiles.isEmpty) {
        print("No images selected.");
        return; // User canceled or selected no files
      }

      print("Uploading ${imageFiles.length} image(s)...");

      // 2. Create a list of all the upload tasks
      final List<Future<void>> uploadTasks = [];

      for (final imageFile in imageFiles) {
        // We add each upload process to our list of Futures
        uploadTasks.add(_uploadSingleAvatar(imageFile));
      }

      // 3. Run all upload tasks in parallel
      await Future.wait(uploadTasks);

      print("Successfully uploaded all avatars!");
    } catch (e) {
      print("An error occurred during multi-upload: $e");
      throw e;
    }
  }

  // Helper method to handle the logic for a single file
  Future<void> _uploadSingleAvatar(XFile imageFile) async {
    String fileName = imageFile.name;
    String destination = 'profile_avatars/$fileName';

    final ref = _storage.ref(destination);

    // Platform-specific upload
    if (kIsWeb) {
      await ref.putData(await imageFile.readAsBytes());
    } else {
      await ref.putFile(File(imageFile.path));
    }

    String downloadUrl = await ref.getDownloadURL();
    final doc = _firestore.collection('avatars').doc();
    final uid = doc.id;
    await doc.set({
      'uid': uid,
      'name': fileName,
      'imageUrl': downloadUrl,
      'createdAt': FieldValue.serverTimestamp(),
    });
    // Add the URL to the 'avatars' collection in Firestore

    print("-> Completed: $fileName");
  }
}

class ImagePic extends StatefulWidget {
  const ImagePic({super.key});

  @override
  State<ImagePic> createState() => _ImagePicState();
}

class _ImagePicState extends State<ImagePic> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            try {
              AvatarUploadService().pickAndUploadAvatars();
            } catch (e) {
              print('error');
            }
          },
          child: Text('upload', style: TextStyle(color: Colors.black)),
        ),
      ),
    );
  }
}
