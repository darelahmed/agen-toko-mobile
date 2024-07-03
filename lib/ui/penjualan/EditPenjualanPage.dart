import 'package:flutter/material.dart';
import 'package:agen_toko/models/penjualan_api.dart';
import 'package:agen_toko/models/itempenjualan_api.dart';
import 'package:agen_toko/models/pelanggan_api.dart';
import 'package:agen_toko/models/barang_api.dart';

class EditPenjualanPage extends StatefulWidget {
  final int id;

  const EditPenjualanPage({super.key, required this.id});

  @override
  _EditPenjualanPageState createState() => _EditPenjualanPageState();
}

class _EditPenjualanPageState extends State<EditPenjualanPage> {
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
    _fetchPenjualanDetail();
    _fetchItemPenjualan();
    _fetchPelanggan();
  }

  Future<void> _fetchPenjualanDetail() async {
    try {
      Penjualan penjualan = await PenjualanApi().fetchPenjualanDetail(widget.id);
      setState(() {
        _idNota = penjualan.id_nota;
        _tanggal = penjualan.tanggal;
        _idPelanggan = penjualan.id_pelanggan;
        _subTotal = penjualan.sub_total;
      });
    } catch (e) {
      print('Error fetching penjualan detail: $e');
    }
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

  Future<void> _updatePenjualan() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      try {
        await PenjualanApi().updatePenjualan(widget.id, Penjualan(
            id: widget.id,
            id_nota: _idNota!,
            tanggal: _tanggal,
            id_pelanggan: _idPelanggan!,
            sub_total: _subTotal!)
        );
        Navigator.pop(context, true);
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to update penjualan: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Penjualan'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              DropdownButtonFormField<int>(
                decoration: InputDecoration(labelText: 'ID Nota'),
                value: _idNota,
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
                value: _idPelanggan,
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
              Text(
                'Total: ${_subTotal?.toInt() ?? 0}',
                style: TextStyle(fontSize: 20),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _updatePenjualan,
                child: Text('Update'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
