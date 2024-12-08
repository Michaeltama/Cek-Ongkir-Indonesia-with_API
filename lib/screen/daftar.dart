import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HalamanRegister extends StatefulWidget {
  @override
  _HalamanRegisterState createState() => _HalamanRegisterState();
}

class _HalamanRegisterState extends State<HalamanRegister> {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  void register(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    await prefs.setString('username', usernameController.text);
    await prefs.setString('email', emailController.text);
    await prefs.setString('phone', phoneController.text);
    await prefs.setString('password', passwordController.text);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Pendaftaran Berhasil'),
          content:
              const Text('Akun Anda telah berhasil dibuat, silakan login.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                Navigator.pushReplacementNamed(context, '/login');
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF42A5F5), // Latar belakang biru
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Judul Aplikasi
            Padding(
              padding: const EdgeInsets.only(top: 80.0),
              child: Text(
                'Aplikasi Cek Ongkir',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  letterSpacing: 2.0,
                ),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'Buat akun baru untuk melanjutkan',
              style: TextStyle(
                fontSize: 18,
                color: Colors.white70,
              ),
            ),
            const SizedBox(height: 40),

            // Card Container for Registration Form
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Card(
                elevation: 10,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    children: [
                      // Username Field
                      _buildTextField(
                        controller: usernameController,
                        label: 'Username',
                        icon: Icons.person,
                      ),
                      const SizedBox(height: 20),

                      // Email Field
                      _buildTextField(
                        controller: emailController,
                        label: 'Email',
                        icon: Icons.email,
                      ),
                      const SizedBox(height: 20),

                      // Phone Field
                      _buildTextField(
                        controller: phoneController,
                        label: 'Nomor HP',
                        icon: Icons.phone,
                        keyboardType: TextInputType.phone,
                      ),
                      const SizedBox(height: 20),

                      // Password Field
                      _buildTextField(
                        controller: passwordController,
                        label: 'Password',
                        icon: Icons.lock,
                        obscureText: true,
                      ),
                      const SizedBox(height: 30),

                      // Register Button
                      ElevatedButton(
                        onPressed: () => register(context),
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                              vertical: 15, horizontal: 80),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          backgroundColor: const Color(0xFF42A5F5), // Biru
                        ),
                        child: const Text(
                          'Daftar',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),

                      // Already have account text
                      TextButton(
                        onPressed: () =>
                            Navigator.pushReplacementNamed(context, '/login'),
                        child: const Text(
                          'Sudah punya akun? Login di sini.',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Reusable TextField widget for both fields
  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
    bool obscureText = false,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: TextField(
        controller: controller,
        obscureText: obscureText,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          labelText: label,
          labelStyle: const TextStyle(color: Color(0xFF66BB6A)),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: const BorderSide(color: Color(0xFF42A5F5), width: 2),
          ),
          prefixIcon: Icon(icon, color: const Color(0xFF66BB6A)),
        ),
      ),
    );
  }
}
