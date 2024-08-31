import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

class UserProfileService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  Future<void> updateUserProfile(String name, String profilePictureUrl) async {
    final user = _auth.currentUser;
    if (user == null) {
      throw Exception('No user is currently signed in');
    }

    await _firestore.collection('users').doc(user.uid).set({
      'name': name,
      'profilePicture': profilePictureUrl,
    }, SetOptions(merge: true));
  }

  Future<Map<String, dynamic>?> getUserProfile() async {
    final user = _auth.currentUser;
    if (user == null) {
      return null;
    }

    final doc = await _firestore.collection('users').doc(user.uid).get();
    return doc.data();
  }

  Future<String?> uploadProfilePicture(File imageFile) async {
    try {
      final user = _auth.currentUser;
      if (user == null) {
        throw Exception('No user is currently signed in');
      }

      final storageRef =
          _storage.ref().child('profile_pictures/${user.uid}.jpg');
      await storageRef.putFile(imageFile);

      // Get the download URL for the uploaded image
      return await storageRef.getDownloadURL();
    } catch (e) {
      print('Error uploading profile picture: $e');
      return null;
    }
  }
}
