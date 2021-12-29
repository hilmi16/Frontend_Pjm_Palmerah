import 'dart:convert';
import 'package:device_info/device_info.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:pjm_palmerah/custom/SizeHelper.dart';
import 'package:pjm_palmerah/custom/preference_profile.dart';
import 'package:pjm_palmerah/model/KeranjangBelanjaModel.dart';
import 'package:pjm_palmerah/network/network.dart';
import 'package:pjm_palmerah/screen/loginCheckout.dart';
import 'package:pjm_palmerah/screen/product/dataPembeli.dart';
import 'package:shared_preferences/shared_preferences.dart';

class KeranjangBelanja extends StatefulWidget {
  @override
  _KeranjangBelanjaState createState() => _KeranjangBelanjaState();
}

class _KeranjangBelanjaState extends State<KeranjangBelanja> {
  List<KeranjangBelanjaModel> list = [];
  DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
  String unikID;
  final price = NumberFormat("#,##0", 'en_US');
  bool login = false;
  String idUser;
  String level;
  String idProduk;

  getDeviceInfo() async {
    var build = await deviceInfo.androidInfo;
    SharedPreferences preferences = await SharedPreferences.getInstance();

    setState(() {
      unikID = build.androidId;
      //Mengambil preference apakah sudah login?
      login = preferences.getBool(Preference.login) ??
          false; //maksud dari ?? false (Jika data dari Preference.logi = null maka boolean login menjadi false sehingga tidak memberikan nilai null pada boolean)
      idUser = preferences.getString(Preference.id);
      level = preferences.getString(Preference.level);
    });
    _fetchData();
  }

  _menambahQuantity(KeranjangBelanjaModel model) async {
    await http.post(Uri.tryParse(NetworkUrl.menambahQuantityKeranjangBelanja()),
        body: {"idProduk": model.id, "unikID": unikID});

    return setState(() {
      _fetchData();
    });
  }

  _mengurangiQuantity(KeranjangBelanjaModel model) async {
    await http.post(
        Uri.tryParse(NetworkUrl.mengurangiQuantityKeranjangBelanja()),
        body: {"idProduk": model.id, "unikID": unikID});

    return setState(() {
      _fetchData();
    });
  }

  var loading = false;
  var cekData = false;

  _fetchData() async {
    setState(() {
      loading = true;
    });

    final response =
        await http.get(Uri.tryParse(NetworkUrl.getKeranjangBelanja(unikID)));
    if (response.statusCode == 200) {
      list.clear();
      if (response.contentLength == 2) {
        setState(() {
          loading = false;
          cekData = false;
        });
      } else {
        setState(() {
          loading = false;
          cekData = true;
        });
        final data = jsonDecode(response.body);
        for (Map i in data) {
          list.add(KeranjangBelanjaModel.fromJson(i));
        }

        _getPenjumlahanTotalHarga();
      }
    } else {
      setState(() {
        loading = false;
        cekData = false;
      });
    }
  }

  var totalHarga = "0";
  _getPenjumlahanTotalHarga() async {
    setState(() {
      loading = true;
    });
    final response = await http.get(Uri.tryParse(
        NetworkUrl.getPenjumlahanTotalHargaBarangDalamKeranjang(unikID)));
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body)[0];
      String total = data['total'];
      setState(() {
        loading = false;
        totalHarga = total;
      });
    } else {
      loading = false;
    }
  }

  loginTrue() async {
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => DataPembeli()));
  }

  loginFalse() async {
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => LoginCheckout()));
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
          "Keranjang Belanja",
          style: TextStyle(
            color: Colors.amber,
            fontSize: displayWidth(context) * 0.05,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        elevation: 1,
        // leading: IconButton(
        //     icon: Icon(Icons.arrow_back),
        //     onPressed: () => Navigator.pushReplacement(
        //         context, MaterialPageRoute(builder: (context) => Menu()))),
      ),
      body: Container(
        padding: EdgeInsets.all(16),
        child: loading
            ? Center(
                child: CircularProgressIndicator(),
              )
            : cekData
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Expanded(
                        child: ListView.builder(
                          itemCount: list.length,
                          shrinkWrap: true,
                          physics: ClampingScrollPhysics(),
                          itemBuilder: (context, i) {
                            final a = list[i];
                            return Container(
                              child: Row(
                                children: <Widget>[
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.stretch,
                                      children: <Widget>[
                                        SizedBox(
                                          height: 7,
                                        ),
                                        Text(
                                          "Nama Produk : ${a.namaProduk}",
                                          style: TextStyle(
                                            fontSize:
                                                displayWidth(context) * 0.04,
                                          ),
                                        ),
                                        SizedBox(
                                          height: 7,
                                        ),
                                        Text(
                                          "Quantity : ${a.quantity}",
                                          style: TextStyle(
                                            fontSize:
                                                displayWidth(context) * 0.04,
                                          ),
                                        ),
                                        SizedBox(
                                          height: 7,
                                        ),
                                        Text(
                                          "Harga : Rp. ${price.format(a.hargaProduk)}",
                                          style: TextStyle(
                                            fontSize:
                                                displayWidth(context) * 0.04,
                                          ),
                                        ),
                                        Container(
                                          padding:
                                              EdgeInsets.symmetric(vertical: 2),
                                          child: Divider(
                                            color: Colors.grey,
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                  Container(
                                      child: IconButton(
                                          icon: Icon(Icons.remove),
                                          onPressed: () {
                                            _mengurangiQuantity(a);
                                          })),
                                  Container(
                                    child: Text("${a.quantity}"),
                                  ),
                                  Container(
                                      child: IconButton(
                                          icon: Icon(Icons.add),
                                          onPressed: () {
                                            _menambahQuantity(a);
                                          })),
                                ],
                              ),
                            );
                          },
                        ),
                      ),
                      totalHarga == "0"
                          ? SizedBox()
                          : Container(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Text(
                                    "Estimasi Total  : Rp. ${price.format(int.parse(totalHarga))} ",
                                    style: TextStyle(
                                        fontSize: displayWidth(context) * 0.04,
                                        color: Colors.deepOrangeAccent,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  SizedBox(
                                    width: displayWidth(context) * 0.1,
                                  ),
                                  InkWell(
                                    onTap: () {
                                      login ? loginTrue() : loginFalse();
                                    },
                                    child: Container(
                                      padding: EdgeInsets.only(
                                        left: displayWidth(context) * 0.04,
                                        right: displayWidth(context) * 0.04,
                                        top: displayHeight(context) * 0.03,
                                        bottom: displayHeight(context) * 0.03,
                                      ),
                                      decoration: BoxDecoration(
                                          shape: BoxShape.rectangle,
                                          borderRadius:
                                              BorderRadius.circular(20),
                                          color: Colors.amber),
                                      child: Text(
                                        "CheckOut",
                                        style: TextStyle(
                                            fontSize:
                                                displayWidth(context) * 0.03,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            )
                    ],
                  )
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        "Kamu Belum Memiliki Produk Didalam Keranjang",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: displayWidth(context) * 0.048,
                            fontWeight: FontWeight.bold),
                      )
                    ],
                  ),
      ),
    );
  }
}
