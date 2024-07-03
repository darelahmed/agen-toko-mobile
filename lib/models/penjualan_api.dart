import 'package:http/http.dart' as http;
import 'dart:convert';
import 'barang_api.dart';
import 'package:agen_toko/models/itempenjualan_api.dart';

class PenjualanApi {
  final String apiUrl = "http://192.168.100.19/api/v1/penjualan/all";
  final String detailUrl = "http://192.168.100.19/api/v1/penjualan/detail";
  final String storeUrl = "http://192.168.100.19/api/v1/penjualan/store";
  final String updateUrl = "http://192.168.100.19/api/v1/penjualan/update";
  final String deleteUrl = "http://192.168.100.19/api/v1/penjualan/delete";
  final String baseUrl = 'http://192.168.100.19/api/v1';

  Future<List<Penjualan>> fetchPenjualan() async {
    final response = await http.get(Uri.parse(apiUrl));

    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      return jsonResponse.map((data) => Penjualan.fromJson(data)).toList();
    } else {
      throw Exception('Failed to load penjualan');
    }
  }

  Future<Penjualan> fetchPenjualanDetail(int id) async {
    final response = await http.get(Uri.parse('$detailUrl/$id'));

    if (response.statusCode == 200) {
      return Penjualan.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load penjualan detail');
    }
  }

  Future<void> addPenjualan(Penjualan penjualan) async {
    final response = await http.post(
      Uri.parse(storeUrl),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(penjualan.toJson()),
    );

    if (response.statusCode != 201) {
      throw Exception('Failed to add penjualan');
    }
  }

  Future<void> updatePenjualan(int id, Penjualan penjualan) async {
    final response = await http.post(
      Uri.parse('$updateUrl/$id'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(penjualan.toJson()),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to update penjualan');
    }
  }

  Future<void> deletePenjualan(int id) async {
    final response = await http.delete(
      Uri.parse('$deleteUrl/$id'),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to delete penjualan');
    }
  }

  Future<double> calculateSubTotal(int id_nota) async {
    final itemPenjualanApi = ItemPenjualanApi();
    final barangApi = BarangApi();
    double subTotal = 0.0;

    final itemPenjualanList = await itemPenjualanApi.fetchItemPenjualanByNota(id_nota);
    for (var item in itemPenjualanList) {
      final barang = await barangApi.fetchBarangDetail(item.id_barang);
      subTotal += item.qty * barang.harga;
    }

    return subTotal;
  }
}

class Penjualan {
  final int id;
  final int id_nota;
  final DateTime tanggal;
  final int id_pelanggan;
  final double sub_total;

  Penjualan({
    required this.id,
    required this.id_nota,
    required this.tanggal,
    required this.id_pelanggan,
    required this.sub_total,
  });

  factory Penjualan.fromJson(Map<String, dynamic> json) {
    return Penjualan(
      id: json['id'],
      id_nota: json['id_nota'],
      tanggal: DateTime.parse(json['tanggal']),
      id_pelanggan: json['id_pelanggan'],
      sub_total: json['sub_total'].toDouble(), // Ensure sub_total is converted to double
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'id_nota': id_nota,
      'tanggal': tanggal.toIso8601String(),
      'id_pelanggan': id_pelanggan,
      'sub_total': sub_total.toStringAsFixed(0),
    };
  }
}
