import 'package:flutter/material.dart';
import 'package:agen_toko/models/itempenjualan_api.dart';
import 'package:agen_toko/models/barang_api.dart';

class EditItemPenjualanPage extends StatefulWidget {
  final int id;
  const EditItemPenjualanPage({super.key, required this.id});

  @override
  _EditItemPenjualanPageState createState() => _EditItemPenjualanPageState();
}

class _EditItemPenjualanPageState extends State<EditItemPenjualanPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _qtyController = TextEditingController();
  late Future<ItemPenjualan> futureItemPenjualan;
  late Future<List<Barang>> futureBarang;
  Barang? selectedBarang;

  @override
  void initState() {
    super.initState();
    futureItemPenjualan =
        ItemPenjualanApi().fetchItemPenjualanDetail(widget.id);
    futureBarang = BarangApi().fetchBarang();
    fetchInitialData();
  }

  Future<void> fetchInitialData() async {
    ItemPenjualan itemPenjualan = await futureItemPenjualan;
    _qtyController.text = itemPenjualan.qty.toString();
    List<Barang> barangList = await futureBarang;
    setState(() {
      selectedBarang = barangList
          .firstWhere((barang) => barang.id == itemPenjualan.id_barang);
    });
  }

  void _submitForm() async {
    if (_formKey.currentState!.validate() && selectedBarang != null) {
      ItemPenjualan updatedItemPenjualan = ItemPenjualan(
        id: widget.id,
        id_barang: selectedBarang!.id,
        qty: int.parse(_qtyController.text),
      );

      try {
        await ItemPenjualanApi().updateItemPenjualan(widget.id, updatedItemPenjualan);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Item Penjualan berhasil diperbarui')),
        );
        Navigator.pop(context, true); // Return true to indicate success
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Gagal memperbarui item penjualan: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Item Penjualan'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: FutureBuilder<ItemPenjualan>(
          future: futureItemPenjualan,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text("Error: ${snapshot.error}"));
            } else if (snapshot.hasData) {
              return FutureBuilder<List<Barang>>(
                future: futureBarang,
                builder: (context, barangSnapshot) {
                  if (barangSnapshot.connectionState ==
                      ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  } else if (barangSnapshot.hasError) {
                    return Center(
                        child: Text("Error: ${barangSnapshot.error}"));
                  } else if (barangSnapshot.hasData) {
                    List<Barang> barangList = barangSnapshot.data!;
                    return Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          DropdownButtonFormField<Barang>(
                            value: selectedBarang,
                            decoration:
                                InputDecoration(labelText: 'Pilih Barang'),
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
                            validator: (value) =>
                                value == null ? 'Pilih barang' : null,
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
                            child: Text('Perbarui'),
                          ),
                        ],
                      ),
                    );
                  }
                  return Center(child: Text("Tidak ada data"));
                },
              );
            }
            return CircularProgressIndicator();
          },
        ),
      ),
    );
  }
}
