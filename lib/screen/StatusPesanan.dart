import 'package:google_sign_in/google_sign_in.dart';
import 'package:device_info/device_info.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pjm_palmerah/custom/SizeHelper.dart';
import 'package:pjm_palmerah/custom/preference_profile.dart';
import 'package:pjm_palmerah/model/StatusPesananModel.dart';
import 'package:pjm_palmerah/respository/StatusPesananRepository.dart';
import 'package:pjm_palmerah/screen/PencarianStatusPesananBerdasarkanNoInvoice.dart';
import 'package:pjm_palmerah/screen/StatusPesananDetail.dart';
import 'package:pjm_palmerah/screen/login.dart';
import 'package:pjm_palmerah/screen/menu.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StatusPesanan extends StatefulWidget {
  @override
  _StatusPesananState createState() => _StatusPesananState();
}

class _StatusPesananState extends State<StatusPesanan> {
  bool login = false;
  var loading = false;
  var checkData = false;
  String idUsers, level, namaLengkap, email, phone, deviceID;
  StatusPesananRepository _statusPesananRepository = StatusPesananRepository();
  List<StatusPesananModel> list = [];
  final price = NumberFormat("#,##0", 'en_US');

  getPreference() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      idUsers = preferences.getString(Preference.id);
      namaLengkap = preferences.getString(Preference.namaLengkap);
      email = preferences.getString(Preference.email);
      phone = preferences.getString(Preference.phone);
      level = preferences.getString(Preference.level);
      login = preferences.getBool(Preference.login) ?? false;
    });
    await _statusPesananRepository.fetchdata(list, () {
      if (!mounted) {
        return; // Just do nothing if the widget is disposed.
      }
      setState(() {
        loading = true;
      });
    }, checkData);
    getDeviceInfo();
  }

  DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
  getDeviceInfo() async {
    var build = await deviceInfo.androidInfo;

    if (!mounted) {
      return; // Just do nothing if the widget is disposed.
    }
    setState(() {
      deviceID = build.androidId;
    });
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
      googleSignIn.signOut();
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => Menu()));
    });
  }

  Future<void> refreshHalaman() async {
    getPreference();
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
            "Pesanan Produk",
            style: TextStyle(
              color: Colors.amber,
              fontSize: displayWidth(context) * 0.05,
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
                          builder: (context) => PencarianStatusPesanan()));
                }),
          ]),
      drawer: new Drawer(
        child: ListView(
          children: <Widget>[
            new UserAccountsDrawerHeader(
              accountName: login
                  ? Text(
                      "$namaLengkap",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    )
                  : SizedBox(
                      child: Row(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          "Silahkan Login Terlebih Dahulu",
                          textAlign: TextAlign.center,
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ],
                    )),
              accountEmail: login
                  ? Text(
                      "$email",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    )
                  : SizedBox(
                      child: Center(
                        widthFactor: 6,
                        child: InkWell(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => Login()));
                          },
                          child: Container(
                            padding: EdgeInsets.all(15),
                            decoration: BoxDecoration(
                                shape: BoxShape.rectangle,
                                borderRadius: BorderRadius.circular(20),
                                color: Colors.amber),
                            child: Text(
                              "Login",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      ),
                    ),
            ),
            InkWell(
              onTap: () {
                Navigator.pushReplacement(
                    context, MaterialPageRoute(builder: (context) => Menu()));
              },
              child: ListTile(
                title: Text(
                  "Home",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                leading: Icon(
                  Icons.home,
                  color: Colors.amber,
                ),
              ),
            ),
            Divider(),
            login
                ? InkWell(
                    onTap: () {
                      signOut();
                    },
                    child: ListTile(
                      title: Text(
                        "Logout",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      leading: Icon(
                        Icons.lock_open,
                        color: Colors.amber,
                      ),
                    ),
                  )
                : SizedBox(),
          ],
        ),
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

                    //tinggal panggil valuenya misal Column()

                    return InkWell(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => StatusPesananDetail(a)));
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
                            "Nama Penerima : ${a.namaPenerima}",
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
