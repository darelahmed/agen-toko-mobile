import 'package:flutter/material.dart';
import 'package:agen_toko/models/barang_api.dart';

class BarangDetailPage extends StatelessWidget {
  final int id;

  const BarangDetailPage({super.key, required this.id});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Detail Barang'),
      ),
      body: FutureBuilder<Barang>(
        future: BarangApi().fetchBarangDetail(id),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          } else if (snapshot.hasData) {
            Barang barang = snapshot.data!;
            return Padding(
              padding: EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Nama: ${barang.nama}', style: TextStyle(fontSize: 18)),
                  SizedBox(height: 8),
                  Text('Kategori: ${barang.kategori}',
                      style: TextStyle(fontSize: 18)),
                  SizedBox(height: 8),
                  Text('Harga: Rp ${barang.harga}',
                      style: TextStyle(fontSize: 18)),
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
