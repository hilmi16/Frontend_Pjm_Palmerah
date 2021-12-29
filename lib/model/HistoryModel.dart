class HistoryModel {
  final String id;
  final String noInvoice;
  final String namaPenerima;
  final String alamatPenerima;
  final String nomorPenerima;
  final String tanggalTransaksi;
  final String status;
  final List<HistoryDetailModel> detail;

  HistoryModel({
    this.id,
    this.noInvoice,
    this.namaPenerima,
    this.alamatPenerima,
    this.nomorPenerima,
    this.tanggalTransaksi,
    this.status,
    this.detail,
  });
  factory HistoryModel.fromJson(Map<String, dynamic> json) {
    var list = json['detail'] as List;
    List<HistoryDetailModel> dataList =
        list.map((e) => HistoryDetailModel.fromJson(e)).toList();
    return HistoryModel(
      id: json['id'],
      noInvoice: json['noInvoice'],
      namaPenerima: json['namaPenerima'],
      alamatPenerima: json['alamatPenerima'],
      nomorPenerima: json['nomorPenerima'],
      tanggalTransaksi: json['tanggalTransaksi'],
      status: json['status'],
      detail: dataList,
    );
  }
}

class HistoryDetailModel {
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

  HistoryDetailModel(
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
  factory HistoryDetailModel.fromJson(Map<String, dynamic> json) {
    return HistoryDetailModel(
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
