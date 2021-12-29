import 'dart:convert';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:device_info/device_info.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:intl/intl.dart';
import 'package:pjm_palmerah/custom/preference_profile.dart';
import 'package:pjm_palmerah/model/HistoryModel.dart';
import 'package:pjm_palmerah/model/KategoriProdukModel.dart';
import 'package:pjm_palmerah/model/ProdukModel.dart';
import 'package:pjm_palmerah/network/network.dart';
import 'package:pjm_palmerah/screen/login.dart';
import 'package:pjm_palmerah/screen/menu.dart';
import 'package:pjm_palmerah/screen/menu/history_transaksi.dart';
import 'package:pjm_palmerah/screen/product/Keranjang_Belanja.dart';
import 'package:http/http.dart' as http;
import 'package:pjm_palmerah/screen/product/detail_produk.dart';
import 'package:pjm_palmerah/custom/SizeHelper.dart';
import 'package:pjm_palmerah/screen/product/pencarian_produk.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';
import 'package:flutter/services.dart';
import 'package:flutter_open_whatsapp/flutter_open_whatsapp.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
  final ProdukModel product;
  final HistoryModel model;
  final VoidCallback reload;
  final KategoriProdukModel kategori;

  Home({
    Key key,
    this.product,
    this.model,
    this.reload,
    this.kategori,
  }) : super(key: key);
}

class _HomeState extends State<Home> {
  var loading = false;

  DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
  List<KategoriProdukModel> listKategori = [];
  // ignore: unused_field
  String deviceID, _platformVersion = 'Unknown';

// Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    String platformVersion;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      platformVersion = await FlutterOpenWhatsapp.platformVersion;
    } on PlatformException {
      platformVersion = 'Failed to get platform version.';
    }

    if (!mounted) return;

    setState(() {
      _platformVersion = platformVersion;
    });
  }

