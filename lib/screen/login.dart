import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HalamanLogin extends StatelessWidget {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  void login(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    String? storedUsername = prefs.getString('username');
    String? storedPassword = prefs.getString('password');

    String inputUsername = usernameController.text;
    String inputPassword = passwordController.text;

    if (inputUsername == storedUsername && inputPassword == storedPassword) {
      Navigator.pushReplacementNamed(context, '/home');
    } else {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Login Gagal'),
            content: const Text('Username atau password salah.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('OK'),
              ),
            ],
          );
        },
      );
    }
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
              'Masuk untuk melanjutkan',
              style: TextStyle(
                fontSize: 18,
                color: Colors.white70,
              ),
            ),
            const SizedBox(height: 40),

            // Card Container for Login Form
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
                      TextField(
                        controller: usernameController,
                        decoration: InputDecoration(
                          labelText: 'Username',
                          labelStyle: const TextStyle(
                              color: Color(0xFF66BB6A)), // Hijau
                          prefixIcon: const Icon(Icons.person,
                              color: Color(0xFF66BB6A)),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),

                      // Password Field
                      TextField(
                        controller: passwordController,
                        obscureText: true,
                        decoration: InputDecoration(
                          labelText: 'Password',
                          labelStyle: const TextStyle(
                              color: Color(0xFF66BB6A)), // Hijau
                          prefixIcon:
                              const Icon(Icons.lock, color: Color(0xFF66BB6A)),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                        ),
                      ),
                      const SizedBox(height: 30),

                      // Login Button
                      ElevatedButton(
                        onPressed: () => login(context),
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                              vertical: 15, horizontal: 80),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          backgroundColor: const Color(0xFF42A5F5), // Biru
                          elevation: 5,
                        ),
                        child: const Text(
                          'Login',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Daftar Button
            TextButton(
              onPressed: () => Navigator.pushNamed(context, '/register'),
              child: const Text(
                'Belum punya akun? Daftar di sini.',
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
    );
  }
}
