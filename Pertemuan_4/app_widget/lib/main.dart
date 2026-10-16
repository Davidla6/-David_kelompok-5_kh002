import 'package:flutter/material.dart';

import 'theme/app_theme.dart';
import 'widgets/app_button.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      home: const ProfilePage(),
    );
  }
}

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Personal Profile Card')),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
            ),
            child: Padding(
              padding: const EdgeInsets.all(22),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const CircleAvatar(
                    radius: 26,
                    child: Icon(Icons.person, size: 32),
                  ),
                  const SizedBox(height: 16),
                  const Text('David lai'),
                  const SizedBox(height: 14),
                  const Text('20240801026'),
                  const SizedBox(height: 8),
                  const Text('Teknik informatika'),
                  const SizedBox(height: 8),
                  const Text(
                    'Mahasiswa teknik informatika, '
                    'yang masuk pada tahun 2024',
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 20),
                  const AppButton(
                    label: 'Kunjungi GitHub Saya',
                    icon: Icons.open_in_new,
                    url: 'https://github.com/Davidla6',
                    height: 46,
                    borderRadius: 10,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
