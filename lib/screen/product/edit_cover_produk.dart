import 'dart:convert';
import 'dart:typed_data';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as path;
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:pjm_palmerah/custom/SizeHelper.dart';
import 'package:pjm_palmerah/model/ProdukModel.dart';
import 'package:pjm_palmerah/network/network.dart';
import 'package:pjm_palmerah/screen/product/Menampilkan_produk_di_edit_produk.dart';
import 'package:pjm_palmerah/screen/product/menampilkan_cover_produk.dart';

class EditCoverProduk extends StatefulWidget {
  final ProdukModel model;
  EditCoverProduk(this.model);
  @override
  _EditCoverProdukState createState() => _EditCoverProdukState();
}

class _EditCoverProdukState extends State<EditCoverProduk> {
  @override
  // ignore: override_on_non_overriding_member
  XFile image;
  bool isImage = false;
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

  menyimpanHasil() async {
    if (image == null) {
      Navigator.pop(context);
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text("Perhatian"),
              content: Text("Masukkan Gambar Terlebih Dahulu !!!!"),
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
        var url = Uri.parse(NetworkUrl.editCoverProducts());
        var multiPartFile = http.MultipartFile.fromBytes('image', bytes,
            filename: path.basename(image.path));
        var request = new http.MultipartRequest("POST", url);

        request.fields["idProduk"] = widget.model.id;
        request.files.add(multiPartFile);

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
                                          MenampilkanProdukEditCoverProduk()));
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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Upload Cover Produk",
          style: TextStyle(
            color: Colors.amber,
            fontSize: displayWidth(context) * 0.05,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: Container(
        padding: EdgeInsets.all(20),
        child: ListView(
          children: <Widget>[
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
              onTap: () {
                menyimpanHasil();
              },
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
                  "Upload Gambar",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: displayWidth(context) * 0.04,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
