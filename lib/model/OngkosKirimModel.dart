class OngkosKirimModel {
  final String idKota;
  final String namaKota;
  final String ongkosKirim;

  OngkosKirimModel({
    this.idKota,
    this.namaKota,
    this.ongkosKirim,
  });

  factory OngkosKirimModel.fromJson(Map<String, dynamic> json) {
    return OngkosKirimModel(
        idKota: json['id_kota'],
        namaKota: json['nama_kota'],
        ongkosKirim: json['ongkos_kirim']);
  }
}
