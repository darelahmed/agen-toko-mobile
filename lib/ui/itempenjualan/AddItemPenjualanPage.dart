import 'package:flutter/material.dart';
import 'package:agen_toko/models/itempenjualan_api.dart';
import 'package:agen_toko/models/barang_api.dart';

class AddItemPenjualanPage extends StatefulWidget {
  const AddItemPenjualanPage({super.key});

  @override
  _AddItemPenjualanPageState createState() => _AddItemPenjualanPageState();
}

class _AddItemPenjualanPageState extends State<AddItemPenjualanPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _qtyController = TextEditingController();
  late Future<List<Barang>> futureBarang;
  Barang? selectedBarang;

  @override
  void initState() {
    super.initState();
    futureBarang = ItemPenjualanApi().fetchBarang();
  }

  void _submitForm() async {
    if (_formKey.currentState!.validate() && selectedBarang != null) {
      ItemPenjualan newItemPenjualan = ItemPenjualan(
        id: 0,
        id_barang: selectedBarang!.id,
        qty: int.parse(_qtyController.text),
      );

      try {
        await ItemPenjualanApi().addItemPenjualan(newItemPenjualan);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Item Penjualan berhasil ditambahkan')),
        );
        Navigator.pop(context, true); // Return true to indicate success
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Gagal menambahkan item penjualan: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tambah Item Penjualan'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: FutureBuilder<List<Barang>>(
          future: futureBarang,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text("Error: ${snapshot.error}"));
            } else if (snapshot.hasData) {
              List<Barang> barangList = snapshot.data!;
              return Form(
                key: _formKey,
                child: Column(
                  children: [
                    DropdownButtonFormField<Barang>(
                      decoration: InputDecoration(labelText: 'Pilih Barang'),
                      items: barangList.map((Barang barang) {
                        return DropdownMenuItem<Barang>(
                          value: barang,
                          child: Text(barang.nama),
                        );
                      }).toList(),
                      onChanged: (Barang? newValue) {
                        setState(() {
                          selectedBarang = newValue;
                        });
                      },
                      validator: (value) => value == null ? 'Pilih barang' : null,
                    ),
                    TextFormField(
                      controller: _qtyController,
                      decoration: InputDecoration(labelText: 'Quantity'),
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Qty tidak boleh kosong';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: _submitForm,
                      child: Text('Tambah'),
                    ),
                  ],
                ),
              );
            }
            return Center(child: Text("Tidak ada data"));
          },
        ),
      ),
    );
  }
}
