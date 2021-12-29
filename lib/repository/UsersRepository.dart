import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:pjm_palmerah/model/UsersModel.dart';
import 'package:pjm_palmerah/network/network.dart';

class UsersRepository {
  Future fetchdata(
    List<UsersModel> list,
    VoidCallback reload,
    BuildContext context,
    bool checkData,
  ) async {
    reload();
    list.clear();
    final response = await http.get(Uri.tryParse(NetworkUrl.getUsers()));
    if (response.statusCode == 200) {
      reload();
      if (response.contentLength == 2) {
        checkData = false;
      } else {
        Navigator.pop(context);
        final data = jsonDecode(response.body);
        for (Map i in data) {
          list.add(UsersModel.fromJson(i));
        }
        checkData = true;

        Navigator.pop(context);
      }
    } else {
      checkData = false;
      reload();
    }
  }
}
