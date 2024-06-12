import 'dart:async';
import 'package:bus_travel/home_screen.dart';
import 'package:flutter/material.dart';


void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo', 
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: SplashScreen(), // Mengarahkan pertama kali ke SplashScreen
      debugShowCheckedModeBanner: false, // Menghilangkan debug banner
    );
  }
}

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 3), () {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
            builder: (_) => const MyHomePage(title: 'Tiket Bus & Shuttle')),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            // Ganti teks dengan gambar
            Image.asset(
              'assets/images/logo_bus.png', // Ganti dengan path gambar yang sesuai
              width: 250, // Sesuaikan lebar gambar
              height: 250, // Sesuaikan tinggi gambar
            ), // Spasi antara gambar dan teks
          ],
        ),
      ),
    );
  }
}
