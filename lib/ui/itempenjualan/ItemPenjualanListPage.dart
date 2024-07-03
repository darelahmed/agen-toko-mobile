import 'package:flutter/material.dart';
import 'package:agen_toko/models/itempenjualan_api.dart';
import 'package:agen_toko/models/barang_api.dart';
import 'package:agen_toko/ui/itempenjualan/AddItemPenjualanPage.dart';
import 'package:agen_toko/ui/itempenjualan/EditItemPenjualanPage.dart';
import 'package:agen_toko/ui/itempenjualan/ItemPenjualanDetailPage.dart';

class ItemPenjualanListPage extends StatefulWidget {
  const ItemPenjualanListPage({super.key});

  @override
  State<ItemPenjualanListPage> createState() => _ItemPenjualanListPageState();
}

class _ItemPenjualanListPageState extends State<ItemPenjualanListPage> {
  late Future<List<ItemPenjualan>> futureItemPenjualan;
  late Future<List<Barang>> futureBarang;
  List<Barang> barangList = [];

  @override
  void initState() {
    super.initState();
    futureItemPenjualan = ItemPenjualanApi().fetchItemPenjualan();
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

  Future<void> _deleteItemPenjualan(int id) async {
    try {
      await ItemPenjualanApi().deleteItemPenjualan(id);
      setState(() {
        futureItemPenjualan = ItemPenjualanApi().fetchItemPenjualan();
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to delete itemPenjualan: $e')),
      );
    }
  }

  Future<void> _refreshData() async {
    setState(() {
      futureItemPenjualan = ItemPenjualanApi().fetchItemPenjualan();
      futureBarang = BarangApi().fetchBarang();
      fetchBarangList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Daftar Item Penjualan'),
      ),
      body: Center(
        child: FutureBuilder<List<ItemPenjualan>>(
          future: futureItemPenjualan,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              List<ItemPenjualan> data = snapshot.data!;
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
                              Text('${data[index].id_barang}. ${getNamaBarang(data[index].id_barang)}'),
                              Text('Quantity: ${data[index].qty}'),
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
                                            EditItemPenjualanPage(
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
                                                _deleteItemPenjualan(
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
                                ItemPenjualanDetailPage(id: data[index].id),
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
            MaterialPageRoute(builder: (context) => AddItemPenjualanPage()),
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
