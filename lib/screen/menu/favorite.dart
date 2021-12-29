import 'dart:convert';
import 'package:device_info/device_info.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:intl/intl.dart';
import 'package:pjm_palmerah/custom/SizeHelper.dart';
import 'package:pjm_palmerah/custom/preference_profile.dart';
import 'package:pjm_palmerah/model/ProdukModel.dart';
import 'package:http/http.dart' as http;
import 'package:pjm_palmerah/network/network.dart';
import 'package:pjm_palmerah/screen/login.dart';
import 'package:pjm_palmerah/screen/menu.dart';
import 'package:pjm_palmerah/screen/menu/history_transaksi.dart';
import 'package:pjm_palmerah/screen/product/Keranjang_Belanja.dart';
import 'package:pjm_palmerah/screen/product/detail_produk.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/services.dart';

class Favorite extends StatefulWidget {
  @override
  _FavoriteState createState() => _FavoriteState();
}

class _FavoriteState extends State<Favorite> {
  List<ProdukModel> productList = [];
  var loading = false;
  var checkData =
      false; //Tujuan dari variabel check data ini untuk menghendel jika data dalam method getData() kosong
  DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
  String deviceID;
  final price = NumberFormat(
      "#,##0", 'en_US'); //sebuah variabel untuk memisahkan format HARGA
  String namaLengkap, email, phone, level;
  bool login = false;
  getPreference() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      login = preferences.getBool(Preference.login) ?? false;
      namaLengkap = preferences.getString(Preference.namaLengkap);
      email = preferences.getString(Preference.email);
      phone = preferences.getString(Preference.phone);
      level = preferences.getString(Preference.level);
    });
  }

// MENGIDENTIFIKASI DEVICE_UUID PERANGKAT
  getDeviceInfo() async {
    var build = await deviceInfo.androidInfo;
    setState(() {
      deviceID = build.androidId;
    });
    getProducts();
  }

  GoogleSignIn googleSignIn = GoogleSignIn();

  signOut() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.remove(Preference.namaLengkap);
    preferences.remove(Preference.id);
    preferences.remove(Preference.email);
    preferences.remove(Preference.login);
    preferences.remove(Preference.level);
    preferences.remove(Preference.tanggalDibuat);
    preferences.remove(Preference.kode);

    setState(() {
      // _auth.signOut();
      googleSignIn.signOut();
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => Menu()));
    });
  }

  //MENAMBAHKAN PRODUK FAVORIT
  tambahkanFavorit(ProdukModel model) async {
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
    setState(() {
      loading = true;
    });
    final response = await http.post(
        Uri.tryParse(NetworkUrl.addFavoritProdukWithoutLogin()),
        body: {"deviceInfo": deviceID, "idProduk": model.id});
    final data = jsonDecode(response.body);
    int value = data['value'];
    String message = data['message'];
    if (value == 1) {
      print(message);
      Navigator.pop(context);
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text("Informasi"),
              content: Text(message),
              actions: <Widget>[
                TextButton(
                    onPressed: () => Navigator.pop(context), child: Text("Ok"))
              ],
            );
          });

      getProducts(); //Method ini dipanggil untuk Menghapus Favorit Produk
      setState(() {
        loading = false;
      });
    } else {
      print(message);
      Navigator.pop(context);
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text("Perhatian"),
              content: Text(message),
              actions: <Widget>[
                TextButton(
                    onPressed: () => Navigator.pop(context), child: Text("Ok"))
              ],
            );
          });
      setState(() {
        loading = false;
      });
    }
  }

