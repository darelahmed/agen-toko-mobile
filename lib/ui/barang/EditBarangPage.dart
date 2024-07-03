import 'package:flutter/material.dart';
import 'package:agen_toko/models/barang_api.dart';

class EditBarangPage extends StatefulWidget {
  final Barang barang;

  EditBarangPage({required this.barang});

  @override
  _EditBarangPageState createState() => _EditBarangPageState();
}

class _EditBarangPageState extends State<EditBarangPage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _kategoriController;
  late TextEditingController _hargaController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.barang.nama);
    _kategoriController = TextEditingController(text: widget.barang.kategori);
    _hargaController = TextEditingController(text: widget.barang.harga.toString());
  }

  Future<void> _updateBarang() async {
    if (_formKey.currentState!.validate()) {
      Barang updatedBarang = Barang(
        id: widget.barang.id,
        nama: _nameController.text,
        kategori: _kategoriController.text,
        harga: double.parse(_hargaController.text),
      );

      try {
        await BarangApi().updateBarang(updatedBarang);
        Navigator.pop(context, true); // Indicate that an update was successful
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to update barang: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Barang'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(labelText: 'Nama'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the nama';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _kategoriController,
                decoration: InputDecoration(labelText: 'Kategori'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the kategori';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _hargaController,
                decoration: InputDecoration(labelText: 'Harga'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the harga';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _updateBarang,
                child: Text('Update'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
