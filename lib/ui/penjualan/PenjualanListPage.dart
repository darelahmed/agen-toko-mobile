import 'package:flutter/material.dart';
import 'package:agen_toko/models/penjualan_api.dart';
import 'package:agen_toko/models/pelanggan_api.dart';
import 'package:agen_toko/ui/penjualan/AddPenjualanPage.dart';
import 'package:agen_toko/ui/penjualan/EditPenjualanPage.dart';
import 'package:agen_toko/ui/penjualan/PenjualanDetailPage.dart';
import 'package:intl/intl.dart';

class PenjualanListPage extends StatefulWidget {
  const PenjualanListPage({super.key});

  @override
  State<PenjualanListPage> createState() => _PenjualanListPageState();
}

class _PenjualanListPageState extends State<PenjualanListPage> {
  late Future<List<Penjualan>> futurePenjualan;
  late Future<List<Pelanggan>> futurePelanggan;
  List<Pelanggan> pelangganList = [];

  @override
  void initState() {
    super.initState();
    futurePenjualan = PenjualanApi().fetchPenjualan();
    futurePelanggan = PelangganApi().fetchPelanggan();
    fetchPelangganList();
  }

  Future<void> fetchPelangganList() async {
    try {
      List<Pelanggan> fetchedPelangganList = await futurePelanggan;
      setState(() {
        pelangganList = fetchedPelangganList;
      });
    } catch (e) {
      print('Error fetching pelanggan list: $e');
    }
  }

  String getNamaPelanggan(int idPelanggan) {
    try {
      return pelangganList
          .firstWhere((pelanggan) => pelanggan.id == idPelanggan)
          .nama;
    } catch (e) {
      return 'Unknown';
    }
  }

  Future<void> _deletePenjualan(int id) async {
    try {
      await PenjualanApi().deletePenjualan(id);
      setState(() {
        futurePenjualan = PenjualanApi().fetchPenjualan();
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to delete penjualan: $e')),
      );
    }
  }

  Future<void> _refreshData() async {
    setState(() {
      futurePenjualan = PenjualanApi().fetchPenjualan();
      futurePelanggan = PelangganApi().fetchPelanggan();
      fetchPelangganList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Daftar Penjualan'),
      ),
      body: Center(
        child: FutureBuilder<List<Penjualan>>(
          future: futurePenjualan,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              List<Penjualan> data = snapshot.data!;
              return ListView.builder(
                itemCount: data.length,
                itemBuilder: (context, index) {
                  return Card(
                    child: ListTile(
                      subtitle: Row(
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('ID Nota: ${data[index].id_nota}'),
                              Text('Tanggal: ${DateFormat.yMMMd().format(data[index].tanggal)}'),
                              Text('Pelanggan: ${getNamaPelanggan(data[index].id_pelanggan)}'),
                              Text('Subtotal: ${data[index].sub_total.toInt()}'),
                            ],
                          ),
                          Spacer(),
                          Padding(
                            padding: const EdgeInsets.only(right: 10.0),
                            child: Column(
                              children: [
                                IconButton(
                                  icon: Icon(Icons.edit),
                                  onPressed: () async {
                                    bool? result = await Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            EditPenjualanPage(
                                                id: data[index].id),
                                      ),
                                    );
                                    if (result == true) {
                                      _refreshData();
                                    }
                                  },
                                ),
                                IconButton(
                                  icon: Icon(Icons.delete),
                                  onPressed: () {
                                    showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return AlertDialog(
                                          title: Text('Konfirmasi'),
                                          content: Text(
                                              'Apakah Anda yakin ingin menghapus item penjualan ini?'),
                                          actions: <Widget>[
                                            TextButton(
                                              onPressed: () {
                                                Navigator.of(context).pop();
                                              },
                                              child: Text('Batal'),
                                            ),
                                            TextButton(
                                              onPressed: () {
                                                _deletePenjualan(
                                                    data[index].id);
                                                Navigator.of(context).pop();
                                              },
                                              child: Text('Hapus'),
                                            ),
                                          ],
                                        );
                                      },
                                    );
                                  },
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                PenjualanDetailPage(id: data[index].id),
                          ),
                        );
                      },
                    ),
                  );
                },
              );
            } else if (snapshot.hasError) {
              return Text("Error: ${snapshot.error}");
            }
            return CircularProgressIndicator();
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          bool? result = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddPenjualanPage()),
          );
          if (result == true) {
            _refreshData();
          }
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
