import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _namaController = TextEditingController();

  final TextEditingController _tanggalMasukController = TextEditingController();

  final TextEditingController _tanggalKeluarController =
      TextEditingController();

  final TextEditingController _kodeController = TextEditingController();

  final TextEditingController _stokController = TextEditingController();

  bool _isLoading = false;

  // Ganti sesuai inisial nama depan dan dua digit terakhir NIM.
  static const String inisialNama = 'D';
  static const String duaDigitTerakhirNim = '26';

  Future<void> simpanData() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final String namaBarang = _namaController.text.trim();
    final String tanggalMasuk = _tanggalMasukController.text.trim();
    final String tanggalKeluar = _tanggalKeluarController.text.trim();

    final int? kodeBarang = int.tryParse(_kodeController.text.trim());

    final int? jumlahStok = int.tryParse(_stokController.text.trim());

    if (kodeBarang == null || jumlahStok == null) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      await FirebaseFirestore.instance.collection('stok_barang').add({
        'nama_barang': namaBarang,
        'tanggal_masuk': tanggalMasuk,
        'tanggal_keluar': tanggalKeluar,
        'kode_barang': kodeBarang,
        'jumlah_stok': jumlahStok,
        'waktu': FieldValue.serverTimestamp(),
      });

      if (!mounted) return;

      _namaController.clear();
      _tanggalMasukController.clear();
      _tanggalKeluarController.clear();
      _kodeController.clear();
      _stokController.clear();

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Data barang berhasil disimpan!'),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Gagal menyimpan data: $e'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  void dispose() {
    _namaController.dispose();
    _tanggalMasukController.dispose();
    _tanggalKeluarController.dispose();
    _kodeController.dispose();
    _stokController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pencatatan Stok Barang'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                'Form Input Barang',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),

              const SizedBox(height: 20),

              // 1. Nama Barang: inisial nama depan mahasiswa
              TextFormField(
                controller: _namaController,
                decoration: const InputDecoration(
                  labelText: 'Nama Barang',
                  hintText: 'Masukkan inisial nama depan',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.inventory_2),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Inisial nama wajib diisi';
                  }

                  if (value.trim().toUpperCase() != inisialNama) {
                    return 'Gunakan inisial $inisialNama';
                  }

                  return null;
                },
              ),

              const SizedBox(height: 16),

              // 2. Tanggal Masuk Barang
              TextFormField(
                controller: _tanggalMasukController,
                keyboardType: TextInputType.datetime,
                decoration: const InputDecoration(
                  labelText: 'Tanggal Masuk Barang',
                  hintText: 'Contoh: 16-10-2026',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.calendar_today),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Tanggal masuk wajib diisi';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 16),

              // 3. Tanggal Keluar Barang
              TextFormField(
                controller: _tanggalKeluarController,
                keyboardType: TextInputType.datetime,
                decoration: const InputDecoration(
                  labelText: 'Tanggal Keluar Barang',
                  hintText: 'Contoh: 17-10-2026',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.event),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Tanggal keluar wajib diisi';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 16),

              // 4. Kode Barang: minimal 6 angka,
              // dua angka terakhir harus sesuai NIM
              TextFormField(
                controller: _kodeController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Kode Barang',
                  hintText: 'Minimal 6 angka, berakhir 26',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.qr_code),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Kode barang wajib diisi';
                  }

                  final String kode = value.trim();

                  if (!RegExp(r'^[0-9]+$').hasMatch(kode)) {
                    return 'Kode barang hanya boleh berisi angka';
                  }

                  if (kode.length < 6) {
                    return 'Kode barang minimal 6 angka';
                  }

                  if (!kode.endsWith(duaDigitTerakhirNim)) {
                    return 'Dua angka terakhir harus $duaDigitTerakhirNim';
                  }

                  if (int.tryParse(kode) == null) {
                    return 'Kode barang tidak valid';
                  }

                  return null;
                },
              ),

              const SizedBox(height: 16),

              // 5. Jumlah Stok: integer nonnegatif
              TextFormField(
                controller: _stokController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Jumlah Stok',
                  hintText: 'Contoh: 25',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.numbers),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Jumlah stok wajib diisi';
                  }

                  final int? stok = int.tryParse(value.trim());

                  if (stok == null) {
                    return 'Stok harus berupa bilangan bulat';
                  }

                  if (stok < 0) {
                    return 'Stok tidak boleh negatif';
                  }

                  return null;
                },
              ),

              const SizedBox(height: 24),

              ElevatedButton(
                onPressed: _isLoading ? null : simpanData,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: _isLoading
                    ? const SizedBox(
                        height: 22,
                        width: 22,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2,
                        ),
                      )
                    : const Text('Simpan Barang'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
