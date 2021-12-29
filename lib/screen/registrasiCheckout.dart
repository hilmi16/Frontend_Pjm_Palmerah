import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:pjm_palmerah/custom/SizeHelper.dart';
import 'package:pjm_palmerah/custom/preference_profile.dart';
import 'package:pjm_palmerah/network/network.dart';
import 'package:pjm_palmerah/screen/LoginCheckout.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RegistrasiCheckout extends StatefulWidget {
  final String email;
  final String token;
  RegistrasiCheckout(this.email, this.token);
  @override
  _RegistrasiCheckoutState createState() => _RegistrasiCheckoutState();
}

class _RegistrasiCheckoutState extends State<RegistrasiCheckout> {
  bool loading = false;
  TextEditingController email, password, namaLengkap, phone;
  RegExp regx = RegExp(r"^[a-z0-9_]*$", caseSensitive: false);
  setup() {
    email = TextEditingController(text: widget.email);
    password = TextEditingController();
    namaLengkap = TextEditingController();
    phone = TextEditingController();
  }

  final _key = GlobalKey<FormState>();
  cek() {
    final form = _key.currentState;
    if (form.validate()) {
      form.save();
      simpan();
    }
  }

  bool _secureText = true;
  showHide() {
    setState(() {
      _secureText = !_secureText;
    });
  }

//method di bawah ini untuk menyimpan ke MySQL
  simpan() async {
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
    setState(() {
      loading = true;
    });
    final response = await http.post(Uri.tryParse(NetworkUrl.daftar()), body: {
      "email": email.text,
      "password": password.text,
      "token": widget.token,
      "namaLengkap": namaLengkap.text,
      "phone": phone.text
    });
    final data = jsonDecode(response.body);
    int value = data['value'];
    String message = data['message'];
    String id = data['id'];
    String nama = data['namaLengkap'];
    String hp = data['phone'];
    String emailUsers = data['email'];
    String tanggalDibuat = data['tanggalDibuat'];
    String level = data['level'];
    if (value == 1) {
      Navigator.pop(context);
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text("Informasi"),
              content: Text(message),
              actions: <Widget>[
                TextButton(
                    onPressed: () => Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => LoginCheckout())),
                    child: Text("Ok"))
              ],
            );
          });
      setState(() {
        savePreference(id, emailUsers, hp, nama, tanggalDibuat, level);
        loading = false;
      });
    } else {
      print(message);
      Navigator.pop(context);
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text("Perhatian"),
              content: Text(message),
              actions: <Widget>[
                TextButton(
                    onPressed: () => Navigator.pop(context), child: Text("Ok"))
              ],
            );
          });
      setState(() {
        loading = false;
      });
    }
  }

  savePreference(String id, String email, String phone, String namaLengkap,
      String tanggalDibuat, String level) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      preferences.setString(Preference.id, id);
      preferences.setString(Preference.email, email);
      preferences.setString(Preference.namaLengkap, namaLengkap);
      preferences.setString(Preference.tanggalDibuat, tanggalDibuat);
      preferences.setString(Preference.level, level);
      preferences.setBool(Preference.login, true);
    });
  }

  @override
  void initState() {
    super.initState();
    setup();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            "Halaman Registrasi",
            style: TextStyle(
              color: Colors.amber,
              fontSize: displayWidth(context) * 0.05,
              fontWeight: FontWeight.bold,
            ),
          ),
          centerTitle: true,
        ),
        body: Form(
          key: _key,
          child: ListView(
            padding: EdgeInsets.all(16),
            children: <Widget>[
              SizedBox(
                height: displayHeight(context) * 0.04,
              ),
              widget.email == null
                  ? TextFormField(
                      controller: email,
                      validator: (value) {
                        if (value.isEmpty) {
                          return "Silahkan Masukkan Email Anda";
                        }
                        return null;
                      },
                      decoration: InputDecoration(hintText: "Email"),
                    )
                  : TextFormField(
                      readOnly: true,
                      controller: email,
                      validator: (value) {
                        if (value.isEmpty) {
                          return "Silahkan Masukkan Email Anda";
                        }
                        return null;
                      },
                      decoration: InputDecoration(hintText: "Email"),
                    ),
              SizedBox(
                height: displayHeight(context) * 0.04,
              ),
              TextFormField(
                controller: password,
                obscureText: _secureText,
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Silahkan Masukkan Password Anda';
                  } else if (value.length < 6) {
                    return 'Paswword Harus Lebih Dari 6 Karakter';
                  } else if (!(regx.hasMatch(value))) {
                    return 'Jangan Gunakan Spesial Karakter Contoh : "@%#^"';
                  }
                  return null;
                },
                decoration: InputDecoration(
                  hintText: "Password",
                  suffixIcon: IconButton(
                    onPressed: showHide,
                    icon: Icon(
                      _secureText ? Icons.visibility_off : Icons.visibility,
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: displayHeight(context) * 0.04,
              ),
              TextFormField(
                controller: namaLengkap,
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Silahkan input nama lengkap anda';
                  }
                  return null;
                },
                decoration: InputDecoration(hintText: "Nama Lengkap"),
              ),
              SizedBox(
                height: displayHeight(context) * 0.04,
              ),
              TextFormField(
                controller: phone,
                keyboardType: TextInputType.phone,
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Silahkan input nomor ponsel anda';
                  }
                  return null;
                },
                decoration: InputDecoration(hintText: "Nomor Ponsel"),
              ),
              SizedBox(
                height: displayHeight(context) * 0.04,
              ),
              InkWell(
                onTap: cek,
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
                        colors: [Colors.red, Colors.cyan[200]],
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight),
                  ),
                  child: Text(
                    "Daftar",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: displayWidth(context) * 0.04,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
