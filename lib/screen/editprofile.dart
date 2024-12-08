import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EditProfileScreen extends StatefulWidget {
  @override
  _EditProfileScreenState createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadProfileData();
  }

  Future<void> _loadProfileData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _nameController.text = prefs.getString('username') ?? "Nama Pengguna";
      _phoneController.text = prefs.getString('phone') ?? "Nomor HP";
      _emailController.text = prefs.getString('email') ?? "Email";
    });
  }

  Future<void> _saveProfileData() async {
    if (_formKey.currentState!.validate()) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('username', _nameController.text);
      await prefs.setString('phone', _phoneController.text);
      await prefs.setString('email', _emailController.text);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Profil berhasil disimpan'),
          backgroundColor: Colors.green,
        ),
      );

      Navigator.pop(context, true); // Kembali ke profile
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Profil'),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF4CAF50), Color(0xFF00C853)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              const SizedBox(height: 20),
              _buildTextField(
                controller: _nameController,
                label: "Nama Lengkap",
                icon: Icons.person,
                validator: (value) =>
                    value!.isEmpty ? "Nama tidak boleh kosong" : null,
              ),
              const SizedBox(height: 20),
              _buildTextField(
                controller: _phoneController,
                label: "Nomor HP",
                icon: Icons.phone,
                validator: (value) {
                  if (value!.isEmpty) return "Nomor HP tidak boleh kosong";
                  if (value.length < 10) return "Nomor HP terlalu pendek";
                  return null;
                },
              ),
              const SizedBox(height: 20),
              _buildTextField(
                controller: _emailController,
                label: "Email",
                icon: Icons.email,
                validator: (value) {
                  if (value!.isEmpty) return "Email tidak boleh kosong";
                  if (!RegExp(
                          r"^[a-zA-Z0-9._%-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,4}$")
                      .hasMatch(value)) return "Email tidak valid";
                  return null;
                },
              ),
              const SizedBox(height: 30),
              ElevatedButton(
                onPressed: _saveProfileData,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  backgroundColor: const Color(0xFF00C853),
                ),
                child: const Text(
                  'Simpan',
                  style: TextStyle(fontSize: 18, color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    required String? Function(String?) validator,
  }) {
    return Row(
      children: [
        Icon(icon, color: const Color(0xFF4CAF50)),
        const SizedBox(width: 10),
        Expanded(
          child: TextFormField(
            controller: controller,
            decoration: InputDecoration(
              hintText: label,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            validator: validator,
          ),
        ),
      ],
    );
  }
}
