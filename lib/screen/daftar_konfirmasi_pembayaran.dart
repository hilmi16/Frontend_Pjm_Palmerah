import 'dart:convert';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:pjm_palmerah/custom/SizeHelper.dart';
import 'package:pjm_palmerah/custom/preference_profile.dart';
import 'package:pjm_palmerah/model/konfirmasiPembayaranModel.dart';
import 'package:pjm_palmerah/network/network.dart';
import 'package:pjm_palmerah/respository/daftarKonfirmasiPembayaranRepository.dart';
import 'package:pjm_palmerah/screen/menu.dart';
import 'package:pjm_palmerah/screen/pencarian_daftar_konfirmasi_pembayaran.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DaftarKonfirmasiPembayaran extends StatefulWidget {
  @override
  _DaftarKonfirmasiPembayaranState createState() =>
      _DaftarKonfirmasiPembayaranState();
}

class _DaftarKonfirmasiPembayaranState
    extends State<DaftarKonfirmasiPembayaran> {
  bool login = false;
  var loading = false;
  var checkData = false;
  String idUsers, level, namaLengkap, email, phone, deviceID;
  DaftarKonfirmasiPembayaranRepository _daftarKonfirmasiPembayaranRepository =
      DaftarKonfirmasiPembayaranRepository();
  List<KonfirmasiPembayaranModel> list = [];

  getPreference() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      // idUsers = preferences.getString(Preference.id);
      login = preferences.getBool(Preference.login) ?? false;
      idUsers = preferences.getString(Preference.id);
      namaLengkap = preferences.getString(Preference.namaLengkap);
      email = preferences.getString(Preference.email);
      phone = preferences.getString(Preference.phone);
      level = preferences.getString(Preference.level);
    });
    await _daftarKonfirmasiPembayaranRepository.fetchdata(list, () {
      setState(() {
        loading = true;
      });
    }, checkData);

    print("Login (class StatusPemesanan.dart): $login");
  }

  Future<void> refreshHalaman() async {
    getPreference();
  }

  // FirebaseAuth _auth = FirebaseAuth.instance;
  GoogleSignIn googleSignIn = GoogleSignIn();

  signOut() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.remove(Preference.namaLengkap);
    preferences.remove(Preference.id);
    preferences.remove(Preference.email);
    preferences.remove(Preference.login);
    preferences.remove(Preference.level);
    preferences.remove(Preference.tanggalDibuat);
    preferences.remove(Preference.kode);

    setState(() {
      // _auth.signOut();
      googleSignIn.signOut();
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => Menu()));
    });
  }

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
    getPreference();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 1,
        title: Text(
          "Daftar Konfirmasi Pembayaran",
          style: TextStyle(
            fontSize: displayWidth(context) * 0.04,
            color: Colors.amber,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
              icon: Icon(
                Icons.search,
                color: Colors.white,
              ),
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => PencarianKonfirmasiPembayaran()));
              }),
        ],
      ),
      body: Container(
        child: Center(
          child: RefreshIndicator(
            onRefresh: refreshHalaman,
            child: ListView(
              padding: EdgeInsets.all(16),
              children: <Widget>[
                Divider(),
                ListView.builder(
                  padding: EdgeInsets.all(16),
                  itemCount: list.length,
                  shrinkWrap: true,
                  physics: ClampingScrollPhysics(),
                  itemBuilder: (context, i) {
                    final a = list[i];

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
            ),
          ),
        ),
      ),
    );
  }
}
