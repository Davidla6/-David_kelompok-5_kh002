import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class StokBarangPage extends StatefulWidget {
  const StokBarangPage({super.key});

  @override
  State<StokBarangPage> createState() => _StokBarangPageState();
}

class _StokBarangPageState extends State<StokBarangPage> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _namaController = TextEditingController();

  final TextEditingController _kodeController = TextEditingController();

  final TextEditingController _stokController = TextEditingController();

  bool _isLoading = false;

  Future<void> simpanBarang() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final String namaBarang = _namaController.text.trim();
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
        'kode_barang': kodeBarang,
        'jumlah_stok': jumlahStok,
        'waktu': FieldValue.serverTimestamp(),
      });

      if (!mounted) return;

      _namaController.clear();
      _kodeController.clear();
      _stokController.clear();

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Barang berhasil disimpan!'),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Gagal menyimpan barang: $e'),
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

              TextFormField(
                controller: _namaController,
                decoration: const InputDecoration(
                  labelText: 'Nama Barang',
                  hintText: 'Contoh: Buku Tulis',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.inventory_2),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Nama barang wajib diisi';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 16),

              TextFormField(
                controller: _kodeController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Kode Barang',
                  hintText: 'Contoh: 1001',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.qr_code),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Kode barang wajib diisi';
                  }

                  if (int.tryParse(value.trim()) == null) {
                    return 'Kode harus berupa bilangan bulat';
                  }

                  return null;
                },
              ),

              const SizedBox(height: 16),

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
                onPressed: _isLoading ? null : simpanBarang,
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
