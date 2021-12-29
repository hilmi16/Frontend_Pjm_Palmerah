import 'dart:convert';
import 'package:device_info/device_info.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:pjm_palmerah/custom/SizeHelper.dart';
import 'package:pjm_palmerah/custom/preference_profile.dart';
import 'package:pjm_palmerah/model/HistoryModel.dart';
import 'package:pjm_palmerah/network/network.dart';
import 'package:pjm_palmerah/respository/historyrespository.dart';
import 'package:pjm_palmerah/screen/DaftarUsers.dart';
import 'package:pjm_palmerah/screen/daftar_konfirmasi_pembayaran.dart';
import 'package:pjm_palmerah/screen/login.dart';
import 'package:pjm_palmerah/screen/menampilkan_Ongkos_Kirim.dart';
import 'package:pjm_palmerah/screen/menu.dart';
import 'package:pjm_palmerah/screen/menu/history_transaksi.dart';
import 'package:pjm_palmerah/screen/product/Menu_Kelola_Produk.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/services.dart';

class User extends StatefulWidget {
  @override
  _UserState createState() => _UserState();
}

class _UserState extends State<User> {
  bool login = false;
  String namaLengkap, email, phone, idUsers, level;

  HistoryRepository historyRepository = HistoryRepository();
  List<HistoryModel> list = [];
  var loading = false;
  var checkData = false;

