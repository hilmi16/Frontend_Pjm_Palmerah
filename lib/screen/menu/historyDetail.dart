import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_open_whatsapp/flutter_open_whatsapp.dart';
import 'package:intl/intl.dart';
import 'package:pjm_palmerah/custom/SizeHelper.dart';
import 'package:pjm_palmerah/model/HistoryModel.dart';
import 'package:pjm_palmerah/network/network.dart';
import 'package:pjm_palmerah/screen/konfirmasi_pembayaran.dart';
import 'package:http/http.dart' as http;

class HistoryDetail extends StatefulWidget {
  final HistoryModel model;

  HistoryDetail(this.model);
  @override
  _HistoryDetailState createState() => _HistoryDetailState();
}

class _HistoryDetailState extends State<HistoryDetail> {
  final price = NumberFormat("#,##0", 'en_US');
  var totalHargaPembelian = "0";
  getPenjumlahanTotalPembelian() async {
    final response = await http.get(Uri.tryParse(
        NetworkUrl.getPenjumlahanTotalPembelian(widget.model.noInvoice)));
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body)[0];
      String total = data['total'];
      setState(() {
        totalHargaPembelian = total;
      });
    } else {}
  }

  Future<void> refreshHalaman() async {
    setState(() {
      getPenjumlahanTotalPembelian();
    });
  }

  @override
  void initState() {
    super.initState();
    getPenjumlahanTotalPembelian();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);

    return Scaffold(
      appBar: AppBar(
        elevation: 1,
        title: Text(
          "Detail Pemesanan",
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
          padding: EdgeInsets.all(16),
          children: <Widget>[
            Container(
              child: Divider(
                color: Colors.green,
              ),
            ),
            Text(
              "No. Invoice : ${widget.model.noInvoice}",
              style: TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: displayWidth(context) * 0.035,
              ),
            ),
            SizedBox(
              height: 8,
            ),
            Text(
              "Tanggal : ${widget.model.tanggalTransaksi}",
              style: TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: displayWidth(context) * 0.035,
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
                color: Colors.red,
                fontSize: displayWidth(context) * 0.03,
                fontWeight: FontWeight.w500,
              ),
            ),
            Container(
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
                        // Desain tampilan list

                        crossAxisAlignment: CrossAxisAlignment.stretch,

                        children: <Widget>[
                          SizedBox(
                            height: 8,
                          ),
                          Text(
                            "Nama Produk : ${a.nama_produk}",
                            style: TextStyle(
                              fontSize: displayWidth(context) * 0.03,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          SizedBox(
                            height: 8,
                          ),
                          Text(
                            "Jumlah Barang : ${a.quantity} Barang (${a.berat} KG)",
                            style: TextStyle(
                              fontSize: displayWidth(context) * 0.03,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          SizedBox(
                            height: 8,
                          ),
                          Text(
                            "Sub Total (Termasuk Ongkos Kirim) : RP ${price.format(int.parse(a.harga))}",
                            style: TextStyle(
                              fontSize: displayWidth(context) * 0.03,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Container(
                            height: 200,
                            width: MediaQuery.of(context).size.width,
                            margin: EdgeInsets.only(
                              left: 40,
                              right: 20,
                              top: 20,
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
                          SizedBox(
                            height: 10,
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
              "Jumlah Yang Harus Dibayar",
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
            SizedBox(
              height: 25,
            ),
            Container(
              padding: EdgeInsets.symmetric(vertical: 5),
              child: Divider(
                color: Colors.green,
              ),
            ),
            widget.model.status == '0'
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        "Informasi",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.red,
                          fontWeight: FontWeight.bold,
                          fontSize: displayWidth(context) * 0.05,
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        "1. Untuk pembayaran dapat dikirim ke no.Rek BCA : 160-223-2354 a/n PjmPalmerah setelah melakukan proses pembayaran silahkan lakukan konfirmasi pada menu konfirmasi pembayaran atau tekan tombol konfirmasi pembayaran dibawah ini ",
                        textAlign: TextAlign.justify,
                        style: TextStyle(
                          color: Colors.redAccent,
                          fontWeight: FontWeight.w500,
                          fontSize: displayWidth(context) * 0.04,
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      InkWell(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      KonfirmasiPembayaran(widget.model)));
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
                            right: displayWidth(context) * 0.1,
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
                            "Konfirmasi Pembayaran",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: displayWidth(context) * 0.04,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        "2. Setelah melakukan konfirmasi pembayaran admin akan segera merespon pesanan anda dalam 1x24 jam. Apabila dalam waktu 1x24 jam belum ada perubahan status / status masih pending silahkan hubungi kami via Whatsapp melalui tombol dibawah ini ",
                        textAlign: TextAlign.justify,
                        style: TextStyle(
                          color: Colors.redAccent,
                          fontWeight: FontWeight.w500,
                          fontSize: displayWidth(context) * 0.04,
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      InkWell(
                        onTap: () {
                          FlutterOpenWhatsapp.sendSingleMessage(
                              "+62895376676901",
                              "Hallo Admin, kenapa status pemesanan dengan No.Invoice : ${widget.model.noInvoice} saya belum berubah?");
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
                            right: displayWidth(context) * 0.1,
                            top: displayHeight(context) * 0.05,
                            bottom: displayHeight(context) * 0.05,
                          ),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            gradient: LinearGradient(
                                begin: Alignment.centerLeft,
                                end: Alignment.centerRight,
                                colors: [Colors.greenAccent, Colors.blue]),
                          ),
                          child: Text(
                            "Hubungi Kami Via Whatsapp",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: displayWidth(context) * 0.04,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                    ],
                  )
                : SizedBox(),
          ],
        ),
      ),
    );
  }
}