// MENGIDENTIFIKASI DEVICE_UUID PERANGKAT
  getDeviceInfo() async {
    var build = await deviceInfo.androidInfo;

    if (!mounted) {
      return; // Just do nothing if the widget is disposed.
    }
    setState(() {
      deviceID = build.androidId;
    });
  }

  getProdukDenganKategori() async {
    if (!mounted) {
      return; // Just do nothing if the widget is disposed.
    }
    setState(() {
      loading = true;
    });
    listKategori.clear();
    final response =
        await http.get(Uri.tryParse(NetworkUrl.getKategoriProduk()));
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (!mounted) {
        return; // Just do nothing if the widget is disposed.
      }
      setState(() {
        for (Map i in data) {
          listKategori.add(KategoriProdukModel.fromJson(i));
        }
        loading = false;
      });
    } else {
      setState(() {
        loading = false;
      });
    }
  }

  var filter = false;

  List<ProdukModel> productList = [];

  getProducts() async {
    setState(() {
      loading = true;
    });
    productList.clear();
    final response = await http.get(Uri.tryParse(NetworkUrl.getProducts()));
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (!mounted) {
        return; // Just do nothing if the widget is disposed.
      }
      setState(() {
        for (Map i in data) {
          productList.add(ProdukModel.fromJson(i));
        }
        loading = false;
      });
    } else {
      if (!mounted) {
        return; // Just do nothing if the widget is disposed.
      }
      setState(() {
        loading = false;
      });
    }
  }

  final price = NumberFormat(
      "#,##0", 'en_US'); //sebuah variabel untuk memisahkan format HARGA

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

      if (!mounted) {
        return;
      }
      setState(() {
        loadingTotalBarangDikeranjang = false;
        totalBarangDikeranjang = total;
      });
    } else {
      if (!mounted) {
        return;
      }
      setState(() {
        loadingTotalBarangDikeranjang = false;
      });
    }
  }

  Future<void> refreshHalaman() async {
    getTotalBarangDikeranjang();
    getProducts();
    getProdukDenganKategori();
    initPlatformState();
    if (!mounted) {
      return; // Just do nothing if the widget is disposed.
    }
    setState(() {
      filter = false;
    });
  }

  int index = 0;

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

      setState(() {
        loading = false;
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
      setState(() {
        loading = false;
      });
    }
  }

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

  // FirebaseAuth _auth = FirebaseAuth.instance;
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
                      refreshHalaman();
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
                    onPressed: () {
                      Navigator.pop(context);
                      refreshHalaman();
                    },
                    child: Text("Ok"))
              ],
            );
          });
    }
  }

  @override
  void initState() {
    super.initState();
    getDeviceInfo();
    getPreference();
    getProducts();
    getProdukDenganKategori();
    getTotalBarangDikeranjang();
  }

  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);

    return Scaffold(
        appBar: AppBar(
          elevation: 0.0,
          actions: [
            IconButton(
                icon: Stack(
                  children: <Widget>[
                    Icon(
                      Icons.shopping_cart,
                      color: Colors.white,
                    ),
                    totalBarangDikeranjang == "0"
                        ? SizedBox()
                        : Positioned(
                            right: 0,
                            top: -4,
                            child: Container(
                              padding: EdgeInsets.all(4),
                              decoration: BoxDecoration(
                                  shape: BoxShape.circle, color: Colors.white),
                              child: Text(
                                "$totalBarangDikeranjang",
                                style: TextStyle(
                                    color: Colors.redAccent,
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold),
                              ),
                            ))
                  ],
                ),
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => KeranjangBelanja()));
                })
          ],
          title: InkWell(
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => PencarianProduk()));
            },
            child: Container(
              height: 50,
              padding: EdgeInsets.all(5),
              margin: EdgeInsets.only(top: displayHeight(context) * 0.001),
              child: TextField(
                textAlign: TextAlign.left,
                style: TextStyle(
                  fontSize: 16,
                ),
                decoration: InputDecoration(
                    hintText: "Pencarian Produk",
                    hintStyle: TextStyle(
                      fontWeight: FontWeight.w500,
                      wordSpacing: 1.5,
                      fontSize: displayWidth(context) * 0.035,
                    ),
                    fillColor: Colors.cyanAccent,
                    filled: true,
                    enabled: false,
                    suffixIcon:
                        IconButton(icon: Icon(Icons.search), onPressed: null),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: BorderSide(style: BorderStyle.none),
                    )),
              ),
            ),
          ),
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
                          widthFactor: displayWidth(context) * 0.1,
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
              login
                  ? InkWell(
                      onTap: () {
                        signOut();
                      },
                      child: ListTile(
                        title: Text(
                          "Logout",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        leading: Icon(
                          Icons.lock_open,
                          color: Colors.amber,
                        ),
                      ),
                    )
                  : SizedBox(),
            ],
          ),
        ),
        body: loading
            ? Center(
                child: CircularProgressIndicator(),
              )
            : RefreshIndicator(
                onRefresh: refreshHalaman,
                child: ListView(
                  children: [
                    Container(
                      height: displayHeight(context) * 0.3,
                      child: new CarouselSlider(
                          options: CarouselOptions(
                            height: displayHeight(context) * 1,
                            scrollPhysics: ClampingScrollPhysics(),
                            autoPlay: true,
                            autoPlayInterval: Duration(seconds: 3),
                            autoPlayAnimationDuration:
                                Duration(milliseconds: 800),
                            autoPlayCurve: Curves.fastOutSlowIn,
                          ),
                          items: productList.map((value) {
                            return Builder(builder: (BuildContext context) {
                              return InkWell(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              DetailProduk(value)));
                                },
                                child: Container(
                                  width: displayWidth(context) * 1,
                                  margin: EdgeInsets.only(
                                      left: 5, right: 5, top: 10, bottom: 10),
                                  decoration: BoxDecoration(
                                      color: Colors.amberAccent,
                                      border: Border.all(
                                          color: Colors.blue,
                                          style: BorderStyle.solid)),
                                  child: Image.network(
                                    "https://pjmpalmerah.000webhostapp.com/products/${value.coverProduk}",
                                    fit: BoxFit.fill,
                                  ),
                                ),
                              );
                            });
                          }).toList()),
                      decoration: BoxDecoration(
                          color: Colors.blue,
                          borderRadius: BorderRadius.circular(2)),
                    ),

                    SizedBox(
                      height: displayHeight(context) * 0.009,
                    ),

                    new Padding(
                      padding: const EdgeInsets.only(
                          left: 10.0, top: 10.0, right: 8.0, bottom: 10.0),
                      child: new Text(
                        "Kategori Produk",
                        style: TextStyle(
                          fontSize: displayWidth(context) * 0.05,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),

                    // menampilkan kategori produk
                    Container(
                      height: displayHeight(context) * 0.085,
                      child: ListView.builder(
                          shrinkWrap: true,
                          scrollDirection: Axis.horizontal,
                          itemCount: listKategori.length,
                          itemBuilder: (context, i) {
                            final a = listKategori[i];
                            return InkWell(
                              onTap: () {
                                setState(() {
                                  filter = true;
                                  index = i;
                                });
                              },
                              child: Container(
                                margin: EdgeInsets.only(
                                    right: displayWidth(context) * 0.03,
                                    left: displayWidth(context) * 0.03),
                                padding: EdgeInsets.all(
                                    displayHeight(context) * 0.03),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(15),
                                    color: Colors.deepOrangeAccent),
                                child: Text(
                                  a.namaKategori,
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w500,
                                      fontSize: displayWidth(context) * 0.035),
                                ),
                              ),
                            );
                          }),
                    ),
                    SizedBox(
                      height: 10,
                    ),

                    filter
                        ? new Padding(
                            padding:
                                EdgeInsets.all(displayWidth(context) * 0.03),
                            child: new Text(
                              "Produk Terfilter",
                              style: TextStyle(
                                fontSize: displayWidth(context) * 0.05,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          )
                        : new Padding(
                            padding:
                                EdgeInsets.all(displayWidth(context) * 0.03),
                            child: new Text(
                              "Produk Terbaru",
                              style: TextStyle(
                                fontSize: displayWidth(context) * 0.05,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                    SizedBox(
                      height: 5,
                    ),

                    // menampilkan produk
                    filter
                        ? listKategori[index].products.length == 0
                            ? Column(
                                children: [
                                  Container(
                                      height: displayHeight(context) * 0.5,
                                      padding: EdgeInsets.all(16),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.stretch,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            "Maaf Kategori Produk Yang Anda Pilih Belum Tersedia",
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize:
                                                  displayWidth(context) * 0.05,
                                            ),
                                          ),
                                        ],
                                      )),
                                ],
                              )

                            //Produk Yang Terfilter dengan Kategori
                            : Container(
                                padding: EdgeInsets.all(6),
                                child: GridView.builder(
                                  shrinkWrap: true,
                                  physics: ClampingScrollPhysics(),
                                  itemCount:
                                      listKategori[index].products.length,
                                  gridDelegate:
                                      SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 2,
                                    mainAxisSpacing: 10,
                                    crossAxisSpacing: 10,
                                  ),
                                  itemBuilder: (context, i) {
                                    final a = listKategori[index].products[i];

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
                                            width:
                                                displayWidth(context) * 0.005,
                                            color: Colors.grey[300],
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(15),
                                          boxShadow: [
                                            BoxShadow(
                                                blurRadius: 4,
                                                color: Colors.grey[300])
                                          ],
                                          color: Colors.white,
                                        ),
                                        padding: EdgeInsets.all(8),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          verticalDirection:
                                              VerticalDirection.down,
                                          mainAxisSize: MainAxisSize.min,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.stretch,
                                          children: <Widget>[
                                            Expanded(
                                              child: Stack(
                                                children: <Widget>[
                                                  Image.network(
                                                      "https://pjmpalmerah.000webhostapp.com/products/${a.coverProduk}",
                                                      height:
                                                          displayHeight(
                                                                  context) *
                                                              0.9,
                                                      width: displayWidth(
                                                              context) *
                                                          1,
                                                      fit: BoxFit.cover),
                                                  Positioned(
                                                    height:
                                                        displayHeight(context) *
                                                            0.06,
                                                    width:
                                                        displayWidth(context) *
                                                            0.12,
                                                    top:
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
                                                                .favorite_border),
                                                            onPressed: () {
                                                              tambahkanFavorit(
                                                                  a);
                                                            })),
                                                  ),
                                                  int.tryParse(a.stok) <= 0
                                                      ? SizedBox()
                                                      : Positioned(
                                                          height: displayHeight(
                                                                  context) *
                                                              0.06,
                                                          width: displayWidth(
                                                                  context) *
                                                              0.12,
                                                          bottom: displayHeight(
                                                                  context) *
                                                              0,
                                                          right: displayWidth(
                                                                  context) *
                                                              0,
                                                          child: Container(
                                                              decoration: BoxDecoration(
                                                                  shape: BoxShape
                                                                      .circle,
                                                                  color: Colors
                                                                      .white),
                                                              child: IconButton(
                                                                  icon: Icon(Icons
                                                                      .add_shopping_cart),
                                                                  onPressed:
                                                                      () {
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
                                                    displayWidth(context) *
                                                        0.03,
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
                                                    displayWidth(context) *
                                                        0.03,
                                              ),
                                            ),
                                            SizedBox(
                                              height: 6,
                                            ),
                                            int.tryParse(a.stok) <= 0
                                                ? Text(
                                                    " Stok : Habis",
                                                    style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      color: Colors.red,
                                                      fontSize: displayWidth(
                                                              context) *
                                                          0.03,
                                                    ),
                                                  )
                                                : Text(
                                                    " Stok : ${a.stok}",
                                                    style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      color: Colors.red,
                                                      fontSize: displayWidth(
                                                              context) *
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

                        //Produk yang muncul di homeStateProduk();
                        : Container(
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
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
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
                                                  height:
                                                      displayHeight(context) *
                                                          0.9,
                                                  width:
                                                      displayWidth(context) * 1,
                                                  fit: BoxFit.cover),
                                              Positioned(
                                                height: displayHeight(context) *
                                                    0.06,
                                                width: displayWidth(context) *
                                                    0.12,
                                                top: displayHeight(context) * 0,
                                                right:
                                                    displayWidth(context) * 0,
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
                                                      height: displayHeight(
                                                              context) *
                                                          0.06,
                                                      width: displayWidth(
                                                              context) *
                                                          0.12,
                                                      bottom: displayHeight(
                                                              context) *
                                                          0,
                                                      right: displayWidth(
                                                              context) *
                                                          0,
                                                      child: Container(
                                                          decoration:
                                                              BoxDecoration(
                                                                  shape: BoxShape
                                                                      .circle,
                                                                  color: Colors
                                                                      .white),
                                                          child: IconButton(
                                                              iconSize:
                                                                  displayWidth(
                                                                          context) *
                                                                      0.05,
                                                              icon: Icon(Icons
                                                                  .add_shopping_cart),
                                                              onPressed: () {
                                                                masukkanKeranjangBelanjaNavigateToKeranjangBelanja(
                                                                    a);
                                                              })),
                                                    )
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
                          ),
                    SizedBox(
                      height: 30,
                    ),
                  ],
                ),
              ));
  }
}
