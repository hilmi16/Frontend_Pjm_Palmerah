import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;
import 'package:device_info/device_info.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pjm_palmerah/custom/SizeHelper.dart';
import 'package:pjm_palmerah/custom/preference_profile.dart';
import 'package:pjm_palmerah/model/StatusPesananModel.dart';
import 'package:pjm_palmerah/model/UsersModel.dart';
import 'package:pjm_palmerah/network/network.dart';
import 'package:pjm_palmerah/respository/daftarPesananUserRepository.dart';
import 'package:pjm_palmerah/screen/HistoryDetailPemesananUser.dart';
import 'package:pjm_palmerah/screen/menu.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HistoryPemesananUser extends StatefulWidget {
  final UsersModel model;
  HistoryPemesananUser(this.model);
  @override
  _HistoryPemesananUserState createState() => _HistoryPemesananUserState();
}

class _HistoryPemesananUserState extends State<HistoryPemesananUser> {
  bool login = false;
  var loading = false;
  var checkData = false;
  String idUsers, level, namaLengkap, email, phone, deviceID;
  DaftarPesananUserRepository _daftarPesananUserRepository =
      DaftarPesananUserRepository();
  List<StatusPesananModel> list = [];
  final price = NumberFormat("#,##0", 'en_US');

  getPreference() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      // idUsers = preferences.getString(Preference.id);
      idUsers = widget.model.id;
      namaLengkap = preferences.getString(Preference.namaLengkap);
      email = preferences.getString(Preference.email);
      phone = preferences.getString(Preference.phone);
      level = preferences.getString(Preference.level);
      login = preferences.getBool(Preference.login) ?? false;
    });
    await _daftarPesananUserRepository.fetchdata(list, idUsers, () {
      setState(() {
        loading = true;
      });
    }, checkData);
    getDeviceInfo();
  }

  DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
  getDeviceInfo() async {
    var build = await deviceInfo.androidInfo;
    setState(() {
      deviceID = build.androidId;
    });
    getTotalBarangDikeranjang();
  }

  FirebaseAuth _auth = FirebaseAuth.instance;
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
      _auth.signOut();
      googleSignIn.signOut();
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => Menu()));
    });
  }

  Future<void> refreshHalaman() async {
    getPreference();
  }

  var loadingTotalBarangDikeranjang = false;
  var totalBarangDikeranjang = "0";
  getTotalBarangDikeranjang() async {
    setState(() {
      loadingTotalBarangDikeranjang = true;
    });
    final response = await http
        .get(Uri.tryParse(NetworkUrl.getTotalBarangDikeranjang(deviceID)));
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body)[0];
      String total = data['total'];
      if (!mounted) {
        return;
      }
      setState(() {
        loadingTotalBarangDikeranjang = false;
        totalBarangDikeranjang = total;
      });
    } else {
      if (!mounted) {
        return;
      }
      setState(() {
        loadingTotalBarangDikeranjang = false;
      });
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
          "Histori Pemesanan User",
          style: TextStyle(
            color: Colors.amber,
            fontSize: displayWidth(context) * 0.05,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: Container(
        child: Center(
          child: RefreshIndicator(
            onRefresh: refreshHalaman,
            child: ListView(
              children: <Widget>[
                Divider(),
                ListView.builder(
                  padding: EdgeInsets.all(16),
                  itemCount: list.length,
                  shrinkWrap: true,
                  physics: ClampingScrollPhysics(),
                  itemBuilder: (context, i) {
                    final a = list[i];

                    return InkWell(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    HistoryDetailPemesananUser(a)));
                      },
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: <Widget>[
                          Text(
                            "No.Invoice : ${a.noInvoice}",
                            style: TextStyle(
                              fontSize: displayWidth(context) * 0.035,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Text(
                            "Tanggal CheckOut : ${a.tanggalTransaksi}",
                            style: TextStyle(
                              fontSize: displayWidth(context) * 0.035,
                              fontWeight: FontWeight.bold,
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
                            a.status == "1"
                                ? "Status : Dalam Pengiriman"
                                : a.status == "0"
                                    ? "Status : Pending"
                                    : "Status : Sudah diterima",
                            style: TextStyle(
                                fontSize: displayWidth(context) * 0.030,
                                fontWeight: FontWeight.w500,
                                color: Colors.red),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Text(
                            "Nama penerima : ${a.namaPenerima}",
                            style: TextStyle(
                              fontSize: displayWidth(context) * 0.030,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Text(
                            "Nomor Penerima : ${a.nomorPenerima}",
                            style: TextStyle(
                              fontSize: displayWidth(context) * 0.030,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Text(
                            "Alamat Pengiriman : ${a.alamatPenerima}",
                            style: TextStyle(
                              fontSize: displayWidth(context) * 0.030,
                              fontWeight: FontWeight.w500,
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
                      ),
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
