import 'dart:convert';
import 'dart:typed_data';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as path;
import 'package:pjm_palmerah/custom/SizeHelper.dart';
import 'package:pjm_palmerah/model/KategoriProdukModel.dart';
import 'package:pjm_palmerah/network/network.dart';
import 'package:pjm_palmerah/screen/product/Menampilkan_produk_di_edit_produk.dart';

class AddProduct extends StatefulWidget {
  AddProduct(BuildContext context);

  @override
  _AddProductState createState() => _AddProductState();
}

class _AddProductState extends State<AddProduct> {
  final _key = new GlobalKey<FormState>();
  String selectedKategoriProduk,
      namaProduk,
      beratProduk,
      quantity,
      hargaProduk,
      deskripsiProduk,
      kategoriProduk;
  XFile image;
  bool isImage = false;
  String _selectedFieldId;

  List<KategoriProdukModel> _fieldList = [];
  Uint8List bytes, nampilinGambar;
  uploadGambar() async {
    ImagePicker _picker = ImagePicker();
    var _image = await _picker.pickImage(source: ImageSource.camera);
    setState(() {
      image = _image;
    });
  }

  Widget _buildFile(XFile file) {
    return FutureBuilder<List<int>>(
        future: file.readAsBytes(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            bytes = Uint8List.fromList(snapshot.data);
            return Image.memory(
              bytes,
              fit: BoxFit.contain,
            );
          }
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Text(file.path),
              ),
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Text(
                  file.path,
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          );
        });
  }

  check() async {
    final form = _key.currentState;
    if (form.validate()) {
      form.save();
      menyimpanHasil();
    }
  }

  menyimpanHasil() async {
    if (image == null) {
      Navigator.pop(context);
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text("Perhatian"),
              content:
                  Text("Pastikan form tambah produk sudah terisi semua !!!!"),
              actions: <Widget>[
                TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text("Ok"))
              ],
            );
          });
    } else {
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
        bytes = await image.readAsBytes();
        var url = Uri.parse(NetworkUrl.addProducts());
        var multiPartFile = http.MultipartFile.fromBytes('image', bytes,
            filename: path.basename(image.path));
        var request = new http.MultipartRequest("POST", url);

        request.fields["nama_produk"] = namaProduk;
        request.fields["berat"] = beratProduk;
        request.fields["quantity"] = quantity;
        request.fields["harga_produk"] = hargaProduk;
        request.fields["deskripsi_produk"] = deskripsiProduk;
        request.fields["idKategori"] = _selectedFieldId;
        request.files.add(multiPartFile);

        var response = await request.send();
        response.stream.transform(utf8.decoder).listen((value) {
          final data = jsonDecode(value);
          int valueGet = data['value'];
          String message = data['message'];
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
                              Navigator.push(
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
                                          AddProduct(context)));
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
  }

  Future<String> _getDropDownData() async {
    var res = await http
        .get(Uri.tryParse(Uri.encodeFull(NetworkUrl.getKategoriProduk())));
    return res.body;
  }

  // map data KategoriProduk to list
  void _getFieldsData() {
    _getDropDownData().then((data) {
      final items = jsonDecode(data).cast<Map<String, dynamic>>();
      var fieldListData = items.map<KategoriProdukModel>((json) {
        return KategoriProdukModel.fromJson(json);
      }).toList();
      _selectedFieldId = fieldListData[0].id;
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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Tambah Produk",
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
          left: displayWidth(context) * 0.025,
          right: displayWidth(context) * 0.025,
          top: displayHeight(context) * 0.025,
          bottom: displayHeight(context) * 0.025,
        ),
        child: Form(
            key: _key,
            child: ListView(padding: EdgeInsets.all(16.0), children: <Widget>[
              InputDecorator(
                decoration: InputDecoration(
                    labelText: "Silahkan Masukkan Kategori Produk",
                    labelStyle: TextStyle(
                      color: Colors.blueAccent,
                      fontSize: displayWidth(context) * 0.04,
                    ),
                    errorStyle: TextStyle(
                      color: Colors.redAccent,
                      fontSize: displayWidth(context) * 0.04,
                    ),
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
                          padding: EdgeInsets.only(
                            left: displayWidth(context) * 0.023,
                            right: displayWidth(context) * 0.023,
                          ),
                          child: Text(
                            value.namaKategori,
                            style: TextStyle(
                              fontSize: displayWidth(context) * 0.03,
                            ),
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

              SizedBox(
                height: displayHeight(context) * 0.04,
              ),
              TextFormField(
                // ignore: missing_return
                validator: (e) {
                  if (e.isEmpty) {
                    return "Nama Produk Harus Diisi !!!";
                  }
                },
                onSaved: (e) => namaProduk = e,
                keyboardType: TextInputType.text,
                decoration: InputDecoration(
                  labelText: "Nama Produk",
                  labelStyle: TextStyle(
                    color: Colors.lightBlue,
                  ),
                  filled: true,
                  fillColor: Colors.white54,
                ),
              ),
              TextFormField(
                // ignore: missing_return
                validator: (e) {
                  if (e.isEmpty) {
                    return "Berat Produk Harus Diisi !!!";
                  }
                },
                onSaved: (e) => beratProduk = e,
                keyboardType: TextInputType.phone,
                decoration: InputDecoration(
                  labelText: "Berat Produk (KG)",
                  labelStyle: TextStyle(
                    color: Colors.lightBlue,
                  ),
                  filled: true,
                  fillColor: Colors.white54,
                ),
              ),
              TextFormField(
                // ignore: missing_return
                validator: (e) {
                  if (e.isEmpty) {
                    return "Quantity Produk Harus Diisi !!!";
                  }
                },
                onSaved: (e) => quantity = e,
                keyboardType: TextInputType.phone,
                decoration: InputDecoration(
                  labelText: "Quantity",
                  labelStyle: TextStyle(
                    color: Colors.lightBlue,
                  ),
                  filled: true,
                  fillColor: Colors.white54,
                ),
              ),
              TextFormField(
                // ignore: missing_return
                validator: (e) {
                  if (e.isEmpty) {
                    return "Harga Produk Harus Diisi !!!";
                  }
                },
                onSaved: (e) => hargaProduk = e,
                keyboardType: TextInputType.phone,
                decoration: InputDecoration(
                  labelText: "Harga",
                  labelStyle: TextStyle(
                    color: Colors.lightBlue,
                  ),
                  filled: true,
                  fillColor: Colors.white54,
                ),
              ),
              TextFormField(
                // ignore: missing_return
                validator: (e) {
                  if (e.isEmpty) {
                    return "Deskripsi Produk Harus Diisi !!!";
                  }
                },
                onSaved: (e) => deskripsiProduk = e,
                keyboardType: TextInputType.text,
                maxLines: 3,
                decoration: InputDecoration(
                  labelText: "Deskripsi Produk",
                  labelStyle: TextStyle(
                    color: Colors.lightBlue,
                  ),
                  filled: true,
                  fillColor: Colors.white54,
                ),
              ),
              SizedBox(
                height: 16,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Text(
                    "Silahkan Upload Cover Produk",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.red,
                      fontWeight: FontWeight.bold,
                      fontSize: displayWidth(context) * 0.04,
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 16,
              ),

              InkWell(
                  onTap: () {
                    uploadGambar();
                  },
                  child: image == null
                      ? Image.asset(
                          'lib/assets/images/placeholder.png',
                          fit: BoxFit.cover,
                        )
                      : _buildFile(image)),

              SizedBox(
                height: 16,
              ),

              //ini adalah Button yang dibuat dengan Widget Container
              InkWell(
                onTap: check,
                child: Container(
                  padding: EdgeInsets.only(
                    left: displayWidth(context) * 0.025,
                    right: displayWidth(context) * 0.025,
                    top: displayHeight(context) * 0.025,
                    bottom: displayHeight(context) * 0.025,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    gradient: LinearGradient(
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                        colors: [Colors.deepOrange, Colors.deepPurple]),
                  ),
                  child: Text(
                    "Save Produk",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: displayWidth(context) * 0.04,
                    ),
                  ),
                ),
              ),
            ])),
      ),
    );
  }
}
