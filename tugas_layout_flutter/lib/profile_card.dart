import 'package:flutter/material.dart';

class ProfileCard extends StatelessWidget {
  final String nama;
  final String nim;
  final String hobi;
  final int skorAktivitas;

  const ProfileCard({
    super.key,
    required this.nama,
    required this.nim,
    required this.hobi,
    required this.skorAktivitas,
  });

  @override
  Widget build(BuildContext context) {
    // Mengambil digit terakhir NIM
    final int digitTerakhir = int.parse(nim.substring(nim.length - 1));

    // Mengambil digit kedua dari belakang NIM
    final int digitKeduaTerakhir = int.parse(
      nim.substring(nim.length - 2, nim.length - 1),
    );

    // ==============================
    // RUMUS STYLING BERDASARKAN NIM
    // ==============================

    // Lebar kartu
    final double lebarKartu = 320.0 + (digitKeduaTerakhir * 5);

    // Sudut melengkung
    final double radiusKartu = 12.0 + (digitTerakhir * 1.5);

    // Ukuran logo
    final double ukuranLogo = 60.0 + (digitTerakhir * 2);

    // Jarak logo dengan teks
    final double jarakPemisah = 15.0 + digitTerakhir;

    return Container(
      width: lebarKartu,
      padding: const EdgeInsets.all(20.0),

      decoration: BoxDecoration(
        color: Colors.white,

        borderRadius: BorderRadius.circular(radiusKartu),

        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.3), blurRadius: 10.0),
        ],
      ),

      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // ==============================
          // HEADER
          // ==============================

          Row(
            children: [
              // Logo Flutter
              Container(
                padding: const EdgeInsets.all(8.0),

                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(radiusKartu),

                  border: Border.all(color: Colors.blue, width: 2.0),
                ),

                child: FlutterLogo(size: ukuranLogo),
              ),

              // Jarak antara logo dan teks
              SizedBox(width: jarakPemisah),

              // Judul dan nama
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,

                  children: [
                    const Text(
                      'Kartu Praktikan',
                      style: TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 5.0),

                    Text(
                      nama,
                      style: const TextStyle(
                        fontSize: 16.0,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          // ==============================
          // PEMISAH
          // ==============================
          const Divider(thickness: 1.5),

          const SizedBox(height: 10.0),

          // ==============================
          // DETAIL IDENTITAS
          // ==============================
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,

            children: [
              Text(
                'NIM: $nim',
                style: const TextStyle(
                  fontSize: 16.0,
                  fontWeight: FontWeight.w600,
                ),
              ),

              const SizedBox(height: 8.0),

              Text(
                'Hobi: $hobi',
                style: const TextStyle(
                  fontSize: 16.0,
                  fontWeight: FontWeight.w600,
                ),
              ),

              const SizedBox(height: 8.0),

              Text(
                'Skor Aktivitas: $skorAktivitas',
                style: const TextStyle(
                  fontSize: 16.0,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
