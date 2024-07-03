import 'dart:convert';
import 'package:http/http.dart' as http;
import 'barang_api.dart';

class ItemPenjualanApi {
  final String apiUrl = "http://192.168.100.19/api/v1/itempenjualan/all";
  final String detailUrl = "http://192.168.100.19/api/v1/itempenjualan/detail";
  final String storeUrl = "http://192.168.100.19/api/v1/itempenjualan/store";
  final String updateUrl = "http://192.168.100.19/api/v1/itempenjualan/update";
  final String deleteUrl = "http://192.168.100.19/api/v1/itempenjualan/delete";
  final String baseUrl = 'http://192.168.100.19/api/v1';

  Future<List<Barang>> fetchBarang() async {
    final response = await http.get(Uri.parse('$baseUrl/barang/all'));

    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      return jsonResponse.map((data) => Barang.fromJson(data)).toList();
    } else {
      throw Exception('Failed to load barang');
    }
  }

  Future<List<ItemPenjualan>> fetchItemPenjualan() async {
    final response = await http.get(Uri.parse(apiUrl));

    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      return jsonResponse.map((data) => ItemPenjualan.fromJson(data)).toList();
    } else {
      throw Exception('Failed to load data');
    }
  }

  Future<ItemPenjualan> fetchItemPenjualanDetail(int id) async {
    final response = await http.get(Uri.parse('$detailUrl/$id'));

    if (response.statusCode == 200) {
      return ItemPenjualan.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load detail');
    }
  }

  Future<void> addItemPenjualan(ItemPenjualan itemPenjualan) async {
    final response = await http.post(
      Uri.parse('$storeUrl'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(itemPenjualan.toJson()),
    );

    if (response.statusCode != 201) {
      throw Exception('Failed to add item penjualan');
    }
  }

  Future<List<ItemPenjualan>> fetchItemPenjualanByNota(int id) async {
    final response = await http.get(Uri.parse('$baseUrl/itempenjualan/$id'));

    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      return jsonResponse.map((data) => ItemPenjualan.fromJson(data)).toList();
    } else {
      throw Exception('Failed to load items for nota');
    }
  }

  Future<void> updateItemPenjualan(int id, ItemPenjualan itemPenjualan) async {
    final response = await http.post(
      Uri.parse('$updateUrl/$id'),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(itemPenjualan.toJson()),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to update item penjualan');
    }
  }

  Future<void> deleteItemPenjualan(int id) async {
    final response = await http.delete(
      Uri.parse('$deleteUrl/$id'),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to delete item penjualan');
    }
  }
}

class ItemPenjualan {
  final int id;
  final int id_barang;
  final int qty;

  ItemPenjualan({
    required this.id,
    required this.id_barang,
    required this.qty,
  });

  factory ItemPenjualan.fromJson(Map<String, dynamic> json) {
    return ItemPenjualan(
      id: json['id'],
      id_barang: json['id_barang'],
      qty: json['qty'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'id_barang': id_barang,
      'qty': qty,
    };
  }
}
