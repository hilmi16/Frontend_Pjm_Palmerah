import 'dart:convert';
import 'package:device_info/device_info.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pjm_palmerah/custom/SizeHelper.dart';
import 'package:pjm_palmerah/model/ProdukModel.dart';
import 'package:http/http.dart' as http;
import 'package:pjm_palmerah/network/network.dart';
import 'package:pjm_palmerah/screen/menu.dart';
import 'package:pjm_palmerah/screen/product/Keranjang_Belanja.dart';

class DetailProduk extends StatefulWidget {
  final ProdukModel model;

  DetailProduk(this.model);

  @override
  _DetailProdukState createState() => _DetailProdukState();
}

class _DetailProdukState extends State<DetailProduk> {
  DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
  String deviceID;
  final price = NumberFormat("#,##0", 'en_US');

  getDeviceInfo() async {
    var build = await deviceInfo.androidInfo;

    setState(() {
      deviceID = build.androidId;
    });
  }

  masukkanKeranjangBelanjaNavigateToKeranjangBelanja() async {
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

    final response = await http.post(
        Uri.tryParse(NetworkUrl.addKeranjangBelanja()),
        body: {"unikID": deviceID, "idProduk": widget.model.id});
    final data = jsonDecode(response.body);
    int value = data['value'];
    String message = data['message'];
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
                    onPressed: () {
                      Navigator.pop(context);
                      setState(() {
                        Navigator.pop(context);
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => KeranjangBelanja()));
                      });
                    },
                    child: Text("Ok"))
              ],
            );
          });
    } else {
      Navigator.pop(context);
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text("Perhatian"),
              content: Text(message),
              actions: <Widget>[
                TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                      setState(() {
                        Navigator.pop(context);
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => KeranjangBelanja()));
                      });
                    },
                    child: Text("Ok"))
              ],
            );
          });
    }
  }

  masukkanKeranjangBelanja() async {
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

    final response = await http.post(
        Uri.tryParse(NetworkUrl.addKeranjangBelanja()),
        body: {"unikID": deviceID, "idProduk": widget.model.id});
    final data = jsonDecode(response.body);
    int value = data['value'];
    String message = data['message'];
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
                    onPressed: () {
                      Navigator.pop(context);
                      setState(() {
                        Navigator.pop(context);
                      });
                    },
                    child: Text("Ok"))
              ],
            );
          });
    } else {
      Navigator.pop(context);
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text("Perhatian"),
              content: Text(message),
              actions: <Widget>[
                TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                      setState(() {
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
  bool loading = false;
  //MENAMBAHKAN PRODUK FAVORIT
  tambahkanFavorit(ProdukModel model) async {
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
    final response = await http.post(
        Uri.tryParse(NetworkUrl.addFavoritProdukWithoutLogin()),
        body: {"deviceInfo": deviceID, "idProduk": model.id});
    final data = jsonDecode(response.body);
    int value = data['value'];
    String message = data['message'];
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
                  child: Text("Ok"),
                  onPressed: () {
                    Navigator.pop(context);
                    setState(() {
                      Navigator.pop(context);
                      Navigator.pushReplacement(context,
                          MaterialPageRoute(builder: (context) => Menu()));
                    });
                  },
                ),
              ],
            );
          });

      setState(() {
        loading = false;
      });
    } else {
      Navigator.pop(context);
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text("Perhatian"),
              content: Text(message),
              actions: <Widget>[
                TextButton(
                    child: Text("Ok"),
                    onPressed: () {
                      Navigator.pop(context);
                      setState(() {
                        Navigator.pop(context);
                        Navigator.pushReplacement(context,
                            MaterialPageRoute(builder: (context) => Menu()));
                      });
                    }),
              ],
            );
          });
      setState(() {
        loading = false;
      });
    }
  }

  Future<void> refreshHalaman() async {
    getDeviceInfo();
  }

  @override
  void initState() {
    super.initState();
    getDeviceInfo();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Detail Produk",
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
        child: ListView(
          children: <Widget>[
            Container(
              height: 300,
              child: GridTile(
                child: Container(
                  color: Colors.white,
                  child: Image.network(
                    "https://pjmpalmerah.000webhostapp.com/products/${widget.model.coverProduk}",
                    fit: BoxFit.cover,
                  ),
                ),
                footer: new Container(
                  color: Colors.white54,
                  child: ListTile(
                    leading: Text(
                      "${widget.model.namaProduk}",
                      textAlign: TextAlign.start,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                        fontSize: displayWidth(context) * 0.05,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Divider(
              color: Colors.grey,
            ),
            SizedBox(
              height: 10,
            ),
            Container(
              color: Colors.transparent,
              margin: EdgeInsets.only(left: 15),
              child: new Row(
                children: <Widget>[
                  int.tryParse(widget.model.stok) <= 0
                      ? Text(
                          "Stok   : Habis",
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            color: Colors.red,
                            fontSize: displayWidth(context) * 0.05,
                          ),
                        )
                      : Text(
                          "Stok   : ${widget.model.stok} PCS",
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            color: Colors.red,
                            fontSize: displayWidth(context) * 0.05,
                          ),
                        ),
                ],
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Container(
              color: Colors.transparent,
              margin: EdgeInsets.only(left: 15),
              child: new Row(
                children: <Widget>[
                  Text(
                    "Harga : Rp. ${price.format(widget.model.hargaProduk)}",
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      color: Colors.red,
                      fontSize: displayWidth(context) * 0.05,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Row(
              children: <Widget>[
                int.tryParse(widget.model.stok) <= 0
                    ? Container(
                        margin:
                            EdgeInsets.only(left: displayWidth(context) * 0.03),
                        child: MaterialButton(
                          padding: EdgeInsets.only(
                            left: displayWidth(context) * 0.28,
                            right: displayWidth(context) * 0.28,
                            top: displayHeight(context) * 0.01,
                            bottom: displayHeight(context) * 0.01,
                          ),
                          onPressed: () {
                            showDialog(
                                context: context,
                                builder: (context) {
                                  return AlertDialog(
                                    title: Text("Informasi"),
                                    content: Text(
                                        "Stok Sudah Habis Silahkan Pilih Produk Lain"),
                                    actions: <Widget>[
                                      TextButton(
                                          onPressed: () {
                                            Navigator.pop(context);
                                            setState(() {
                                              // Navigator.pop(context);
                                            });
                                          },
                                          child: Text("Ok"))
                                    ],
                                  );
                                });
                          },
                          color: Colors.red,
                          textColor: Colors.white,
                          elevation: 2,
                          child: new Text(
                            "Stok Habis",
                            style: TextStyle(
                              fontSize: displayWidth(context) * 0.05,
                            ),
                          ),
                        ),
                      )
                    : Container(
                        margin:
                            EdgeInsets.only(left: displayWidth(context) * 0.03),
                        child: MaterialButton(
                          enableFeedback: true,
                          padding: EdgeInsets.only(
                            left: displayWidth(context) * 0.18,
                            right: displayWidth(context) * 0.18,
                            top: displayHeight(context) * 0.01,
                            bottom: displayHeight(context) * 0.01,
                          ),
                          onPressed: () {
                            masukkanKeranjangBelanjaNavigateToKeranjangBelanja();
                          },
                          color: Colors.red,
                          textColor: Colors.white,
                          elevation: 2,
                          child: new Text(
                            "Beli Sekarang",
                            style: TextStyle(
                              fontSize: displayWidth(context) * 0.05,
                            ),
                          ),
                        ),
                      ),
                int.tryParse(widget.model.stok) <= 0
                    ? SizedBox()
                    : new IconButton(
                        iconSize: displayWidth(context) * 0.08,
                        icon: Icon(
                          Icons.add_shopping_cart,
                          color: Colors.redAccent,
                        ),
                        onPressed: () {
                          masukkanKeranjangBelanja();
                        }),
                new IconButton(
                    iconSize: displayWidth(context) * 0.08,
                    icon: Icon(
                      Icons.favorite_border,
                      color: Colors.redAccent,
                    ),
                    onPressed: () {
                      tambahkanFavorit(widget.model);
                    }),
              ],
            ),
            Divider(
              color: Colors.grey,
            ),
            new ListTile(
              title: Text(
                "Detail Produk",
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: displayWidth(context) * 0.05,
                    fontWeight: FontWeight.bold),
              ),
            ),
            Divider(
              color: Colors.grey,
            ),
            ListTile(
              subtitle: Text(
                "${widget.model.deskripsiProduk}",
                textAlign: TextAlign.justify,
                style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: displayWidth(context) * 0.04,
                    wordSpacing: 1.5),
              ),
            ),
            SizedBox(
              height: 20,
            ),
          ],
        ),
      ),
    );
  }
}
