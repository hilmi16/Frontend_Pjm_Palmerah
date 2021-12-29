import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:pjm_palmerah/custom/SizeHelper.dart';
import 'package:pjm_palmerah/model/KategoriProdukModel.dart';
import 'package:pjm_palmerah/model/ProdukModel.dart';
import 'package:pjm_palmerah/network/network.dart';
import 'package:pjm_palmerah/screen/product/Menampilkan_produk_di_edit_produk.dart';

class EditProduk extends StatefulWidget {
  final ProdukModel model;
  EditProduk(this.model);
  @override
  _EditProdukState createState() => _EditProdukState();
}

class _EditProdukState extends State<EditProduk> {
  String selectedKategoriProduk;
  bool isImage = false;
  String _selectedFieldId;

  List<KategoriProdukModel> _fieldList = [];
  Uint8List bytes, nampilinGambar;

  TextEditingController namaProdukController,
      beratProdukController,
      quantityController,
      hargaProdukController,
      deskripsiProdukController,
      kategoriProdukController;
  setup() {
    namaProdukController = TextEditingController(text: widget.model.namaProduk);
    beratProdukController = TextEditingController(text: widget.model.berat);
    quantityController = TextEditingController(text: widget.model.stok);
    hargaProdukController =
        TextEditingController(text: widget.model.hargaProduk.toString());
    deskripsiProdukController =
        TextEditingController(text: widget.model.deskripsiProduk);
    kategoriProdukController = TextEditingController(text: _selectedFieldId);
  }

  menyimpanHasil() async {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Loading"),
          content: Container(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                CircularProgressIndicator(),
                SizedBox(
                  height: 10,
                ),
                Text("Mohon menunggu data sedang diproses... ")
              ],
            ),
          ),
        );
      },
    );

    try {
      var url = Uri.parse(NetworkUrl.editProducts());
      var request = new http.MultipartRequest("POST", url);
      request.fields["idProduk"] = widget.model.id;
      request.fields["nama_produk"] = namaProdukController.text;
      request.fields["berat"] = beratProdukController.text;
      request.fields["quantity"] = quantityController.text;
      request.fields["harga_produk"] = hargaProdukController.text;
      request.fields["deskripsi_produk"] = deskripsiProdukController.text;
      request.fields["idKategori"] = _selectedFieldId;

      var response = await request.send();
      response.stream.transform(utf8.decoder).listen((value) {
        final data = jsonDecode(value);
        int valueGet = data['value'];
        String message = data['message'];
        print(message);
        if (valueGet == 1) {
          Navigator.pop(context);
          showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  title: Text("Informasi"),
                  content: Text(message),
                  actions: <Widget>[
                    TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                          setState(() {
                            Navigator.pop(context);
                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        MenampilkanProdukEditProduk()));
                          });
                        },
                        child: Text("Ok"))
                  ],
                );
              });

          print(message);
        } else {
          Navigator.pop(context);
          showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  title: Text("Perhatian"),
                  content: Text(message),
                  actions: <Widget>[
                    TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                          setState(() {
                            Navigator.pop(context);
                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        MenampilkanProdukEditProduk()));
                          });
                        },
                        child: Text("Ok"))
                  ],
                );
              });

          print(message);
        }
      });
    } catch (e) {
      debugPrint("Error $e");
    }
  }

  Future<String> _getDropDownData() async {
    var res = await http
        .get(Uri.tryParse(Uri.encodeFull(NetworkUrl.getKategoriProduk())));
    return res.body;
  }

  // map data to list
  void _getFieldsData() {
    _getDropDownData().then((data) {
      final items = jsonDecode(data).cast<Map<String, dynamic>>();
      var fieldListData = items.map<KategoriProdukModel>((json) {
        return KategoriProdukModel.fromJson(json);
      }).toList();
      _selectedFieldId = widget.model.idKategori;
      // update widget
      setState(() {
        _fieldList = fieldListData;
      });
    });
  }

  @override
  void initState() {
    super.initState();
    _getFieldsData();
    setup();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Edit Product",
          style: TextStyle(
            color: Colors.amber,
            fontSize: displayWidth(context) * 0.05,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: Container(
        padding: EdgeInsets.only(
          left: displayWidth(context) * 0.05,
          top: displayHeight(context) * 0.05,
          right: displayWidth(context) * 0.05,
          bottom: displayHeight(context) * 0.05,
        ),
        child: ListView(
          children: <Widget>[
            FormField<String>(
              builder: (FormFieldState<String> state) {
                return Padding(
                  padding: EdgeInsets.only(
                    left: displayWidth(context) * 0.023,
                    top: displayHeight(context) * 0.023,
                    right: displayWidth(context) * 0.023,
                    bottom: displayHeight(context) * 0.023,
                  ),
                  child: InputDecorator(
                    decoration: InputDecoration(
                        labelText: "Silahkan Masukkan Kategori Produk",
                        labelStyle:
                            TextStyle(color: Colors.blueAccent, fontSize: 16.0),
                        errorStyle:
                            TextStyle(color: Colors.redAccent, fontSize: 16.0),
                        hintText: 'Silahkan Pilih Kategori Produk',
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(6.0))),
                    isEmpty: _selectedFieldId == '',
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        items: _fieldList.map((value) {
                          return DropdownMenuItem(
                            value: value.id,
                            child: Padding(
                              padding:
                                  const EdgeInsets.only(left: 8.0, right: 8.0),
                              child: Text(
                                value.namaKategori,
                                style: TextStyle(),
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

            TextField(
              controller: namaProdukController,
              keyboardType: TextInputType.text,
              decoration: InputDecoration(labelText: "Nama Produk"),
            ),

            TextField(
              controller: beratProdukController,
              keyboardType: TextInputType.phone,
              decoration: InputDecoration(labelText: "Berat Produk (KG)"),
            ),

            TextField(
              controller: quantityController,
              keyboardType: TextInputType.phone,
              decoration: InputDecoration(labelText: "Quantity"),
            ),

            TextField(
              controller: hargaProdukController,
              keyboardType: TextInputType.phone,
              decoration: InputDecoration(labelText: "Harga"),
            ),

            TextField(
              controller: deskripsiProdukController,
              keyboardType: TextInputType.text,
              maxLines: 3,
              decoration: InputDecoration(labelText: "Deskripsi Produk"),
            ),

            SizedBox(
              height: 16,
            ),

            //ini adalah Button yang dibuat dengan Widget Container
            InkWell(
              onTap: () {
                menyimpanHasil();
              },
              child: Container(
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  gradient: LinearGradient(
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                      colors: [Colors.deepOrange, Colors.deepPurple]),
                ),
                child: Text("Save Produk", textAlign: TextAlign.center),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
