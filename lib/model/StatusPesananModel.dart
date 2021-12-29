class StatusPesananModel {
  final String noInvoice;
  final String namaPenerima;
  final String alamatPenerima;
  final String nomorPenerima;
  final String tanggalTransaksi;
  final String idUsers;
  final String status;

  final List<StatusPesananDetailModel> detail;

  StatusPesananModel({
    this.noInvoice,
    this.namaPenerima,
    this.alamatPenerima,
    this.nomorPenerima,
    this.tanggalTransaksi,
    this.idUsers,
    this.status,
    this.detail,
  });

  factory StatusPesananModel.fromJson(Map<String, dynamic> json) {
    var list = json['detail'] as List;
    List<StatusPesananDetailModel> dataList =
        list.map((e) => StatusPesananDetailModel.fromJson(e)).toList();
    return StatusPesananModel(
      noInvoice: json['noInvoice'],
      namaPenerima: json['namaPenerima'],
      alamatPenerima: json['alamatPenerima'],
      nomorPenerima: json['nomorPenerima'],
      tanggalTransaksi: json['tanggalTransaksi'],
      idUsers: json['idUsers'],
      status: json['status'],
      detail: dataList,
    );
  }
}

class StatusPesananDetailModel {
  final String id;
  final String idProduk;
  final String berat;
  final String quantity;
  final String harga;
  final String diskon;
  // ignore: non_constant_identifier_names
  final String nama_produk;
  // ignore: non_constant_identifier_names
  final String cover_produk;

  StatusPesananDetailModel(
      {this.id,
      this.idProduk,
      this.berat,
      this.quantity,
      this.harga,
      this.diskon,
      // ignore: non_constant_identifier_names
      this.nama_produk,
      // ignore: non_constant_identifier_names
      this.cover_produk});
  factory StatusPesananDetailModel.fromJson(Map<String, dynamic> json) {
    return StatusPesananDetailModel(
      id: json['id'],
      idProduk: json['idProduk'],
      berat: json['berat'],
      quantity: json['quantity'],
      harga: json['harga'],
      diskon: json['diskon'],
      nama_produk: json['nama_produk'],
      cover_produk: json['cover_produk'],
    );
  }
}
