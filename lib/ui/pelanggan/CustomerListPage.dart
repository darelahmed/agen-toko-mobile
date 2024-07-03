import 'package:flutter/material.dart';
import 'package:agen_toko/ui/pelanggan/AddCustomerPage.dart';
import 'package:agen_toko/ui/pelanggan/CustomerDetailPage.dart';
import 'package:agen_toko/ui/pelanggan/EditCustomerPage.dart';
import 'package:agen_toko/models/pelanggan_api.dart';

class CustomerListPage extends StatefulWidget {
  const CustomerListPage({super.key});

  @override
  State<CustomerListPage> createState() => _CustomerListPageState();
}

class _CustomerListPageState extends State<CustomerListPage> {
  late Future<List<Pelanggan>> futurePelanggan;

  @override
  void initState() {
    super.initState();
    futurePelanggan = PelangganApi().fetchPelanggan();
  }

  Future<void> _deleteCustomer(int id) async {
    try {
      await PelangganApi().deletePelanggan(id);
      setState(() {
        futurePelanggan = PelangganApi().fetchPelanggan();
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to delete customer: $e')),
      );
    }
  }

  Future<void> _refreshData() async {
    setState(() {
      futurePelanggan = PelangganApi().fetchPelanggan();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Daftar Pelanggan'),
      ),
      body: Center(
        child: FutureBuilder<List<Pelanggan>>(
          future: futurePelanggan,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              List<Pelanggan> data = snapshot.data!;
              return ListView.builder(
                itemCount: data.length,
                itemBuilder: (context, index) {
                  return Card(
                    child: ListTile(
                      subtitle: Row(
                        children: [
                          Text('${data[index].id}'),
                          SizedBox(width: 5),
                          Icon(Icons.person,
                              color: Theme.of(context).colorScheme.primary,
                              size: 80),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(data[index].nama),
                              Text('Domisili: ${data[index].domisili}'),
                              Text(
                                  'Jenis Kelamin: ${data[index].jenisKelamin}'),
                            ],
                          ),
                          Spacer(),
                          Padding(
                            padding: const EdgeInsets.only(left: 15.0),
                            child: Column(
                              children: [
                                IconButton(
                                  icon: Icon(Icons.edit),
                                  onPressed: () async {
                                    bool? result = await Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => EditCustomerPage(
                                            customer: data[index]),
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
                                                _deleteCustomer(data[index].id);
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
                                CustomerDetailPage(id: data[index].id),
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
            MaterialPageRoute(builder: (context) => AddCustomerPage()),
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
