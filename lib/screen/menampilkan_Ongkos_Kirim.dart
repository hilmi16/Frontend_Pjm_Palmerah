import 'dart:convert';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:pjm_palmerah/custom/SizeHelper.dart';
import 'package:pjm_palmerah/model/OngkosKirimModel.dart';
import 'package:pjm_palmerah/network/network.dart';
import 'package:pjm_palmerah/screen/update_ongkos_kirim.dart';

class MenampilkanOngkosKirim extends StatefulWidget {
  @override
  _MenampilkanOngkosKirimState createState() => _MenampilkanOngkosKirimState();
}

class _MenampilkanOngkosKirimState extends State<MenampilkanOngkosKirim> {
  TextEditingController namaKotaController = TextEditingController();
  TextEditingController ongkosKirimController = TextEditingController();
  bool loading = false;
  final price = NumberFormat("#,##0", 'en_US');
  var filter = false;

  List<OngkosKirimModel> ongkosKirimList = [];

  getOngkosKirim() async {
    setState(() {
      loading = true;
    });
    ongkosKirimList.clear();
    final response = await http.get(Uri.tryParse(NetworkUrl.getOngkosKirim()));
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);

      setState(() {
        for (Map i in data) {
          ongkosKirimList.add(OngkosKirimModel.fromJson(i));
        }
        loading = false;
      });
    } else {
      setState(() {
        loading = false;
      });
    }
  }

  tambahOngkosKirim() async {
    setState(() {
      loading = true;
    });
    var response =
        await http.post(Uri.tryParse(NetworkUrl.addOngkosKirim()), body: {
      "namaKota": namaKotaController.text,
      "ongkosKirim": ongkosKirimController.text,
    });
    var data = jsonDecode(response.body);
    int value = data['value'];
    print(value);
    String message = data['message'];
    print(message);
    if (value == 1) {
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
                                          MenampilkanOngkosKirim()));
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
      setState(() {
        loading = false;
      });
    } else {
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
                                          MenampilkanOngkosKirim()));
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
      setState(() {
        loading = false;
      });
    }
  }

  _deleteOngkosKirim(String idKota) async {
    final response = await http.post(
        Uri.tryParse(NetworkUrl.deleteOngkosKirim()),
        body: {'idKota': idKota});
    final data = jsonDecode(response.body);
    String message = data['message'];
    int value = data['value'];
    print(idKota);
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
                                          MenampilkanOngkosKirim()));
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
      setState(() {
        getOngkosKirim();
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
                                          MenampilkanOngkosKirim()));
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

  Future<void> refreshHalaman() async {
    getOngkosKirim();
    setState(() {
      filter = false;
    });
  }

  int index = 0;

  @override
  void initState() {
    super.initState();
    getOngkosKirim();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Kelola Ongkos Kirim",
          style: TextStyle(
            color: Colors.amber,
            fontSize: displayWidth(context) * 0.05,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: RefreshIndicator(
        onRefresh: refreshHalaman,
        child: Container(
          padding: EdgeInsets.all(20),
          child: ListView(
            children: <Widget>[
              new Padding(
                padding: EdgeInsets.only(
                  left: displayWidth(context) * 0.019,
                  top: displayHeight(context) * 0.023,
                  right: displayWidth(context) * 0.023,
                  bottom: displayHeight(context) * 0.023,
                ),
                child: new Text(
                  "Tambahkan Kota & Ongkos Kirim",
                  style: TextStyle(
                    fontSize: displayWidth(context) * 0.05,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

              SizedBox(
                height: 8,
              ),
              TextField(
                controller: namaKotaController,
                keyboardType: TextInputType.text,
                decoration: InputDecoration(labelText: "Masukkan Nama Kota"),
              ),
              SizedBox(
                height: 8,
              ),
              TextField(
                controller: ongkosKirimController,
                keyboardType: TextInputType.phone,
                decoration:
                    InputDecoration(labelText: "Masukkan Nominal Ongkos Kirim"),
              ),
              SizedBox(
                height: 16,
              ),

              // //ini adalah Button yang dibuat dengan Widget Container
              InkWell(
                onTap: () {
                  tambahOngkosKirim();
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
                    "Tambah Ongkos Kirim",
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

              new Padding(
                padding: EdgeInsets.only(
                  left: displayWidth(context) * 0.023,
                  top: displayHeight(context) * 0.023,
                  right: displayWidth(context) * 0.023,
                  bottom: displayHeight(context) * 0.023,
                ),
                child: new Text(
                  "Hapus & Edit Ongkos Kirim",
                  style: TextStyle(
                    fontSize: displayWidth(context) * 0.05,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SizedBox(
                height: 16,
              ),

              // menampilkan kategori produk
              GridView.builder(
                  shrinkWrap: true,
                  physics: ClampingScrollPhysics(),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 5,
                    crossAxisSpacing: 5,
                  ),
                  itemCount: ongkosKirimList.length,
                  itemBuilder: (context, i) {
                    final a = ongkosKirimList[i];
                    return InkWell(
                      onTap: () {},
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(
                            width: displayWidth(context) * 0.005,
                            color: Colors.grey[300],
                          ),
                          borderRadius: BorderRadius.circular(15),
                          boxShadow: [
                            BoxShadow(blurRadius: 4, color: Colors.grey[300])
                          ],
                          color: Colors.white,
                        ),
                        padding: EdgeInsets.all(6.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          verticalDirection: VerticalDirection.down,
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: <Widget>[
                            Expanded(
                              child: Stack(
                                children: <Widget>[
                                  Text(
                                    a.namaKota,
                                    style: TextStyle(
                                        color: Colors.red,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Positioned(
                                    bottom: displayHeight(context) * 0.01,
                                    left: displayWidth(context) * 0,
                                    child: Text(
                                      "Rp. ${price.format(int.parse(a.ongkosKirim))}",
                                      style: TextStyle(
                                          color: Colors.red,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  Positioned(
                                    height: displayHeight(context) * 0.06,
                                    width: displayWidth(context) * 0.12,
                                    bottom: displayHeight(context) * 0.06,
                                    left: displayWidth(context) * 0,
                                    child: Container(
                                        decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: Colors.white),
                                        child: IconButton(
                                            icon: Icon(Icons.delete),
                                            onPressed: () {
                                              _deleteOngkosKirim(a.idKota);
                                            })),
                                  ),
                                  Positioned(
                                    height: displayHeight(context) * 0.06,
                                    width: displayWidth(context) * 0.12,
                                    bottom: displayHeight(context) * 0.06,
                                    right: displayWidth(context) * 0,
                                    child: Container(
                                        decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: Colors.white),
                                        child: IconButton(
                                            icon: Icon(Icons.edit),
                                            onPressed: () {
                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          UpdateOngkosKirim(
                                                              a)));
                                            })),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              height: 6,
                            ),
                          ],
                        ),
                      ),
                    );
                  }),
              SizedBox(
                height: 10,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
