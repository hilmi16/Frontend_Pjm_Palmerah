import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:pjm_palmerah/custom/SizeHelper.dart';

import 'package:pjm_palmerah/model/ProdukModel.dart';
import 'package:pjm_palmerah/network/network.dart';

import 'detail_produk.dart';

class PencarianProduk extends StatefulWidget {
  @override
  _PencarianProdukState createState() => _PencarianProdukState();
}

class _PencarianProdukState extends State<PencarianProduk> {
  var loading = false;

  List<ProdukModel> productList = [];
  List<ProdukModel> listPencarianProduct = [];

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

  final price = NumberFormat("#,##0", 'en_US');

  TextEditingController _controllerPencarianProduk = TextEditingController();

  dalamPencarian(String text) async {
    if (text.isEmpty) {
      setState(() {});
    }
    listPencarianProduct.clear();
    productList.forEach((a) {
      if (a.namaProduk.contains(text)) {
        listPencarianProduct.add(a);
      } else if (a.namaProduk.toLowerCase().contains(text)) {
        listPencarianProduct.add(a);
      } else if (a.namaProduk.toUpperCase().contains(text)) {
        listPencarianProduct.add(a);
      }
    });

    setState(() {});
  }

  Future<void> refreshHalaman() async {
    getProducts();
  }

  int index = 0;

  @override
  void initState() {
    super.initState();
    getProducts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Container(
          height: 50,
          padding: EdgeInsets.all(4),
          child: TextField(
            textAlign: TextAlign.left,
            autofocus: true,
            controller: _controllerPencarianProduk,
            onChanged: dalamPencarian,
            style: TextStyle(
              fontSize: 16,
            ),
            decoration: InputDecoration(
              hintText: "Pencarian Produk",
              fillColor: Colors.cyanAccent,
              hintStyle: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: displayWidth(context) * 0.035,
                  wordSpacing: 1.5),
              filled: true,
              suffixIcon: IconButton(icon: Icon(Icons.search), onPressed: null),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide(style: BorderStyle.none),
              ),
            ),
          ),
        ),
      ),
      body: Container(
          child: loading
              ? Center(
                  child: CircularProgressIndicator(),
                )
              : _controllerPencarianProduk.text.isNotEmpty ||
                      listPencarianProduct.length != 0
                  ? GridView.builder(
                      shrinkWrap: true,
                      physics: ClampingScrollPhysics(),
                      itemCount: listPencarianProduct.length,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        mainAxisSpacing: 10,
                        crossAxisSpacing: 10,
                      ),
                      itemBuilder: (context, i) {
                        final a = listPencarianProduct[i];

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
                                BoxShadow(
                                    blurRadius: 4, color: Colors.grey[300])
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
                                          fontSize:
                                              displayWidth(context) * 0.03,
                                        ),
                                      )
                                    : Text(
                                        " Stok : ${a.stok}",
                                        style: TextStyle(
                                          fontWeight: FontWeight.w500,
                                          color: Colors.red,
                                          fontSize:
                                              displayWidth(context) * 0.03,
                                        ),
                                      ),
                              ],
                            ),
                          ),
                        );
                      },
                    )
                  : Container(
                      padding: EdgeInsets.all(16),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: <Widget>[
                          Text(
                            "Cari Item Produk Yang Kamu Mau",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: displayWidth(context) * 0.05,
                            ),
                          )
                        ],
                      ),
                    )),
    );
  }
}
