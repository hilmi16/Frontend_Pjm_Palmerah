import 'dart:convert';
import 'dart:io';
import 'package:device_info/device_info.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pjm_palmerah/custom/SizeHelper.dart';
import 'package:pjm_palmerah/custom/preference_profile.dart';
import 'package:pjm_palmerah/model/OngkosKirimModel.dart';
import 'package:pjm_palmerah/network/network.dart';
import 'package:pjm_palmerah/screen/menu.dart';
import 'package:pjm_palmerah/screen/historiTransaksiSetelahCheckout.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class DataPembeli extends StatefulWidget {
  @override
  _DataPembeliState createState() => _DataPembeliState();
}

class _DataPembeliState extends State<DataPembeli> {
  String idUsers, level, unikID, _selectedFieldId, namaLengkap, phone;
  final price = NumberFormat("#,##0", 'en_US');
  // ignore: deprecated_member_use
  List<OngkosKirimModel> _fieldList = List();
  DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();

  var loading = false;
  var checkData = false;

  getDeviceInfo() async {
    var build = await deviceInfo.androidInfo;
    SharedPreferences preferences = await SharedPreferences.getInstance();

    setState(() {
      unikID = build.androidId;
      idUsers = preferences.getString(Preference.id);
      namaLengkap = preferences.getString(Preference.namaLengkap);
      level = preferences.getString(Preference.level);
      phone = preferences.getString(Preference.phone);
    });
    setup();
    _getFieldsData();
  }

  TextEditingController namaPenerima, nomorPenerima, alamatPenerima;
  setup() {
    namaPenerima = TextEditingController(text: namaLengkap);
    nomorPenerima = TextEditingController(text: phone);
    alamatPenerima = TextEditingController();
  }

  checkOut() async {
    setState(() {
      loading = true;
    });
    var response = await http.post(Uri.tryParse(NetworkUrl.checkOut()), body: {
      "idUser": idUsers,
      "unikID": unikID,
      "namaPenerima": namaPenerima.text,
      "alamatPenerima": alamatPenerima.text,
      "nomorPenerima": nomorPenerima.text,
      "ongkosKirim": _selectedFieldId,
    });
    var data = jsonDecode(response.body);

    int value = data['value'];

    String message = data['message'];

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
                                          HistoriTransaksiSetelahCheckout()));
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
                                      builder: (context) => Menu()));
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

  Future<String> _getDropDownData() async {
    var res = await http
        .get(Uri.tryParse(Uri.encodeFull(NetworkUrl.getOngkosKirim())));
    return res.body;
  }

  void _getFieldsData() {
    _getDropDownData().then((data) {
      final items = jsonDecode(data).cast<Map<String, dynamic>>();
      var fieldListData = items.map<OngkosKirimModel>((json) {
        return OngkosKirimModel.fromJson(json);
      }).toList();

      _selectedFieldId = fieldListData[0].ongkosKirim;
      print("Id Ongkir : " + _selectedFieldId);
      // update widget
      if (!mounted) {
        return; // Just do nothing if the widget is disposed.
      }
      setState(() {
        _fieldList = fieldListData;
      });
    });
  }

  kirimNotifikasi(String level1) async {
    await http.post(
      Uri.tryParse(NetworkUrl.kirimNotifikasiAdmin(namaLengkap, level1)),
    );
  }

  @override
  void initState() {
    super.initState();
    getDeviceInfo();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.pushReplacement(
                    context, MaterialPageRoute(builder: (context) => Menu()));
              }),
          title: Text(
            "Form CheckOut",
            style: TextStyle(
              color: Colors.amber,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          centerTitle: true,
          elevation: 0.0,
        ),
        body: Form(
          child: ListView(
            padding: EdgeInsets.all(8),
            children: <Widget>[
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  SizedBox(
                    height: 10,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    "Silahkan Lengkapi Form CheckOut",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: Colors.red,
                        fontWeight: FontWeight.bold,
                        fontSize: 20),
                  ),
                ],
              ),
              SizedBox(
                height: displayHeight(context) * 0.04,
              ),
              TextFormField(
                controller: namaPenerima,
                decoration: InputDecoration(
                  labelText: "Nama Lengkap",
                  filled: true,
                ),
              ),
              SizedBox(
                height: displayHeight(context) * 0.02,
              ),
              TextFormField(
                controller: nomorPenerima,
                keyboardType: TextInputType.phone,
                decoration: InputDecoration(
                  labelText: "Nomor Ponsel",
                  filled: true,
                ),
              ),
              SizedBox(
                height: displayHeight(context) * 0.02,
              ),
              TextFormField(
                keyboardType: TextInputType.multiline,
                maxLines: null,
                controller: alamatPenerima,
                decoration: InputDecoration(
                  labelText: "Alamat Pengiriman",
                  filled: true,
                ),
              ),
              SizedBox(
                height: displayHeight(context) * 0.02,
              ),
              FormField<String>(
                builder: (FormFieldState<String> state) {
                  return Padding(
                    padding: const EdgeInsets.all(16),
                    child: InputDecorator(
                      decoration: InputDecoration(
                          filled: true,
                          labelText: "Silahkan Pilih Kota Tujuan Pengiriman",
                          labelStyle: TextStyle(
                              color: Colors.blueAccent, fontSize: 16.0),
                          errorStyle: TextStyle(
                              color: Colors.redAccent, fontSize: 16.0),
                          hintText: 'Silahkan Pilih Kota Tujuan Pengiriman',
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(6.0))),
                      isEmpty: _selectedFieldId == '',
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          items: _fieldList.map((value) {
                            return DropdownMenuItem(
                              value: value.ongkosKirim.toString(),
                              child: Padding(
                                padding:
                                    const EdgeInsets.only(left: 8, right: 8),
                                child: Row(
                                  children: [
                                    Text(
                                      value.namaKota,
                                      style: TextStyle(),
                                    ),
                                    SizedBox(
                                      width: displayWidth(context) * 0.01,
                                    ),
                                    Text(
                                        "RP ${price.format(int.parse(value.ongkosKirim))}/KG"),
                                  ],
                                ),
                              ),
                            );
                          }).toList(),
                          value: _selectedFieldId,
                          onChanged: (value) {
                            setState(() {
                              _selectedFieldId = value;
                            });
                          },
                        ),
                      ),
                    ),
                  );
                },
              ),
              SizedBox(
                height: displayHeight(context) * 0.03,
              ),
              InkWell(
                onTap: () {
                  checkOut();
                  kirimNotifikasi("2");
                },
                child: Container(
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    gradient: LinearGradient(
                        colors: [Colors.red, Colors.cyan[200]],
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight),
                  ),
                  child: Text(
                    "Pesan",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 30,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