  getPreference() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      login = preferences.getBool(Preference.login) ?? false;
      namaLengkap = preferences.getString(Preference.namaLengkap);
      email = preferences.getString(Preference.email);
      phone = preferences.getString(Preference.phone);
      level = preferences.getString(Preference.level);
    });
    await historyRepository.fetchdata(list, idUsers, () {
      if (!mounted) {
        return; // Just do nothing if the widget is disposed.
      }
      setState(() {
        checkData = false;
      });
    }, checkData);
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
        return; // Just do nothing if the widget is disposed.
      }
      setState(() {
        loadingTotalBarangDikeranjang = false;
      });
    }
  }

  String deviceID;
  DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
  getDeviceInfo() async {
    var build = await deviceInfo.androidInfo;
    setState(() {
      deviceID = build.androidId;
    });
    getTotalBarangDikeranjang();
  }

  Future<void> refreshHalaman() async {
    getPreference();
  }

  @override
  void initState() {
    super.initState();
    getPreference();
    getDeviceInfo();
    getPreference();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    return Scaffold(
      appBar: AppBar(
        elevation: 1,
        title: login
            ? level == '2'
                ? Text(
                    "Halaman Admin",
                    style: TextStyle(
                      color: Colors.amber,
                      fontSize: displayWidth(context) * 0.05,
                      fontWeight: FontWeight.bold,
                    ),
                  )
                : Text(
                    "Selamat Datang $namaLengkap",
                    style: TextStyle(
                      color: Colors.amber,
                      fontSize: displayWidth(context) * 0.04,
                      fontWeight: FontWeight.bold,
                    ),
                  )
            : Text(
                "Menu User",
                style: TextStyle(
                  color: Colors.amber,
                  fontSize: displayWidth(context) * 0.05,
                  fontWeight: FontWeight.bold,
                ),
              ),
        centerTitle: true,
        actions: <Widget>[
          login
              ? IconButton(icon: Icon(Icons.lock_open), onPressed: signOut)
              : SizedBox(),
        ],
      ),
      body:
          login //login ? Jikatrue("Account") : Jika False("Silahkan Login Terlebih Dahulu")
              ? Stack(
                  fit: StackFit.expand,
                  children: <Widget>[
                    SingleChildScrollView(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          const SizedBox(
                            height: 10.0,
                          ),
                          level == "1"
                              ? SizedBox()
                              : Text(
                                  "Menu Admin",
                                  style: TextStyle(
                                    fontSize: displayWidth(context) * 0.05,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.deepOrangeAccent,
                                  ),
                                ),
                          level == "1"
                              ? SizedBox()
                              : Card(
                                  elevation: 4.0,
                                  margin: const EdgeInsets.fromLTRB(
                                      20.0, 8.0, 20.0, 16.0),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                  child: Column(
                                    children: <Widget>[
                                      Divider(),
                                      ListTile(
                                        leading: Icon(
                                          Icons.settings,
                                          color: Colors.orange,
                                        ),
                                        title: Text(
                                          "Kelola Produk",
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize:
                                                displayWidth(context) * 0.04,
                                          ),
                                        ),
                                        trailing:
                                            Icon(Icons.keyboard_arrow_right),
                                        onTap: () {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      MenuKelolaProduk()));
                                        },
                                      ),
                                      Divider(),
                                      ListTile(
                                        leading: Icon(Icons.account_box,
                                            color: Colors.orange),
                                        title: Text(
                                          "Daftar Users",
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize:
                                                displayWidth(context) * 0.04,
                                          ),
                                        ),
                                        trailing:
                                            Icon(Icons.keyboard_arrow_right),
                                        onTap: () {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      DaftarUsers()));
                                        },
                                      ),
                                      Divider(),
                                      ListTile(
                                        leading: Icon(Icons.confirmation_number,
                                            color: Colors.orange),
                                        title: Text(
                                          "Daftar Konfirmasi Pembayaran",
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize:
                                                displayWidth(context) * 0.04,
                                          ),
                                        ),
                                        trailing:
                                            Icon(Icons.keyboard_arrow_right),
                                        onTap: () {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      DaftarKonfirmasiPembayaran()));
                                        },
                                      ),
                                      Divider(),
                                      ListTile(
                                        leading: Icon(Icons.local_shipping,
                                            color: Colors.orange),
                                        title: Text(
                                          "Kelola Ongkos Kirim Berdasarkan Kota Tujuan",
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize:
                                                displayWidth(context) * 0.04,
                                          ),
                                        ),
                                        trailing:
                                            Icon(Icons.keyboard_arrow_right),
                                        onTap: () {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      MenampilkanOngkosKirim()));
                                        },
                                      ),
                                      Divider(),
                                    ],
                                  ),
                                ),
                          const SizedBox(
                            height: 10,
                          ),
                          level != "1"
                              ? SizedBox()
                              : Text(
                                  "Status Pesanan",
                                  style: TextStyle(
                                      fontSize: displayWidth(context) * 0.05,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.red),
                                ),
                          level != "1" ? SizedBox() : Divider(),
                          level != "1"
                              ? SizedBox()
                              : ListTile(
                                  leading: Icon(Icons.equalizer,
                                      color: Colors.orange),
                                  title: Text(
                                    "Status Pesanan",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: displayWidth(context) * 0.04,
                                    ),
                                  ),
                                  trailing: Icon(Icons.keyboard_arrow_right),
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                HistoriTransaksi()));
                                  },
                                ),
                          level != "1" ? SizedBox() : Divider(),
                          level != "1"
                              ? SizedBox()
                              : ListTile(
                                  leading: Icon(Icons.confirmation_number,
                                      color: Colors.orange),
                                  title: Text(
                                    "Konfirmasi Pembayaran",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: displayWidth(context) * 0.04,
                                    ),
                                  ),
                                  trailing: Icon(Icons.keyboard_arrow_right),
                                  onTap: () {},
                                ),
                        ],
                      ),
                    ),
                  ],
                )
              : Container(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch, //sumbuX
                    mainAxisAlignment: MainAxisAlignment.center, //sumbuY
                    children: <Widget>[
                      Text(
                        "Silahkan Login Terlebih Dahulu",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: displayWidth(context) * 0.04,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(
                        height: 16,
                      ),
                      Center(
                        child: InkWell(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => Login()));
                          },
                          child: Container(
                            padding: EdgeInsets.only(
                              left: displayWidth(context) * 0.030,
                              right: displayWidth(context) * 0.030,
                              top: displayHeight(context) * 0.030,
                              bottom: displayHeight(context) * 0.030,
                            ),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              gradient: LinearGradient(
                                  colors: [Colors.red, Colors.cyan[200]],
                                  begin: Alignment.centerLeft,
                                  end: Alignment.centerRight),
                            ),
                            child: Text(
                              "Sign In",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
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
