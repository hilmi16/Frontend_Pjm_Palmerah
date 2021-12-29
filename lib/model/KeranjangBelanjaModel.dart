class KeranjangBelanjaModel {
  final String id;
  final String namaProduk;
  final int hargaProduk;
  final String waktuInputProduk;
  final String coverProduk;
  final String status;
  final String deskripsiProduk;
  final String quantity;

  KeranjangBelanjaModel(
      {this.id,
      this.namaProduk,
      this.hargaProduk,
      this.waktuInputProduk,
      this.coverProduk,
      this.status,
      this.deskripsiProduk,
      this.quantity});

  factory KeranjangBelanjaModel.fromJson(Map<String, dynamic> json) {
    return KeranjangBelanjaModel(
        id: json['id'],
        namaProduk: json['nama_produk'],
        hargaProduk: json['harga_produk'],
        waktuInputProduk: json['waktu_input_produk'],
        coverProduk: json['cover_produk'],
        status: json['status'],
        deskripsiProduk: json['deskripsi_produk'],
        quantity: json['quantity']);
  }
}
