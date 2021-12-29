import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter/material.dart';
import 'package:pjm_palmerah/custom/SizeHelper.dart';
import 'package:pjm_palmerah/custom/preference_profile.dart';
import 'package:pjm_palmerah/model/UsersModel.dart';
import 'package:pjm_palmerah/respository/UsersRepository.dart';
import 'package:pjm_palmerah/screen/historyPemesananUser.dart';
import 'package:pjm_palmerah/screen/menu.dart';
import 'package:pjm_palmerah/screen/pencarian_users.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DaftarUsers extends StatefulWidget {
  @override
  _DaftarUsersState createState() => _DaftarUsersState();
}

class _DaftarUsersState extends State<DaftarUsers> {
  bool login = false;
  bool checkData = false;
  String idUsers, level, namaLengkap, email, phone, deviceID;
  UsersRepository _usersRepository = UsersRepository();
  List<UsersModel> list = [];

  getPreference() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      login = preferences.getBool(Preference.login) ?? false;
      idUsers = preferences.getString(Preference.id);
      namaLengkap = preferences.getString(Preference.namaLengkap);
      email = preferences.getString(Preference.email);
      phone = preferences.getString(Preference.phone);
      level = preferences.getString(Preference.level);
    });
    await _usersRepository.fetchdata(list, () {
      setState(() {
        checkData = false;
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
      });
    }, context, checkData);
  }

  Future<void> refreshHalaman() async {
    getPreference();
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
          "Daftar Users",
          style: TextStyle(
            fontSize: displayWidth(context) * 0.05,
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
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => PencarianUsers()));
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

                    return InkWell(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => HistoryPemesananUser(a)));
                      },
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: <Widget>[
                          Text(
                            "ID Users : ${a.id}",
                            style: TextStyle(
                              fontSize: displayWidth(context) * 0.03,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Text(
                            "Nama : ${a.namaLengkap}",
                            style: TextStyle(
                              fontSize: displayWidth(context) * 0.03,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Text(
                            "Email : ${a.email}",
                            style: TextStyle(
                              fontSize: displayWidth(context) * 0.03,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Text(
                            "Nomor Telepon : ${a.phone}",
                            style: TextStyle(
                              fontSize: displayWidth(context) * 0.03,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Text(
                            "Tanggal Pembuatan Akun : ${a.tanggalDibuat}",
                            style: TextStyle(
                              fontSize: displayWidth(context) * 0.03,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Text(
                            a.level == '1' ? "Level : User" : "Level : Admin",
                            style: TextStyle(
                              fontSize: displayWidth(context) * 0.03,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          SizedBox(
                            height: 20,
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
