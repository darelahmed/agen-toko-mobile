import 'package:flutter/material.dart';
import 'package:agen_toko/models/pelanggan_api.dart';

class CustomerDetailPage extends StatelessWidget {
  final int id;

  const CustomerDetailPage({super.key, required this.id});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Detail Pelanggan'),
      ),
      body: FutureBuilder<Pelanggan>(
        future: PelangganApi().fetchPelangganDetail(id),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          } else if (snapshot.hasData) {
            Pelanggan pelanggan = snapshot.data!;
            return Padding(
              padding: EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Nama: ${pelanggan.nama}', style: TextStyle(fontSize: 18)),
                  SizedBox(height: 8),
                  Text('Domisili: ${pelanggan.domisili}', style: TextStyle(fontSize: 18)),
                  SizedBox(height: 8),
                  Text('Jenis Kelamin: ${pelanggan.jenisKelamin}', style: TextStyle(fontSize: 18)),
                ],
              ),
            );
          }
          return Center(child: Text("Tidak ada data"));
        },
      ),
    );
  }
}
