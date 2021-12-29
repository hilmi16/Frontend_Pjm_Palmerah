import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:pjm_palmerah/custom/SizeHelper.dart';
import 'package:pjm_palmerah/model/ProdukModel.dart';
import 'package:pjm_palmerah/network/network.dart';
import 'package:pjm_palmerah/screen/product/edit_cover_produk.dart';

class MenampilkanProdukEditCoverProduk extends StatefulWidget {
  @override
  _MenampilkanProdukEditCoverProdukState createState() =>
      _MenampilkanProdukEditCoverProdukState();
}

class _MenampilkanProdukEditCoverProdukState
    extends State<MenampilkanProdukEditCoverProduk> {
  var loading = false;

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
          "Pilih Produk",
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
              child: ListView(children: <Widget>[
                SizedBox(
                  height: 16,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    Text(
                      "Silahkan Pilih Cover Produk Untuk Melakukan Perubahan Cover",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.red,
                        fontWeight: FontWeight.bold,
                        fontSize: displayWidth(context) * 0.04,
                      ),
                    ),
                  ],
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
                                builder: (context) => EditCoverProduk(a)));
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
    );
  }
}
