import '../screen/editprofile.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class UserProfileScreen extends StatefulWidget {
  @override
  _UserProfileScreenState createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {
  File? _image;
  String _username = "Nama Pengguna";
  String _email = "Email";
  String _phone = "Nomor HP";
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _loadProfileData();
  }

  Future<void> _loadProfileData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _username = prefs.getString('username') ?? "Nama Pengguna";
      _email = prefs.getString('email') ?? "Email";
      _phone = prefs.getString('phone') ?? "Nomor HP";
      String? imagePath = prefs.getString('profileImage');
      if (imagePath != null) {
        _image = File(imagePath);
      }
    });
  }

  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('profileImage', pickedFile.path);
    }
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 12.0),
      elevation: 5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: ListTile(
        leading: Icon(icon, color: const Color(0xFF00C853)), // Green color
        title: Text(
          label,
          style: const TextStyle(fontSize: 15, color: Colors.grey),
        ),
        subtitle: Text(
          value,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Profil Pengguna',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF4CAF50), Color(0xFF00C853)], // Green gradient
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Stack(
              alignment: Alignment.bottomRight,
              children: [
                CircleAvatar(
                  radius: 75,
                  backgroundColor: Colors.grey.shade200,
                  backgroundImage: _image != null
                      ? FileImage(_image!) as ImageProvider
                      : const AssetImage('assets/images/profile.jpg'),
                ),
                Positioned(
                  bottom: 5,
                  right: 5,
                  child: GestureDetector(
                    onTap: _pickImage,
                    child: Container(
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Color(0xFF4CAF50), // Green color
                      ),
                      padding: const EdgeInsets.all(8),
                      child: const Icon(
                        Icons.camera_alt,
                        size: 24,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 30),
            Text(
              _username,
              style: const TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 15),
            _buildInfoRow(Icons.phone, "Nomor HP", _phone),
            _buildInfoRow(Icons.email, "Email", _email),
            const SizedBox(height: 40),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () async {
                  bool? updated = await Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => EditProfileScreen()),
                  );

                  if (updated == true) {
                    _loadProfileData(); // Perbarui data jika ada perubahan
                  }
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 18),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  backgroundColor: const Color(0xFF00C853), // Green button
                ),
                icon: const Icon(Icons.edit, color: Colors.white),
                label: const Text(
                  'Edit Profil',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
