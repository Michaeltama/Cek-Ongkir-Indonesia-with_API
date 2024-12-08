import '../screen/dashboard.dart';
import '../screen/kesanpesan.dart';
import '../screen/profile.dart';
import 'package:flutter/material.dart';

class GlobalNavigation extends StatefulWidget {
  @override
  _GlobalNavigationState createState() => _GlobalNavigationState();
}

class _GlobalNavigationState extends State<GlobalNavigation> {
  int _currentIndex = 0;

  // Daftar halaman untuk navigasi
  final List<Widget> _pages = [
    DashboardScreen(), // Halaman Dashboard
    UserProfileScreen(), // Halaman Profil
    KesanPesanScreen(), // Halaman Kesan & Pesan
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[
          _currentIndex], // Menampilkan halaman sesuai dengan index yang dipilih
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex, // Menandakan index halaman yang aktif
        onTap: (index) {
          setState(() {
            _currentIndex = index; // Pindah ke halaman yang sesuai
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_filled), // Ikon rumah untuk Dashboard
            label: 'Dashboard',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_circle), // Ikon profil untuk Profil
            label: 'Profil',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.chat_bubble), // Ikon obrolan untuk Kesan & Pesan
            label: 'Kesan & Pesan',
          ),
        ],
        selectedItemColor:
            Color(0xFF087F23), // Warna hijau untuk item yang dipilih
        unselectedItemColor:
            Color(0xFFBDBDBD), // Warna abu-abu untuk item yang tidak dipilih
        backgroundColor: Colors.white, // Warna latar belakang navbar
      ),
      appBar: AppBar(
        title: const Text('Ongkos Kirim Indonesia'),
        centerTitle: true,
        titleTextStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color(0xFF4CAF50),
                Color(0xFF087F23)
              ], // Warna hijau gradasi
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
      ),
      floatingActionButton: _currentIndex == 2
          ? FloatingActionButton(
              onPressed: () {
                // Logout dan kembali ke halaman login
                Navigator.pushReplacementNamed(context, '/login');
              },
              child: Icon(Icons.exit_to_app), // Ikon untuk logout
              backgroundColor:
                  Color(0xFFD32F2F), // Warna merah untuk tombol logout
            )
          : null,
    );
  }
}
