import 'package:agen_toko/ui/barang/AddBarangPage.dart';
import 'package:agen_toko/ui/barang/BarangDetailPage.dart';
import 'package:agen_toko/ui/barang/EditBarangPage.dart';
import 'package:flutter/material.dart';
import 'package:agen_toko/models/barang_api.dart';

class BarangListPage extends StatefulWidget {
  const BarangListPage({super.key});

  @override
  State<BarangListPage> createState() => _BarangListPageState();
}

class _BarangListPageState extends State<BarangListPage> {
  late Future<List<Barang>> futureBarang;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    futureBarang = BarangApi().fetchBarang();
  }

  Future<void> _deleteBarang(int id) async {
    try {
      await BarangApi().deleteBarang(id);
      setState(() {
        futureBarang = BarangApi().fetchBarang();
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to delete barang: $e')),
      );
    }
  }

  Future<void> _refreshData() async {
    setState(() {
      futureBarang = BarangApi().fetchBarang();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Daftar Barang'),
      ),
      body: Center(
        child: FutureBuilder<List<Barang>>(
          future: futureBarang,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              List<Barang> data = snapshot.data!;
              return ListView.builder(
                itemCount: data.length,
                itemBuilder: (context, index) {
                  return Card(
                    child: ListTile(
                      subtitle: Row(
                        children: [
                          Text('${data[index].id}'),
                          SizedBox(width: 5),
                          Icon(Icons.indeterminate_check_box_rounded,
                              color: Theme.of(context).colorScheme.primary,
                              size: 80),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(data[index].nama),
                              Text('Kategori: ${data[index].kategori}'),
                              Text('Harga: Rp ${data[index].harga.toInt()}'),
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
                                        builder: (context) => EditBarangPage(
                                            barang: data[index]),
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
                                              'Apakah Anda yakin ingin menghapus pelanggan ini?'),
                                          actions: <Widget>[
                                            TextButton(
                                              onPressed: () {
                                                Navigator.of(context).pop();
                                              },
                                              child: Text('Batal'),
                                            ),
                                            TextButton(
                                              onPressed: () {
                                                _deleteBarang(data[index].id);
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
                                BarangDetailPage(id: data[index].id),
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
            MaterialPageRoute(builder: (context) => AddBarangPage()),
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
