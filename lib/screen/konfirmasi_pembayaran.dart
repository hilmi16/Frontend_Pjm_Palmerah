import 'dart:convert';
import 'dart:typed_data';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as path;
import 'package:pjm_palmerah/custom/SizeHelper.dart';
import 'package:pjm_palmerah/model/HistoryModel.dart';
import 'package:pjm_palmerah/network/network.dart';
import 'package:pjm_palmerah/screen/menu.dart';

class KonfirmasiPembayaran extends StatefulWidget {
  final HistoryModel model;

  KonfirmasiPembayaran(this.model);

  @override
  _KonfirmasiPembayaranState createState() => _KonfirmasiPembayaranState();
}

class _KonfirmasiPembayaranState extends State<KonfirmasiPembayaran> {
  String selectedKategoriProduk;
  XFile image;
  bool isImage = false;
  Uint8List bytes, nampilinGambar;
  uploadGambar() async {
    final ImagePicker _picker = ImagePicker();
    var _image = await _picker.pickImage(source: ImageSource.camera);
    if (!mounted) {
      return;
    }
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

  TextEditingController namaProdukController,
      noInvoiceController,
      namaController,
      tanggalController,
      noHPController;
  setup() {
    noInvoiceController = TextEditingController(text: widget.model.noInvoice);
    namaController = TextEditingController(text: widget.model.namaPenerima);
    tanggalController =
        TextEditingController(text: widget.model.tanggalTransaksi);
    noHPController = TextEditingController(text: widget.model.nomorPenerima);
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
      bytes = await image.readAsBytes();
      var url = Uri.parse(NetworkUrl.inputKonfirmasiPembayaran());
      var multiPartFile = http.MultipartFile.fromBytes('image', bytes,
          filename: path.basename(image.path));
      var request = new http.MultipartRequest("POST", url);

      request.fields["noInvoice"] = noInvoiceController.text;
      request.fields["nama"] = namaController.text;
      request.fields["noHP"] = noHPController.text;
      request.fields["tanggal"] = tanggalController.text;
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
                                    builder: (context) => Menu()));
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
                                        KonfirmasiPembayaran(widget.model)));
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
      Navigator.pop(context);
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text("Informasi"),
              content: Text("Mohon Upload Bukti Transfer"),
              actions: <Widget>[
                TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                      setState(() {
                        Navigator.pop(context);
                      });
                    },
                    child: Text("Ok"))
              ],
            );
          });
    }
  }

  kirimNotifikasi(String noInvoice, level1) async {
    await http.post(
      Uri.tryParse(
          NetworkUrl.kirimNotifikasiKonfirmasiPembayaran(noInvoice, level1)),
    );
  }

  @override
  void initState() {
    super.initState();
    setup();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Konfirmasi Pembayaran",
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
              height: displayHeight(context) * 0.02,
            ),
            TextField(
              readOnly: true,
              controller: noInvoiceController,
              keyboardType: TextInputType.phone,
              decoration: InputDecoration(
                labelText: "No.Invoice",
                filled: true,
              ),
            ),
            SizedBox(
              height: displayHeight(context) * 0.02,
            ),
            TextField(
              readOnly: true,
              controller: namaController,
              keyboardType: TextInputType.text,
              decoration: InputDecoration(
                labelText: "Nama",
                filled: true,
              ),
            ),
            SizedBox(
              height: displayHeight(context) * 0.02,
            ),
            TextField(
              readOnly: true,
              controller: noHPController,
              keyboardType: TextInputType.phone,
              decoration: InputDecoration(
                labelText: "Nomor Yang Bisa DiHubungi",
                filled: true,
              ),
            ),
            SizedBox(
              height: displayHeight(context) * 0.02,
            ),
            TextField(
              readOnly: true,
              controller: tanggalController,
              keyboardType: TextInputType.text,
              decoration: InputDecoration(
                labelText: "Tanggal Pembelian",
                filled: true,
              ),
            ),
            SizedBox(
              height: displayHeight(context) * 0.02,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Text(
                  "Silahkan Upload Bukti Transfer Dibawah ini",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.red,
                    fontWeight: FontWeight.bold,
                    fontSize: displayWidth(context) * 0.045,
                  ),
                ),
              ],
            ),
            SizedBox(
              height: displayHeight(context) * 0.02,
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
              height: displayHeight(context) * 0.02,
            ),

            //ini adalah Button yang dibuat dengan Widget Container
            InkWell(
              onTap: () {
                menyimpanHasil();
                kirimNotifikasi(noInvoiceController.text, "2");
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
                  "Konfirmasi",
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
