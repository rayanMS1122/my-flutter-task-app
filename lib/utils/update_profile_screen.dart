import 'dart:io';
import 'package:example3/utils/user_profile_service.dart';
import 'package:file_selector/file_selector.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class UpdateProfileScreen extends StatefulWidget {
  @override
  _UpdateProfileScreenState createState() => _UpdateProfileScreenState();
}

class _UpdateProfileScreenState extends State<UpdateProfileScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _profilePictureController =
      TextEditingController();
  File? _selectedImage; // File object to hold the selected image
  final picker = ImagePicker();
  @override
  void initState() {
    super.initState();
    _loadUserProfile();
  }

  void _loadUserProfile() async {
    final profile = await UserProfileService().getUserProfile();
    if (profile != null) {
      setState(() {
        _nameController.text = profile['name'] ?? '';
        _profilePictureController.text = profile['profilePicture'] ?? '';
      });
    }
  }

  // Future<void> openFile({required List<XTypeGroup> acceptedTypeGroups}) async {
  //   final XFile? file = await openFile(
  //     acceptedTypeGroups: [
  //       const XTypeGroup(label: 'images', extensions: ['jpg', 'png'])
  //     ],
  //   );
  //   if (file != null) {
  //     // Handle the selected file
  //     print('File selected: ${file.path}');
  //   } else {
  //     print('No file selected.');
  //   }
  // }

  Future<void> _pickImage() async {
    if (Platform.isWindows) {
      // Use the file picker for Windows
      final picker = ImagePicker();
      final pickedFile = await picker.pickImage(source: ImageSource.gallery);

      if (pickedFile != null) {
        setState(() {
          _selectedImage = File(pickedFile.path);
        });
      }
    } else {
      // Show an error or use a different method for other platforms
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('This feature is not supported on this platform.'),
        ),
      );
    }
  }

  Future<void> _updateProfile() async {
    String? profilePictureUrl = _profilePictureController.text;

    if (_selectedImage != null) {
      // Upload the image to Firebase Storage and get the URL
      profilePictureUrl =
          await UserProfileService().uploadProfilePicture(_selectedImage!);
    }

    await UserProfileService()
        .updateUserProfile(_nameController.text, profilePictureUrl ?? '');
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text('Profile updated successfully')));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Update Profile')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _nameController,
              decoration: InputDecoration(labelText: 'Name'),
            ),
            TextField(
              controller: _profilePictureController,
              decoration: InputDecoration(labelText: 'Profile Picture URL'),
              readOnly: true,
            ),
            const SizedBox(height: 20),
            _selectedImage != null
                ? Image.file(_selectedImage!,
                    height: 100) // Display selected image
                : Container(),
            ElevatedButton(
              onPressed: _pickImage,
              child: Text('Choose Profile Picture'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _updateProfile,
              child: Text('Update Profile'),
            ),
          ],
        ),
      ),
    );
  }
}
