import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:pjm_palmerah/custom/SizeHelper.dart';
import 'package:pjm_palmerah/model/UsersModel.dart';
import 'package:pjm_palmerah/network/network.dart';

class PencarianUsers extends StatefulWidget {
  @override
  _PencarianUsersState createState() => _PencarianUsersState();
}

class _PencarianUsersState extends State<PencarianUsers> {
  var loading = false;

  List<UsersModel> usersList = [];
  List<UsersModel> listPencarianUsers = [];

  getDaftarUsers() async {
    setState(() {
      loading = true;
    });
    usersList.clear();
    final response = await http.get(Uri.tryParse(NetworkUrl.getUsers()));
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);

      setState(() {
        for (Map i in data) {
          usersList.add(UsersModel.fromJson(i));
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

  TextEditingController _controllerPencarianUsers = TextEditingController();

  dalamPencarian(String text) async {
    if (text.isEmpty) {
      if (!mounted) {
        return; // Just do nothing if the widget is disposed.
      }
      setState(() {});
    }
    listPencarianUsers.clear();
    usersList.forEach((a) {
      if (a.namaLengkap.contains(text)) {
        listPencarianUsers.add(a);
      } else if (a.namaLengkap.toLowerCase().contains(text)) {
        listPencarianUsers.add(a);
      } else if (a.namaLengkap.toUpperCase().contains(text)) {
        listPencarianUsers.add(a);
      } else if (a.id.toLowerCase().contains(text)) {
        listPencarianUsers.add(a);
      } else if (a.email.toLowerCase().contains(text)) {
        listPencarianUsers.add(a);
      } else if (a.phone.toLowerCase().contains(text)) {
        listPencarianUsers.add(a);
      } else if (a.tanggalDibuat.toLowerCase().contains(text)) {
        listPencarianUsers.add(a);
      }
    });
    if (!mounted) {
      return;
    }
    setState(() {});
  }

  Future<void> refreshHalaman() async {
    getDaftarUsers();
  }

  @override
  void initState() {
    super.initState();
    getDaftarUsers();
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
            controller: _controllerPencarianUsers,
            onChanged: dalamPencarian,
            style: TextStyle(
                fontSize: displayWidth(context) * 0.035,
                fontWeight: FontWeight.w500,
                wordSpacing: 1.5),
            decoration: InputDecoration(
              hintText: "Cari Users",
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
              : _controllerPencarianUsers.text.isNotEmpty ||
                      listPencarianUsers.length != 0
                  ? ListView(
                      padding: EdgeInsets.all(16),
                      children: <Widget>[
                        Divider(),
                        ListView.builder(
                          padding: EdgeInsets.all(16),
                          itemCount: listPencarianUsers.length,
                          shrinkWrap: true,
                          physics: ClampingScrollPhysics(),
                          itemBuilder: (context, i) {
                            final a = listPencarianUsers[i];

                            //tinggal panggil valuenya misal Column()

                            return InkWell(
                              onTap: () {},
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: <Widget>[
                                  Text(
                                    " ID Users : ${a.id}",
                                    style: TextStyle(
                                      fontSize: displayWidth(context) * 0.03,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  SizedBox(
                                    height: 5,
                                  ),
                                  Text(
                                    "Nama : ${a.namaLengkap}",
                                    style: TextStyle(
                                      fontSize: displayWidth(context) * 0.03,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  SizedBox(
                                    height: 5,
                                  ),
                                  Text(
                                    "Nomor telpon : ${a.phone}",
                                    style: TextStyle(
                                      fontSize: displayWidth(context) * 0.03,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  SizedBox(
                                    height: 5,
                                  ),
                                  Text(
                                    "Tanggal Pembuatan Akun : ${a.tanggalDibuat}",
                                    style: TextStyle(
                                      fontSize: displayWidth(context) * 0.03,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  SizedBox(
                                    height: 5,
                                  ),
                                  Text(
                                    a.level == '1'
                                        ? "Level : Users"
                                        : "Level : Admin",
                                    style: TextStyle(
                                      fontSize: displayWidth(context) * 0.03,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  SizedBox(
                                    height: 20,
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
                            "Cari Konfirmasi Pembayaran Berdasarkan No.Invoice",
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
