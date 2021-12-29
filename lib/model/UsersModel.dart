class UsersModel {
  final String id;
  final String email;
  final String password;
  final String phone;
  final String namaLengkap;
  final String tanggalDibuat;
  final String status;
  final String level;
  final String kode;

  UsersModel(
      {this.id,
      this.email,
      this.password,
      this.phone,
      this.namaLengkap,
      this.tanggalDibuat,
      this.status,
      this.level,
      this.kode});

  factory UsersModel.fromJson(Map<String, dynamic> json) {
    return UsersModel(
      id: json['id'],
      email: json['email'],
      password: json['password'],
      phone: json['phone'],
      namaLengkap: json['namaLengkap'],
      tanggalDibuat: json['tanggalDibuat'],
      status: json['status'],
      level: json['level'],
      kode: json['kode'],
    );
  }
}
