import 'package:flutter/material.dart';
import 'package:agen_toko/models/itempenjualan_api.dart';
import 'package:agen_toko/models/barang_api.dart';

class ItemPenjualanDetailPage extends StatefulWidget {
  final int id;
  const ItemPenjualanDetailPage({Key? key, required this.id}) : super(key: key);

  @override
  _ItemPenjualanDetailPageState createState() =>
      _ItemPenjualanDetailPageState();
}

class _ItemPenjualanDetailPageState extends State<ItemPenjualanDetailPage> {
  late Future<ItemPenjualan> futureItemPenjualan;
  late Future<List<Barang>> futureBarang;
  List<Barang> barangList = [];

  @override
  void initState() {
    super.initState();
    futureItemPenjualan =
        ItemPenjualanApi().fetchItemPenjualanDetail(widget.id);
    futureBarang = BarangApi().fetchBarang();
    fetchBarangList();
  }

  Future<void> fetchBarangList() async {
    try {
      List<Barang> fetchedBarangList = await futureBarang;
      setState(() {
        barangList = fetchedBarangList;
      });
    } catch (e) {
      print('Error fetching barang list: $e');
    }
  }

  String getNamaBarang(int idBarang) {
    try {
      return barangList.firstWhere((barang) => barang.id == idBarang).nama;
    } catch (e) {
      return 'Unknown';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Detail Item Penjualan'),
      ),
      body: FutureBuilder<ItemPenjualan>(
        future: futureItemPenjualan,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          } else if (snapshot.hasData) {
            ItemPenjualan itemPenjualan = snapshot.data!;
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Id: ${itemPenjualan.id}'),
                  Text('Id Barang: ${itemPenjualan.id_barang}'),
                  FutureBuilder<List<Barang>>(
                    future: futureBarang,
                    builder: (context, barangSnapshot) {
                      if (barangSnapshot.connectionState ==
                          ConnectionState.waiting) {
                        return Center(child: CircularProgressIndicator());
                      } else if (barangSnapshot.hasError) {
                        return Text('Error: ${barangSnapshot.error}');
                      } else if (barangSnapshot.hasData) {
                        String namaBarang =
                            getNamaBarang(itemPenjualan.id_barang);
                        return Text('Nama Barang: $namaBarang');
                      } else {
                        return Text('Nama Barang: Loading...');
                      }
                    },
                  ),
                  Text('Quantity: ${itemPenjualan.qty}'),
                ],
              ),
            );
          } else {
            return Center(child: Text("Tidak ada data"));
          }
        },
      ),
    );
  }
}
