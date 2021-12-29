import 'dart:convert';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:pjm_palmerah/custom/SizeHelper.dart';
import 'package:pjm_palmerah/model/ProdukModel.dart';
import 'package:pjm_palmerah/network/network.dart';
import 'package:pjm_palmerah/screen/product/detail_produk.dart';
import 'package:pjm_palmerah/screen/product/edit_produk.dart';
import 'package:pjm_palmerah/screen/product/menampilkan_cover_produk.dart';

class MenampilkanProdukEditProduk extends StatefulWidget {
  @override
  _MenampilkanProdukEditProdukState createState() =>
      _MenampilkanProdukEditProdukState();
}

class _MenampilkanProdukEditProdukState
    extends State<MenampilkanProdukEditProduk> {
  var loading = false;
  String deviceID;
  List<ProdukModel> productList = [];

  getProducts() async {
    setState(() {
      loading = true;
    });
    productList.clear();
    final response = await http.get(Uri.tryParse(NetworkUrl.getProducts()));
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);

      setState(() {
        for (Map i in data) {
          productList.add(ProdukModel.fromJson(i));
        }
        loading = false;
      });
    } else {
      setState(() {
        loading = false;
      });
    }
  }

  final price = NumberFormat(
      "#,##0", 'en_US'); //sebuah variabel untuk memisahkan format HARGA

  Future<void> refreshHalaman() async {
    getProducts();
  }

  _deleteProduk(String id, String coverProduk) async {
    final response =
        await http.post(Uri.tryParse(NetworkUrl.deleteProducts()), body: {
      'idProduk': id,
      'cover_produk': coverProduk,
    });
    final data = jsonDecode(response.body);
    String message = data['message'];
    int value = data['value'];

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
                                          MenampilkanProdukEditProduk()));
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
        getProducts();
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
                                          MenampilkanProdukEditProduk()));
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
      print(message);
    }
  }

  @override
  void initState() {
    super.initState();
    getProducts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Edit & Hapus Produk",
          style: TextStyle(
            color: Colors.amber,
            fontSize: displayWidth(context) * 0.05,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: loading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : RefreshIndicator(
              onRefresh: refreshHalaman,
              child: Container(
                padding: EdgeInsets.all(6),
                child: ListView(children: <Widget>[
                  Card(
                    child: Column(
                      children: <Widget>[
                        Divider(),
                        ListTile(
                          leading: Icon(Icons.edit, color: Colors.orange),
                          title: Text(
                            "Edit Cover Produk",
                            style: TextStyle(
                              fontSize: displayWidth(context) * 0.04,
                            ),
                          ),
                          trailing: Icon(Icons.keyboard_arrow_right),
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        MenampilkanProdukEditCoverProduk()));
                          },
                        ),
                        Divider(),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  GridView.builder(
                    shrinkWrap: true,
                    physics: ClampingScrollPhysics(),
                    itemCount: productList.length,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      mainAxisSpacing: 10,
                      crossAxisSpacing: 10,
                    ),
                    itemBuilder: (context, i) {
                      final a = productList[i];

                      return InkWell(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => DetailProduk(a)));
                        },
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
                          padding: EdgeInsets.all(8),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            verticalDirection: VerticalDirection.down,
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: <Widget>[
                              Expanded(
                                child: Stack(
                                  children: <Widget>[
                                    Image.network(
                                        "https://pjmpalmerah.000webhostapp.com/products/${a.coverProduk}",
                                        height: displayHeight(context) * 0.9,
                                        width: displayWidth(context) * 1,
                                        fit: BoxFit.cover),
                                    Positioned(
                                      height: displayHeight(context) * 0.06,
                                      width: displayWidth(context) * 0.12,
                                      top: displayHeight(context) * 0,
                                      right: displayWidth(context) * 0,
                                      child: Container(
                                          decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              color: Colors.white),
                                          child: IconButton(
                                              icon: Icon(Icons.delete),
                                              onPressed: () {
                                                _deleteProduk(
                                                    a.id, a.coverProduk);
                                              })),
                                    ),
                                    Positioned(
                                      height: displayHeight(context) * 0.06,
                                      width: displayWidth(context) * 0.12,
                                      bottom: displayHeight(context) * 0,
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
                                                            EditProduk(a)));
                                              })),
                                    )
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: 6,
                              ),
                              Text(
                                "${a.namaProduk}",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                  fontSize: displayWidth(context) * 0.03,
                                ),
                              ),
                              SizedBox(
                                height: 6,
                              ),
                              Text(
                                "Rp. ${price.format(a.hargaProduk)}",
                                style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  color: Colors.red,
                                  fontSize: displayWidth(context) * 0.03,
                                ),
                              ),
                              SizedBox(
                                height: 6,
                              ),
                              int.tryParse(a.stok) <= 0
                                  ? Text(
                                      " Stok : Habis",
                                      style: TextStyle(
                                        fontWeight: FontWeight.w500,
                                        color: Colors.red,
                                        fontSize: displayWidth(context) * 0.03,
                                      ),
                                    )
                                  : Text(
                                      " Stok : ${a.stok}",
                                      style: TextStyle(
                                        fontWeight: FontWeight.w500,
                                        color: Colors.red,
                                        fontSize: displayWidth(context) * 0.03,
                                      ),
                                    ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                  SizedBox(
                    height: 30,
                  ),
                ]),
              ),
            ),
    );
  }
}
