import 'dart:convert';
import 'dart:ffi';
import 'package:http/http.dart' as http;

class BarangApi {
  final String apiUrl = "http://192.168.100.19/api/v1/barang/all";
  final String detailUrl = "http://192.168.100.19/api/v1/barang/detail";
  final String storeUrl = "http://192.168.100.19/api/v1/barang/store";
  final String updateUrl = "http://192.168.100.19/api/v1/barang/update";
  final String deleteUrl = "http://192.168.100.19/api/v1/barang/delete";

  Future<List<Barang>> fetchBarang() async {
    final response = await http.get(Uri.parse(apiUrl));

    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      return jsonResponse.map((data) => Barang.fromJson(data)).toList();
    } else {
      throw Exception('Failed to load data');
    }
  }

  Future<Barang> fetchBarangDetail(int id) async {
    final response = await http.get(Uri.parse('$detailUrl/$id'));

    if (response.statusCode == 200) {
      return Barang.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load detail');
    }
  }

  Future<void> addBarang(Barang barang) async {
    final response = await http.post(
      Uri.parse(storeUrl),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(barang.toJson()),
    );

    if (response.statusCode != 201) {
      throw Exception('Failed to add barang');
    }
  }

  Future<void> updateBarang(Barang barang) async {
    final response = await http.post(
      Uri.parse('$updateUrl/${barang.id}'),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(barang.toJson()),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to update barang');
    }
  }

  Future<void> deleteBarang(int id) async {
    final response = await http.delete(
      Uri.parse('$deleteUrl/$id'),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to delete barang');
    }
  }
}

class Barang {
  final int id;
  final String nama;
  final String kategori;
  final double harga;

  Barang(
      {required this.id,
      required this.nama,
      required this.kategori,
      required this.harga});

  factory Barang.fromJson(Map<String, dynamic> json) {
    return Barang(
      id: json['id'],
      nama: json['nama'],
      kategori: json['kategori'],
      harga: json['harga'].toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nama': nama,
      'kategori': kategori,
      'harga': harga,
    };
  }
}