//METHOD DIBAWAH INI DIGUNAKAN UNTUK MENDAPATKAN deviceID PENGGUNA YANG MENAMBAHKAN FAVORIT TANPA LOGIN APP DARI DATABASE
  getProducts() async {
    setState(() {
      loading = true;
    });
    productList.clear();
    final response = await http
        .get(Uri.tryParse(NetworkUrl.getFavoritProdukWhitoutLogin(deviceID)));
    if (response.statusCode == 200) {
      if (response.contentLength == 2) {
        if (!mounted) {
          return; // Just do nothing if the widget is disposed.
        }
        setState(() {
          loading = false;
          checkData = false;
        });
      } else {
        final data = jsonDecode(response.body);
        if (!mounted) {
          return; // Just do nothing if the widget is disposed.
        }
        setState(() {
          for (Map i in data) {
            productList.add(ProdukModel.fromJson(i));
          }
          loading = false;
          checkData = true;
        });
      }
    } else {
      if (!mounted) {
        return;
      }
      setState(() {
        loading = false;
        checkData = false;
      });
    }
  }

  Future<void> refreshHalaman() async {
    getDeviceInfo();
  }

  masukkanKeranjangBelanjaNavigateToKeranjangBelanja(ProdukModel model) async {
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

    final response = await http.post(
        Uri.tryParse(NetworkUrl.addKeranjangBelanja()),
        body: {"unikID": deviceID, "idProduk": model.id});
    final data = jsonDecode(response.body);
    int value = data['value'];
    String message = data['message'];
    if (value == 1) {
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
                        Navigator.pushReplacement(context,
                            MaterialPageRoute(builder: (context) => Menu()));
                      });
                    },
                    child: Text("Ok"))
              ],
            );
          });
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
                    onPressed: () => Navigator.pop(context), child: Text("Ok"))
              ],
            );
          });
    }
  }

  var loadingTotalBarangDikeranjang = false;
  var totalBarangDikeranjang = "0";
  getTotalBarangDikeranjang() async {
    setState(() {
      loadingTotalBarangDikeranjang = true;
    });
    final response = await http
        .get(Uri.tryParse(NetworkUrl.getTotalBarangDikeranjang(deviceID)));
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body)[0];
      String total = data['total'];
      // ignore: unnecessary_brace_in_string_interps
      print(" Total Cart ${total}");
      setState(() {
        loadingTotalBarangDikeranjang = false;
        totalBarangDikeranjang = total;
      });
    } else {
      setState(() {
        loadingTotalBarangDikeranjang = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    getDeviceInfo();
    getPreference();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    return Scaffold(
      appBar: AppBar(
        title: Text("Produk Favorit",
            style: TextStyle(
                color: Colors.amber,
                fontSize: displayWidth(context) * 0.05,
                fontWeight: FontWeight.bold),
            textAlign: TextAlign.center),
        centerTitle: true,
      ),
      drawer: new Drawer(
        child: ListView(
          children: <Widget>[
            new UserAccountsDrawerHeader(
              accountName: login
                  ? Text(
                      "$namaLengkap",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    )
                  : SizedBox(
                      child: Row(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          "Silahkan Login Terlebih Dahulu",
                          textAlign: TextAlign.center,
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ],
                    )),
              accountEmail: login
                  ? Text(
                      "$email",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    )
                  : SizedBox(
                      child: Center(
                        widthFactor: 6,
                        child: InkWell(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => Login()));
                          },
                          child: Container(
                            padding: EdgeInsets.all(15),
                            decoration: BoxDecoration(
                                shape: BoxShape.rectangle,
                                borderRadius: BorderRadius.circular(20),
                                color: Colors.amber),
                            child: Text(
                              "Login",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      ),
                    ),
            ),
            InkWell(
              onTap: () {
                Navigator.pushReplacement(
                    context, MaterialPageRoute(builder: (context) => Menu()));
              },
              child: ListTile(
                title: Text(
                  "Home",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                leading: Icon(
                  Icons.home,
                  color: Colors.amber,
                ),
              ),
            ),
            InkWell(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => KeranjangBelanja()));
              },
              child: ListTile(
                title: Text(
                  "Keranjang Belanja",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                leading: Icon(
                  Icons.shopping_basket,
                  color: Colors.amber,
                ),
              ),
            ),
            level == "1"
                ? InkWell(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => HistoriTransaksi()));
                    },
                    child: ListTile(
                      title: Text(
                        "Status Pemesanan",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      leading: Icon(
                        Icons.equalizer,
                        color: Colors.amber,
                      ),
                    ),
                  )
                : SizedBox(),
            Divider(),
          ],
        ),
      ),
      body: RefreshIndicator(
        onRefresh:
            refreshHalaman, //Permasalahan Sebelumnya Layer ini Tidak Bisa Di Refresh, dan Solusinya adalah membungkus Containernya dengan ListView(),Setelah itu ListView dibungkus Dengan RefreshIndicator()
        child: ListView(
          children: <Widget>[
            Container(
              child: loading
                  ? Center(
                      child: CircularProgressIndicator(),
                    )
                  : checkData
                      ? Container(
                          padding: EdgeInsets.all(10),
                          child: GridView.builder(
                            shrinkWrap: true,
                            physics: ClampingScrollPhysics(),
                            itemCount: productList.length,
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              mainAxisSpacing: 10,
                              crossAxisSpacing: 10,
                            ),
                            itemBuilder: (context, i) {
                              final a = productList[i];

                              return InkWell(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              DetailProduk(a)));
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      width: displayWidth(context) * 0.005,
                                      color: Colors.grey[300],
                                    ),
                                    borderRadius: BorderRadius.circular(15),
                                    boxShadow: [
                                      BoxShadow(
                                          blurRadius: 4,
                                          color: Colors.grey[300])
                                    ],
                                    color: Colors.white,
                                  ),
                                  padding: EdgeInsets.all(8),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    verticalDirection: VerticalDirection.down,
                                    mainAxisSize: MainAxisSize.min,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.stretch,
                                    children: <Widget>[
                                      Expanded(
                                        child: Stack(
                                          children: <Widget>[
                                            Image.network(
                                                "https://pjmpalmerah.000webhostapp.com/products/${a.coverProduk}",
                                                height: displayHeight(context) *
                                                    0.9,
                                                width:
                                                    displayWidth(context) * 1,
                                                fit: BoxFit.cover),
                                            Positioned(
                                              height:
                                                  displayHeight(context) * 0.06,
                                              width:
                                                  displayWidth(context) * 0.12,
                                              top: displayHeight(context) * 0,
                                              right: displayWidth(context) * 0,
                                              child: Container(
                                                  decoration: BoxDecoration(
                                                      shape: BoxShape.circle,
                                                      color: Colors.white),
                                                  child: IconButton(
                                                      iconSize: displayWidth(
                                                              context) *
                                                          0.05,
                                                      icon: Icon(Icons
                                                          .favorite_border),
                                                      onPressed: () {
                                                        tambahkanFavorit(a);
                                                      })),
                                            ),
                                            int.tryParse(a.stok) <= 0
                                                ? SizedBox()
                                                : Positioned(
                                                    height:
                                                        displayHeight(context) *
                                                            0.06,
                                                    width:
                                                        displayWidth(context) *
                                                            0.12,
                                                    bottom:
                                                        displayHeight(context) *
                                                            0,
                                                    right:
                                                        displayWidth(context) *
                                                            0,
                                                    child: Container(
                                                        decoration:
                                                            BoxDecoration(
                                                                shape: BoxShape
                                                                    .circle,
                                                                color: Colors
                                                                    .white),
                                                        child: IconButton(
                                                            icon: Icon(Icons
                                                                .add_shopping_cart),
                                                            onPressed: () {
                                                              masukkanKeranjangBelanjaNavigateToKeranjangBelanja(
                                                                  a);
                                                            })),
                                                  ),
                                          ],
                                        ),
                                      ),
                                      SizedBox(
                                        height: 6,
                                      ),
                                      Text(
                                        "${a.namaProduk}",
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black,
                                          fontSize:
                                              displayWidth(context) * 0.03,
                                        ),
                                      ),
                                      SizedBox(
                                        height: 6,
                                      ),
                                      Text(
                                        "Rp. ${price.format(a.hargaProduk)}",
                                        style: TextStyle(
                                          fontWeight: FontWeight.w500,
                                          color: Colors.red,
                                          fontSize:
                                              displayWidth(context) * 0.03,
                                        ),
                                      ),
                                      SizedBox(
                                        height: 6,
                                      ),
                                      int.tryParse(a.stok) <= 0
                                          ? Text(
                                              " Stok : Habis",
                                              style: TextStyle(
                                                fontWeight: FontWeight.w500,
                                                color: Colors.red,
                                                fontSize:
                                                    displayWidth(context) *
                                                        0.03,
                                              ),
                                            )
                                          : Text(
                                              " Stok : ${a.stok}",
                                              style: TextStyle(
                                                fontWeight: FontWeight.w500,
                                                color: Colors.red,
                                                fontSize:
                                                    displayWidth(context) *
                                                        0.03,
                                              ),
                                            ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                        )
                      : Container(
                          padding: EdgeInsets.only(
                            left: displayWidth(context) * 0.03,
                            top: displayHeight(context) * 0.3,
                            right: displayWidth(context) * 0.03,
                            bottom: displayHeight(context) * 0.03,
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: <Widget>[
                              Text(
                                "Anda Belum Memiliki Produk Favorit",
                                style: TextStyle(
                                    fontSize: displayWidth(context) * 0.04,
                                    fontWeight: FontWeight.bold),
                                textAlign: TextAlign.center,
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              Text(
                                "Refresh Jika Anda Sudah Menambahkan Sebagai Favorit Tetapi Tidak Terlihat",
                                style: TextStyle(
                                    fontSize: displayWidth(context) * 0.03,
                                    fontWeight: FontWeight.bold),
                                textAlign: TextAlign.center,
                              )
                            ],
                          ),
                        ),
            ),
          ],
        ),
      ),
    );
  }
}
