import 'package:flutter/material.dart';
import 'package:agen_toko/models/penjualan_api.dart';
import 'package:agen_toko/models/itempenjualan_api.dart';
import 'package:agen_toko/models/pelanggan_api.dart';
import 'package:agen_toko/models/barang_api.dart';

class AddPenjualanPage extends StatefulWidget {
  @override
  _AddPenjualanPageState createState() => _AddPenjualanPageState();
}

class _AddPenjualanPageState extends State<AddPenjualanPage> {
  final _formKey = GlobalKey<FormState>();
  int? _idNota;
  DateTime _tanggal = DateTime.now();
  int? _idPelanggan;
  double? _subTotal;

  List<ItemPenjualan> _itemPenjualanList = [];
  List<Pelanggan> _pelangganList = [];

  @override
  void initState() {
    super.initState();
    _fetchItemPenjualan();
    _fetchPelanggan();
  }

  Future<void> _fetchItemPenjualan() async {
    try {
      List<ItemPenjualan> fetchedItemPenjualanList =
          await ItemPenjualanApi().fetchItemPenjualan();
      setState(() {
        _itemPenjualanList = fetchedItemPenjualanList;
      });
    } catch (e) {
      print('Error fetching item penjualan: $e');
    }
  }

  Future<void> _fetchPelanggan() async {
    try {
      List<Pelanggan> fetchedPelangganList =
          await PelangganApi().fetchPelanggan();
      setState(() {
        _pelangganList = fetchedPelangganList;
      });
    } catch (e) {
      print('Error fetching pelanggan: $e');
    }
  }

  Future<void> _calculateSubTotal(int idNota) async {
    try {
      final itemPenjualan = await ItemPenjualanApi().fetchItemPenjualanDetail(idNota);
      final barang = await BarangApi().fetchBarangDetail(itemPenjualan.id_barang);
      setState(() {
        _subTotal = itemPenjualan.qty * barang.harga;
      });
    } catch (e) {
      print('Error calculating sub total: $e');
    }
  }

  Future<void> _savePenjualan() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      try {
        await PenjualanApi().addPenjualan(Penjualan(
            id: 0,
            id_nota: _idNota!,
            tanggal: _tanggal,
            id_pelanggan: _idPelanggan!,
            sub_total: _subTotal!));
        Navigator.pop(context, true);
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to add penjualan: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Penjualan'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              DropdownButtonFormField<int>(
                decoration: InputDecoration(labelText: 'ID Nota'),
                items: _itemPenjualanList.map((item) {
                  return DropdownMenuItem<int>(
                    value: item.id,
                    child: Text(item.qty.toString()),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _idNota = value;
                    _calculateSubTotal(value!);
                  });
                },
                validator: (value) {
                  if (value == null) {
                    return 'Please select ID Nota';
                  }
                  return null;
                },
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Tanggal'),
                initialValue: _tanggal.toString(),
                readOnly: true,
                onTap: () async {
                  DateTime? picked = await showDatePicker(
                    context: context,
                    initialDate: _tanggal,
                    firstDate: DateTime(2000),
                    lastDate: DateTime(2101),
                  );
                  if (picked != null && picked != _tanggal) {
                    setState(() {
                      _tanggal = picked;
                    });
                  }
                },
              ),
              DropdownButtonFormField<int>(
                decoration: InputDecoration(labelText: 'ID Pelanggan'),
                items: _pelangganList.map((pelanggan) {
                  return DropdownMenuItem<int>(
                    value: pelanggan.id,
                    child: Text(pelanggan.nama),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _idPelanggan = value;
                  });
                },
                validator: (value) {
                  if (value == null) {
                    return 'Please select ID Pelanggan';
                  }
                  return null;
                },
              ),
              SizedBox(
                height: 20,
              ), // Add this line
              Text(
                'Total: ${_subTotal?.toInt() ?? 0}',
                style: TextStyle(fontSize: 20),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _savePenjualan,
                child: Text('Save'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
