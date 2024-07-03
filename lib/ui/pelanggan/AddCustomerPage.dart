import 'package:flutter/material.dart';
import 'package:agen_toko/models/pelanggan_api.dart';

class AddCustomerPage extends StatefulWidget {
  const AddCustomerPage({super.key});

  @override
  _AddCustomerPageState createState() => _AddCustomerPageState();
}

class _AddCustomerPageState extends State<AddCustomerPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _namaController = TextEditingController();
  final TextEditingController _domisiliController = TextEditingController();
  String? _jenisKelamin;

  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      Pelanggan newPelanggan = Pelanggan(
        id: 0, // You can generate or handle this id in your backend
        nama: _namaController.text,
        domisili: _domisiliController.text,
        jenisKelamin: _jenisKelamin!,
      );

      try {
        await PelangganApi().addPelanggan(newPelanggan);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Pelanggan berhasil ditambahkan')),
        );
        Navigator.pop(context, true); // Return true to indicate success
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Gagal menambahkan pelanggan: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tambah Pelanggan'),
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
                controller: _domisiliController,
                decoration: InputDecoration(labelText: 'Domisili'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Domisili tidak boleh kosong';
                  }
                  return null;
                },
              ),
              DropdownButtonFormField<String>(
                decoration: InputDecoration(labelText: 'Jenis Kelamin'),
                value: _jenisKelamin,
                items: ['PRIA', 'WANITA']
                    .map((label) => DropdownMenuItem(
                          child: Text(label),
                          value: label,
                        ))
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    _jenisKelamin = value;
                  });
                },
                validator: (value) {
                  if (value == null) {
                    return 'Pilih jenis kelamin';
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
