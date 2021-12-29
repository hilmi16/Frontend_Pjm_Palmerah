import 'dart:convert';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:pjm_palmerah/custom/SizeHelper.dart';
import 'package:pjm_palmerah/model/OngkosKirimModel.dart';
import 'package:pjm_palmerah/network/network.dart';
import 'package:pjm_palmerah/screen/menu/user.dart';

class UpdateOngkosKirim extends StatefulWidget {
  final OngkosKirimModel model;

  UpdateOngkosKirim(this.model);

  @override
  _UpdateOngkosKirimState createState() => _UpdateOngkosKirimState();
}

class _UpdateOngkosKirimState extends State<UpdateOngkosKirim> {
  TextEditingController updateNamaKotaController, updateOngkosKirimController;

  setup() {
    updateNamaKotaController =
        TextEditingController(text: widget.model.namaKota);
    updateOngkosKirimController =
        TextEditingController(text: widget.model.ongkosKirim);
  }

  bool loading = false;
  final price = NumberFormat("#,##0", 'en_US');

  _updateOngkosKirim() async {
    final response =
        await http.post(Uri.tryParse(NetworkUrl.updateOngkosKirim()), body: {
      'idKota': widget.model.idKota,
      'namaKota': updateNamaKotaController.text,
      'ongkosKirim': updateOngkosKirimController.text,
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
                                      builder: (context) => User()));
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
                                      builder: (context) => User()));
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
        padding: EdgeInsets.only(
          left: displayWidth(context) * 0.05,
          top: displayHeight(context) * 0.05,
          right: displayWidth(context) * 0.05,
          bottom: displayHeight(context) * 0.05,
        ),
        child: ListView(
          children: <Widget>[
            TextField(
              controller: updateNamaKotaController,
              keyboardType: TextInputType.text,
              decoration: InputDecoration(labelText: "Masukkan Nama Kota"),
            ),
            SizedBox(
              height: 10,
            ),
            TextField(
              controller: updateOngkosKirimController,
              keyboardType: TextInputType.phone,
              decoration:
                  InputDecoration(labelText: "Masukkan Nominal Ongkos Kirim"),
            ),

            SizedBox(
              height: 16,
            ),

            //ini adalah Button yang dibuat dengan Widget Container
            InkWell(
              onTap: () {
                _updateOngkosKirim();
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
                  "Menyimpan Perubahan",
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
