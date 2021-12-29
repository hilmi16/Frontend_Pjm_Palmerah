import 'dart:convert';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:pjm_palmerah/custom/SizeHelper.dart';
import 'package:pjm_palmerah/model/KategoriProdukModel.dart';
import 'package:pjm_palmerah/network/network.dart';
import 'package:pjm_palmerah/screen/product/update_nama_kategori_produk.dart';

class MenampilkanKategoriProduk extends StatefulWidget {
  @override
  _MenampilkanKategoriProdukState createState() =>
      _MenampilkanKategoriProdukState();
}

class _MenampilkanKategoriProdukState extends State<MenampilkanKategoriProduk> {
  final _key = new GlobalKey<FormState>();
  String kategoriProduk;
  bool loading = false;
  List<KategoriProdukModel> listKategori = [];

  getKategoriProduk() async {
    setState(() {
      loading = true;
    });
    listKategori.clear();
    final response =
        await http.get(Uri.tryParse(NetworkUrl.getKategoriProduk()));
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      setState(() {
        for (Map i in data) {
          listKategori.add(KategoriProdukModel.fromJson(i));
        }
        loading = false;
      });
    } else {
      setState(() {
        loading = false;
      });
    }
  }

  check() async {
    final form = _key.currentState;
    if (form.validate()) {
      form.save();
      tambahKategoriProduk();
    }
  }

  tambahKategoriProduk() async {
    setState(() {
      loading = true;
    });
    var response =
        await http.post(Uri.tryParse(NetworkUrl.addKategoriProduk()), body: {
      "namaKategoriProduk": kategoriProduk,
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
                    title: Text("Informasi"),
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
                    title: Text("Informasi"),
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
      setState(() {
        loading = false;
      });
    }
  }

  _deleteKategoriProduk(String idKategori) async {
    final response = await http.post(
        Uri.tryParse(NetworkUrl.deleteKategoriProducts()),
        body: {'idKategoriProduk': idKategori});
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
      setState(() {
        getKategoriProduk();
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

  Future<void> refreshHalaman() async {
    getKategoriProduk();
  }

  int index = 0;

  @override
  void initState() {
    super.initState();
    getKategoriProduk();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Kelola Kategori Produk",
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
            child: Form(
              key: _key,
              child: ListView(
                children: <Widget>[
                  new Padding(
                    padding: EdgeInsets.only(
                      left: displayWidth(context) * 0.019,
                      top: displayWidth(context) * 0.023,
                      right: displayWidth(context) * 0.023,
                      bottom: displayWidth(context) * 0.023,
                    ),
                    child: new Text(
                      "Tambahkan Kategori Produk",
                      style: TextStyle(
                        fontSize: displayWidth(context) * 0.05,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),

                  SizedBox(
                    height: 8,
                  ),
                  TextFormField(
                    // ignore: missing_return
                    validator: (e) {
                      if (e.isEmpty) {
                        return "Nama Kategori Produk Harus Diisi !!!";
                      }
                    },
                    onSaved: (e) => kategoriProduk = e,
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                      labelText: "Masukkan Kategori Produk",
                      labelStyle: TextStyle(
                        color: Colors.lightBlue,
                      ),
                      filled: true,
                      fillColor: Colors.white54,
                    ),
                  ),
                  SizedBox(
                    height: 16,
                  ),

                  // //ini adalah Button yang dibuat dengan Widget Container
                  InkWell(
                    onTap: () {
                      tambahKategoriProduk();
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
                        "Tambah Kategori Produk",
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
                    padding: const EdgeInsets.all(8.0),
                    child: new Text(
                      "Hapus & Edit Kategori Produk",
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
                      itemCount: listKategori.length,
                      itemBuilder: (context, i) {
                        final a = listKategori[i];
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
                                BoxShadow(
                                    blurRadius: 4, color: Colors.grey[300])
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
                                        a.namaKategori,
                                        style: TextStyle(
                                            color: Colors.red,
                                            fontWeight: FontWeight.bold),
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
                                                  _deleteKategoriProduk(a.id);
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
                                                              UpdateNamaKategoriProduk(
                                                                  a)));
                                                })),
                                      )
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
            )),
      ),
    );
  }
}
