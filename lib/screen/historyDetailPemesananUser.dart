import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pjm_palmerah/custom/SizeHelper.dart';
import 'package:pjm_palmerah/model/StatusPesananModel.dart';
import 'package:pjm_palmerah/network/network.dart';
import 'package:pjm_palmerah/screen/update_status_pemesanan.dart';

class HistoryDetailPemesananUser extends StatefulWidget {
  final StatusPesananModel model;
  HistoryDetailPemesananUser(this.model);
  @override
  _HistoryDetailPemesananUserState createState() =>
      _HistoryDetailPemesananUserState();
}

class _HistoryDetailPemesananUserState
    extends State<HistoryDetailPemesananUser> {
  var totalHargaPembelian = "0";
  getTotalBarangDikeranjang() async {
    final response = await http.get(Uri.tryParse(
        NetworkUrl.getPenjumlahanTotalPembelian(widget.model.noInvoice)));
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body)[0];
      String total = data['total'];
      // ignore: unnecessary_brace_in_string_interps
      // print(" Total Cart ${total}");
      setState(() {
        totalHargaPembelian = total;
      });
    } else {}
  }

  final price = NumberFormat("#,##0", 'en_US');
  @override
  void initState() {
    super.initState();
    getTotalBarangDikeranjang();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 1,
        title: Text(
          "Histori Detail Pemesanan User",
          style: TextStyle(
            color: Colors.amber,
            fontSize: displayWidth(context) * 0.05,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: ListView(
        padding: EdgeInsets.all(16),
        children: <Widget>[
          Text(
            "No. Invoice : ${widget.model.noInvoice}",
            style: TextStyle(
              fontSize: displayWidth(context) * 0.035,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(
            height: 8,
          ),
          Text(
            "Tanggal CheckOut : ${widget.model.tanggalTransaksi}",
            style: TextStyle(
              fontSize: displayWidth(context) * 0.035,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(
            height: 8,
          ),
          Text(
            widget.model.status == "1"
                ? "Status : Dalam Pengiriman"
                : widget.model.status == "0"
                    ? "Status : Pending"
                    : "Status : Sudah diterima",
            style: TextStyle(
                fontSize: displayWidth(context) * 0.030,
                fontWeight: FontWeight.bold,
                color: Colors.red),
          ),
          Container(
            padding: EdgeInsets.symmetric(vertical: 4),
            child: Divider(
              color: Colors.green,
            ),
          ),
          ListView.builder(
            physics: ScrollPhysics(),
            scrollDirection: Axis.vertical,
            itemCount: widget.model.detail.length,
            shrinkWrap: true,
            itemBuilder: (context, i) {
              final a = widget.model.detail[i];

              return Row(
                children: <Widget>[
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        Text(
                          "Id Produk : ${a.idProduk}",
                          style: TextStyle(
                            fontSize: displayWidth(context) * 0.030,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        SizedBox(
                          height: 8,
                        ),
                        Text(
                          "Nama Produk : ${a.nama_produk}",
                          style: TextStyle(
                            fontSize: displayWidth(context) * 0.030,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        SizedBox(
                          height: 8,
                        ),
                        Text(
                          "Jumlah Barang : ${a.quantity} Barang ",
                          style: TextStyle(
                            fontSize: displayWidth(context) * 0.030,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        SizedBox(
                          height: 8,
                        ),
                        Text(
                          "Harga :  RP ${price.format(int.parse(a.harga))}",
                          style: TextStyle(
                            fontSize: displayWidth(context) * 0.030,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.symmetric(vertical: 5),
                          child: Divider(
                            color: Colors.green,
                          ),
                        ),
                        Container(
                          height: 200,
                          width: MediaQuery.of(context).size.width,
                          margin: EdgeInsets.only(
                            left: displayWidth(context) * 0.1,
                            right: displayWidth(context) * 0.05,
                            top: displayWidth(context) * 0.05,
                          ),
                          decoration: BoxDecoration(
                              color: Colors.amberAccent,
                              border: Border.all(
                                  color: Colors.blue,
                                  style: BorderStyle.solid)),
                          child: Image.network(
                            "https://pjmpalmerah.000webhostapp.com/products/${a.cover_produk}",
                            fit: BoxFit.fill,
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.symmetric(vertical: 5),
                          child: Divider(
                            color: Colors.green,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    width: 20,
                  ),
                ],
              );
            },
          ),
          SizedBox(
            height: 8,
          ),
          Text(
            "Jumlah Yang Harus Dibayar Customer",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: displayWidth(context) * 0.05,
            ),
          ),
          SizedBox(
            height: 8,
          ),
          Text(
            "RP ${price.format(int.parse(totalHargaPembelian))}",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.redAccent,
              fontSize: displayWidth(context) * 0.05,
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(vertical: 5),
            child: Divider(
              color: Colors.green,
            ),
          ),
          InkWell(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => UbahStatusPemesanan(widget.model)));
            },
            child: Container(
              padding: EdgeInsets.only(
                left: displayWidth(context) * 0.025,
                right: displayWidth(context) * 0.025,
                top: displayHeight(context) * 0.025,
                bottom: displayHeight(context) * 0.025,
              ),
              margin: EdgeInsets.only(
                left: displayWidth(context) * 0.1,
                right: displayWidth(context) * 0.05,
                top: displayHeight(context) * 0.05,
                bottom: displayHeight(context) * 0.05,
              ),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                gradient: LinearGradient(
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                    colors: [Colors.deepOrange, Colors.deepPurple]),
              ),
              child: Text(
                "Ubah Status Pemesanan",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: displayWidth(context) * 0.04,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
