import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:pjm_palmerah/model/HistoryModel.dart';
import 'package:pjm_palmerah/network/network.dart';

class HistoryRepository {
  Future fetchdata(
    List<HistoryModel> list,
    String idUsers,
    VoidCallback reload,
    bool checkData,
  ) async {
    reload();
    list.clear();
    final response =
        await http.get(Uri.tryParse(NetworkUrl.getHistory(idUsers)));
    if (response.statusCode == 200) {
      reload();
      if (response.contentLength == 2) {
        checkData = false;
      } else {
        final data = jsonDecode(response.body);
        for (Map i in data) {
          list.add(HistoryModel.fromJson(i));
        }
        checkData = true;
      }
    } else {
      checkData = false;
      reload();
    }
  }
}
