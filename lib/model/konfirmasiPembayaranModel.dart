class KonfirmasiPembayaranModel {
  final String noInvoice;
  final String nama;
  final String phone;
  final String tanggalPembelian;
  final String tanggalKonfirmasi;
  final String buktiTransfer;

  KonfirmasiPembayaranModel({
    this.noInvoice,
    this.nama,
    this.phone,
    this.tanggalPembelian,
    this.tanggalKonfirmasi,
    this.buktiTransfer,
  });

  factory KonfirmasiPembayaranModel.fromJson(Map<String, dynamic> json) {
    return KonfirmasiPembayaranModel(
      noInvoice: json['noInvoice'],
      nama: json['nama'],
      phone: json['phone'],
      tanggalPembelian: json['tanggalPembelian'],
      tanggalKonfirmasi: json['tanggalKonfirmasi'],
      buktiTransfer: json['buktiTransfer'],
    );
  }
}
