import 'dart:convert';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:pjm_palmerah/custom/SizeHelper.dart';
import 'package:pjm_palmerah/model/KategoriProdukModel.dart';
import 'package:pjm_palmerah/network/network.dart';
import 'package:pjm_palmerah/screen/product/menampilkan_kategori_produk.dart';

class UpdateNamaKategoriProduk extends StatefulWidget {
  final KategoriProdukModel model;
  UpdateNamaKategoriProduk(this.model);

  @override
  _UpdateNamaKategoriProdukState createState() =>
      _UpdateNamaKategoriProdukState();
}

class _UpdateNamaKategoriProdukState extends State<UpdateNamaKategoriProduk> {
  TextEditingController updateNamaKategoriProdukController;
  setup() {
    updateNamaKategoriProdukController =
        TextEditingController(text: widget.model.namaKategori);
  }

  bool loading = false;

  _updateNamaKategoriProduk() async {
    final response = await http
        .post(Uri.tryParse(NetworkUrl.updateNamaKategoriProduk()), body: {
      'idKategoriProduk': widget.model.id,
      'namaKategoriProduk': updateNamaKategoriProdukController.text,
    });
    final data = jsonDecode(response.body);
    String message = data['message'];
    int value = data['value'];

    if (value == 1) {
      print(message);
      showDialog(
          context: context,
          builder: (context) {
            return Platform.isAndroid
                ? AlertDialog(
                    title: Text("Perhatian"),
                    content: Text("$message"),
                    actions: <Widget>[
                      TextButton(
                          onPressed: () {
                            setState(() {
                              Navigator.pop(context);
                              Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          MenampilkanKategoriProduk()));
                            });
                          },
                          child: Text("Ok"))
                    ],
                  )
                : CupertinoAlertDialog(
                    title: Text("Perhatian"),
                    content: Text("$message"),
                    actions: <Widget>[
                      TextButton(
                          onPressed: () {
                            setState(() {
                              Navigator.pop(context);
                              Navigator.pop(context);
                            });
                          },
                          child: Text("Ok"))
                    ],
                  );
          });
    } else {
      print(message);
      showDialog(
          context: context,
          builder: (context) {
            return Platform.isAndroid
                ? AlertDialog(
                    title: Text("Perhatian"),
                    content: Text("$message"),
                    actions: <Widget>[
                      TextButton(
                          onPressed: () {
                            setState(() {
                              Navigator.pop(context);
                              Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          MenampilkanKategoriProduk()));
                            });
                          },
                          child: Text("Ok"))
                    ],
                  )
                : CupertinoAlertDialog(
                    title: Text("Perhatian"),
                    content: Text("$message"),
                    actions: <Widget>[
                      TextButton(
                          onPressed: () {
                            setState(() {
                              Navigator.pop(context);
                              Navigator.pop(context);
                            });
                          },
                          child: Text("Ok"))
                    ],
                  );
          });
    }
  }

  int index = 0;

  @override
  void initState() {
    super.initState();
    setup();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          " Update Nama Kategori",
          style: TextStyle(
            color: Colors.amber,
            fontSize: displayWidth(context) * 0.05,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: Container(
        padding: EdgeInsets.all(20),
        child: ListView(
          children: <Widget>[
            TextField(
              controller: updateNamaKategoriProdukController,
              keyboardType: TextInputType.text,
              decoration:
                  InputDecoration(labelText: "Masukkan Nama Kategori Produk"),
            ),
            SizedBox(
              height: 16,
            ),

            //ini adalah Button yang dibuat dengan Widget Container
            InkWell(
              onTap: () {
                _updateNamaKategoriProduk();
              },
              child: Container(
                padding: EdgeInsets.only(
                  left: displayWidth(context) * 0.025,
                  right: displayWidth(context) * 0.025,
                  top: displayHeight(context) * 0.025,
                  bottom: displayHeight(context) * 0.025,
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  gradient: LinearGradient(
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                      colors: [Colors.deepOrange, Colors.deepPurple]),
                ),
                child: Text(
                  "Ganti Nama Kategori Produk",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: displayWidth(context) * 0.04,
                  ),
                ),
              ),
            ),
            Divider(),

            SizedBox(
              height: 10,
            ),
          ],
        ),
      ),
    );
  }
}
