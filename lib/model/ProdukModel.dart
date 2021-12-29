class ProdukModel {
  final String id;
  final String idKategori;
  final String namaProduk;
  final String berat;
  final String stok;
  final int hargaProduk;
  final String waktuInputProduk;
  final String coverProduk;
  final String deskripsiProduk;

  ProdukModel(
      {this.id,
      this.idKategori,
      this.namaProduk,
      this.berat,
      this.stok,
      this.hargaProduk,
      this.waktuInputProduk,
      this.coverProduk,
      this.deskripsiProduk});

  factory ProdukModel.fromJson(Map<String, dynamic> json) {
    return ProdukModel(
      id: json['id'],
      idKategori: json['idKategori'],
      namaProduk: json['nama_produk'],
      berat: json['berat'],
      stok: json['stok'],
      hargaProduk: json['harga_produk'],
      waktuInputProduk: json['waktu_input_produk'],
      coverProduk: json['cover_produk'],
      deskripsiProduk: json['deskripsi_produk'],
    );
  }
}
