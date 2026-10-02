import 'package:flutter/material.dart';

import 'profile_card.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    const String nim = '20240801026';

    // Mengambil digit terakhir NIM
    final int digitTerakhir = int.parse(nim.substring(nim.length - 1));

    // Mengambil 2 digit terakhir NIM
    final int duaDigitTerakhir = int.parse(nim.substring(nim.length - 2));

    // Skor aktivitas = 2 digit terakhir + 50
    final int skorAktivitas = duaDigitTerakhir + 50;

    // Menentukan warna berdasarkan digit terakhir
    final Color warnaBackground;

    if (digitTerakhir % 2 == 1) {
      // Ganjil
      warnaBackground = Colors.tealAccent[100]!;
    } else {
      // Genap
      warnaBackground = Colors.amber[100]!;
    }

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Tugas Layout Flutter',

      theme: ThemeData(scaffoldBackgroundColor: warnaBackground),

      home: HomePage(nim: nim, skorAktivitas: skorAktivitas),
    );
  }
}

class HomePage extends StatelessWidget {
  final String nim;
  final int skorAktivitas;

  const HomePage({super.key, required this.nim, required this.skorAktivitas});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tugas Layout Flutter'),
        centerTitle: true,
      ),

      body: Center(
        child: ProfileCard(
          nama: 'David',
          nim: nim,
          hobi: 'Bermain Game',
          skorAktivitas: skorAktivitas,
        ),
      ),
    );
  }
}
