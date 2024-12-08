import 'package:CekOngkirIndonesia/screen/data.dart';
import 'package:flutter/material.dart';
import 'konversi_uang.dart'; // Import file Konversi Mata Uang
import 'konversi_waktu.dart'; // Import file Konversi Waktu
import 'cek_ongkir.dart'; // Import file Cek Ongkir

class DashboardScreen extends StatelessWidget {
  // Fungsi untuk membangun tombol menu utama
  Widget _buildMenuButton(
    BuildContext context,
    IconData icon,
    String label,
    Widget targetScreen,
  ) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => targetScreen),
        );
      },
      child: Card(
        elevation: 6,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        color: Colors.white, // Kartu menu berwarna putih
        child: Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 60,
                color: Colors.teal, // Menggunakan teal untuk ikon
              ),
              const SizedBox(height: 10),
              Text(
                label,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.teal, // Warna teks yang sama dengan ikon
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Selamat Datang di Aplikasi!',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color(0xFF81C784),
                Color(0xFF66BB6A)
              ], // Gradasi hijau muda dan hijau
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Menu Utama:',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Color(0xFF66BB6A), // Warna hijau senada dengan app bar
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 20,
                mainAxisSpacing: 20,
                children: [
                  _buildMenuButton(
                    context,
                    Icons.timer, // Menggunakan ikon timer untuk Konversi Waktu
                    'Konversi Waktu',
                    TimezoneScreen(), // Ganti dengan layar Konversi Waktu
                  ),
                  _buildMenuButton(
                    context,
                    Icons.currency_exchange, // Menggunakan ikon untuk mata uang
                    'Konversi Mata Uang',
                    KonversiUangScreen(), // Ganti dengan layar Konversi Mata Uang
                  ),
                  _buildMenuButton(
                    context,
                    Icons
                        .local_shipping_outlined, // Menggunakan ikon truk untuk Cek Ongkir
                    'Cek Ongkir',
                    CekOngkirScreen(), // Ganti dengan layar Cek Ongkir
                  ),
                   _buildMenuButton(
                    context,
                    Icons
                        .local_shipping_outlined, // Menggunakan ikon truk untuk Cek Ongkir
                    'Lacak',
                    TrackingScreen(), // Ganti dengan layar Cek Ongkir
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      // Hapus bagian ini untuk menghilangkan tombol floating action button
    );
  }
}
