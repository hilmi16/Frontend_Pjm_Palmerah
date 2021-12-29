import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:pjm_palmerah/custom/SizeHelper.dart';
import 'package:pjm_palmerah/custom/preference_profile.dart';
import 'package:pjm_palmerah/screen/menu.dart';
import 'package:pjm_palmerah/screen/product/Menampilkan_produk_di_edit_produk.dart';
import 'package:pjm_palmerah/screen/product/add_product.dart';
import 'package:pjm_palmerah/screen/product/menampilkan_kategori_produk.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MenuKelolaProduk extends StatefulWidget {
  @override
  _MenuKelolaProdukState createState() => _MenuKelolaProdukState();
}

class _MenuKelolaProdukState extends State<MenuKelolaProduk> {
  bool login = false;
  String idUsers, level, namaLengkap, email, phone, deviceID;
  getPrefences() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      idUsers = preferences.getString(Preference.id);
      namaLengkap = preferences.getString(Preference.namaLengkap);
      email = preferences.getString(Preference.email);
      phone = preferences.getString(Preference.phone);
      level = preferences.getString(Preference.level);
      login = preferences.getBool(Preference.login) ?? false;
    });
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
    getPrefences();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Kelola Produk",
          style: TextStyle(
            color: Colors.amber,
            fontSize: displayWidth(context) * 0.05,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: ListView(
        children: <Widget>[
          Card(
            child: Column(
              children: <Widget>[
                Divider(),
                ListTile(
                  leading: Icon(Icons.edit, color: Colors.orange),
                  title: Text(
                    "Edit & Hapus Produk",
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: displayWidth(context) * 0.04,
                    ),
                  ),
                  trailing: Icon(Icons.keyboard_arrow_right),
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                MenampilkanProdukEditProduk()));
                  },
                ),
                Divider(),
              ],
            ),
          ),
          Card(
            child: Column(
              children: <Widget>[
                Divider(),
                ListTile(
                  leading: Icon(Icons.edit, color: Colors.orange),
                  title: Text(
                    "Tambah Produk",
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: displayWidth(context) * 0.04,
                    ),
                  ),
                  trailing: Icon(Icons.keyboard_arrow_right),
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => AddProduct(context)));
                  },
                ),
                Divider(),
              ],
            ),
          ),
          Card(
            child: Column(
              children: <Widget>[
                Divider(),
                ListTile(
                  leading: Icon(Icons.edit, color: Colors.orange),
                  title: Text(
                    "Kelola Kategori Produk",
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: displayWidth(context) * 0.04,
                    ),
                  ),
                  trailing: Icon(Icons.keyboard_arrow_right),
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => MenampilkanKategoriProduk()));
                  },
                ),
                Divider(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
