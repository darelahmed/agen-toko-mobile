import 'package:flutter/material.dart';
import 'package:agen_toko/models/pelanggan_api.dart';

class EditCustomerPage extends StatefulWidget {
  final Pelanggan customer;

  EditCustomerPage({required this.customer});

  @override
  _EditCustomerPageState createState() => _EditCustomerPageState();
}

class _EditCustomerPageState extends State<EditCustomerPage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _domisiliController;
  late TextEditingController _jenisKelaminController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.customer.nama);
    _domisiliController = TextEditingController(text: widget.customer.domisili);
    _jenisKelaminController =
        TextEditingController(text: widget.customer.jenisKelamin);
  }

  Future<void> _updateCustomer() async {
    if (_formKey.currentState!.validate()) {
      Pelanggan updatedCustomer = Pelanggan(
        id: widget.customer.id,
        nama: _nameController.text,
        domisili: _domisiliController.text,
        jenisKelamin: _jenisKelaminController.text,
      );

      try {
        await PelangganApi().updatePelanggan(updatedCustomer);
        Navigator.pop(context, true); // Indicate that an update was successful
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to update customer: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Customer'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(labelText: 'Name'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the name';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _domisiliController,
                decoration: InputDecoration(labelText: 'Domisili'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the domisili';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _jenisKelaminController,
                decoration: InputDecoration(labelText: 'Jenis Kelamin'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the jenis kelamin';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _updateCustomer,
                child: Text('Update'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
