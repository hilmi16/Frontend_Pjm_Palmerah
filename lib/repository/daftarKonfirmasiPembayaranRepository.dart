import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/cupertino.dart';
import 'package:pjm_palmerah/model/konfirmasiPembayaranModel.dart';
import 'package:pjm_palmerah/network/network.dart';

class DaftarKonfirmasiPembayaranRepository {
  Future fetchdata(
    List<KonfirmasiPembayaranModel> list,
    VoidCallback reload,
    bool checkData,
  ) async {
    reload();
    list.clear();
    final response =
        await http.get(Uri.tryParse(NetworkUrl.getKonfirmasiPembayaran()));
    if (response.statusCode == 200) {
      reload();
      if (response.contentLength == 2) {
        checkData = false;
      } else {
        final data = jsonDecode(response.body);
        for (Map i in data) {
          list.add(KonfirmasiPembayaranModel.fromJson(i));
        }
        checkData = true;
      }
    } else {
      checkData = false;
      reload();
    }
  }
}
