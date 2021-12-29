import 'package:pjm_palmerah/model/ProdukModel.dart';

class KategoriProdukModel {
  final String id;
  final String namaKategori;
  final String waktuDibuat;
  final String status;
  final List<ProdukModel> products;
  KategoriProdukModel(
      {this.id,
      this.namaKategori,
      this.waktuDibuat,
      this.status,
      this.products});

  factory KategoriProdukModel.fromJson(Map<String, dynamic> json) {
    var list = json['products'] as List;
    List<ProdukModel> produkList =
        list.map((i) => ProdukModel.fromJson(i)).toList();
    return KategoriProdukModel(
        products: produkList,
        id: json['id'],
        namaKategori: json['namaKategori'],
        status: json['status'],
        waktuDibuat: json['waktuDibuat']);
  }
}
