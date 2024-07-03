import 'package:flutter/material.dart';
import 'package:agen_toko/models/penjualan_api.dart';
import 'package:intl/intl.dart';

class PenjualanDetailPage extends StatelessWidget {
  final int id;

  const PenjualanDetailPage({super.key, required this.id});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Detail Penjualan'),
      ),
      body: FutureBuilder<Penjualan>(
        future: PenjualanApi().fetchPenjualanDetail(id),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            Penjualan penjualan = snapshot.data!;
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('ID: ${penjualan.id}'),
                  Text('ID Nota: ${penjualan.id_nota}'),
                  Text('Tanggal: ${DateFormat.yMMMd().format(penjualan.tanggal)}'),
                  Text('ID Pelanggan: ${penjualan.id_pelanggan}'),
                  Text('Subtotal: ${penjualan.sub_total.toInt()}'),
                ],
              ),
            );
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          return Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}
