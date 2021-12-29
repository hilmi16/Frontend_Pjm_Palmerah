import 'dart:convert';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;
import 'package:line_icons/line_icons.dart';
import 'package:pjm_palmerah/custom/SizeHelper.dart';
import 'package:pjm_palmerah/screen/menuAdmin.dart';
import 'package:supercharged/supercharged.dart';
import 'package:pjm_palmerah/custom/preference_profile.dart';
import 'package:pjm_palmerah/network/network.dart';
import 'package:pjm_palmerah/screen/menu.dart';
import 'package:pjm_palmerah/screen/registrasi.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  String namaLengkap, id, email, password, level;
  final _key = new GlobalKey<FormState>();
  RegExp regx = RegExp(r"^[a-z0-9_]*$", caseSensitive: false);
  bool _secureText = true;

  getPrefences() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      namaLengkap = preferences.getString(Preference.namaLengkap);
      id = preferences.getString(Preference.id);
      id != null ? sessionLogin() : sessionLogout();
      level = preferences.getString(Preference.level);
    });
  }

  sessionLogin() async {
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => Menu()));
  }

  sessionLogout() async {}

  FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  GoogleSignIn googleSignIn = GoogleSignIn();

  String fcmToken;
  generatedTokenFcm() async {
    fcmToken = await _firebaseMessaging.getToken();
  }

  showHide() async {
    setState(() {
      _secureText = !_secureText;
    });
  }

  check() async {
    final form = _key.currentState;
    if (form.validate()) {
      form.save();
      login(email);
    }
  }

  login(String email) async {
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
    final response = await http.post(Uri.tryParse(NetworkUrl.login()), body: {
      "email": email,
      "password": password,
      "token": fcmToken,
    });
    final data = jsonDecode(response.body);
    int value = data['value'];
    String pesan = data['message'];
    String id = data['id'];
    String namaAPI = data['namaLengkap'];
    String emailAPI = data['email'];
    String phone = data['phone'];
    String tanggalDibuat = data['tanggalDibuat'];
    String level = data['level'];
    if (value == 1) {
      Navigator.pop(context);
      setState(() {
        savePreference(id, emailAPI, phone, namaAPI, tanggalDibuat, level);
      });
      if (level == '2') {
        Navigator.pop(context);
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => MenuAdmin()));
      } else {
        Navigator.pop(context);
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => Menu()));
      }
      print(pesan);
    } else {
      print(pesan);
      Navigator.pop(context);
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text("Informasi"),
              content: Text(pesan),
              actions: <Widget>[
                TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text("Ok"))
              ],
            );
          });
    }
  }

  savePreference(String id, String email, String phone, String namaLengkap,
      String tanggalDibuat, String level) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      preferences.setString(Preference.id, id);
      preferences.setString(Preference.email, email);
      preferences.setString(Preference.phone, phone);
      preferences.setString(Preference.namaLengkap, namaLengkap);
      preferences.setString(Preference.tanggalDibuat, tanggalDibuat);
      preferences.setString(Preference.level, level);
      preferences.setBool(Preference.login, true);
    });
  }

  @override
  void initState() {
    super.initState();
    generatedTokenFcm();
    getPrefences();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: "#338be8".toColor(),
        appBar: AppBar(
          leading: IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.pushReplacement(
                    context, MaterialPageRoute(builder: (context) => Menu()));
              }),
          title: Text(
            "Halaman Login",
            style: TextStyle(
              color: Colors.amber,
              fontSize: displayWidth(context) * 0.05,
              fontWeight: FontWeight.bold,
            ),
          ),
          centerTitle: true,
        ),
        body: Center(
          child: Form(
            key: _key,
            child: ListView(
              padding: EdgeInsets.all(16.0),
              children: <Widget>[
                SizedBox(
                  height: displayHeight(context) * 0.04,
                ),
                TextFormField(
                  cursorColor: Colors.black,
                  // ignore: missing_return
                  validator: (e) {
                    if (e.isEmpty) {
                      return "Silahkan Masukkan Email Terlebih Dahulu";
                    }
                  },
                  onSaved: (e) => email = e,
                  decoration: InputDecoration(
                    icon: Icon(
                      LineIcons.user,
                      color: Colors.amberAccent,
                    ),
                    labelText: "Email",
                    labelStyle: TextStyle(
                      color: Colors.lightBlue,
                    ),
                    filled: true,
                    fillColor: Colors.white54,
                  ),
                ),
                SizedBox(
                  height: displayHeight(context) * 0.04,
                ),
                TextFormField(
                  obscureText: _secureText,
                  // ignore: missing_return
                  validator: (e) {
                    if (e.isEmpty) {
                      return "Silahkan Masukkan Password Terlebih Dahulu";
                    }
                  },
                  onSaved: (e) => password = e,
                  decoration: InputDecoration(
                    icon: Icon(
                      LineIcons.key,
                      color: Colors.amberAccent,
                    ),
                    labelText: "Password",
                    labelStyle: TextStyle(
                      color: Colors.lightBlue,
                    ),
                    filled: true,
                    fillColor: Colors.white54,
                    suffixIcon: IconButton(
                      onPressed: showHide,
                      icon: Icon(_secureText
                          ? Icons.visibility_off
                          : Icons.visibility),
                    ),
                  ),
                ),
                SizedBox(
                  height: displayHeight(context) * 0.04,
                ),
                InkWell(
                  onTap: check,
                  child: Container(
                    padding: EdgeInsets.only(
                      left: displayWidth(context) * 0.04,
                      right: displayWidth(context) * 0.04,
                      top: displayHeight(context) * 0.04,
                      bottom: displayHeight(context) * 0.04,
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      gradient: LinearGradient(
                          colors: [Colors.blue, Colors.cyan],
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight),
                    ),
                    child: Text(
                      "Login",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: displayWidth(context) * 0.04,
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: displayHeight(context) * 0.04,
                ),
                InkWell(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => Registrasi(email, fcmToken)));
                  },
                  child: Container(
                    padding: EdgeInsets.only(
                      left: displayWidth(context) * 0.04,
                      right: displayWidth(context) * 0.04,
                      top: displayHeight(context) * 0.04,
                      bottom: displayHeight(context) * 0.04,
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      gradient: LinearGradient(
                          colors: [Colors.blue, Colors.cyan],
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight),
                    ),
                    child: Text(
                      "Belum Punya Akun ? Klik Disini",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: displayWidth(context) * 0.04,
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: displayHeight(context) * 0.04,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
