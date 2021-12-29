import 'package:bottom_navy_bar/bottom_navy_bar.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:line_icons/line_icons.dart';
import 'package:pjm_palmerah/custom/preference_profile.dart';
import 'package:pjm_palmerah/screen/StatusPesanan.dart';
import 'package:pjm_palmerah/screen/menu/favorite.dart';
import 'package:pjm_palmerah/screen/menu/home.dart';
import 'package:pjm_palmerah/screen/menu/user.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:pjm_palmerah/custom/SizeHelper.dart';

class MenuAdmin extends StatefulWidget {
  @override
  _MenuAdminState createState() => _MenuAdminState();
}

class _MenuAdminState extends State<MenuAdmin> {
  FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  String fcmToken, namaLengkap, level;
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
    // ignore: unnecessary_brace_in_string_interps
    print(" Level = ${level}");
  }

  generedToken() async {
    fcmToken = await _firebaseMessaging.getToken();
  }

  GlobalKey _bottomNavigationKey = GlobalKey();
  PageController _pageController;
  @override
  void initState() {
    super.initState();
    generedToken();
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
    return Scaffold(
        body: level == '2' && login
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
        bottomNavigationBar: level == '2' && login
            ? BottomNavyBar(
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
