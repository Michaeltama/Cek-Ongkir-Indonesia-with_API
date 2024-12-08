import 'package:flutter/material.dart';
import '../screen/splash.dart'; // Halaman Splash
import '../screen/login.dart'; // Halaman Login
import '../screen/daftar.dart'; // Halaman Daftar
import '../globalnavigation.dart'; // Import GlobalNavigation

void main() {
  runApp(CekOngkirApp());
}

class CekOngkirApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Cek Ongkir Idonesia',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/', // Splash sebagai halaman awal
      routes: {
        '/': (context) => SplashScreen(), // Splash Screen
        '/login': (context) => HalamanLogin(), // Login Screen
        '/register': (context) => HalamanRegister(), // Register Screen
        '/home': (context) =>
            GlobalNavigation(), // Global Navigation setelah login atau register
      },
    );
  }
}
