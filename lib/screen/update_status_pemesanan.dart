import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:pjm_palmerah/custom/SizeHelper.dart';
import 'package:pjm_palmerah/custom/preference_profile.dart';
import 'package:pjm_palmerah/model/StatusPesananModel.dart';
import 'package:pjm_palmerah/network/network.dart';
import 'package:pjm_palmerah/screen/product/Menampilkan_produk_di_edit_produk.dart';
import 'package:pjm_palmerah/screen/daftar_konfirmasi_pembayaran.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UbahStatusPemesanan extends StatefulWidget {
  final StatusPesananModel model;

  UbahStatusPemesanan(this.model);
  @override
  _UbahStatusPemesananState createState() => _UbahStatusPemesananState();
}

class _UbahStatusPemesananState extends State<UbahStatusPemesanan> {
  @override
  // ignore: override_on_non_overriding_member
  final price = NumberFormat("#,##0", 'en_US');
  String _valueNumber;

  menyimpanHasil() async {
    if (_valueNumber == null) {
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text("Perhatian"),
              content:
                  Text("Silahkan pilih status pesanan terlebih dahulu !!!"),
              actions: <Widget>[
                TextButton(
                    onPressed: () {
                      setState(() {
                        Navigator.pop(context);
                      });
                    },
                    child: Text("Ok"))
              ],
            );
          });
    } else {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text("Loading"),
            content: Container(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  CircularProgressIndicator(),
                  SizedBox(
                    height: 10,
                  ),
                  Text("Mohon menunggu data sedang diproses... ")
                ],
              ),
            ),
          );
        },
      );

      try {
        var url = Uri.parse(NetworkUrl.updateStatusPemesanan());

        var request = new http.MultipartRequest("POST", url);
        request.fields["noInvoice"] = widget.model.noInvoice;
        request.fields["status"] = _valueNumber;

        var response = await request.send();
        response.stream.transform(utf8.decoder).listen((value) {
          final data = jsonDecode(value);
          int valueGet = data['value'];
          String message = data['message'];
          print(message);
          if (valueGet == 1) {
            Navigator.pop(context);
            showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: Text("Informasi"),
                    content: Text(message),
                    actions: <Widget>[
                      TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                            setState(() {
                              Navigator.pop(context);
                              Navigator.pop(context);
                            });
                          },
                          child: Text("Ok"))
                    ],
                  );
                });

            print(message);
          } else {
            Navigator.pop(context);
            showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: Text("Perhatian"),
                    content: Text(message),
                    actions: <Widget>[
                      TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                            setState(() {
                              Navigator.pop(context);
                              Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          MenampilkanProdukEditProduk()));
                            });
                          },
                          child: Text("Ok"))
                    ],
                  );
                });

            print(message);
          }
        });
      } catch (e) {
        debugPrint("Error $e");
      }
    }
  }

  String namaLengkap, email, phone, level;
  bool login = false;
  getPreference() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      login = preferences.getBool(Preference.login) ?? false;
      namaLengkap = preferences.getString(Preference.namaLengkap);
      email = preferences.getString(Preference.email);
      phone = preferences.getString(Preference.phone);
      level = preferences.getString(Preference.level);
    });
  }

  kirimNotifikasi(String noInvoice) async {
    await http.post(
      Uri.tryParse(NetworkUrl.kirimNotifikasiStatusPemesanan(noInvoice)),
    );
  }

  List _listNumberStatus = ["0", "1", "2"];
  var totalHargaPembelian = "0";
  getPenjumlahanTotalPembelian() async {
    final response = await http.get(Uri.tryParse(
        NetworkUrl.getPenjumlahanTotalPembelian(widget.model.noInvoice)));
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body)[0];
      String total = data['total'];

      setState(() {
        totalHargaPembelian = total;
      });
    } else {}
  }

  @override
  void initState() {
    super.initState();
    getPenjumlahanTotalPembelian();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Ubah Status Pemesanan",
          style: TextStyle(
            color: Colors.amber,
            fontSize: displayWidth(context) * 0.05,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: Container(
        margin: EdgeInsets.all(20),
        child: ListView(
          children: <Widget>[
            Text(
              "No.Invoice : ${widget.model.noInvoice}",
              style: TextStyle(
                fontSize: displayWidth(context) * 0.035,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(
              height: 5,
            ),
            Text(
              "Tanggal Transaksi : ${widget.model.tanggalTransaksi}",
              style: TextStyle(
                fontSize: displayWidth(context) * 0.035,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(
              height: 5,
            ),
            Text(
              "Jumlah Yang Harus Dibayarkan : RP ${price.format(int.parse(totalHargaPembelian))}",
              style: TextStyle(
                  fontSize: displayWidth(context) * 0.030,
                  fontWeight: FontWeight.bold,
                  color: Colors.red),
            ),
            SizedBox(
              height: 5,
            ),
            InkWell(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => DaftarKonfirmasiPembayaran()));
              },
              child: Container(
                padding: EdgeInsets.only(
                  left: displayWidth(context) * 0.025,
                  right: displayWidth(context) * 0.025,
                  top: displayHeight(context) * 0.025,
                  bottom: displayHeight(context) * 0.025,
                ),
                margin: EdgeInsets.only(
                  left: displayWidth(context) * 0.05,
                  right: displayWidth(context) * 0.05,
                  top: displayHeight(context) * 0.05,
                  bottom: displayHeight(context) * 0.05,
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  gradient: LinearGradient(
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                      colors: [Colors.deepOrange, Colors.deepPurple]),
                ),
                child: Text(
                  "Daftar Konfirmasi Pembayaran",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: displayWidth(context) * 0.04,
                  ),
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(
                vertical: 10,
              ),
              child: Divider(
                color: Colors.green,
              ),
            ),
            SizedBox(
              height: 5,
            ),

            Text(
              "Nama Penerima : ${widget.model.namaPenerima}",
              style: TextStyle(
                fontSize: displayWidth(context) * 0.035,
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(
              height: 5,
            ),
            Text(
              "Nomor Penerima : ${widget.model.nomorPenerima}",
              style: TextStyle(
                fontSize: displayWidth(context) * 0.035,
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(
              height: 5,
            ),
            Text(
              "Alamat Pengiriman : ${widget.model.alamatPenerima}",
              style: TextStyle(
                fontSize: displayWidth(context) * 0.035,
                fontWeight: FontWeight.w500,
              ),
            ),

            SizedBox(
              height: 10,
            ),
            Text(
              widget.model.status == "1"
                  ? "Status : Dalam Pengiriman"
                  : widget.model.status == "0"
                      ? "Status : Pending"
                      : "Status : Sudah diterima",
              style: TextStyle(
                color: Colors.red,
                fontWeight: FontWeight.w500,
                fontSize: displayWidth(context) * 0.035,
              ),
            ),

            Container(
              padding: EdgeInsets.symmetric(
                vertical: 10,
              ),
              child: Divider(
                color: Colors.green,
              ),
            ),

            SizedBox(
              height: 16,
            ),
            FormField<String>(
              builder: (FormFieldState<String> state) {
                return Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: InputDecorator(
                    decoration: InputDecoration(
                        labelText: "Silahkan Ubah Status Pemesanan",
                        labelStyle: TextStyle(
                          color: Colors.blueAccent,
                          fontSize: displayWidth(context) * 0.04,
                        ),
                        errorStyle: TextStyle(
                          color: Colors.redAccent,
                          fontSize: displayWidth(context) * 0.04,
                        ),
                        hintText: 'Silahkan Ubah Status Pemesanan',
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(6.0))),
                    isEmpty: _valueNumber == '',
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton(
                        items: _listNumberStatus.map((value) {
                          return DropdownMenuItem(
                            value: value,
                            child: Padding(
                              padding: EdgeInsets.only(
                                left: displayWidth(context) * 0.023,
                                right: displayWidth(context) * 0.023,
                              ),
                              child: Text(
                                value == '0'
                                    ? "Pending"
                                    : value == '1'
                                        ? "Dalam Pengiriman"
                                        : "Sudah diterima",
                                style: TextStyle(
                                  fontSize: displayWidth(context) * 0.03,
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                        value: _valueNumber,
                        onChanged: (value) {
                          setState(() {
                            _valueNumber = value;
                          });
                        },
                      ),
                    ),
                  ),
                );
              },
            ),
            SizedBox(
              height: 16,
            ),

            //ini adalah Button yang dibuat dengan Widget Inkwell
            InkWell(
              onTap: () {
                menyimpanHasil();
                kirimNotifikasi(widget.model.noInvoice);
              },
              child: Container(
                padding: EdgeInsets.only(
                  left: displayWidth(context) * 0.025,
                  right: displayWidth(context) * 0.025,
                  top: displayHeight(context) * 0.025,
                  bottom: displayHeight(context) * 0.025,
                ),
                margin: EdgeInsets.only(
                  left: displayWidth(context) * 0.05,
                  right: displayWidth(context) * 0.05,
                  top: displayHeight(context) * 0.05,
                  bottom: displayHeight(context) * 0.05,
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  gradient: LinearGradient(
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                      colors: [Colors.deepOrange, Colors.deepPurple]),
                ),
                child: Text(
                  "Ubah Status",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: displayWidth(context) * 0.04,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
