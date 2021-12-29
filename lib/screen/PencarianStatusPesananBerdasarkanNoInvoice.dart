import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:pjm_palmerah/custom/SizeHelper.dart';
import 'package:pjm_palmerah/model/StatusPesananModel.dart';
import 'package:pjm_palmerah/network/network.dart';
import 'package:pjm_palmerah/screen/StatusPesananDetail.dart';

class PencarianStatusPesanan extends StatefulWidget {
  @override
  _PencarianStatusPesananState createState() => _PencarianStatusPesananState();
}

class _PencarianStatusPesananState extends State<PencarianStatusPesanan> {
  var loading = false;

  List<StatusPesananModel> statusPesananList = [];
  List<StatusPesananModel> listPencarianStatusPesanan = [];

  getStatusPesanan() async {
    setState(() {
      loading = true;
    });
    statusPesananList.clear();
    final response =
        await http.get(Uri.tryParse(NetworkUrl.getStatusPesanan()));
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);

      setState(() {
        for (Map i in data) {
          statusPesananList.add(StatusPesananModel.fromJson(i));
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

  TextEditingController _controllerPencarianNoInvoice = TextEditingController();

  dalamPencarian(String text) async {
    if (text.isEmpty) {
      setState(() {});
    }
    listPencarianStatusPesanan.clear();
    statusPesananList.forEach((a) {
      if (a.noInvoice.toLowerCase().contains(text)) {
        listPencarianStatusPesanan.add(a);
      } else if (a.idUsers.toLowerCase().contains(text)) {
        listPencarianStatusPesanan.add(a);
      } else if (a.namaPenerima.toLowerCase().contains(text)) {
        listPencarianStatusPesanan.add(a);
      } else if (a.status.toLowerCase().contains(text)) {
        listPencarianStatusPesanan.add(a);
      } else if (a.alamatPenerima.toLowerCase().contains(text)) {
        listPencarianStatusPesanan.add(a);
      } else if (a.tanggalTransaksi.toLowerCase().contains(text)) {
        listPencarianStatusPesanan.add(a);
      }
    });

    setState(() {});
  }

  Future<void> refreshHalaman() async {
    getStatusPesanan();
  }

  int index = 0;

  @override
  void initState() {
    super.initState();
    getStatusPesanan();
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
            controller: _controllerPencarianNoInvoice,
            onChanged: dalamPencarian,
            style: TextStyle(
                fontSize: displayWidth(context) * 0.035,
                fontWeight: FontWeight.w500,
                wordSpacing: 1.5),
            decoration: InputDecoration(
              hintText: "Cari Pesanan User",
              hintStyle: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: displayWidth(context) * 0.035,
                  wordSpacing: 1.5),
              fillColor: Colors.cyanAccent,
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
              : _controllerPencarianNoInvoice.text.isNotEmpty ||
                      listPencarianStatusPesanan.length != 0
                  ? ListView(
                      children: <Widget>[
                        Divider(),
                        ListView.builder(
                          padding: EdgeInsets.all(16),
                          itemCount: listPencarianStatusPesanan.length,
                          shrinkWrap: true,
                          physics: ClampingScrollPhysics(),
                          itemBuilder: (context, i) {
                            final a = listPencarianStatusPesanan[i];

                            //tinggal panggil valuenya misal Column()

                            return InkWell(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            StatusPesananDetail(a)));
                              },
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: <Widget>[
                                  Text(
                                    "No.Invoice : ${a.noInvoice}",
                                    style: TextStyle(
                                      fontSize: displayWidth(context) * 0.035,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(
                                    height: 5,
                                  ),
                                  Text(
                                    "Tanggal Transaksi : ${a.tanggalTransaksi}",
                                    style: TextStyle(
                                      fontSize: displayWidth(context) * 0.035,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Container(
                                    padding: EdgeInsets.symmetric(
                                      vertical: 10,
                                    ),
                                    child: Divider(
                                      color: Colors.green,
                                    ),
                                  ),
                                  SizedBox(
                                    height: 5,
                                  ),
                                  Text(
                                    a.status == "0"
                                        ? "Status : Pending"
                                        : "Status : Success",
                                    style: TextStyle(
                                        fontSize: displayWidth(context) * 0.030,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.red),
                                  ),
                                  SizedBox(
                                    height: 5,
                                  ),
                                  Text(
                                    "Nama penerima : ${a.namaPenerima}",
                                    style: TextStyle(
                                      fontSize: displayWidth(context) * 0.030,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  SizedBox(
                                    height: 5,
                                  ),
                                  Text(
                                    "Nomor Penerima : ${a.nomorPenerima}",
                                    style: TextStyle(
                                      fontSize: displayWidth(context) * 0.030,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  SizedBox(
                                    height: 5,
                                  ),
                                  Text(
                                    "Alamat Pengiriman : ${a.alamatPenerima}",
                                    style: TextStyle(
                                      fontSize: displayWidth(context) * 0.030,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  Container(
                                    padding: EdgeInsets.symmetric(
                                      vertical: 10,
                                    ),
                                    child: Divider(
                                      color: Colors.green,
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ],
                    )
                  : Container(
                      padding: EdgeInsets.all(16),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: <Widget>[
                          Text(
                            "Cari Pesanan User",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          )
                        ],
                      ),
                    )),
    );
  }
}
