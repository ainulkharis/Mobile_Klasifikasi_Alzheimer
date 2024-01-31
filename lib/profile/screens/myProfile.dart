import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:e_alzaimer/helpers/database_profil.dart';

class myProfile extends StatefulWidget {
  @override
  _MyProfileState createState() => _MyProfileState();
}

class _MyProfileState extends State<myProfile> {
  final DatabaseHelper dbHelper = DatabaseHelper();
  String imageUrl = "assets/profil.jpeg";
  TextEditingController usernameController = TextEditingController();
  TextEditingController alamatController = TextEditingController();
  TextEditingController noHPController = TextEditingController();
  final picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _loadProfileData();
  }

  Future<void> _loadProfileData() async {
    Map<String, dynamic>? userProfile = await dbHelper.getUser();

    if (userProfile != null) {
      setState(() {
        usernameController.text = userProfile['username'] ?? '';
        alamatController.text = userProfile['alamat'] ?? '';
        noHPController.text = userProfile['noHP'] ?? '';
        imageUrl = userProfile['imageUrl'] ?? imageUrl;
      });
    }
  }

  Future<void> _getImageFromGallery() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        imageUrl = pickedFile.path;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Profile'),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () {
              _logout();
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            GestureDetector(
              onTap: () {
                _getImageFromGallery();
              },
              child: Center(
                child: Stack(
                  children: [
                    CircleAvatar(
                      backgroundImage: FileImage(File(imageUrl)),
                      radius: 100,
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.blue,
                        ),
                        child: Icon(
                          Icons.camera_alt,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 16),
            buildProfileCard('Nama Pengguna', usernameController.text),
            buildProfileCard('Alamat', alamatController.text),
            buildProfileCard('No HP', noHPController.text),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                _navigateToEditProfile(context);
              },
              child: Text('Edit Profil'),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildProfileCard(String title, String subtitle) {
    return Card(
      child: ListTile(
        title: Text(title),
        subtitle: Text(subtitle),
      ),
    );
  }

  Future<void> _navigateToEditProfile(BuildContext context) async {
    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Edit Profil'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: usernameController,
                decoration: InputDecoration(labelText: 'Nama Pengguna'),
              ),
              TextField(
                controller: alamatController,
                decoration: InputDecoration(labelText: 'Alamat'),
                keyboardType: TextInputType.multiline,
                maxLines: null,
              ),
              TextField(
                controller: noHPController,
                decoration: InputDecoration(labelText: 'No HP'),
                keyboardType: TextInputType.phone,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text('Batal'),
          ),
          ElevatedButton(
            onPressed: () async {
              await _handleEditProfile();
              Navigator.of(context).pop();
            },
            child: Text('Simpan'),
          ),
        ],
      ),
    );
  }

  Future<void> _handleEditProfile() async {
    Map<String, dynamic> updatedProfile = {
      'username': usernameController.text,
      'alamat': alamatController.text,
      'noHP': noHPController.text,
      'imageUrl': imageUrl,
    };

    int result = await dbHelper.updateUser(updatedProfile);

    if (result > 0) {
      await _loadProfileData();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Profil berhasil diperbarui!'),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Gagal memperbarui profil.'),
        ),
      );
    }
  }

  void _logout() {
    Navigator.pushReplacementNamed(context, '/login');
  }
}
