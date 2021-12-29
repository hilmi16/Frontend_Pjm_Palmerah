import 'package:bottom_navy_bar/bottom_navy_bar.dart';
import 'package:flutter/material.dart';
import 'package:line_icons/line_icons.dart';
import 'package:pjm_palmerah/custom/preference_profile.dart';
import 'package:pjm_palmerah/screen/StatusPesanan.dart';
import 'package:pjm_palmerah/screen/menu/favorite.dart';
import 'package:pjm_palmerah/screen/menu/history_transaksi.dart';
import 'package:pjm_palmerah/screen/menu/home.dart';
import 'package:pjm_palmerah/screen/menu/user.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:pjm_palmerah/custom/SizeHelper.dart';
import 'package:flutter/services.dart';

class Menu extends StatefulWidget {
  @override
  _MenuState createState() => _MenuState();
}

class _MenuState extends State<Menu> {
  String namaLengkap, level;
  int halamanpage = 0;
  bool login = false;

  //Method dibawah ini untuk mengetes apakah setPrefence itu bekerja?
  getPrefences() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      namaLengkap = preferences.getString(Preference.namaLengkap);
      login = preferences.getBool(Preference.login) ?? false;
      level = preferences.getString(Preference.level);
    });
  }

  GlobalKey _bottomNavigationKey = GlobalKey();
  PageController _pageController;
  @override
  void initState() {
    super.initState();
    getPrefences();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    return Scaffold(
        body: login
            ? level == '1'
                ? SizedBox.expand(
                    child: PageView(
                    controller: _pageController,
                    onPageChanged: (index) {
                      setState(() => halamanpage = index);
                    },
                    children: [
                      Offstage(
                        offstage: halamanpage != 0,
                        child: TickerMode(
                          enabled: halamanpage == 0,
                          child: Home(),
                        ),
                      ),
                      Offstage(
                        offstage: halamanpage != 1,
                        child: TickerMode(
                          enabled: halamanpage == 1,
                          child: Favorite(),
                        ),
                      ),
                      Offstage(
                        offstage: halamanpage != 2,
                        child: TickerMode(
                          enabled: halamanpage == 2,
                          child: HistoriTransaksi(),
                        ),
                      ),
                    ],
                  ))
                : SizedBox.expand(
                    child: PageView(
                    controller: _pageController,
                    onPageChanged: (index) {
                      setState(() => halamanpage = index);
                    },
                    children: [
                      Offstage(
                        offstage: halamanpage != 0,
                        child: TickerMode(
                          enabled: halamanpage == 0,
                          child: User(),
                        ),
                      ),
                      Offstage(
                        offstage: halamanpage != 1,
                        child: TickerMode(
                          enabled: halamanpage == 1,
                          child: StatusPesanan(),
                        ),
                      ),
                    ],
                  ))
            : SizedBox.expand(
                child: PageView(
                controller: _pageController,
                onPageChanged: (index) {
                  setState(() => halamanpage = index);
                },
                children: [
                  Offstage(
                    offstage: halamanpage != 0,
                    child: TickerMode(
                      enabled: halamanpage == 0,
                      child: Home(),
                    ),
                  ),
                  Offstage(
                    offstage: halamanpage != 1,
                    child: TickerMode(
                      enabled: halamanpage == 1,
                      child: Favorite(),
                    ),
                  ),
                ],
              )),
        bottomNavigationBar: login
            ? level == '1'
                ? BottomNavyBar(
                    key: _bottomNavigationKey,
                    selectedIndex: halamanpage,
                    showElevation: true,
                    itemCornerRadius: displayWidth(context) * 0.05,
                    backgroundColor: Colors.blue,
                    curve: Curves.easeInBack,
                    animationDuration: Duration(milliseconds: 100),
                    items: [
                      BottomNavyBarItem(
                          icon: Icon(
                            LineIcons.home,
                            size: displayWidth(context) * 0.05,
                            color: Colors.amber,
                          ),
                          title: Text(
                            "Home",
                            style: TextStyle(color: Colors.amber),
                          )),
                      BottomNavyBarItem(
                          icon: Icon(
                            LineIcons.heart,
                            size: displayWidth(context) * 0.05,
                            color: Colors.amber,
                          ),
                          title: Text(
                            "Favorit",
                            style: TextStyle(color: Colors.amber),
                          )),
                      BottomNavyBarItem(
                          icon: Icon(
                            LineIcons.history,
                            size: displayWidth(context) * 0.05,
                            color: Colors.amber,
                          ),
                          title: Text(
                            "Histori Pemesanan",
                            style: TextStyle(color: Colors.amber),
                          )),
                    ],
                    onItemSelected: (index) {
                      setState(() {
                        halamanpage = index;
                      });

                      _pageController.animateToPage(index,
                          duration: Duration(milliseconds: 100),
                          curve: Curves.ease);
                    },
                  )
                : BottomNavyBar(
                    key: _bottomNavigationKey,
                    selectedIndex: halamanpage,
                    showElevation: true,
                    itemCornerRadius: displayWidth(context) * 0.02,
                    backgroundColor: Colors.blue,
                    curve: Curves.easeInBack,
                    animationDuration: Duration(milliseconds: 100),
                    items: [
                      BottomNavyBarItem(
                          icon: Icon(
                            LineIcons.home,
                            size: displayWidth(context) * 0.05,
                            color: Colors.amber,
                          ),
                          title: Text(
                            "Home",
                            style: TextStyle(color: Colors.amber),
                          )),
                      BottomNavyBarItem(
                          icon: Icon(
                            Icons.shopping_basket,
                            size: displayWidth(context) * 0.05,
                            color: Colors.amber,
                          ),
                          title: Text(
                            "Pesanan Produk",
                            style: TextStyle(color: Colors.amber),
                          )),
                    ],
                    onItemSelected: (index) {
                      setState(() {
                        halamanpage = index;
                        _pageController.animateToPage(index,
                            duration: Duration(milliseconds: 100),
                            curve: Curves.ease);
                      });
                    },
                  )
            : BottomNavyBar(
                key: _bottomNavigationKey,
                selectedIndex: halamanpage,
                showElevation: true,
                itemCornerRadius: 50,
                backgroundColor: Colors.blue,
                curve: Curves.easeInBack,
                animationDuration: Duration(milliseconds: 100),
                items: [
                  BottomNavyBarItem(
                      icon: Icon(
                        LineIcons.home,
                        size: displayWidth(context) * 0.05,
                        color: Colors.amber,
                      ),
                      title: Text(
                        "Home",
                        style: TextStyle(color: Colors.amber),
                      )),
                  BottomNavyBarItem(
                      icon: Icon(
                        LineIcons.heart,
                        size: displayWidth(context) * 0.05,
                        color: Colors.amber,
                      ),
                      title: Text(
                        "Favorit",
                        style: TextStyle(color: Colors.amber),
                      )),
                ],
                onItemSelected: (index) {
                  setState(() {
                    halamanpage = index;
                  });
                  _pageController.animateToPage(index,
                      duration: Duration(milliseconds: 100),
                      curve: Curves.ease);
                },
              ));
  }
}
