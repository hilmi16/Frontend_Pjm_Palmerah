import 'package:device_info/device_info.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:pjm_palmerah/custom/SizeHelper.dart';
import 'package:pjm_palmerah/custom/preference_profile.dart';
import 'package:pjm_palmerah/model/HistoryModel.dart';
import 'package:pjm_palmerah/respository/historyrespository.dart';
import 'package:pjm_palmerah/screen/login.dart';
import 'package:pjm_palmerah/screen/menu.dart';
import 'package:pjm_palmerah/screen/menu/historyDetail.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/services.dart';

class HistoriTransaksiSetelahCheckout extends StatefulWidget {
  @override
  _HistoriTransaksiSetelahCheckoutState createState() =>
      _HistoriTransaksiSetelahCheckoutState();
}

class _HistoriTransaksiSetelahCheckoutState
    extends State<HistoriTransaksiSetelahCheckout> {
  bool login = false;
  String idUsers, level, namaLengkap, email, phone, deviceID;

  HistoryRepository historyRepository = HistoryRepository();
  List<HistoryModel> list = [];
  var loading = false;
  var checkData = false;
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
    await historyRepository.fetchdata(list, idUsers, () {
      setState(() {
        checkData = false;
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
  }

  Future<void> refreshHalaman() async {
    getPreference();
  }

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

  @override
  void initState() {
    super.initState();
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
        leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () => Navigator.pushReplacement(
                context, MaterialPageRoute(builder: (context) => Menu()))),
        title: Text(
          "Status Pemesanan",
          style: TextStyle(
            color: Colors.amber,
            fontSize: displayWidth(context) * 0.05,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: login
          ? Container(
              child: Center(
                child: RefreshIndicator(
                    onRefresh: refreshHalaman,
                    child: ListView(
                      children: <Widget>[
                        ListView.builder(
                          padding: EdgeInsets.all(16),
                          itemCount: list.length,
                          shrinkWrap: true,
                          physics: ClampingScrollPhysics(),
                          itemBuilder: (context, i) {
                            final a = list[i];

                            //tinggal panggil valuenya misal Column()

                            return InkWell(
                              onTap: () {},
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: <Widget>[
                                  Container(
                                    padding: EdgeInsets.symmetric(
                                      vertical: 4,
                                    ),
                                    child: Divider(
                                      color: Colors.black,
                                    ),
                                  ),
                                  Text(
                                    "No.Invoice : ${a.noInvoice}",
                                    style: TextStyle(
                                      fontSize: displayWidth(context) * 0.035,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  SizedBox(
                                    height: 5,
                                  ),
                                  Text(
                                    "Tanggal : ${a.tanggalTransaksi}",
                                    style: TextStyle(
                                      fontSize: displayWidth(context) * 0.035,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  Container(
                                    padding: EdgeInsets.symmetric(
                                      vertical: 4,
                                    ),
                                    child: Divider(
                                      color: Colors.black,
                                    ),
                                  ),
                                  SizedBox(
                                    height: 5,
                                  ),
                                  Text(
                                    "Nama : ${a.namaPenerima}",
                                    style: TextStyle(
                                      fontSize: displayWidth(context) * 0.03,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  SizedBox(
                                    height: 5,
                                  ),
                                  Text(
                                    "Alamat Pengiriman : ${a.alamatPenerima}",
                                    style: TextStyle(
                                      fontSize: displayWidth(context) * 0.03,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  SizedBox(
                                    height: 5,
                                  ),
                                  Text(
                                    "Nomor Telepon : ${a.nomorPenerima}",
                                    style: TextStyle(
                                      fontSize: displayWidth(context) * 0.03,
                                      fontWeight: FontWeight.w500,
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
                                      fontSize: displayWidth(context) * 0.03,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.red,
                                    ),
                                  ),
                                  InkWell(
                                    onTap: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  HistoryDetail(a)));
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
                                        right: displayWidth(context) * 0.125,
                                        top: displayHeight(context) * 0.025,
                                        bottom: displayHeight(context) * 0,
                                      ),
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
                                        "Detail Pemesanan",
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            fontSize:
                                                displayWidth(context) * 0.04,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                  ),
                                  Container(
                                    padding: EdgeInsets.symmetric(
                                      vertical: 4,
                                    ),
                                    child: Divider(
                                      color: Colors.black,
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ],
                    )),
              ),
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
                        Navigator.pushReplacement(context,
                            MaterialPageRoute(builder: (context) => Login()));
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
