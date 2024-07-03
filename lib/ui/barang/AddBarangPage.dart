import 'package:flutter/material.dart';
import 'package:agen_toko/models/barang_api.dart';

class AddBarangPage extends StatefulWidget {
  const AddBarangPage({super.key});

  @override
  _AddBarangPageState createState() => _AddBarangPageState();
}

class _AddBarangPageState extends State<AddBarangPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _namaController = TextEditingController();
  final TextEditingController _kategoriController = TextEditingController();
  final TextEditingController _hargaController = TextEditingController();

  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      Barang newBarang = Barang(
        id: 0, // You can generate or handle this id in your backend
        nama: _namaController.text,
        kategori: _kategoriController.text,
        harga: double.parse(_hargaController.text),
      );

      try {
        await BarangApi().addBarang(newBarang);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Barang berhasil ditambahkan')),
        );
        Navigator.pop(context, true); // Return true to indicate success
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Gagal menambahkan barang: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tambah Barang'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _namaController,
                decoration: InputDecoration(labelText: 'Nama'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Nama tidak boleh kosong';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _kategoriController,
                decoration: InputDecoration(labelText: 'Kategori'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Kategori tidak boleh kosong';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _hargaController,
                decoration: InputDecoration(labelText: 'Harga'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Harga tidak boleh kosong';
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
        ),
      ),
    );
  }
}
