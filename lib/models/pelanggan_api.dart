import 'dart:convert';
import 'package:http/http.dart' as http;

class PelangganApi {
  final String apiUrl = "http://192.168.100.19/api/v1/pelanggan/all";
  final String detailUrl = "http://192.168.100.19/api/v1/pelanggan/detail";
  final String storeUrl = "http://192.168.100.19/api/v1/pelanggan/store";
  final String updateUrl = "http://192.168.100.19/api/v1/pelanggan/update";
  final String deleteUrl = "http://192.168.100.19/api/v1/pelanggan/delete";

  Future<List<Pelanggan>> fetchPelanggan() async {
    final response = await http.get(Uri.parse(apiUrl));

    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      return jsonResponse.map((data) => Pelanggan.fromJson(data)).toList();
    } else {
      throw Exception('Failed to load data');
    }
  }

  Future<Pelanggan> fetchPelangganDetail(int id) async {
    final response = await http.get(Uri.parse('$detailUrl/$id'));

    if (response.statusCode == 200) {
      return Pelanggan.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load detail');
    }
  }

  Future<void> addPelanggan(Pelanggan pelanggan) async {
    final response = await http.post(
      Uri.parse(storeUrl),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(pelanggan.toJson()),
    );

    if (response.statusCode != 201) {
      throw Exception('Failed to add pelanggan');
    }
  }

  Future<void> updatePelanggan(Pelanggan pelanggan) async {
    final response = await http.post(
      Uri.parse('$updateUrl/${pelanggan.id}'),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(pelanggan.toJson()),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to update pelanggan');
    }
  }

  Future<void> deletePelanggan(int id) async {
    final response = await http.delete(
      Uri.parse('$deleteUrl/$id'),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to delete pelanggan');
    }
  }
}

class Pelanggan {
  final int id;
  final String nama;
  final String domisili;
  final String jenisKelamin;

  Pelanggan(
      {required this.id,
        required this.nama,
        required this.domisili,
        required this.jenisKelamin});

  factory Pelanggan.fromJson(Map<String, dynamic> json) {
    return Pelanggan(
      id: json['id'],
      nama: json['nama'],
      domisili: json['domisili'],
      jenisKelamin: json['jenis_kelamin'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nama': nama,
      'domisili': domisili,
      'jenis_kelamin': jenisKelamin,
    };
  }
}
