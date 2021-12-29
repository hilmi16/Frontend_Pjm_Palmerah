import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:pjm_palmerah/custom/SizeHelper.dart';
import 'package:pjm_palmerah/model/konfirmasiPembayaranModel.dart';
import 'package:pjm_palmerah/network/network.dart';
import 'package:pjm_palmerah/screen/daftar_konfirmasi_pembayaran.dart';

class PencarianKonfirmasiPembayaran extends StatefulWidget {
  @override
  _PencarianKonfirmasiPembayaranState createState() =>
      _PencarianKonfirmasiPembayaranState();
}

class _PencarianKonfirmasiPembayaranState
    extends State<PencarianKonfirmasiPembayaran> {
  var loading = false;

  List<KonfirmasiPembayaranModel> konfirmasiPembayaranList = [];
  List<KonfirmasiPembayaranModel> listPencariankonfirmasiPembayaran = [];

  getDaftarKonfirmasiPembayaran() async {
    setState(() {
      loading = true;
    });
    konfirmasiPembayaranList.clear();
    final response =
        await http.get(Uri.tryParse(NetworkUrl.getKonfirmasiPembayaran()));
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (!mounted) {
        return; // Just do nothing if the widget is disposed.
      }
      setState(() {
        for (Map i in data) {
          konfirmasiPembayaranList.add(KonfirmasiPembayaranModel.fromJson(i));
        }
        loading = false;
      });
    } else {
      if (!mounted) {
        return; // Just do nothing if the widget is disposed.
      }
      setState(() {
        loading = false;
      });
    }
  }

  final price = NumberFormat("#,##0", 'en_US');

  TextEditingController _controllerPencarianNoInvoice = TextEditingController();

  dalamPencarian(String text) async {
    if (text.isEmpty) {
      if (!mounted) {
        return; // Just do nothing if the widget is disposed.
      }
      setState(() {});
    }
    listPencariankonfirmasiPembayaran.clear();
    konfirmasiPembayaranList.forEach((a) {
      if (a.noInvoice.toLowerCase().contains(text)) {
        listPencariankonfirmasiPembayaran.add(a);
      } else if (a.tanggalKonfirmasi.toLowerCase().contains(text)) {
        listPencariankonfirmasiPembayaran.add(a);
      } else if (a.phone.toLowerCase().contains(text)) {
        listPencariankonfirmasiPembayaran.add(a);
      } else if (a.tanggalPembelian.toLowerCase().contains(text)) {
        listPencariankonfirmasiPembayaran.add(a);
      } else if (a.nama.contains(text)) {
        listPencariankonfirmasiPembayaran.add(a);
      } else if (a.nama.toUpperCase().contains(text)) {
        listPencariankonfirmasiPembayaran.add(a);
      } else if (a.nama.toLowerCase().contains(text)) {
        listPencariankonfirmasiPembayaran.add(a);
      }
    });
    if (!mounted) {
      return; // Just do nothing if the widget is disposed.
    }
    setState(() {});
  }

  Future<void> refreshHalaman() async {
    getDaftarKonfirmasiPembayaran();
  }

  int index = 0;
  _deleteKonfirmasiPembayaran(String noInvoice, String buktiTransfer) async {
    final response = await http
        .post(Uri.tryParse(NetworkUrl.deleteKonfirmasiPembayaran()), body: {
      'noInvoice': noInvoice,
      'buktiTransfer': buktiTransfer,
    });
    final data = jsonDecode(response.body);
    String message = data['message'];
    int value = data['value'];

    if (value == 1) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text("Informasi"),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              child: Text(
                "Ok",
                style: TextStyle(
                  color: Colors.grey,
                  fontWeight: FontWeight.bold,
                ),
              ),
              onPressed: () {
                setState(() {
                  Navigator.pop(context);
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) => DaftarKonfirmasiPembayaran()));
                });
              },
            ),
          ],
        ),
      );
    } else {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text("Informasi"),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              child: Text(
                "Ok",
                style: TextStyle(
                  color: Colors.grey,
                  fontWeight: FontWeight.bold,
                ),
              ),
              onPressed: () {
                setState(() {
                  Navigator.pop(context);
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) => DaftarKonfirmasiPembayaran()));
                });
              },
            ),
          ],
        ),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    getDaftarKonfirmasiPembayaran();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Container(
          height: 50,
          padding: EdgeInsets.all(4),
          child: TextField(
            textAlign: TextAlign.left,
            autofocus: true,
            controller: _controllerPencarianNoInvoice,
            onChanged: dalamPencarian,
            style: TextStyle(
                fontSize: displayWidth(context) * 0.035,
                fontWeight: FontWeight.w500,
                wordSpacing: 1.5),
            decoration: InputDecoration(
              hintText: "Cari Konfirmasi Pembayaran Users",
              hintStyle: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: displayWidth(context) * 0.035,
                  wordSpacing: 1.5),
              fillColor: Colors.cyanAccent,
              filled: true,
              suffixIcon: IconButton(icon: Icon(Icons.search), onPressed: null),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide(style: BorderStyle.none),
              ),
            ),
          ),
        ),
      ),
      body: Container(
          child: loading
              ? Center(
                  child: CircularProgressIndicator(),
                )
              : _controllerPencarianNoInvoice.text.isNotEmpty ||
                      listPencariankonfirmasiPembayaran.length != 0
                  ? ListView(
                      padding: EdgeInsets.all(16),
                      children: <Widget>[
                        Divider(),
                        ListView.builder(
                          padding: EdgeInsets.all(16),
                          itemCount: listPencariankonfirmasiPembayaran.length,
                          shrinkWrap: true,
                          physics: ClampingScrollPhysics(),
                          itemBuilder: (context, i) {
                            final a = listPencariankonfirmasiPembayaran[i];

                            //tinggal panggil valuenya misal Column()

                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: <Widget>[
                                Text(
                                  "No.Invoice : ${a.noInvoice}",
                                  style: TextStyle(
                                    fontSize: displayWidth(context) * 0.03,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                Text(
                                  "Nama : ${a.nama}",
                                  style: TextStyle(
                                    fontSize: displayWidth(context) * 0.03,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                Text(
                                  "Nomor telpon : ${a.phone}",
                                  style: TextStyle(
                                    fontSize: displayWidth(context) * 0.03,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                Text(
                                  "Tanggal Pembelian : ${a.tanggalPembelian}",
                                  style: TextStyle(
                                    fontSize: displayWidth(context) * 0.03,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                Text(
                                  "Tanggal Konfirmasi : ${a.tanggalKonfirmasi}",
                                  style: TextStyle(
                                    fontSize: displayWidth(context) * 0.03,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                                Image.network(
                                    "https://pjmpalmerah.000webhostapp.com/products/konfirmasiPembayaran/${a.buktiTransfer}"),
                                InkWell(
                                  onTap: () {
                                    _deleteKonfirmasiPembayaran(
                                        a.noInvoice, a.buktiTransfer);
                                  },
                                  child: Container(
                                    padding: EdgeInsets.only(
                                      left: displayWidth(context) * 0.025,
                                      right: displayWidth(context) * 0.025,
                                      top: displayHeight(context) * 0.025,
                                      bottom: displayHeight(context) * 0.025,
                                    ),
                                    margin: EdgeInsets.only(
                                        left: displayWidth(context) * 0.1,
                                        right: displayWidth(context) * 0.075,
                                        top: displayWidth(context) * 0.05,
                                        bottom: displayWidth(context) * 0),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(20),
                                      gradient: LinearGradient(
                                          begin: Alignment.centerLeft,
                                          end: Alignment.centerRight,
                                          colors: [
                                            Colors.deepOrange,
                                            Colors.deepPurple
                                          ]),
                                    ),
                                    child: Text(
                                      "Hapus Konfirmasi Pembayaran",
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
                              ],
                            );
                          },
                        ),
                      ],
                    )
                  : Container(
                      padding: EdgeInsets.all(16),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: <Widget>[
                          Text(
                            "Cari Konfirmasi Pembayaran User",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          )
                        ],
                      ),
                    )),
    );
  }
}
