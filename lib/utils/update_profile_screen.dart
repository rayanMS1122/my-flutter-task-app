import 'dart:io';
import 'package:serenity_tasks/utils/user_profile_service.dart';
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
  File? _selectedImage;
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

  Future<void> _pickImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Kein Bild ausgewählt.'),
        ),
      );
    }
  }

  Future<void> _updateProfile() async {
    String? profilePictureUrl = _profilePictureController.text;

    if (_selectedImage != null) {
      profilePictureUrl =
          await UserProfileService().uploadProfilePicture(_selectedImage!);
    }

    await UserProfileService()
        .updateUserProfile(_nameController.text, profilePictureUrl ?? '');
    ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Profil erfolgreich aktualisiert')));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Profil aktualisieren')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: 'Name'),
            ),
            TextField(
              controller: _profilePictureController,
              decoration: const InputDecoration(labelText: 'Profilbild-URL'),
              readOnly: true,
            ),
            const SizedBox(height: 20),
            _selectedImage != null
                ? Image.file(_selectedImage!, height: 100)
                : Container(),
            ElevatedButton(
              onPressed: _pickImage,
              child: const Text('Profilbild auswählen'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _updateProfile,
              child: const Text('Profil aktualisieren'),
            ),
          ],
        ),
      ),
    );
  }
}
