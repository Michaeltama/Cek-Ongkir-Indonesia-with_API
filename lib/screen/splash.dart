import 'dart:async';
import 'package:flutter/material.dart';
import 'login.dart'; // Ganti dengan file halaman login Anda.

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 3), () {
      // Navigasi ke halaman login setelah 3 detik
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HalamanLogin()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFF42A5F5),
              Color(0xFF66BB6A)
            ], // Gradien biru dan hijau
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Nama aplikasi
              const Text(
                'Aplikasi Cek Ongkir',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 10),
              // Subjudul
              const Text(
                'Membantu pengecekan ongkos kirim paket Anda',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.white70,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 40),
              // Animasi loading
              const CircularProgressIndicator(
                color: Colors.white,
                strokeWidth: 3,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
